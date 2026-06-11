-- ============================================================
-- Study Hub — Supabase Schema
-- Run this in your Supabase SQL editor (Dashboard → SQL Editor)
-- ============================================================

-- Subjects table
create table if not exists subjects (
  id           uuid primary key default gen_random_uuid(),
  user_id      text not null,         -- 'system' for admin subjects, username for students
  subject_name text not null,
  color        text not null default '#667eea',
  notes        text not null default '',
  doc_links    text not null default '',   -- newline-separated URLs
  periods      text not null default '',   -- comma-separated period numbers e.g. "1,3,5"
  created_at   timestamptz default now()
);

-- Enable Row Level Security
alter table subjects enable row level security;

-- Policy: anyone with the anon key can read/write
-- For a real production app you'd want auth-based policies,
-- but this mirrors the original app's behaviour.
create policy "allow all" on subjects
  for all using (true) with check (true);

-- Users table (for admin user management view)
create table if not exists users (
  id         uuid primary key default gen_random_uuid(),
  username   text unique not null,
  password   text not null,           -- store hashed in production!
  user_type  text not null default 'student',
  created_at timestamptz default now()
);

alter table users enable row level security;

create policy "allow all" on users
  for all using (true) with check (true);

-- Seed admin account
insert into users (username, password, user_type)
values ('admin', 'admin123', 'admin')
on conflict (username) do nothing;
