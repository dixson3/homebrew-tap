class Yf < Formula
  desc "Yoshiko Flow CLI: install, upgrade, verify, and preflight portable agent skills."
  homepage "https://github.com/dixson3/yoshiko-flow"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.2.0/yf-aarch64-apple-darwin.tar.xz"
      sha256 "df6be16c1280e3f30850e0ea551677f223803682747ae1dd61baa92da492cbe7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.2.0/yf-x86_64-apple-darwin.tar.xz"
      sha256 "dfded1380cceb38b8e80db1ef1f73f476f8ab1bd2783451ee2b848ca8e35f1f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.2.0/yf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "930b3b8d66ded84ffcb67b3958cefb564860c7b41c5069eb021bce293a6c1f06"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.2.0/yf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f363f6b893e614745e0b82a1f2676532c353c236c03ba8a821fefd4b71aa5226"
    end
  end
  license "MIT"
  depends_on "beads"
  depends_on "uv"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "yf" if OS.mac? && Hardware::CPU.arm?
    bin.install "yf" if OS.mac? && Hardware::CPU.intel?
    bin.install "yf" if OS.linux? && Hardware::CPU.arm?
    bin.install "yf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
