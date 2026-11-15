-- 내 앱 런처(apps) 동기화용 테이블 — personal-apps 프로젝트 SQL Editor에서 한 번 실행
create table if not exists public.applinks (
  user_id    uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data       jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.applinks enable row level security;

drop policy if exists "applinks_select_own" on public.applinks;
drop policy if exists "applinks_insert_own" on public.applinks;
drop policy if exists "applinks_update_own" on public.applinks;
drop policy if exists "applinks_delete_own" on public.applinks;

create policy "applinks_select_own" on public.applinks for select using (auth.uid() = user_id);
create policy "applinks_insert_own" on public.applinks for insert with check (auth.uid() = user_id);
create policy "applinks_update_own" on public.applinks for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "applinks_delete_own" on public.applinks for delete using (auth.uid() = user_id);
