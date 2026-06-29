# STATUS

## Done & verified (against synthetic PDFs that replicate the 3 real sample layouts)
- 3 banks (LGT, BoS, UBS), each with `inbox/` + its own real `parser.py`.
- Folder-watch trigger (`watcher.py`) + manual run (`run_all_once.py`).
- Launchers for BOTH OSes: `*.command` (Mac) and `*.bat` (Windows).
- Pipeline: PDF → Gross/Net NAV → master Excel (3 tabs) → section screenshot → per-bank `.docx`.
- Local-only screenshots via PyMuPDF (NOT MinerU — MinerU uploads to cloud).
- File-safety: originals never moved/deleted; de-dupe by content hash.

## Extraction logic (real, not placeholder)
- **UBS** — reads "Total gross assets" / "Total net assets"; handles SPACE thousands + SGD prefix.
- **BoS** — Gross = the "Assets" (100%) row; Net = "Total Net Asset Value". Net=Gross when liabilities 0.
- **LGT** — Net = "Total"; finds negative line items; Gross = live Excel formula `=Net-SUM(addbacks)`.
- Finance formatting: hardcoded = BLUE, formulas = BLACK. Add-back cells tagged with line-item name.

## Open
1. **Validate against real layouts** — confirm via dummy/redacted PDFs or the colleague's
   answers in `docs/STATEMENT_SPEC_TEMPLATE.md` (esp. multi-portfolio PDFs, multi-page,
   exact label wording, BoS non-zero-liability case).
2. **Account No (column A)** — currently blank; filled by colleague's own AI via
   `docs/FOR_COLLEAGUE_AI.md`. Could be automated once we know where it sits on each statement.
3. **Multiple clients per PDF** — parsers currently assume one account per PDF.

## Deferred (placeholders left in)
- Email ingestion / more file formats — add a new reader in `shared/readers/`.

## Confirmed / added this session
- Colleague runs on **Windows** → she uses the `.bat` files (`.command` are Mac, ignored).
- Offline install: Windows wheels bundled in `vendor/` (covers Python 3.11–3.13 x64);
  `setup.bat` installs with `--no-index --find-links vendor`. Recommend Python 3.12.
- Outputs are a **DRAFT/staging** area, not the master file. The copy-paste table is the
  3-column A:C block (Account No | Gross NAV | Net NAV); paste into master as VALUES.

## Open question for Warren
- (resolved) OS = Windows.
