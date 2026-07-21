// Настройки подключения к Supabase.
// Взять в Supabase → Project Settings → API:
//   SUPABASE_URL      - поле "Project URL"
//   SUPABASE_ANON_KEY - поле "anon public"
//
// Ключ anon публичный по замыслу: он не дает доступа к данным сам по себе.
// Доступ режет RLS в schema.sql - каждый видит только свои строки, и только после входа.
window.TRACKER_CONFIG = {
  SUPABASE_URL: 'ВСТАВЬ_СЮДА_PROJECT_URL',
  SUPABASE_ANON_KEY: 'ВСТАВЬ_СЮДА_ANON_KEY',
};
