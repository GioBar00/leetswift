# Contributing to Swift LeetCode Diary

Thanks for your interest in this project! Here's how to get involved.

---

## 🗓️ Using This as Your Own Diary

This repository is a **template** — it's designed to be forked so you can maintain your own private LeetCode diary in Swift.

1. Click **"Use this template"** on the GitHub page to create your own copy.
2. Clone it locally and start adding challenges with `swift create.swift <slug>`.
3. Your diary, your rules — no need to submit anything back.

---

## 🛠️ Contributing Structural Improvements

Improvements to the **template itself** (new shared utilities, CLI features, CI workflows, documentation fixes, bug reports) are very welcome via Pull Request.

### What's in scope for PRs
- Bug fixes in the CLI, `BenchmarkRunner`, `create.swift`, or `Package.swift`
- New shared helper types (e.g., new `Shared/` utilities like `Graph.swift`)
- CI/CD and workflow improvements
- Documentation corrections or enhancements
- Tooling (Makefile targets, scripts)

### What's NOT in scope for PRs
- Individual LeetCode solutions — those belong in your own forked diary

---

## ✍️ Commit Message Convention

This project uses **[Conventional Commits](https://www.conventionalcommits.org/)** to enable automated changelog generation. All commits must follow this format:

```
<type>(<optional scope>): <short description>

[optional body]

[optional footer]
```

### Types

| Type | When to use |
|------|-------------|
| `feat` | A new feature or capability |
| `fix` | A bug fix |
| `docs` | Documentation changes only |
| `chore` | Maintenance, dependency updates, CI config |
| `refactor` | Code restructuring without behavior change |
| `test` | Adding or fixing tests |
| `perf` | Performance improvements |

### Examples

```
feat(cli): add --json output flag to benchmark command
fix(benchmark): correct memory footprint calculation on Linux
docs: update two-sum README with real complexity table
chore(ci): pin SwiftyLab/setup-swift to v1.3.2
refactor(shared): extract formatDuration to CLIHelpers
```

> [!IMPORTANT]
> Commit messages are enforced by a blocking `commitlint` CI check on all Pull Requests.
> PRs with non-conforming messages will not be merged until fixed.

---

## 🔀 Pull Request Process

1. Fork the repository and create a feature branch: `git checkout -b feat/my-improvement`
2. Make your changes with properly formatted commit messages
3. Open a Pull Request against `main`
4. The CI suite (build, tests, commitlint) must pass
5. One review approval is sufficient for merge

---

## 📦 Release Process

Releases use a two-step automated pipeline:

1. **Trigger a version bump** via GitHub Actions → Actions → **"Bump Version"** → **Run workflow**.
   Choose the bump type: `patch`, `minor`, `major`, or `prerelease` (with a label: `alpha`, `beta`, `rc`).
   The workflow computes the next version from the latest tag and pushes it automatically.

2. **The release is created automatically** when the tag lands. `git-cliff` reads all conventional commits
   since the previous tag, generates grouped release notes, updates `CHANGELOG.md`, and publishes the GitHub Release.

**Prerelease flow example:**
```
Bump: prerelease (beta) → v1.1.0-beta.1
Bump: prerelease (beta) → v1.1.0-beta.2  (auto-increments)
Bump: minor             → v1.1.0          (stable release)
```

Prerelease GitHub Releases are automatically marked as pre-release on the repository page.

---

## 🔄 Updating Your Fork from the Template

When this template gets improvements (new CLI features, shared utilities, CI updates), you can pull them into your own fork.

### Quick path — GitHub Sync Fork button
If your fork hasn't diverged much from the template (no structural file conflicts), use GitHub's built-in sync:
1. Open your fork on GitHub
2. Click **"Sync fork"** → **"Update branch"**

This merges all upstream changes at once. Works best if you haven't modified structural files (CLI, Shared/, workflows).

### Robust path — Upstream remote (recommended)
For full control over what gets merged, especially if you've customized structural files:

```bash
# One-time setup: add the template as a remote
git remote add upstream https://github.com/GioBar00/swift-leetcode-diary.git

# Fetch latest changes from the template
git fetch upstream

# Merge template changes into your main branch
git merge upstream/main
```

Resolve any merge conflicts that arise (these will only be in structural files you've customized — your personal solution files in `Sources/leetcodes/<slug>/` and `Tests/leetcodesTests/<slug>/` will never conflict).

Alternatively, cherry-pick only specific commits you want:
```bash
git cherry-pick <commit-sha>
```

> [!TIP]
> Check the [CHANGELOG.md](CHANGELOG.md) or GitHub Releases page to see what changed in each version before deciding whether to update.
