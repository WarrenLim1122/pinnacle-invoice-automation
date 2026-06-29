# Session handoff — Obsidian seeding + global CLAUDE.md cleanup (post-deploy)

> Persistent resume file. Paste into a fresh session (or auto-load via a SessionStart hook).
> Delta only — project overview, bank logic, constraints, and deploy facts live in CLAUDE.md & docs (auto-loaded).

**Role:** Warren builds on his Mac with Claude; the colleague runs it on her **Windows** PC and owns the real master file. The Excel/docx this tool makes are a DRAFT she copies from.

## Status — updated 2026-06-29
- (carry) **Deployed + shipped:** public repo `WarrenLim1122/pinnacle-invoice-automation`; output is `output/nav_master.xlsx`; re-do feature (re-drop a PDF, or `run_all_once.py --redo`). Colleague docs: `docs/EMAIL_TO_COLLEAGUE.md` + `docs/RULEBOOK.md`. Details in CLAUDE.md.
- **Confirmed:** the tool runs fully **without column A**. Account No is the only manual step; NAV extraction works without it.
- **Obsidian:** seeded this project's vault (AnuPpuccin theme + obsidian-style-settings plugin; `appearance.json` set). Added `.obsidian/` and `.vscode/` to `.gitignore`. Committed + pushed. (Warren must reload Obsidian to see it.)
- **Global config:** `~/Coding Projects/` was renamed to `~/Claude-Code/`. Updated `~/.claude/CLAUDE.md` — fixed all path refs, light reorg (TOC + numbered §1–13 + tightened prose, no rules lost), and fixed the Obsidian-seeding rule (scope now `~/Claude-Code/`; seeds when a bare `.obsidian` is noticed, not strictly first-session). This is a global file, not under version control, just saved in place.

## Next actions
1. **Account No (column A)** — main open task. Either her AI fills it via `docs/FOR_COLLEAGUE_AI.md`, or get the per-bank account-number location and add it to `banks/<bank>/parser.py`.
2. **Validate parsers on real layouts** — one dummy/redacted PDF per bank (multi-page, multi-portfolio UBS, BoS non-zero liabilities). See `docs/STATEMENT_SPEC_TEMPLATE.md`.

## Running state
- Background processes: none
- Dev servers / ports: none
- Worktrees / branches: `main`, pushed to `origin` (public GitHub). Clean tree.

## Open items
- Account-number extraction: lands in Python (needs layout info) or stays an AI step on her side.
- Real-statement accuracy unproven (parsers verified on synthetic PDFs only).
- If `~/.claude` is ever put under version control, the refreshed global `CLAUDE.md` should be committed there.

## Pick up here
Most likely next: the account-number task — open `docs/FOR_COLLEAGUE_AI.md` and either run that AI prompt to fill column A, or get the per-bank account-number location and add it to the parsers.
