# Pinnacle Invoice / Fee Automation — router

Local-only tool: reads bank client-statement **PDFs**, pulls **Gross NAV + Net NAV**,
writes them to a master Excel (3 tabs, finance-formatted), and screenshots the exact PDF
section each number came from into a per-bank Word doc for human eyeball verification.

Real sample layouts are in `invoice examples/` (LGT.png, BoS.png, UBS.png) — the parsers
are tuned to these. Bank specifics:
- **UBS** "Total gross assets"/"Total net assets"; SPACE thousands + SGD prefix.
- **BoS** Gross = "Assets" (100%) row; Net = "Total Net Asset Value".
- **LGT** only Net ("Total"); Gross = Excel formula adding back negative line items.
Excel finance format: hardcoded = BLUE font, formulas = BLACK.

## 🔒 Hard constraints (client banking data — non-negotiable)
- **Everything runs locally. Nothing is ever uploaded.** No cloud parsers (this is
  why we use local `PyMuPDF`, NOT MinerU — MinerU uploads to its cloud).
- **Never move/delete the colleague's statement PDFs.** Originals stay in `inbox/`.
  De-duplication is by content hash in `processed_index.json`, not by moving files.
  Re-do: a freshly (re)dropped PDF force-reprocesses (overwrites its row); startup
  catch-up still skips already-done files. `run_all_once.py --redo` rebuilds all.
- Builds on Mac, **runs on Windows**. Keep all code cross-platform (use `pathlib`,
  no hard-coded `/` or `\` paths). The `.bat` files are the Windows entry points.

## Layout (what each piece does)
- `config.py` — ALL paths + the fee setting (`MGMT_FEE_RATE`). One place to tweak.
- `watcher.py` — auto-trigger: watches the 3 inboxes, processes new PDFs.
- `run_all_once.py` — manual one-shot processing.
- Launchers: `*.command` (Mac) + `*.bat` (Windows): setup / run_watcher / run_once.
- `banks/<LGT|BoS|UBS>/parser.py` — the **3 distinct per-bank parsers** (real logic).
- `shared/extract.py` — line grouping + number parsing (commas AND space thousands).
- `shared/fees.py` — LGT Gross-from-add-backs ("fee formula").
- `shared/excel_writer.py` — master workbook; blue=hardcoded, black=formula; upsert by filename.
- `shared/docx_writer.py` — per-bank verification `.docx` (values + add-backs + snapshots).
- `shared/snapshot.py` — renders a PDF section to PNG. `shared/process.py` — the glue.
- `output/nav_master.xlsx` — generated. `logs/` — run log + snapshot PNGs.
- `docs/STATEMENT_SPEC_TEMPLATE.md` — how colleague specifies layouts w/o sharing data.
- `docs/FOR_COLLEAGUE_AI.md` — prompt for her AI to fill Account No (column A).
- `docs/RULEBOOK.md` — Warren's detailed plain-English playbook (teach-the-colleague).
- `docs/EMAIL_TO_COLLEAGUE.md` — ready-to-send setup + daily-use email.

## Runtime / handoff facts
- Colleague runs on **Windows** → `.bat` launchers (`.command` are Mac, ignored).
- Deps pre-bundled in `vendor/` (Windows wheels, Py 3.11–3.13 x64) → `setup.bat` installs
  **offline** (`--no-index --find-links vendor`, online fallback). Recommend Python 3.12.
- Outputs are a **DRAFT/staging** area, not her master file. Copy table = the 3-col A:C
  block (Account No | Gross NAV | Net NAV); she pastes into her master as VALUES.
- `HANDOFF.md` (root) = AI-readable handoff for the colleague.
- **GitHub (deployment):** public repo `WarrenLim1122/pinnacle-invoice-automation`.
  Colleague gets it via `git clone` or **Code → Download ZIP** (no account needed,
  no `.venv` carried). She then runs `setup.bat` to build a fresh Windows `.venv`.

## Open (see docs/STATUS.md)
- Validate against real/dummy PDFs (multi-portfolio, multi-page, BoS non-zero liabilities).
- Account No (column A) blank → next task: her AI fills it (`docs/FOR_COLLEAGUE_AI.md`).

## Run (dev)
`python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt`
then `python run_all_once.py` (after a PDF is in an inbox).
