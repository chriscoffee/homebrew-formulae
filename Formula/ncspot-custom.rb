class NcspotCustom < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.5.0.tar.gz"
  sha256 "301c99bfe1c62d9f48f3b22a1f7795f61bd9b341ed904afd59d0ceb8693e295d"
  license "BSD-2-Clause"

  depends_on "python@3.9" => :build
  depends_on "rust" => :build
  depends_on "portaudio" => :build

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install",
      "--no-default-features", "--features", "portaudio_backend,cursive/pancurses-backend,cover,notify", *std_cargo_args
  end

  test do
    pid = fork { exec "#{bin}/ncspot -b . -d debug.log 2>&1 >/dev/null" }
    sleep 2
    Process.kill "TERM", pid

    assert_match '[ncspot::config] [TRACE] "./.config"', File.read("debug.log")
  end
end
