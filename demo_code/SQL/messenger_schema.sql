-- SQL Schema: Messenger App
-- Compatible with MySQL / MariaDB
-- Demonstrates advanced relational design: 1:1, 1:M, M:M, ENUMs, JSON fields, indexing, and constraints

-- Drop and recreate the database
DROP DATABASE IF EXISTS messenger;
CREATE SCHEMA messenger;
USE messenger;

-- Users table
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(100),
    lastname VARCHAR(100) COMMENT 'Last name',
    login VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(256),
    phone BIGINT UNSIGNED UNIQUE COMMENT 'e.g. +7 (900) 123-45-67 → 79001234567',
    birthday DATE,
    INDEX idx_users_username(firstname, lastname)
) COMMENT = 'User accounts';

-- User settings (1:1 relationship)
DROP TABLE IF EXISTS user_settings;
CREATE TABLE user_settings (
    user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    is_premium_account BIT,
    is_night_mode_enabled BIT,
    color_scheme ENUM('classic', 'day', 'tinted', 'night'),
    app_language ENUM('english', 'french', 'russian', 'german', 'belorussian', 'croatian', 'dutch'),
    status_text VARCHAR(70),
    notifications_and_sounds JSON,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Private messages (1:M relationship)
DROP TABLE IF EXISTS private_messages;
CREATE TABLE private_messages (
    id SERIAL,
    sender_id BIGINT UNSIGNED NOT NULL,
    receiver_id BIGINT UNSIGNED NOT NULL,
    reply_to_id BIGINT UNSIGNED NULL,
    media_type ENUM('text', 'image', 'audio', 'video'),
    body TEXT,
    filename VARCHAR(200),
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id),
    FOREIGN KEY (reply_to_id) REFERENCES private_messages(id)
);

-- Groups
DROP TABLE IF EXISTS groups;
CREATE TABLE groups (
    id SERIAL,
    title VARCHAR(45),
    icon VARCHAR(45),
    invite_link VARCHAR(100),
    settings JSON,
    owner_user_id BIGINT UNSIGNED NOT NULL,
    is_private BIT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (owner_user_id) REFERENCES users(id)
);

-- Group members (M:M relationship)
DROP TABLE IF EXISTS group_members;
CREATE TABLE group_members (
    id SERIAL,
    group_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (group_id) REFERENCES groups(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Group messages (1:M)
DROP TABLE IF EXISTS group_messages;
CREATE TABLE group_messages (
    id SERIAL,
    group_id BIGINT UNSIGNED NOT NULL,
    sender_id BIGINT UNSIGNED NOT NULL,
    reply_to_id BIGINT UNSIGNED NULL,
    media_type ENUM('text', 'image', 'audio', 'video'),
    body TEXT,
    filename VARCHAR(100),
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (group_id) REFERENCES groups(id),
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (reply_to_id) REFERENCES group_messages(id)
);

-- Channels
DROP TABLE IF EXISTS channels;
CREATE TABLE channels (
    id SERIAL,
    title VARCHAR(45),
    icon VARCHAR(45),
    invite_link VARCHAR(100),
    settings JSON,
    owner_user_id BIGINT UNSIGNED NOT NULL,
    is_private BIT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (owner_user_id) REFERENCES users(id)
);

-- Channel subscribers (M:M)
DROP TABLE IF EXISTS channel_subscribers;
CREATE TABLE channel_subscribers (
    channel_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    status ENUM('requested', 'joined', 'left'),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, channel_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (channel_id) REFERENCES channels(id)
);

-- Channel messages
DROP TABLE IF EXISTS channel_messages;
CREATE TABLE channel_messages (
    id SERIAL,
    channel_id BIGINT UNSIGNED NOT NULL,
    sender_id BIGINT UNSIGNED NOT NULL,
    media_type ENUM('text', 'image', 'audio', 'video'),
    body TEXT,
    filename VARCHAR(100),
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (channel_id) REFERENCES channels(id),
    FOREIGN KEY (sender_id) REFERENCES users(id)
);

-- Saved messages (self-storage)
DROP TABLE IF EXISTS saved_messages;
CREATE TABLE saved_messages (
    id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Reactions catalog
DROP TABLE IF EXISTS reactions_list;
CREATE TABLE reactions_list (
    id SERIAL,
    code VARCHAR(1)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Private message reactions
DROP TABLE IF EXISTS private_message_reactions;
CREATE TABLE private_message_reactions (
    reaction_id BIGINT UNSIGNED NOT NULL,
    message_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (reaction_id) REFERENCES reactions_list(id),
    FOREIGN KEY (message_id) REFERENCES private_messages(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Channel message reactions
DROP TABLE IF EXISTS channel_message_reactions;
CREATE TABLE channel_message_reactions (
    reaction_id BIGINT UNSIGNED NOT NULL,
    message_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (reaction_id) REFERENCES reactions_list(id),
    FOREIGN KEY (message_id) REFERENCES channel_messages(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Group message reactions
DROP TABLE IF EXISTS group_message_reactions;
CREATE TABLE group_message_reactions (
    reaction_id BIGINT UNSIGNED NOT NULL,
    message_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (reaction_id) REFERENCES reactions_list(id),
    FOREIGN KEY (message_id) REFERENCES group_messages(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Stories (ephemeral content)
DROP TABLE IF EXISTS stories;
CREATE TABLE stories (
    id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    caption VARCHAR(140),
    filename VARCHAR(100),
    views_count INT UNSIGNED,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Story likes
DROP TABLE IF EXISTS stories_likes;
CREATE TABLE stories_likes (
    id SERIAL,
    story_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (story_id) REFERENCES stories(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
