class Yf < Formula
  desc "Yoshiko Flow CLI: install, upgrade, verify, and preflight portable agent skills."
  homepage "https://github.com/dixson3/yoshiko-flow"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.3.2/yf-aarch64-apple-darwin.tar.xz"
      sha256 "428d33339face7dc025482ae5da858f69f8733ce29938fc03afeeb458400a483"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.3.2/yf-x86_64-apple-darwin.tar.xz"
      sha256 "02f6afddad006d0e386900b9a840c95b33c62f530890ff987e5f4d85769f3d00"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.3.2/yf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f79f45d902f57619a4a057abacefb8c155e5b134a3e7d8b6b0ecc9ed305717a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dixson3/yoshiko-flow/releases/download/v0.3.2/yf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e51ddd286a1e6347760d0c3f727e613812cd3ce6b982ba83a3c98646d28ea266"
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
