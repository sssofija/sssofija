#  Messenger SQL Schema

A relational SQL schema that models the backend for a modern messaging application — similar in concept to Telegram or Messenger. Built using MySQL syntax with support for:

- Users, user settings
- Private, group, and channel messages
- Subscriptions, reactions, stories, and likes
- Relationships: 1-to-1, 1-to-Many, Many-to-Many
- Use of ENUM, JSON, INDEX, FOREIGN KEYS

---

## 🗂️ Project Structure

This schema contains DDL (Data Definition Language) commands for creating and modifying tables:

| Feature                          | Description |
|----------------------------------|-------------|
| `users`                          | Main user accounts (name, login, email, etc.) |
| `user_settings`                  | One-to-one table with custom preferences |
| `private_messages`              | 1-to-many personal messages between users |
| `groups`, `group_members`       | Group chat system and participant tracking |
| `group_messages`                | Messages within groups |
| `channels`, `channel_subscribers` | Public/private channels with subscription management |
| `channel_messages`              | Broadcast-style message system |
| `saved_messages`                | Self-saved user notes |
| `reactions_list`                | Emoji catalog |
| `*_reactions`                   | Message reaction tracking for all types |
| `stories`, `stories_likes`      | Temporary story-style content and reactions |

---

## 🛠️ Technologies Used

- **MySQL / MariaDB** (compatible)
- Relational data modeling
- Modern SQL features (ENUM, JSON, indexes, foreign keys)

---

## Sample Use Cases

- Register users, create channels, send and reply to messages
- Subscribe to channels or join groups
- Add emoji reactions to messages
- Save private messages and post stories

---

## 🔧 How to Use

1. Run the script in a MySQL-compatible environment (e.g., MySQL Workbench, DBeaver, or CLI).
2. All `DROP TABLE IF EXISTS` statements are included for safe resets.
3. The default schema is `messenger`. You can rename it as needed.

---

## 📂 File

The full SQL script is located in:

```
📁 messenger_schema.sql
```

---

## 📌 License

This project is provided for educational and demonstration purposes. Feel free to use and adapt it for your own learning or prototyping needs.
