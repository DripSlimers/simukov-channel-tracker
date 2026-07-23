// Настройки подключения к Supabase.
// Взять в Supabase → Project Settings → API:
//   SUPABASE_URL      - поле "Project URL"
//   SUPABASE_ANON_KEY - поле "anon public"
//
// Ключ anon публичный по замыслу: он не дает доступа к данным сам по себе.
// Доступ режет RLS в schema.sql - каждый видит только свои строки, и только после входа.
window.TRACKER_CONFIG = {
  SUPABASE_URL: 'https://yiybhnjwbpvpdolcaiuc.supabase.co',
  SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpeWJobmp3YnB2cGRvbGNhaXVjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ4MTI5ODksImV4cCI6MjEwMDM4ODk4OX0.e7HpfgeKhWEbiwMLqm2VW028jgU-TN6MSVAt7HBFZBg',
};
