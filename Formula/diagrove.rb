# frozen_string_literal: true

# Homebrew formula for the diagrove command-line tool (D391, D403, D1374). tools/release-cli.sh fills in
# 1.0.0, https://github.com/ninjaappsnet/homebrew-diagrove/releases/download/v1.0.0/diagrove-1.0.0-macos.zip, a0f609fa29605e53a2a3599763e6d048f016279acb572adc0d66ffb9ee231821 and https://ninjaapps.net/apps/diagrove/ and writes it as Formula/diagrove.rb in the tap,
# github.com/ninjaappsnet/homebrew-diagrove (docs/specs/cli-release.md).
class Diagrove < Formula
  desc "Command-line tool to make, change and draw Diagrove diagrams"
  homepage "https://ninjaapps.net/apps/diagrove/"
  url "https://github.com/ninjaappsnet/homebrew-diagrove/releases/download/v1.0.0/diagrove-1.0.0-macos.zip"
  version "1.0.0"
  sha256 "a0f609fa29605e53a2a3599763e6d048f016279acb572adc0d66ffb9ee231821"

  livecheck do
    url :url
    strategy :github_latest
  end

  # A universal binary for macOS 26 and later (ADR 0008).
  depends_on macos: :tahoe

  def install
    # diagrove reads its resource bundles (Stencil libraries, templates) from beside itself, and
    # finds them through the link in bin.
    libexec.install "diagrove", *Dir["*.bundle"]
    bin.install_symlink libexec/"diagrove"
    prefix.install "LICENSES.txt"
  end

  def caveats
    <<~EOS
      Teach Claude Code to use diagrove:
        diagrove skill install
      Use it from an MCP client: the command is diagrove and the argument is mcp.

      The first time diagrove --live changes a diagram open in Diagrove, macOS asks
      whether your terminal (or AI app) may control Diagrove. Allow it, or change it
      later in System Settings > Privacy & Security > Automation.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/diagrove --version").strip
    (testpath/"flow.gtext").write "a: \"Start\"\nb: \"Done\"\na -> b\n"
    system bin/"diagrove", "new", "--text", "flow.gtext", "-o", "flow.diagrove", "--quiet"
    assert_path_exists testpath/"flow.diagrove/document.json"
    assert_match "\"ok\":true", shell_output("#{bin}/diagrove validate flow.diagrove --quiet")
  end
end
