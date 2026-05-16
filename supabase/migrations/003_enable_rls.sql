-- 003_enable_rls.sql
-- Enable Row Level Security and define starter policies.

-- =========================
-- profiles
-- =========================
alter table public.profiles enable row level security;

drop policy if exists "profiles are readable by authenticated users" on public.profiles;
create policy "profiles are readable by authenticated users"
on public.profiles for select
to authenticated
using (true);

drop policy if exists "users can update their own profile" on public.profiles;
create policy "users can update their own profile"
on public.profiles for update
to authenticated
using  (auth.uid() = id)
with check (auth.uid() = id);

-- profiles are inserted automatically by the trigger (security definer),
-- so no insert policy is needed for end users.

-- =========================
-- categories (public read, no anon write)
-- =========================
alter table public.categories enable row level security;

drop policy if exists "categories are readable by anyone" on public.categories;
create policy "categories are readable by anyone"
on public.categories for select
to anon, authenticated
using (true);

-- Inserts/updates/deletes on categories require the service_role (no policy = denied for anon/authenticated).

-- =========================
-- products
-- =========================
alter table public.products enable row level security;

drop policy if exists "products are readable by anyone" on public.products;
create policy "products are readable by anyone"
on public.products for select
to anon, authenticated
using (true);

drop policy if exists "users can insert their own products" on public.products;
create policy "users can insert their own products"
on public.products for insert
to authenticated
with check (auth.uid() = owner_id);

drop policy if exists "users can update their own products" on public.products;
create policy "users can update their own products"
on public.products for update
to authenticated
using  (auth.uid() = owner_id)
with check (auth.uid() = owner_id);

drop policy if exists "users can delete their own products" on public.products;
create policy "users can delete their own products"
on public.products for delete
to authenticated
using (auth.uid() = owner_id);
