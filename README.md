# brendan-appstart/homebrew-tap

Homebrew formulae for [Bead Me Up, Scotty](https://github.com/brendan-appstart/bead-me-up-scotty) — a local web UI for the [beads](https://github.com/gastownhall/beads) (`bd`) issue tracker.

## Install

```bash
brew install brendan-appstart/tap/bead-me-up-scotty
```

Or tap first, then install:

```bash
brew tap brendan-appstart/tap
brew install bead-me-up-scotty
```

Then run `scotty` (or `bead-me-up-scotty`) from any folder. Run it inside a folder that has a `.beads` repo to open that project's board. For live data you also need `bd` on your `PATH`; without it the app runs in demo mode.

## Update and uninstall

```bash
brew upgrade bead-me-up-scotty
brew uninstall bead-me-up-scotty
```

## Releasing a new version

1. Tag and publish the release in the app repo (for example `v0.4.0`).
2. Bump the formula. This updates `url` and `sha256`, commits, and opens a PR:

   ```bash
   brew bump-formula-pr --url https://github.com/brendan-appstart/bead-me-up-scotty/archive/refs/tags/v0.4.0.tar.gz brendan-appstart/tap/bead-me-up-scotty
   ```

   Or edit `Formula/bead-me-up-scotty.rb` by hand. Get the new hash with
   `curl -sL <tarball-url> | shasum -a 256`.
3. CI runs `brew test-bot` on the PR. Merge when it passes.
