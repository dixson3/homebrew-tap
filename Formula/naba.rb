class Naba < Formula
  desc "Nanobanana image generation CLI (multi-provider: Gemini, OpenRouter)"
  homepage "https://github.com/dixson3/naba"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/naba/releases/download/v0.6.0/naba-aarch64-apple-darwin.tar.gz"
      sha256 "8efd3dd98ebcc3a3079e975870e3fc0dccb0a0fa6a8be902462ee6a99c8a1807"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/naba/releases/download/v0.6.0/naba-x86_64-apple-darwin.tar.gz"
      sha256 "dbf3d45950b80fd08293784ad860b1d4fa2263661739673befc13e6e910bbfd1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/naba/releases/download/v0.6.0/naba-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d0026077d36ff35e8f3a37b9f91ba21b98b68318c23b3b535479599fed50f85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/naba/releases/download/v0.6.0/naba-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f2a71922899400eebfc4fc541c224a8d2ec3888aa724b4805a3ed9a4c4454032"
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
    bin.install "naba" if OS.mac? && Hardware::CPU.arm?
    bin.install "naba" if OS.mac? && Hardware::CPU.intel?
    bin.install "naba" if OS.linux? && Hardware::CPU.arm?
    bin.install "naba" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
