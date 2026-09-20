"""Create development-only users for manual testing.

Run after installing backend requirements: `python seed.py`.
Passwords for all seeded users are `testpass123`.
"""
import time

from main import db, hash_password, init_db

USERS = [
    ("Test Player", "test@example.com", "🧑‍🎓", 740, 4),
    ("Aşgabat Owl", "owl@example.com", "🦉", 1250, 6),
    ("Mergen", "mergen@example.com", "🦅", 1840, 8),
]

init_db()
with db() as conn:
    for name, email, avatar, score, level in USERS:
        user = conn.execute("SELECT id FROM users WHERE email = ?", (email,)).fetchone()
        if not user:
            cursor = conn.execute(
                "INSERT INTO users(name, email, password_hash, avatar) VALUES (?, ?, ?, ?)",
                (name, email, hash_password("testpass123"), avatar),
            )
            user_id = cursor.lastrowid
        else:
            user_id = user["id"]
        conn.execute(
            "INSERT OR IGNORE INTO player_stats(user_id, total_score, level, updated_at) VALUES (?, ?, ?, ?)",
            (user_id, score, level, int(time.time())),
        )
        if not conn.execute("SELECT 1 FROM score_events WHERE user_id = ?", (user_id,)).fetchone():
            conn.execute(
                "INSERT INTO score_events(user_id, points, created_at) VALUES (?, ?, ?)",
                (user_id, score, int(time.time())),
            )
print("Test users are ready. Password: testpass123")
