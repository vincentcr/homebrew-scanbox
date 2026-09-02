class Scanbox < Formula
  desc "Scan from older HP MFPs that macOS dropped support for"
  homepage "https://github.com/vincentcr/scanbox"
  url "https://github.com/vincentcr/scanbox/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "147b002ea14b1e871cb1f16bc4ff1d55c8d739da012448211cc0533b60cbbb89"
  license "MIT"

  # The VM is a runtime component, created on first scan -- but lima has to be
  # there before that can happen, and forgetting it is the likeliest first-run
  # failure. This is the main reason the formula exists.
  depends_on "lima"
  depends_on :macos

  # No python dependency on purpose. The host side is Python but imports only
  # the standard library -- no virtualenv, nothing to build -- and Homebrew
  # itself requires the Command Line Tools, which ship python3. Anything that
  # can install this can already run it. bin/scanbox picks an interpreter by
  # asking it its version, so a too-old pyenv shim on PATH is stepped over
  # rather than inherited.
  def install
    # bin/scanbox resolves its own location through symlinks, so it finds the
    # scanbox package, lib/ and provision/ under libexec however it is invoked.
    libexec.install "bin", "lib", "provision", "scanbox", "scanbox.yaml",
                    "config.example"
    bin.install_symlink libexec/"bin/scanbox"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      Discover your scanner and save the config:

        scanbox setup

      Then scan with:

        scanbox scan

      The Debian VM is created on first scan (a few minutes, once) and stops
      itself after 60 idle minutes. Scans land in ~/Pictures/Scans.
    EOS
  end

  test do
    assert_match "scanbox", shell_output("#{bin}/scanbox --help")
  end
end
