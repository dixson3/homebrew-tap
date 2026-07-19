class Naba < Formula
  desc "Nanobanana image generation CLI (multi-provider: Gemini, OpenRouter)"
  homepage "https://github.com/dixson3/naba"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/naba/releases/download/v0.6.1/naba-aarch64-apple-darwin.tar.gz"
      sha256 "519c7991ee1baf0078c3d3fb3d76e85fd3c2d4106366fef901afa64c38f4f4e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/naba/releases/download/v0.6.1/naba-x86_64-apple-darwin.tar.gz"
      sha256 "491f735ab231f1d36c4c29ca565aa26a7e7be612bbe5002e72043e3056f32179"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/naba/releases/download/v0.6.1/naba-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0a22a1232de79d81ea51fe8c7a9a369f53457076b3be7328f32bed1998e34f0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/naba/releases/download/v0.6.1/naba-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "93171bae0e90ab7423b170ee7befef2cbd8933a8052d626d8081c2f2eec30053"
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
