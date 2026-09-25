"""Small local API for Akyl-ylmyň hyrydary.

Run from this directory with: uvicorn main:app --reload
"""
from __future__ import annotations

import hashlib
import hmac
import json
import secrets
import sqlite3
import time
from contextlib import contextmanager
from pathlib import Path
from typing import Annotated
from datetime import date, datetime, timezone

from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel, EmailStr, Field

DATABASE = Path(__file__).with_name("payhas.db")
security = HTTPBearer()

app = FastAPI(title="Akyl-ylmyň hyrydary API", version="1.0.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


@contextmanager
def db():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    try:
        yield conn
        conn.commit()
    finally:
        conn.close()


def init_db() -> None:
    with db() as conn:
        conn.executescript("""
            CREATE TABLE IF NOT EXISTS users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              email TEXT NOT NULL UNIQUE COLLATE NOCASE,
              password_hash TEXT NOT NULL,
              avatar TEXT NOT NULL DEFAULT '🧑‍🎓'
            );
            CREATE TABLE IF NOT EXISTS sessions (
              token TEXT PRIMARY KEY,
              user_id INTEGER NOT NULL REFERENCES users(id)
            );
            CREATE TABLE IF NOT EXISTS player_stats (
              user_id INTEGER PRIMARY KEY REFERENCES users(id),
              total_score INTEGER NOT NULL DEFAULT 0,
              level INTEGER NOT NULL DEFAULT 1,
              xp INTEGER NOT NULL DEFAULT 0,
              coins INTEGER NOT NULL DEFAULT 0,
              streak_days INTEGER NOT NULL DEFAULT 0,
              longest_streak INTEGER NOT NULL DEFAULT 0,
              total_correct_answers INTEGER NOT NULL DEFAULT 0,
              total_wrong_answers INTEGER NOT NULL DEFAULT 0,
              completed_questions INTEGER NOT NULL DEFAULT 0,
              updated_at INTEGER NOT NULL
            );
            CREATE TABLE IF NOT EXISTS score_events (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id INTEGER NOT NULL REFERENCES users(id),
              points INTEGER NOT NULL,
              created_at INTEGER NOT NULL
            );
        """)
        existing_columns = {
            row["name"] for row in conn.execute("PRAGMA table_info(player_stats)")
        }
        for column in (
            "xp",
            "coins",
            "streak_days",
            "longest_streak",
            "total_correct_answers",
            "total_wrong_answers",
            "completed_questions",
        ):
            if column not in existing_columns:
                conn.execute(
                    f"ALTER TABLE player_stats ADD COLUMN {column} INTEGER NOT NULL DEFAULT 0"
                )


def questions() -> list[dict]:
    source = Path(__file__).parent.parent / "assets" / "proverbs.json"
    return json.loads(source.read_text(encoding="utf-8"))


@app.on_event("startup")
def startup() -> None:
    init_db()


class Credentials(BaseModel):
    email: EmailStr
    password: str = Field(min_length=6, max_length=128)


class Signup(Credentials):
    name: str = Field(min_length=2, max_length=60)


class ProfileUpdate(BaseModel):
    name: str | None = Field(default=None, min_length=2, max_length=60)
    avatar: str | None = Field(default=None, max_length=128)


class StatsUpdate(BaseModel):
    total_score: int = Field(ge=0, le=10_000_000)
    level: int = Field(ge=1, le=1000)
    xp: int = Field(ge=0, le=10_000_000)
    coins: int = Field(ge=0, le=10_000_000)
    streak_days: int = Field(ge=0, le=100_000)
    longest_streak: int = Field(ge=0, le=100_000)
    total_correct_answers: int = Field(ge=0, le=10_000_000)
    total_wrong_answers: int = Field(ge=0, le=10_000_000)
    completed_questions: int = Field(ge=0, le=10_000_000)


def hash_password(password: str) -> str:
    salt = secrets.token_bytes(16)
    digest = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 310_000)
    return f"{salt.hex()}:{digest.hex()}"


