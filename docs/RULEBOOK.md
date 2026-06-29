---
title: Bank NAV Automation — Rulebook
tags: [pinnacle, automation, playbook, internal]
---

# Bank NAV Automation — Rulebook

> [!info] What this document is
> The full plain-English explanation of how this tool works, written so Warren can
> understand every moving part and teach the colleague from it. The short version
> she actually receives lives in [[EMAIL_TO_COLLEAGUE]]. This is the deep version.

## 1. What the tool does, in one breath

The colleague drops a bank statement PDF (LGT, Bank of Singapore, or UBS) into a folder.
The tool reads the **Gross NAV** and **Net NAV** off that PDF, writes them into a master
Excel, and saves a screenshot of the exact part of the PDF each number came from into a
Word document. She opens the Excel and the Word side by side, checks the numbers match the
screenshots, then copies the figures into her own master file.

Everything happens on her own computer. No file is ever sent to the internet. That is a
hard rule, which is why the tool reads PDFs with a local library (PyMuPDF) instead of any
cloud service.

> [!important] It is a draft, not the final file
> The Excel this tool produces is a **staging area**, not her real master spreadsheet. The
> whole point is to cut her work roughly in half: instead of reading each PDF and typing
> figures into her master and then double-checking, she lets the tool extract the numbers,
> eyeballs them once against the screenshots, and pastes them across as values.

## 2. The big picture of how it runs

There are two pieces of plumbing worth understanding.

**Python** is the engine. It is a programming language, and the whole tool is written in it.
Nothing runs unless Python is installed on the machine first.

**The `.bat` files** are the buttons. A `.bat` file ("batch file") is just a plain text file
holding a short list of commands, with a special ending that tells Windows "this is runnable."
Double-clicking one opens a black window and runs those commands for you, top to bottom, so
the colleague never has to open a terminal or type anything herself. You can open any `.bat`
in Notepad and read exactly what it will do. Nothing is hidden.

> [!note] Mac vs Windows launchers
> The folder has launchers ending in both `.bat` (Windows) and `.command` (Mac). Each
> operating system can only run its own kind, and double-clicking the wrong one simply does
> nothing. The colleague is on Windows, so she uses the `.bat` files and ignores the
> `.command` ones. They are harmless, just two sets of the same buttons for two machines.

## 3. Installing Python (the one part people get wrong)

Install **Python 3.12** specifically. The tool ships with its libraries pre-packaged for
Python 3.11 to 3.13, so 3.12 is the safe middle choice. A different version can cause the
offline install to fail and fall back to needing internet.

On the **first** install screen there is a checkbox: **"Add python.exe to PATH"**. Tick it
before clicking Install.

