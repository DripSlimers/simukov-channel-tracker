-- Трекер проекта «ФОТОМАНИЯ»: дополнение к schema.sql
-- Выполнить один раз в Supabase → SQL Editor → New query → Run.
-- Существующих таблиц не касается: своя таблица, своя политика.

-- Состояние трекера поездки: одна строка на пользователя, всё одним jsonb.
-- Внутри: даты поездки, отметки чек-листа, журнал сканирования, журнал записей с дедом.
create table if not exists public.photomania_state (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.photomania_state enable row level security;

drop policy if exists "own rows" on public.photomania_state;
create policy "own rows" on public.photomania_state
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- updated_at обновляется само. Функцию создаём прямо здесь (create or replace),
-- чтобы этот скрипт можно было выполнять отдельно, не завися от schema.sql.
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists photomania_state_touch on public.photomania_state;
create trigger photomania_state_touch before update on public.photomania_state
  for each row execute function public.touch_updated_at();
