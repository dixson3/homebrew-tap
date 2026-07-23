class Naba < Formula
  desc "Nanobanana image generation CLI (multi-provider: Gemini, OpenRouter)"
  homepage "https://github.com/dixson3/naba"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/naba/releases/download/v0.8.2/naba-aarch64-apple-darwin.tar.gz"
      sha256 "868138f0c5c00c321de99bee49384197e86ba9a81413dc6ce1442b7acd723fa9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/naba/releases/download/v0.8.2/naba-x86_64-apple-darwin.tar.gz"
      sha256 "88dd3e3975f8e6022abdce9e3281e9b7cace646585beccf4510115e8ac6d6732"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/naba/releases/download/v0.8.2/naba-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9c101a917ad03ed180fd26e424c8286271e0afe6aa7dc3a918ddc15ad6136e67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/naba/releases/download/v0.8.2/naba-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "66e280db8c50f1dcd6e031f712e853b1845f750a51a1ccaa13c1cabbcc5b6787"
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