def valid_password(password: str, saved: str) -> bool:
    salt_hex, digest_hex = saved.split(":", 1)
    digest = hashlib.pbkdf2_hmac("sha256", password.encode(), bytes.fromhex(salt_hex), 310_000)
    return hmac.compare_digest(digest.hex(), digest_hex)


def serialize_user(user: sqlite3.Row) -> dict:
    return {"id": user["id"], "name": user["name"], "email": user["email"], "avatar": user["avatar"]}


def profile(conn: sqlite3.Connection, user: sqlite3.Row) -> dict:
    stats = conn.execute(
        "SELECT * FROM player_stats WHERE user_id = ?", (user["id"],)
    ).fetchone()
    result = serialize_user(user)
    result["stats"] = {
        "total_score": stats["total_score"] if stats else 0,
        "level": stats["level"] if stats else 1,
        "xp": stats["xp"] if stats else 0,
        "coins": stats["coins"] if stats else 0,
        "streak_days": stats["streak_days"] if stats else 0,
        "longest_streak": stats["longest_streak"] if stats else 0,
        "total_correct_answers": stats["total_correct_answers"] if stats else 0,
        "total_wrong_answers": stats["total_wrong_answers"] if stats else 0,
        "completed_questions": stats["completed_questions"] if stats else 0,
    }
    return result


def new_session(conn: sqlite3.Connection, user: sqlite3.Row) -> dict:
    token = secrets.token_urlsafe(32)
    conn.execute("INSERT INTO sessions(token, user_id) VALUES (?, ?)", (token, user["id"]))
    return {"access_token": token, "token_type": "bearer", "user": profile(conn, user)}


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.get("/questions")
def get_questions(category: str | None = None, difficulty: str | None = None, count: int = 20) -> list[dict]:
    items = questions()
    matched = [item for item in items if (not category or item.get("category") == category) and (not difficulty or item.get("difficulty") == difficulty)]
    # Return a useful quiz even if the requested category/difficulty is small.
    by_id = {item["id"]: item for item in matched}
    by_id.update({item["id"]: item for item in items})
    return list(by_id.values())[:max(1, min(count, len(items)))]


@app.get("/daily-challenges")
def daily_challenge(count: int = 5) -> list[dict]:
    items = questions()
    start = date.today().toordinal() % len(items)
    return [items[(start + index) % len(items)] for index in range(max(1, min(count, len(items))))]


def period_start(period: str) -> int | None:
    now = int(time.time())
    if period == "today":
        return now - (now % 86_400)
    if period == "week":
        # Monday 00:00 UTC.
        return now - ((date.today().weekday() * 86_400) + (now % 86_400))
    if period == "month":
        today = date.today()
        return int(datetime(today.year, today.month, 1, tzinfo=timezone.utc).timestamp())
    if period == "all":
        return None
    raise HTTPException(status_code=422, detail="Nädogry reýting döwri.")


@app.get("/leaderboard")
def leaderboard(period: str = "all", limit: int = 50) -> list[dict]:
    start = period_start(period)
    with db() as conn:
        if start is None:
            rows = conn.execute("""
                SELECT users.id, users.name, users.avatar, player_stats.level,
                       player_stats.total_score AS score
                FROM player_stats JOIN users ON users.id = player_stats.user_id
                ORDER BY score DESC, users.name COLLATE NOCASE LIMIT ?
            """, (min(max(limit, 1), 100),)).fetchall()
        else:
            rows = conn.execute("""
                SELECT users.id, users.name, users.avatar, player_stats.level,
                       COALESCE(SUM(score_events.points), 0) AS score
                FROM player_stats JOIN users ON users.id = player_stats.user_id
                LEFT JOIN score_events ON score_events.user_id = users.id
                    AND score_events.created_at >= ?
                GROUP BY users.id HAVING score > 0
                ORDER BY score DESC, users.name COLLATE NOCASE LIMIT ?
            """, (start, min(max(limit, 1), 100))).fetchall()
    return [{"rank": index + 1, **dict(row)} for index, row in enumerate(rows)]


