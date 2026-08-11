-- Трекер соцсетей: дополнение к schema.sql
-- Выполнить один раз в Supabase → SQL Editor → New query → Run.
-- Основную schema.sql выполнять не нужно, если она уже выполнена.

-- 1. Отметки постинга: одна строка на (пользователь, день, площадка)
create table if not exists public.posting_marks (
  user_id  uuid not null references auth.users(id) on delete cascade,
  day      date not null,
  platform text not null,               -- telegram / youtube / instagram / tiktok / threads
  note     text not null default '',    -- о чем пост
  url      text not null default '',    -- ссылка на публикацию
  ts       timestamptz not null default now(),
  primary key (user_id, day, platform)
);

-- 2. Аккаунты соцсетей
create table if not exists public.social_accounts (
  user_id  uuid not null references auth.users(id) on delete cascade,
  id       text not null,               -- ключ аккаунта: tg, ig, tt, yt, a<ts>
  platform text not null,
  name     text not null default '',
  handle   text not null default '',
  url      text not null default '',
  sort     integer not null default 0,
  primary key (user_id, id)
);

-- 3. Срезы метрик: одна строка на (пользователь, аккаунт, дата)
create table if not exists public.social_snapshots (
  user_id    uuid not null references auth.users(id) on delete cascade,
  account_id text not null,
  date       date not null,
  followers  integer,
  views      bigint,
  likes      bigint,
  posts      integer,
  note       text not null default '',
  primary key (user_id, account_id, date),
  foreign key (user_id, account_id)
    references public.social_accounts(user_id, id) on delete cascade
);

-- 4. RLS: каждый видит и правит только свои строки
alter table public.posting_marks    enable row level security;
alter table public.social_accounts  enable row level security;
alter table public.social_snapshots enable row level security;

drop policy if exists "own rows" on public.posting_marks;
create policy "own rows" on public.posting_marks
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own rows" on public.social_accounts;
create policy "own rows" on public.social_accounts
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "own rows" on public.social_snapshots;
create policy "own rows" on public.social_snapshots
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
