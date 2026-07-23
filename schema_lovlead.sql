-- Трекер тест-группы lovlead: дополнение к schema.sql
-- Выполнить один раз в Supabase → SQL Editor → New query → Run.

-- Тестеры: одна строка на (пользователь, тестер), вся карточка одним jsonb
create table if not exists public.lovlead_testers (
  user_id    uuid not null references auth.users(id) on delete cascade,
  id         text not null,              -- ключ тестера: t02..t29, n<ts>
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

alter table public.lovlead_testers enable row level security;

drop policy if exists "own rows" on public.lovlead_testers;
create policy "own rows" on public.lovlead_testers
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- updated_at обновляется само (функция touch_updated_at уже создана в schema.sql)
drop trigger if exists lovlead_testers_touch on public.lovlead_testers;
create trigger lovlead_testers_touch before update on public.lovlead_testers
  for each row execute function public.touch_updated_at();
