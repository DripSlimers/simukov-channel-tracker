-- Трекер каналов: схема для Supabase
-- Выполнить один раз в Supabase → SQL Editor → New query → Run.

-- 1. Недельные показатели: одна строка на (пользователь, неделя, канал)
create table if not exists public.week_entries (
  user_id    uuid    not null references auth.users(id) on delete cascade,
  week_start date    not null,               -- понедельник недели
  channel    text    not null,               -- ключ канала: maps, partner, chats, ...
  touches    integer not null default 0,     -- касания
  replies    integer not null default 0,     -- ответы
  dialogs    integer not null default 0,     -- диалоги
  calls      integer not null default 0,     -- созвоны
  deals      integer not null default 0,     -- сделки
  revenue    numeric not null default 0,     -- выручка
  hours      numeric not null default 0,     -- часов ушло
  updated_at timestamptz not null default now(),
  primary key (user_id, week_start, channel)
);

-- 2. Прочее состояние: статусы каналов и галочки задач, одним jsonb на пользователя
create table if not exists public.app_state (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- 3. RLS: каждый видит и правит только свои строки
alter table public.week_entries enable row level security;
alter table public.app_state    enable row level security;

drop policy if exists "own rows" on public.week_entries;
create policy "own rows" on public.week_entries
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "own rows" on public.app_state;
create policy "own rows" on public.app_state
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- 4. updated_at обновляется само
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists week_entries_touch on public.week_entries;
create trigger week_entries_touch before update on public.week_entries
  for each row execute function public.touch_updated_at();

drop trigger if exists app_state_touch on public.app_state;
create trigger app_state_touch before update on public.app_state
  for each row execute function public.touch_updated_at();
