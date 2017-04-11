CREATE TABLE
  users (
    id INTEGER PRIMARY KEY,
    fname VARCHAR NOT NULL,
    lname VARCHAR NOT NULL
  );

CREATE TABLE
  questions (
    id INTEGER PRIMARY KEY,
    title VARCHAR,
    body TEXT,
    user_id INTEGER,

    FOREIGN KEY (user_id) REFERENCES users(id)
  );

CREATE TABLE
  question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    question_id INTEGER,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
  );

CREATE TABLE
  replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply INTEGER,
    user_id INTEGER,
    body TEXT,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
  );

CREATE TABLE
  question_likes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    question_id INTEGER,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
  );

INSERT INTO
  users (fname, lname)
VALUES
  ('Audrey', 'Mefford'),
  ('Trevor', 'O''Connor');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Lunch?', 'Like I said, lunch?', (SELECT id FROM users WHERE fname = 'Audrey')),
  ('Cookies?', 'Do you have any?', (SELECT id FROM users WHERE fname = 'Trevor'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Trevor'), (SELECT id FROM questions WHERE title = 'Lunch?')),
  ((SELECT id FROM users WHERE fname = 'Audrey'), (SELECT id FROM questions WHERE title = 'Cookies?'));

INSERT INTO
  replies (question_id, parent_reply, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Lunch?'), NULL, (SELECT id FROM users WHERE fname = 'Trevor'), 'Sure');

INSERT INTO
  replies (question_id, parent_reply, user_id, body)
VALUES 
  ((SELECT id FROM questions WHERE title = 'Lunch?'), (SELECT id FROM replies WHERE question_id IS NOT NULL),
  (SELECT id FROM users WHERE fname = 'Audrey'), 'Cool');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Audrey'), (SELECT id FROM questions WHERE title = 'Cookies?'));
