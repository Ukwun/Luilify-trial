# Liuify Planning & Scheduling Tool – MVP

> **48-hour MVP Sprint** | Point of Contact: Leylan (@Liuify)

## Getting Started
1. Provide your GitHub username to be added to the repository.  
2. Clone the repository once access is granted.  
3. Create a new branch for your implementation.  
4. Follow the commit and PR guidelines below.  

## Git Requirements

### Commit Guidelines
- Make frequent, atomic commits (at least 3–4 per day).  
- Use clear, descriptive commit messages.  
- Follow **Conventional Commits** format:

  ```
  feat: New feature or user-visible functionality
  fix:  Bug fix
  refactor: Code improvement, no behavior change
  docs: README, comments, setup guides
  chore: Tooling, config, deps, scripts — **no app logic**
  ```
- Push changes daily
- Create clear Pull Requests with descriptions of changes

### Branch Strategy
- Create a branch with format: `feature/your-github-username`
- Do not commit directly to main
- Keep PR descriptions clear and detailed

## Technical Stack
- **Frontend:** [Next.js 14+ (App Router)](https://nextjs.org/docs/app)
- **UI Components:** [shadcn/ui](https://ui.shadcn.com)
- **Styling:** [Tailwind CSS](https://tailwindcss.com)
- **State Management:** [Zustand](https://github.com/pmndrs/zustand) *(optional for global state)*
- **Database:** [Supabase (PostgreSQL)](https://supabase.com)
- **Deployment:** [Vercel](https://vercel.com)
- **Language:** TypeScript

## Project Structure
```
liuify-planning-tool-mvp/
├── supabase/
│   └── seed.sql               # Single, clear seed file
├── src/
│   ├── app/                   # Next.js App Router (correct location)
│   │   ├── page.tsx           # Dashboard
│   │   └── layout.tsx
│   ├── components/            # All UI components
│   ├── lib/
│   │   ├── supabase.ts        # DB client + queries
│   │   └── matching.ts        # Business logic (great separation!)
│   └── types/
│       └── index.ts           # TS types in one place
├── .env.example
├── .gitignore
├── package.json
└── README.md

## Success Criteria
1. **Code Quality & Organization**
   - Clear organization
   - Well-documented functions
   - Type hints usage
   - Proper logging
   - Consistent error handling

2. **Git Practice**
   - Regular commits (multiple times per day)
   - Clear commit messages
   - Proper branch usage
   - Well-documented PR

3. **Functionality**
   - Reliable device connection
   - Accurate UI navigation
   - Successful action execution
   - Proper error handling
   - Session management

## Device Requirements
- **Browser:** Latest version of Chrome, Edge, or Firefox
- **Screen Resolution:** Minimum 1280×720 (desktop first design)
- **Internet Connection:** Stable connection required for Supabase sync
- **Environment:** Node.js 18+ and npm installed
- **Vercel Account:** Required for deployment (GitHub integration)
- **Supabase Access:** Developer invite needed (database + API keys)

## Deliverable Format
1. All code pushed to the assigned repository.
2. README must include:
   - Setup instructions
   - Configuration guide
   - Usage examples
   - **Architecture overview of the MVP** (required)
   - Data model summary (guards, locations, shifts, assignments)
   - Environment variables and local run instructions
   - Database seeding instructions
   - Deployment steps for Vercel
   - Known limitations and next steps
3. Dependency file:
   - For Node projects: `package.json` (required)
   - If any Python utilities are included: also add `requirements.txt`
4. Example configuration files:
   - `.env.example` with safe placeholders
   - `config.example.json` if a config file is used
5. Clean Pull Request including:
   - Scope of what was built
   - Implementation details and key tradeoffs
   - Testing notes and how to reproduce
   - Checklist of completed items
   - Optional: screenshots or a short Loom walkthrough
6. Live demo URL deployed on Vercel (publicly accessible).

## Out of Scope (Conceptual Assignment)
**AI Bot Integration - Conceptual Question**

Scenario:
1. Guard reports an emergency to the AI bot.
2. Bot messages 19 other guards (Tier 1).
3. After X minutes with no response, bot escalates to phone calls (Tier 2).
4. Once the shift is filled, the bot notifies the planner.

**Your task (do not build this):**
Write **2–3 paragraphs in the README** explaining how you would architect this on top of your MVP. Consider:
- Webhooks and messaging APIs (e.g., SMS/WhatsApp), plus a queue/scheduler for retries and delays.
- State management for shift status, guard responses, escalation tiers, and timeouts.
- Handoff to a human planner, audit logs for all actions, and idempotency to avoid double fills.

git checkout John-trial
git push
git remote -v
