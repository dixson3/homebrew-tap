class Yf < Formula
  desc "Yoshiko Flow CLI: install, upgrade, verify, and preflight portable agent skills."
  homepage "https://github.com/dixson3/yoshiko-flow"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.4.0/yf-aarch64-apple-darwin.tar.gz"
      sha256 "10646e8a78eb9768c8c450274cd398ae5300f7af29b4919bd8719aa900014bb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.4.0/yf-x86_64-apple-darwin.tar.gz"
      sha256 "9e6f61f5153a47c758902ca6f5eee5c27dff374d85e89fbece27e03b3310215e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.4.0/yf-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a008a784dda65daff3a15f783883bae8a2b02e32172eff9349b87a98101bc62d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.4.0/yf-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fc0a0f10177a5790fae6d6c5aff9b31e45eafafaafb2befff0b58aa51b625413"
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
