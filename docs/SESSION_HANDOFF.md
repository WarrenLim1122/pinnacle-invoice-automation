# Session handoff — built the bank NAV automation end-to-end (LGT/BoS/UBS)

> Persistent resume file. Paste into a fresh session (or auto-load via a SessionStart hook).
> Delta only — project overview, bank logic, and constraints live in CLAUDE.md & docs (auto-loaded).

**Role:** Warren builds it (on his Mac) with Claude; his colleague runs it (on her **Windows** PC) and owns the real/master file. The Excel/docx this tool makes are a DRAFT she copies from.

## Status — updated 2026-06-29
- Full pipeline built and verified end-to-end on synthetic PDFs that replicate the three real sample layouts in `invoice examples/` (LGT.png, BoS.png, UBS.png).
- Real extraction logic per bank (not placeholder) — details in CLAUDE.md. Quick recap: UBS reads Total gross/net assets (space-thousands + SGD); BoS Gross="Assets" 100% row, Net="Total Net Asset Value"; LGT Net="Total", Gross = live Excel formula adding back negative line items.
- Excel finance format applied: hardcoded=blue, formulas=black; LGT add-back cells tagged with line-item name. Verified colors + formula `=C-SUM(addbacks)` compute correctly.
- Offline install bundled: `vendor/` has Windows wheels (Py 3.11–3.13 x64). `setup.bat` uses `--no-index --find-links vendor` with online fallback. Offline mechanism tested (fresh venv, no internet, imports OK).
- Outputs are DRAFT/staging — copy table = 3-col A:C (Account No | Gross NAV | Net NAV), paste into master as VALUES. Documented in `HANDOFF.md` + README.
- Cleaned up: removed redundant `README_WINDOWS.md` (README.md covers Windows) and `.DS_Store`. Single README now.
- `.venv/` kept on disk for Warren's Mac dev (gitignored, do not ship).

## Session 2 delta — deployed + polished (2026-06-29)
- **Pushed to GitHub, now PUBLIC:** `WarrenLim1122/pinnacle-invoice-automation`. Colleague gets it by `git clone` or Code → Download ZIP (no login; clone/ZIP excludes `.venv`, so no Mac binaries travel). This is the deployment path: GitHub → she downloads → `setup.bat` builds a fresh Windows `.venv`.
- **Renamed** output workbook `fees_master.xlsx` → `nav_master.xlsx` everywhere (config + all docs).
- **Re-do feature:** re-dropping a PDF into an inbox force-reprocesses (overwrites its row); startup catch-up still skips already-done files; `run_all_once.py --redo` rebuilds all. Safe because Excel upserts by filename. Compiled + smoke-tested.
- **Did NOT rename `banks/`** (Warren considered `input/`; left as-is because it is an imported Python package and he is risk-averse to structural change).
- **New deliverables:** `docs/EMAIL_TO_COLLEAGUE.md` (ready-to-send) + `docs/RULEBOOK.md` (detailed teach-from playbook covering Python/PATH, the .bat buttons, watcher, re-do, stop, ignore-Mac-files).

## How she runs it (Warren asked to be reminded — Windows)
1. `setup.bat` once (offline install from `vendor/`).
2. `run_watcher.bat` and leave open — OR `run_once.bat` for on-demand.
3. Drop PDFs into `banks\LGT\inbox\`, `banks\BoS\inbox\`, `banks\UBS\inbox\`.
4. Results: `output\nav_master.xlsx` (3-col A:C to copy) + `banks\<bank>\<bank>_verification.docx` (screenshots to eyeball once).
5. No need to delete old files — content-hash de-dup skips them; only new drops process.
- **Auto-start at boot:** put a shortcut to `run_watcher.bat` in the Startup folder (`Win+R` → `shell:startup`). Steps in `README.md` ("Make it auto-start when you log in") and `HANDOFF.md`. The `.command` files are Mac equivalents — she ignores them.

## Next actions (tomorrow)
1. **Account numbers** — the main open task. Either: (a) colleague tells her AI (ChatGPT/Gemini, on her PC) where the account number sits on each bank PDF and fills column A using the prompt in `docs/FOR_COLLEAGUE_AI.md`; or (b) she tells Warren where it sits and we add it to the Python parsers (then the AI step disappears). Goal = finished 3-col table Account No | Gross NAV | Net NAV.
2. **Validate parsers on real layouts** — get one dummy/redacted PDF per bank (fake numbers, real layout) and confirm extraction, especially: multi-page statements, multiple portfolios in one UBS PDF, BoS with non-zero liabilities. See `docs/STATEMENT_SPEC_TEMPLATE.md`.

## Running state
- Background processes: none
- Dev servers / ports: none
- Worktrees / branches: `main`, pushed to `origin` (GitHub, public). Working tree clean.
- Dev venv: `.venv/` exists on Warren's Mac (gitignored). Do NOT ship it; the repo excludes `.venv` and includes `vendor/`.

## Open items
- Confirm colleague's installed **Python version** on Windows (recommend 3.12; vendor covers 3.11–3.13). If she has something else, setup falls back to online.
- Whether account-number extraction ends up in Python (needs layout info) or stays an AI step.
- (done) Remote: pushed to GitHub, public. `.gitignore` blocks all client PDFs/Excel/docx and the `invoice examples/` crops.

## Pick up here
Tomorrow's focus is account numbers: open `docs/FOR_COLLEAGUE_AI.md` and either run that AI prompt to fill column A, or get the account-number location per bank and add it to `banks/<bank>/parser.py`.
