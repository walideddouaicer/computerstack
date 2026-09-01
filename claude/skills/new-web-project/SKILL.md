---
name: new-web-project
description: Start a new web app, site, or full-stack project. Use when Walid says "new app", "new web project", "build me a site", "let's make a web app", describes something with pages, users, or a database, or wants to turn an idea into something running in a browser. Not for data analysis projects, that is new-ml-project.
---

# New web project

Walid is not a web developer. He does ML and data work. That single fact decides
everything in this file.

Two consequences, and they override every other preference:

1. **He must be able to review what you build.** He cannot debug a framework he has
   never seen. Boring and conventional beats clever and current, every time.
2. **He must be able to see it working.** He judges by looking, not by reading code.
   Nothing is "done" until it is on screen in a browser.

## Boundary with design-agent

| | |
|---|---|
| **this skill** | stack, structure, data, deploy. Makes it *work*. |
| **design-agent** | how the screens look. Makes it *good*. |

Set the project up here. Hand every visual decision to design-agent. Do not design
screens in this skill, and do not pick palettes or type scales. Say when you are
handing over.

---

## The stack

**Default, unless a reason below applies:**

```
Next.js (App Router) + TypeScript + Tailwind + shadcn/ui
Postgres + Prisma           when there is data
Vercel                      when it needs to be online
```

Four reasons this is the default, in order of weight:

1. **One language.** TypeScript front and back. He reviews one language, not two.
2. **Largest training presence of any web stack**, so you write it with fewer mistakes.
   Boring is a feature here.
3. **shadcn/ui is what design-agent already targets.** Same components both sides.
4. **Prisma over Drizzle** specifically because of Prisma Studio: he can open a browser
   and *look at his data* without writing SQL. Drizzle is the better tool for someone
   who lives in SQL. That is not the constraint here.

### When to deviate

Deviate for these reasons, and say which one out loud before you do:

| Situation | Use instead |
|---|---|
| Mostly content: blog, docs, landing pages, little interactivity | **Astro.** Ships almost no JavaScript. Do not reach for a React framework to render text. |
| The core of it is Python: ML inference, dataframes, scientific libraries | **FastAPI backend + Next.js frontend.** His Python is his real skill. Do not make him rewrite pandas in TypeScript. |
| A script, a CLI, a one-off scraper | **No framework at all.** A Python file is the correct answer surprisingly often. |
| An existing project | **Whatever it already uses.** Match it. Never introduce a second way of doing things. |

If none of those fit, use the default. Do not deviate for taste, novelty, or benchmarks.

### The Next.js trap, stated once

The **server component vs client component** split is the single most confusing thing
in this stack, and it produces errors that are hard to diagnose without experience.

So: **whenever you add a `"use client"`, say in one line why it was needed.** Usually it
is state, an event handler, or a browser API. If you cannot name the reason, the
component probably should not be a client component.

---

## Build order

This is the part that matters most. Most projects fail here, not in the stack choice.

**Build a vertical slice. Never build in horizontal layers.**

```
WRONG                             RIGHT
schema  →  API  →  UI  →  look    one screen you can look at, immediately
                                        ↓  then real data behind it
he stares at nothing for an hour        ↓  then the one core interaction
and cannot tell if it works             ↓  then everything else
```

### 1. Something on screen, in the first ten minutes

```bash
npx create-next-app@latest <name> --typescript --tailwind --app
cd <name> && npm run dev
```

One page. Hardcoded content. No database, no auth, no API. **Give him the URL and stop.**

He now knows the machine works and can see the thing. Everything after this is
improvement rather than faith.

### 2. Real data behind that same screen

Only now add Postgres and Prisma. One table. Real rows. The screen he already saw now
shows data from the database instead of hardcoded strings.

Run `npx prisma studio` and tell him the URL, so he can see the rows himself.

### 3. The one interaction that defines the app

Not all of them. The one that makes it the thing it is. For a novel app, that is
writing and saving a chapter. Get that working end to end.

### 4. Everything else, one at a time

**Never add two systems in one step.** Not a database and auth together. Not a new page
and a new dependency together. When something breaks, he must be able to point at the
one thing that changed.

### 5. Auth, last, and never hand-rolled

Use a library. Auth.js, Clerk, or whatever the host platform provides. **Never write
your own session handling, password hashing, or token logic.** This is not a matter of
effort, it is a matter of it being wrong in ways nobody notices until it matters.

---

## Never

- **Never hand-roll auth.** Repeated because it is the one that actually hurts.
- **Never add a state management library** before there is state that hurts. `useState`
  goes a very long way.
- **Never set up Docker, CI, or a monorepo on day one.** Add each the day it is needed
  and not before.
- **Never build a backend for something with no data.** A static page is allowed to be
  a static page.
- **Never add a dependency without saying what it is for**, in one line.
- **Never commit `.env`.** Create `.env.example` with the keys and no values.
- **Never say it works if you have not opened it.**

---

## Verification

He cannot read the code carefully enough to catch your mistakes. So the burden is on you.

At every stage:

- **Run it.** `npm run dev` and confirm the page actually renders.
- **Give him a URL**, not a description.
- Check the browser console. Report errors even if the page looks fine.
- If lavish-axi is installed, open it there so he can annotate directly.

When you report progress, say what you **ran**, not what you wrote.

---

## What to write down

Create `CLAUDE.md` at the project root at step 1, and keep it current:

```markdown
# <name>

<One sentence: what this is and who uses it.>

## Stack
<what, and the one-line reason for anything non-default>

## Commands
npm run dev / build / test

## Data
<the tables, and what one row means>

## Decisions
<choices made, with reasons. especially anything he would otherwise
re-litigate in a month.>
```

Rules for it: **only what the code cannot say.** No file listings, no dependency
versions, no component structure. Those are in the repo and will go stale here. Keep it
under 40 lines.

## Do not

- Do not design screens. That is design-agent.
- Do not create files nobody asked for. No README until he asks.
- Do not scaffold pages "for later". Build the one he asked for.
