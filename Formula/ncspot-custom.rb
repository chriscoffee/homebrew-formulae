class NcspotCustom < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.8.1.tar.gz"
  sha256 "6d08ae339dc1b1fb1e472490e0d672840030467158a5a1f7472b588e2de303fe"
  license "BSD-2-Clause"

  depends_on "python@3.9" => :build
  depends_on "rust" => :build

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed
    system "cargo", "install",
           "--no-default-features",
           "--features",
           "rodio_backend,cursive/pancurses-backend,cover,notify",
           *std_cargo_args
  end
  test do
    stdin, stdout, wait_thr = Open3.popen2 "script -q /dev/null"
    stdin.puts "stty rows 80 cols 130"
    stdin.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/ncspot -b ."
    sleep 1
    Process.kill("INT", wait_thr.pid)

    assert_match "Please login to Spotify", stdout.read
  end
end
