class BeadMeUpScotty < Formula
  desc "Local web UI for the beads (bd) issue tracker"
  homepage "https://beadmeupscotty.com"
  url "https://github.com/brendan-appstart/bead-me-up-scotty/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "8146308b54ba05eb5b4c2d67b30984d2e06147037d6954ade79f96c8b8d4cfc3"
  license "MIT"
  head "https://github.com/brendan-appstart/bead-me-up-scotty.git", branch: "main"

  depends_on "node"

  def install
    # The release tarball has no .git, so pin the build badge to the tag.
    ENV["BUILD_SHA"] = "v#{version}" if build.stable?
    ENV["NEXT_TELEMETRY_DISABLED"] = "1"

    system "npm", "ci", "--no-audit", "--no-fund"
    system "npm", "run", "build"
    system "npm", "prune", "--omit=dev", "--no-audit", "--no-fund"
    rm_r ".next/cache"

    libexec.install "bin", ".next", "node_modules", "public", "package.json", "next.config.ts", "LICENSE"
    bin.install_symlink libexec/"bin/bead-me-up-scotty.mjs" => "scotty"
    bin.install_symlink libexec/"bin/bead-me-up-scotty.mjs" => "bead-me-up-scotty"
  end

  def caveats
    <<~EOS
      Run `scotty` from a folder containing a .beads repo to open its board.
      Live mode needs the `bd` CLI on your PATH (https://github.com/gastownhall/beads);
      without it the app runs in demo mode.

      Anonymous usage statistics are on by default for new installs and can be
      turned off in Settings.

      Homebrew manages updates: use `brew upgrade bead-me-up-scotty` rather than
      the in-app "Update now" button.
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/scotty --help")

    port = free_port
    ENV["BEADS_DEMO"] = "1"
    pid = spawn bin/"scotty", "--no-open", "--port", port.to_s
    begin
      30.times do
        sleep 1
        break if quiet_system "curl", "-sfL", "http://localhost:#{port}/"
      end
      assert_match "<html", shell_output("curl -sfL http://localhost:#{port}/")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
