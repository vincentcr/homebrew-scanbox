class Scanbox < Formula
  desc "Scan from older HP MFPs that macOS dropped support for"
  homepage "https://github.com/vincentcr/scanbox"
  url "https://github.com/vincentcr/scanbox/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "83253c95d6dcafa8d11d7666c7a647db2c3005294242a75f46be2663990cd7b4"
  license "MIT"

  # The VM is a runtime component, created on first scan -- but lima has to be
  # there before that can happen, and forgetting it is the likeliest first-run
  # failure. This is the main reason the formula exists.
  depends_on "lima"
  depends_on :macos

  def install
    # scanner resolves its own location through symlinks, so it finds lib/ and
    # provision/ from libexec no matter how it is invoked.
    libexec.install "bin", "lib", "provision", "scanbox.yaml", "config.example"
    bin.install_symlink libexec/"bin/scanbox"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      Discover your scanner and save the config:

        scanbox find

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
