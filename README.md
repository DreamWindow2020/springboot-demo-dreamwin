# demo-springboot-supabase

Minimal Spring Boot REST API with one database table (`items`), backed by a
Supabase Postgres database, deployable to Render.

## What's in here

- `Item` entity → `items` table (`id`, `name`, `description`, `created_at`)
- `ItemRepository` (Spring Data JPA)
- `ItemController` — REST CRUD at `/api/items`
- `/actuator/health` — health check endpoint (used by Render)
- CORS wide open under `/api/**` for demo purposes

Table is auto-created on startup (`spring.jpa.hibernate.ddl-auto=update`) —
no manual SQL or migration tool needed for this demo.

## 1. Create the Supabase database

1. Create a project at supabase.com (free tier is fine).
2. Go to **Project Settings → Database → Connection string**.
3. Copy the **Session pooler** connection string (port 5432) — it's the most
   compatible with a long-lived JDBC connection pool like Hikari. Avoid the
   *Transaction* pooler (port 6543) for this app; it doesn't support some
   things Hibernate relies on (prepared statement caching).
4. You don't need to create the `items` table yourself — Hibernate does it
   on first boot. If you'd rather manage schema by hand, set
   `spring.jpa.hibernate.ddl-auto=validate` and create the table via the
   Supabase SQL editor first.

## 2. Run locally

```bash
cp .env.example .env
# edit .env with your real Supabase host/username/password
export $(grep -v '^#' .env | xargs)   # or use a tool like direnv
./mvnw spring-boot:run
```

Test it:

```bash
curl http://localhost:8080/actuator/health

curl -X POST http://localhost:8080/api/items \
  -H "Content-Type: application/json" \
  -d '{"name":"First item","description":"hello from Spring Boot"}'

curl http://localhost:8080/api/items
```

## 3. Deploy to Render

1. Push this project to a GitHub repo.
2. In Render: **New → Web Service**, connect the repo. Render will detect
   the `Dockerfile` and `render.yaml` automatically (or pick "Docker" as
   the runtime manually if prompted).
3. Set these environment variables in the Render dashboard (Render will
   prompt for them since `render.yaml` marks them `sync: false`):
   - `SPRING_DATASOURCE_URL`
   - `SPRING_DATASOURCE_USERNAME`
   - `SPRING_DATASOURCE_PASSWORD`
4. Deploy. Render sets `PORT` automatically; the app already reads it via
   `server.port=${PORT:8080}`.
5. Once live, health check: `https://<your-app>.onrender.com/actuator/health`

## API reference

| Method | Path              | Body                                  | Description        |
|--------|-------------------|----------------------------------------|---------------------|
| GET    | /api/items        | —                                       | List all items      |
| GET    | /api/items/{id}   | —                                       | Get one item        |
| POST   | /api/items        | `{"name": "...", "description": "..."}` | Create an item      |
| PUT    | /api/items/{id}   | `{"name": "...", "description": "..."}` | Update an item      |
| DELETE | /api/items/{id}   | —                                       | Delete an item      |

## Notes for going beyond a demo

- CORS is wide open (`*`) — restrict `allowedOrigins` to your real frontend
  domain before this is anything but a demo.
- `ddl-auto=update` is convenient but not safe for production schema
  changes — switch to Flyway/Liquibase migrations.
- Add Spring Security / API keys before exposing write endpoints publicly.
