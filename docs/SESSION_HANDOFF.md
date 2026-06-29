# Session handoff — deployed to public GitHub + colleague-facing docs

> Persistent resume file. Paste into a fresh session (or auto-load via a SessionStart hook).
> Delta only — project overview, bank logic, constraints, and deploy facts live in CLAUDE.md & docs (auto-loaded).

**Role:** Warren builds on his Mac with Claude; the colleague runs it on her **Windows** PC and owns the real master file. The Excel/docx this tool makes are a DRAFT she copies from.

## Status — updated 2026-06-29 (session 2)
- **Deployed.** Repo is live and **public**: `WarrenLim1122/pinnacle-invoice-automation`. Delivery path = she clones or uses Code → Download ZIP (no login; excludes `.venv`), then `setup.bat` builds a fresh Windows `.venv`. (See CLAUDE.md §Runtime/handoff facts.)
- **Renamed** output workbook to `output/nav_master.xlsx` (was `fees_master.xlsx`) everywhere.
- **Re-do feature shipped** (see CLAUDE.md §Hard constraints): re-dropping a PDF force-reprocesses its row; startup catch-up still skips; `run_all_once.py --redo` rebuilds all. Compiled + smoke-tested.
- **Decided NOT to rename `banks/`** — it is an imported Python package and Warren is wary of structural change. Left as-is.
- **New colleague-facing docs:** `docs/EMAIL_TO_COLLEAGUE.md` (ready-to-send) and `docs/RULEBOOK.md` (detailed teach-from playbook).
- Working tree clean; 2 commits pushed this session (`003f8e9`, `970464e`).

## Next actions
1. **Account No (column A)** — still the main open task. Either her own AI fills it via `docs/FOR_COLLEAGUE_AI.md`, or get the per-bank account-number location and add it to `banks/<bank>/parser.py`.
2. **Validate parsers on real layouts** — one dummy/redacted PDF per bank to confirm extraction on multi-page, multi-portfolio (UBS), and BoS non-zero-liability cases. See `docs/STATEMENT_SPEC_TEMPLATE.md`.

## Running state
- Background processes: none
- Dev servers / ports: none
- Worktrees / branches: `main`, pushed to `origin` (public GitHub). Clean tree.

## Open items
- Whether account-number extraction lands in Python (needs layout info) or stays an AI step on her side.
- Real-statement accuracy unproven (parsers tuned to the 3 sample crops, verified on synthetic PDFs only) — flagged in the email/rulebook for first real runs.

## Pick up here
Most likely next: work the account-number task — open `docs/FOR_COLLEAGUE_AI.md` and either run that AI prompt to fill column A, or get the per-bank account-number location from Warren/colleague and add it to the parsers.
