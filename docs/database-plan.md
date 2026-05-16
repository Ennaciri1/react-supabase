# Database Plan

Starting schema for the project. Tables are intentionally simple and can be extended.

## Tables

### `profiles`
Public profile per authenticated user. One-to-one with `auth.users`.

| Column      | Type          | Notes                                 |
|-------------|---------------|---------------------------------------|
| id          | uuid (PK)     | references `auth.users(id)` on delete cascade |
| username    | text unique   | display handle                        |
| full_name   | text          |                                       |
| avatar_url  | text          | optional, points to Storage           |
| created_at  | timestamptz   | default `now()`                       |
| updated_at  | timestamptz   | default `now()`                       |

### `categories`
Product categories.

| Column      | Type          | Notes                  |
|-------------|---------------|------------------------|
| id          | uuid (PK)     | default `gen_random_uuid()` |
| name        | text not null |                        |
| slug        | text unique   |                        |
| created_at  | timestamptz   | default `now()`        |

### `products`
A product belongs to a category and to an owner (a profile).

| Column      | Type          | Notes                                   |
|-------------|---------------|-----------------------------------------|
| id          | uuid (PK)     | default `gen_random_uuid()`             |
| owner_id    | uuid          | references `profiles(id)` on delete cascade |
| category_id | uuid          | references `categories(id)` on delete set null |
| name        | text not null |                                         |
| description | text          |                                         |
| price_cents | integer       | not null, default 0                     |
| created_at  | timestamptz   | default `now()`                         |

### `orders`
An order placed by a user.

| Column        | Type          | Notes                                 |
|---------------|---------------|---------------------------------------|
| id            | uuid (PK)     | default `gen_random_uuid()`           |
| buyer_id      | uuid          | references `profiles(id)`             |
| status        | text          | `pending` / `paid` / `cancelled` / `shipped` |
| total_cents   | integer       | not null, default 0                   |
| created_at    | timestamptz   | default `now()`                       |

### `order_items`
Line items of an order.

| Column        | Type          | Notes                                 |
|---------------|---------------|---------------------------------------|
| id            | uuid (PK)     | default `gen_random_uuid()`           |
| order_id      | uuid          | references `orders(id)` on delete cascade |
| product_id    | uuid          | references `products(id)`             |
| quantity      | integer       | not null, default 1                   |
| unit_price_cents | integer    | not null                              |

## Relations

```
auth.users 1───1 profiles 1───* products *───1 categories
                       │
                       1
                       │
                       *
                     orders 1───* order_items *───1 products
```

## RLS policy summary

| Table        | Read                                  | Write                              |
|--------------|---------------------------------------|------------------------------------|
| profiles     | anyone authenticated can read         | only owner can update              |
| categories   | anyone (even anon) can read           | service-role only                  |
| products     | anyone can read                       | only `owner_id = auth.uid()` can insert/update/delete |
| orders       | only `buyer_id = auth.uid()` can read | only `buyer_id = auth.uid()` can insert |
| order_items  | readable if parent order is readable  | writable if parent order is writable |

Implementation lives in `supabase/migrations/003_enable_rls.sql` (starter — extend as you add tables).
