# frozen_string_literal: true

# Homebrew formula for the diagrove command-line tool (D391, D403, D1374). tools/release-cli.sh fills in
# 1.1.0, https://github.com/ninjaappsnet/homebrew-diagrove/releases/download/v1.1.0/diagrove-1.1.0-macos.zip, caaefd0ca8b76349e8a1f85c04fad7e5003a0c6d7a3e17fb6b38ee52bd165095 and https://ninjaapps.net/apps/diagrove/ and writes it as Formula/diagrove.rb in the tap,
# github.com/ninjaappsnet/homebrew-diagrove (docs/specs/cli-release.md).
class Diagrove < Formula
  desc "Command-line tool to make, change and draw Diagrove diagrams"
  homepage "https://ninjaapps.net/apps/diagrove/"
  url "https://github.com/ninjaappsnet/homebrew-diagrove/releases/download/v1.1.0/diagrove-1.1.0-macos.zip"
  version "1.1.0"
  sha256 "caaefd0ca8b76349e8a1f85c04fad7e5003a0c6d7a3e17fb6b38ee52bd165095"

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

      Reading, checking and rendering are free. Making or changing a document needs
      Diagrove's 14-day trial or Diagrove Pro: install Diagrove from the App Store, open
      it, and keep it open while diagrove writes. diagrove status shows what it sees.

      The first time diagrove --live changes a diagram open in Diagrove, macOS asks
      whether your terminal (or AI app) may control Diagrove. Allow it, or change it
      later in System Settings > Privacy & Security > Automation.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/diagrove --version").strip
    # Reading, checking and rendering are free; making or changing a document needs Diagrove open
    # with its trial or Diagrove Pro, which a test can't have.
    (testpath/"flow.gtext").write "a: \"Start\"\nb: \"Done\"\na -> b\n"
    assert_match "\"ok\":true", shell_output("#{bin}/diagrove validate flow.gtext --quiet")
    system bin/"diagrove", "render", "flow.gtext", "-o", "flow.png", "--quiet"
    assert_path_exists testpath/"flow.png"
  end
end
