"""Create development-only users for manual testing.

Run after installing backend requirements: `python seed.py`.
Passwords for all seeded users are `testpass123`.
"""
import time

from main import db, hash_password, init_db

USERS = [
    {
        "name": "Test Player", "email": "test@example.com", "avatar": "🧑‍🎓",
        "total_score": 740, "level": 4, "xp": 360, "coins": 125,
        "streak_days": 3, "longest_streak": 5,
        "total_correct_answers": 68, "total_wrong_answers": 17,
        "completed_questions": 85,
    },
    {
        "name": "Aşgabat Owl", "email": "owl@example.com", "avatar": "🦉",
        "total_score": 1250, "level": 6, "xp": 540, "coins": 240,
        "streak_days": 7, "longest_streak": 11,
        "total_correct_answers": 123, "total_wrong_answers": 24,
        "completed_questions": 147,
    },
    {
        "name": "Mergen", "email": "mergen@example.com", "avatar": "🦅",
        "total_score": 1840, "level": 8, "xp": 760, "coins": 385,
        "streak_days": 12, "longest_streak": 18,
        "total_correct_answers": 181, "total_wrong_answers": 31,
        "completed_questions": 212,
    },
]

init_db()
with db() as conn:
    for stats in USERS:
        user = conn.execute("SELECT id FROM users WHERE email = ?", (stats["email"],)).fetchone()
        if not user:
            cursor = conn.execute(
                "INSERT INTO users(name, email, password_hash, avatar) VALUES (?, ?, ?, ?)",
                (stats["name"], stats["email"], hash_password("testpass123"), stats["avatar"]),
            )
            user_id = cursor.lastrowid
        else:
            user_id = user["id"]
        conn.execute(
            """
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
            """,
            (user_id, *(stats[key] for key in (
                "total_score", "level", "xp", "coins", "streak_days",
                "longest_streak", "total_correct_answers", "total_wrong_answers",
                "completed_questions",
            )), int(time.time())),
        )
        conn.execute("DELETE FROM score_events WHERE user_id = ?", (user_id,))
        conn.execute(
            "INSERT INTO score_events(user_id, points, created_at) VALUES (?, ?, ?)",
            (user_id, stats["total_score"], int(time.time())),
        )
print("Test users are ready. Password: testpass123")
