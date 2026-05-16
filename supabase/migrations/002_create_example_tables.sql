-- 002_create_example_tables.sql
-- Example domain tables: categories and products.

create table if not exists public.categories (
    id          uuid primary key default gen_random_uuid(),
    name        text not null,
    slug        text unique,
    created_at  timestamptz not null default now()
);

create table if not exists public.products (
    id          uuid primary key default gen_random_uuid(),
    owner_id    uuid not null references public.profiles (id) on delete cascade,
    category_id uuid references public.categories (id) on delete set null,
    name        text not null,
    description text,
    price_cents integer not null default 0,
    created_at  timestamptz not null default now()
);

create index if not exists products_owner_id_idx    on public.products (owner_id);
create index if not exists products_category_id_idx on public.products (category_id);
