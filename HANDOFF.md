# Handoff — read this first (for the colleague and her AI)

This project automates reading **Gross NAV** and **Net NAV** off private-bank client
statements (LGT, Bank of Singapore = BoS, UBS) so they don't have to be typed by hand.
**Everything runs locally on this Windows PC. No file is ever uploaded anywhere.**

## ⚠️ The Excel and Word files are a DRAFT / staging area — NOT the final deliverable
The real/master file lives in another folder. The point of this tool is to **cut the work
in half**: instead of reading each PDF and typing figures into the master file (then
re-checking), the colleague:
1. lets the tool extract the figures into the draft `output/nav_master.xlsx`,
2. **eyeballs once** — compares the draft numbers against the screenshots in the Word
   doc (`banks/<bank>/<bank>_verification.docx`),
3. then **copy-pastes** the figures from the draft into her master file.

So treat `nav_master.xlsx` / the `.docx` as scratch that gets overwritten each run.

## The table she copies = 3 columns
On every bank tab, the first three columns are exactly:

| Account No (A) | Gross NAV (B) | Net NAV (C) |
|----------------|---------------|-------------|

That A:C block is what she copies into her master file. (Columns to the right —
Source PDF, Page, Updated At, Flags, and LGT's add-back detail — are only there to help
her eyeball; she doesn't copy those.)

**When copying into the master file, paste as VALUES** (in Excel: Paste Special → Values).
This matters because LGT's Gross NAV is a live formula; pasting as values turns it into a
plain number so it doesn't break in the destination file.

## How the whole system runs (Windows)
1. **One-time:** double-click **`setup.bat`** (installs the bundled libraries offline).
2. **Every day:** double-click **`run_watcher.bat`** and leave the window open.
3. Drop a statement PDF into the matching folder:
   `banks\LGT\inbox\`, `banks\BoS\inbox\`, `banks\UBS\inbox\`.
4. It processes within a second or two. Eyeball, then copy A:C into the master file.
   - On-demand instead of watching? Use **`run_once.bat`**.
5. **No need to delete old files** — already-processed files are skipped automatically
   (matched by content), so nothing duplicates. Just drop the new PDF in.

The `.command` files next to the `.bat` files are the Mac versions — **ignore them on Windows.**

## What each bank does
- **UBS / BoS** — Gross and Net NAV are read straight off the statement.
- **LGT** — the statement shows only the Net NAV ("Total"). The tool finds the negative
  line items (e.g. Credit, Derivatives) and writes Gross NAV as a formula that adds them
  back. Each add-back cell is tagged with its name. (Blue = read off the PDF, Black = formula.)

## 👉 NEXT TASK (for tomorrow) — add Account Numbers
The tool fills Gross NAV and Net NAV. **Account No (column A) is intentionally left blank**
because there's no account-number example yet. The next session's job:

> Tell your AI (ChatGPT / Gemini, running on this computer) **where the account number sits
> on each bank's PDF**, then have it read the account number from each statement and write
> it into **column A** of the matching row in `output/nav_master.xlsx`. The result is the
> finished 3-column table: **Account Number | Gross NAV | Net NAV**.

The ready-to-use AI prompt and tips are in **`docs/FOR_COLLEAGUE_AI.md`**.
If you instead tell Warren *where* the account number appears on each bank's statement,
the Python can be updated to read it automatically and this AI step disappears entirely.

## If something looks wrong
- The **Flags** column in the Excel notes when a figure couldn't be found.
- Full run log: `logs\automation.log`.
