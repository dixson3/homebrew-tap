class Yf < Formula
  desc "Yoshiko Flow CLI: install, upgrade, verify, and preflight portable agent skills."
  homepage "https://github.com/dixson3/yoshiko-flow"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.3.1/yf-aarch64-apple-darwin.tar.xz"
      sha256 "abc47da5553f00f5b41da1252112c346205ba1752e74b2ed96f76e943f1a3d67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.3.1/yf-x86_64-apple-darwin.tar.xz"
      sha256 "5bffc8b7fd5e97405cfaba77aa425e1a22a580a5ecf52599f1e01b6ed1f8b133"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.3.1/yf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c7bb37c0aed99d0d4decc2e0742edead91a3aaea015e1d7cb4b1a930c518a39a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.3.1/yf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "63fd896ae8beb453c7f8d919f47401c7dfa28bc9614c231a0223bad0941f00e4"
    end
  end
  license "MIT"

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
