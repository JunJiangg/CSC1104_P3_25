# Git Team Notes: Clone → Feature Branch → Pull Request (PR)

A fast, practical playbook for a 4‑person team (or any team) using Git + GitHub.

---

## 0) One‑time setup (do this once per machine)

```bash
# Set your identity (use --global once, omit if you want per-repo)
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

#this config prevent accidental merging if conflict happens
git config --global pull.ff only

# Optional: nice defaults
git config --global init.defaultBranch main
git config --global pull.ff only            # prevent accidental merge commits on pull
git config --global fetch.prune true        # auto-prune deleted remote branches
git config --global rerere.enabled true     # reuse recorded conflict resolutions
```


## 1) Clone the repository

```bash
git clone <repo-url>           # HTTPS or SSH
cd <repo-name>
git remote -v                  # verify origin
git branch -vv                 # see local branches and tracking info
```

> Right after clone, your local `main` matches the remote `origin/main` **at that moment**.

---

## 2) Start a new feature branch (always from fresh `main`)

```bash
git fetch origin
git switch main
git pull --ff-only origin main
git switch -c feature/ABC-123-short-title  # name: type/ticket-short-desc
```

The safer way, it fetches origin and allows u to check the different before u switch to main and pulls everything into that local main branch in ur pc
git fetch origin
git log main..origin/main --oneline   # optional check
git diff main..origin/main            # optional check
git switch main
git pull --ff-only origin main

**Tip:** Use a consistent naming convention, e.g. `feature/`, `bugfix/`, `hotfix/`.

---

## 3) Work locally, commit early and often

```bash
git status
git add -p             # stage hunks interactively (or: git add .)
git commit -m "feat: implement X"
# types: feat, fix, docs, chore, refactor, test, perf, build, ci
```

**Good commits are small and focused.**

---

## 4) Keep your branch current with `main`

**Option A — Rebase (clean history, recommended):**
```bash
git fetch origin
git rebase origin/main
# If conflicts: edit files to resolve, then
git add <file1> <file2>
git rebase --continue
# If you need to bail out:
git rebase --abort
# After a successful rebase, your commit IDs changed:
git push --force-with-lease
```

**Option B — Merge (simpler mental model):**
```bash
git fetch origin
git merge origin/main
# If conflicts: edit → git add <files> → git commit
git push
```

> Use **one** approach per team to keep history consistent.

---

## 5) Push your feature branch to GitHub

```bash
git push -u origin feature/ABC-123-short-title   # -u sets upstream for future pushes
```

---

## 6) Open a Pull Request (PR)

- On GitHub: **Compare & pull request** for `feature/...` → `main`  
- Fill in title & description (what, why, how tested)
- Request reviewers
- Ensure CI checks pass (tests, linters, build)

**PR checklist (quick):**
- ✅ Small, focused changes
- ✅ Tests updated/passing
- ✅ Code style/lint passes
- ✅ Clear description & screenshots/logs if helpful

---

## 7) Address review feedback

```bash
# Make changes locally
git add .
git commit -m "fix: address review comments"
git push           # same branch; PR updates automatically
```

If `main` moved while you were reviewing, **rebase or merge** the latest `origin/main` (see Step 4).

---

## 8) Merge the PR (strategy)

In repo settings, make **Squash and merge** the default (clean history).  
Alternative strategies:
- **Merge commit:** preserves branch history (can be noisy)
- **Rebase and merge:** linear history, keeps individual commits

After merging in GitHub: **Delete the branch**.

---

## 9) Post‑merge cleanup locally

```bash
git switch main
git pull --ff-only origin main
git branch -d feature/ABC-123-short-title   # delete local branch
git fetch --prune                           # remove remote-tracking branch refs
```

---

## 10) Start the next feature

Repeat from **Step 2**.

---

## Handy troubleshooting

```bash
git log --oneline --graph --decorate --all    # visualize history
git status                                     # what changed / staged
git diff                                       # see unstaged changes
git diff --staged                              # see staged changes
git restore --staged <file>                    # unstage a file
git restore <file>                             # discard local changes in a file
git stash -u                                   # stash incl. untracked files
git stash pop                                  # reapply stash
git reflog                                     # find lost commits/branches
git reset --soft HEAD~1                        # undo last commit, keep changes staged
git reset --hard HEAD~1                        # **danger**: drop last commit & changes
```

---

## Quick “When do I pull / rebase / push?”

- **Before creating a new branch:** `git pull --ff-only origin main`
- **While working on a branch:** periodically `git fetch` then **rebase** or **merge** `origin/main`
- **Before opening a PR:** ensure your branch is up to date with `origin/main`
- **After PR merges:** switch to `main` and `git pull --ff-only origin main`

---

## Minimal day‑to‑day command recap

```bash
# Start feature
git fetch origin
git switch main && git pull --ff-only origin main
git switch -c feature/ABC-123

# Work
git add .
git commit -m "feat: do thing"
git push -u origin feature/ABC-123

# Refresh with latest main (rebase path)
git fetch origin
git rebase origin/main
git push --force-with-lease

# Open PR on GitHub → get reviews → CI green → squash merge

# After merge
git switch main
git pull --ff-only origin main
git branch -d feature/ABC-123
git fetch --prune
```
