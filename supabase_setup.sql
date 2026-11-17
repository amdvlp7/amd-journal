-- AMD Journal: Supabase SQL setup
-- Run this script in Supabase Dashboard > SQL Editor.
create table if not exists public.trades (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  coin text not null,
  market text not null default 'Spot',
  open_date date not null,
  open_time time not null,
  direction text not null check (direction in ('Long','Short')),
  status text not null default 'Open' check (status in ('Open','Closed')),
  reason text not null,
  day_mood text,
  entry_mood text,
  entry numeric,
  exit numeric,
  qty numeric,
  fees numeric default 0,
  stop numeric,
  target numeric,
  notes text,
  created_at timestamptz not null default now()
);
alter table public.trades enable row level security;
drop policy if exists "Users can read own trades" on public.trades;
create policy "Users can read own trades" on public.trades
  for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Users can insert own trades" on public.trades;
create policy "Users can insert own trades" on public.trades
  for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Users can update own trades" on public.trades;
create policy "Users can update own trades" on public.trades
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete own trades" on public.trades;
create policy "Users can delete own trades" on public.trades
  for delete to authenticated using (auth.uid() = user_id);
create index if not exists trades_user_open_date_idx on public.trades(user_id, open_date desc);
