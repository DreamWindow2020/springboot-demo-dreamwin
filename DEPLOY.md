# Render Deployment Guide

## Prerequisites
- Code pushed to GitHub (`munirajan24/springboot-demo`)
- [Render](https://render.com) account connected to your GitHub

---

## Step 1 — Push Latest Code

```bash
git add .
git commit -m "add Flyway migrations, React UI, env var config"
git push origin master
```

---

## Step 2 — Create a Web Service on Render

1. Go to **render.com → New → Web Service**
2. Select your GitHub repo: `munirajan24/springboot-demo`
3. Render detects the `Dockerfile` automatically — keep **Language = Docker**
4. Fill in:
   | Field | Value |
   |---|---|
   | Name | `springboot-demo-dreamwin` (or anything) |
   | Region | Singapore (Southeast Asia) |
   | Branch | `master` |
   | Plan | Free |

---

## Step 3 — Set Environment Variables

Add these **3 variables** in the Environment Variables section before deploying:

| Name | Value |
|---|---|
| `SPRING_DATASOURCE_URL` | `jdbc:postgresql://db.cdbwldjqqwjezlizlptm.supabase.co:5432/postgres?sslmode=require` |
| `SPRING_DATASOURCE_USERNAME` | `postgres` |
| `SPRING_DATASOURCE_PASSWORD` | `YourShop@2026!` |

> **Note:** Do not embed the username/password inside the URL — keep them in separate vars.

---

## Step 4 — Deploy

Click **Deploy Web Service**.

Render will:
1. Clone the repo and build the Docker image (Maven runs inside the container)
2. Start the JAR — Flyway automatically creates the `items` table and seeds 5 rows on first boot
3. Poll `/actuator/health` to confirm the service is healthy

Your app will be live at:
```
https://<your-service-name>.onrender.com
```

| URL | What you get |
|---|---|
| `/` | React UI (live API tester) |
| `/api/items` | JSON — all items |
| `/api/items/{id}` | JSON — single item |
| `/actuator/health` | Health check |

---

## Redeployment

Every `git push origin master` triggers an automatic redeploy on Render.

To run a new migration, add a new file to `src/main/resources/db/migration/` following the naming convention `V2__description.sql`, `V3__description.sql`, etc.