@app.post("/auth/signup", status_code=status.HTTP_201_CREATED)
def signup(payload: Signup) -> dict:
    with db() as conn:
        if conn.execute("SELECT 1 FROM users WHERE email = ?", (payload.email,)).fetchone():
            raise HTTPException(status_code=409, detail="Bu e-poçta eýýäm hasaba alnan.")
        cursor = conn.execute(
            "INSERT INTO users(name, email, password_hash) VALUES (?, ?, ?)",
            (payload.name.strip(), str(payload.email).lower(), hash_password(payload.password)),
        )
        user = conn.execute("SELECT * FROM users WHERE id = ?", (cursor.lastrowid,)).fetchone()
        return new_session(conn, user)


@app.post("/auth/login")
def login(payload: Credentials) -> dict:
    with db() as conn:
        user = conn.execute("SELECT * FROM users WHERE email = ?", (str(payload.email).lower(),)).fetchone()
        if not user or not valid_password(payload.password, user["password_hash"]):
            raise HTTPException(status_code=401, detail="E-poçta ýa-da parol nädogry.")
        return new_session(conn, user)


def current_user(credentials: Annotated[HTTPAuthorizationCredentials, Depends(security)]) -> dict:
    with db() as conn:
        user = conn.execute(
            "SELECT users.* FROM sessions JOIN users ON users.id = sessions.user_id WHERE sessions.token = ?",
            (credentials.credentials,),
        ).fetchone()
    if not user:
        raise HTTPException(status_code=401, detail="Sessiýa gutardy. Täzeden giriň.")
    return dict(user)


@app.get("/me")
def get_me(user: Annotated[dict, Depends(current_user)]) -> dict:
    with db() as conn:
        row = conn.execute("SELECT * FROM users WHERE id = ?", (user["id"],)).fetchone()
        return profile(conn, row)


@app.patch("/me")
def update_me(payload: ProfileUpdate, user: Annotated[dict, Depends(current_user)]) -> dict:
    if payload.name is None and payload.avatar is None:
        with db() as conn:
            row = conn.execute("SELECT * FROM users WHERE id = ?", (user["id"],)).fetchone()
            return profile(conn, row)
    with db() as conn:
        conn.execute(
            "UPDATE users SET name = COALESCE(?, name), avatar = COALESCE(?, avatar) WHERE id = ?",
            (payload.name.strip() if payload.name else None, payload.avatar, user["id"]),
        )
        updated = conn.execute("SELECT * FROM users WHERE id = ?", (user["id"],)).fetchone()
        return profile(conn, updated)


@app.put("/leaderboard/me")
def update_leaderboard(payload: StatsUpdate, user: Annotated[dict, Depends(current_user)]) -> dict:
    now = int(time.time())
    with db() as conn:
        previous = conn.execute(
            "SELECT total_score FROM player_stats WHERE user_id = ?", (user["id"],)
        ).fetchone()
        previous_score = previous["total_score"] if previous else 0
        gained = max(0, payload.total_score - previous_score)
        conn.execute("""
            INSERT INTO player_stats(
              user_id, total_score, level, xp, coins, streak_days,
              longest_streak, total_correct_answers, total_wrong_answers,
              completed_questions, updated_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(user_id) DO UPDATE SET
              total_score = excluded.total_score, level = excluded.level,
              xp = excluded.xp, coins = excluded.coins,
              streak_days = excluded.streak_days,
              longest_streak = excluded.longest_streak,
              total_correct_answers = excluded.total_correct_answers,
              total_wrong_answers = excluded.total_wrong_answers,
              completed_questions = excluded.completed_questions,
              updated_at = excluded.updated_at
        """, (
            user["id"], payload.total_score, payload.level, payload.xp,
            payload.coins, payload.streak_days, payload.longest_streak,
            payload.total_correct_answers, payload.total_wrong_answers,
            payload.completed_questions, now,
        ))
        if gained:
            conn.execute(
                "INSERT INTO score_events(user_id, points, created_at) VALUES (?, ?, ?)",
                (user["id"], gained, now),
            )
    return {"total_score": payload.total_score, "level": payload.level}
