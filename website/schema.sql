-- Alternative Asset Literacy — Contact Form D1 Schema

CREATE TABLE IF NOT EXISTS contact_submissions (
  id          TEXT    PRIMARY KEY DEFAULT (lower(hex(randomblob(16)))),
  name        TEXT    NOT NULL,
  email       TEXT    NOT NULL,
  subject     TEXT    NOT NULL,
  message     TEXT    NOT NULL,
  route       TEXT    NOT NULL DEFAULT 'general',
  ip          TEXT,
  submitted_at INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_contact_email      ON contact_submissions(email);
CREATE INDEX IF NOT EXISTS idx_contact_route      ON contact_submissions(route);
CREATE INDEX IF NOT EXISTS idx_contact_submitted  ON contact_submissions(submitted_at DESC);