> [!tip] What "Add to PATH" actually means
> You do not choose where Python goes. The installer drops it in a default folder by itself
> (something like `C:\Users\<name>\AppData\Local\Programs\Python\Python312\`).
>
> PATH is a short list of folders that Windows searches whenever a command refers to a
> program by name. When a `.bat` file says the word `python`, Windows walks down that list
> and uses the **first** `python.exe` it finds, then stops. It does **not** scan the whole
> hard drive.
>
> Ticking the box does two things at once: it installs Python to that default folder **and**
> adds that folder to the PATH list. So with the box ticked, the `.bat` files can find Python
> instantly. With it unticked, Python is still installed but not on the list, so the `.bat`
> says "python was not found" and setup fails.

## 4. Getting the tool onto her PC

The project lives on GitHub as a **public** repo, so she needs no account and no login:

`https://github.com/WarrenLim1122/pinnacle-invoice-automation`

The simplest route for a non-technical person: open the link, click the green **Code**
button, choose **Download ZIP**, then right-click the downloaded file and **Extract All**.

> [!tip] Why download/clone instead of zipping your own folder
> A live copy of this project on Warren's Mac contains a hidden `.venv` folder. That folder
> holds libraries compiled for **macOS**, which will not run on Windows. GitHub never stores
> `.venv` (it is in `.gitignore`), so anything she downloads or clones from GitHub is already
> clean, with no `.venv` at all. Her `setup.bat` then builds a fresh **Windows** `.venv`.
> This is the whole reason we go through GitHub rather than emailing a zip of the Mac folder.

If she prefers the command line and has Git installed, the equivalent is:

```bash
git clone https://github.com/WarrenLim1122/pinnacle-invoice-automation.git
```

## 5. The two files she ever touches

| File | When | What it does |
|---|---|---|
| `setup.bat` | Once, ever | Builds the isolated Python environment and installs the libraries (offline, from the bundled `vendor` folder). |
| `run_watcher.bat` | Each working session | Starts the watcher and leaves a window open. This is the "go" button. |

> [!note] What setup.bat installs into
> It creates a folder called `.venv` (a "virtual environment"). Think of it as a private box
> inside the project that holds just this tool's libraries, kept separate from the rest of
> the computer. The libraries come from the `vendor` folder, which already contains the
> correct Windows files, so the install works with no internet. If that ever fails (usually
> a Python version mismatch), it automatically tries the internet as a backup.

## 6. What `run_watcher.bat` actually does

When double-clicked it: checks that setup has been run, activates the `.venv` box, then starts
`watcher.py` and keeps the window open. While that window stays open the watcher sits and
watches the three inbox folders:

- `banks\LGT\inbox`
- `banks\BoS\inbox`
- `banks\UBS\inbox`

The instant a PDF appears in one of them, the watcher:

1. waits until the file has finished copying (so it never reads a half-written file),
2. checks whether it has already done this exact file (see the re-do section below),
3. reads the Gross and Net NAV, writes them into `output\nav_master.xlsx`,
4. saves a screenshot of the exact PDF section into that bank's `_verification.docx`,
5. and at startup also sweeps up any PDFs already sitting in the inboxes, so nothing is missed.

> [!warning] It never moves or deletes her PDFs
> Originals stay exactly where she puts them. The tool remembers what it has processed by
> taking a fingerprint of each file's contents, not by moving files around.

## 7. Reading and copying the results

Open `output\nav_master.xlsx`. There is one tab per bank, and each row is one statement,
identified by the PDF's filename in the "Source PDF" column.

Open the matching Word file next to it, for example `banks\LGT\LGT_verification.docx`. It holds
the screenshots of where each number was read from. Glance across to confirm the figures match.

Then copy the three-column block (**Account No | Gross NAV | Net NAV**) into her own master
file, pasting **as values**. The Account No column is deliberately left blank, for her to fill
on her own machine using her own AI, so account numbers never leave her PC. The how-to for
that lives in [[FOR_COLLEAGUE_AI]].

> [!tip] Colour code in the Excel
> Numbers in **blue** are read straight off the PDF. Numbers in **black** are calculated by a
> formula (this happens for LGT, where the Gross figure is built by adding back negative line
> items). This is standard finance convention, blue for hardcoded, black for formula.

## 8. Re-doing a row (if she deletes something by mistake)

If she accidentally deletes rows in the Excel and wants them back, there are two ways:

**Her easy way:** delete that bank's PDF from its inbox folder, then drop the same PDF back
in. A freshly dropped file is treated as "do this again," so the row gets rebuilt. (This was a
deliberate change. Before, the tool would have skipped a file it had already seen.)

**The bulk way (for Warren or power use):** run `python run_all_once.py --redo`, which rebuilds every row from whatever PDFs are still in the inboxes, even ones already done.

> [!note] Why re-doing is safe
> Each PDF maps to one row by its filename, so re-doing overwrites that same row rather than creating a duplicate. You cannot end up with the same statement counted twice.

## 9. Stopping and starting

To **stop** the tool, close the black window the watcher runs in (or press Ctrl+C inside it).
On a Windows office PC that window is usually **PowerShell** (the older name is Command Prompt).
Closing it stops the watching. To start again the next day, double-click `run_watcher.bat`.

If she would rather run on demand instead of leaving a window open, `run_once.bat` processes
whatever is in the inboxes right now and then closes.

## 10. Things to watch for

- **First real statements:** the parsers were tuned on sample layouts and verified against
  synthetic PDFs that copy those layouts. They have not yet been proven on real-world
  variations (multiple portfolios, multiple pages, Bank of Singapore with non-zero
  liabilities). So for the first few real statements, check carefully against the screenshots.
- **Excel or Word open:** if the master Excel or a bank's Word file is open when a PDF is
  dropped, the write fails. The tool logs a clear message; just close the file and re-drop.
- **Account No still blank:** that is by design, not a bug. It is the one manual step, done on
  her side.

## 11. Where the settings live

Everything tweakable sits in `config.py`: the folder paths, the screenshot sharpness, and the
management fee rate (`MGMT_FEE_RATE`, currently unset until we agree the real rule against a
real statement). The output workbook is `output\nav_master.xlsx`.

---

Related: [[EMAIL_TO_COLLEAGUE]] · [[FOR_COLLEAGUE_AI]] · [[STATUS]] · [[STATEMENT_SPEC_TEMPLATE]]
