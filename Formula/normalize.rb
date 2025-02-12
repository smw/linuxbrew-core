class Normalize < Formula
  desc "Adjust volume of audio files to a standard level"
  homepage "https://www.nongnu.org/normalize/"
  url "https://savannah.nongnu.org/download/normalize/normalize-0.7.7.tar.gz"
  sha256 "6055a2abccc64296e1c38f9652f2056d3a3c096538e164b8b9526e10b486b3d8"
  license "GPL-2.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/normalize/"
    regex(/href=.*?normalize[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "31e0c2d4f6dd0aaae6830e87242bfc8c71077b04c94a41b4079d36e45eedc4ab"
    sha256 cellar: :any, big_sur:       "a35a01c8d74067d94fda21d31a0ab65128842e6dc1ed0629ed6cadf99f13a9b5"
    sha256 cellar: :any, catalina:      "363ac4a56ccb75ff32f3af3ef42a6cf5d74f24b977939bb08c14fddc30ff2ef5"
    sha256 cellar: :any, mojave:        "8e1ac6ecbf84164c27a804b158201b75ddaabd3237e5826d7ffc78fbe8ee7377"
    sha256 cellar: :any, high_sierra:   "e4dd195c639807e3e2e25fee6c5c6f3c4263a37a4c7f8f25ab656a96395faeaf"
    sha256 cellar: :any, sierra:        "1165de2721e8b4d7f373b9ad10f52c2cd49c44a24cd8fddab5ba51983164cefe"
    sha256 cellar: :any, el_capitan:    "052ab2e8b1f6a2aa1e634a30749612d927b5cee5cc9302e057bd02c599a1c256"
    sha256 cellar: :any, yosemite:      "dcb42f107b9674e50d8994215f6d125e0fb9523b1d99b393fd00ee2b827be5e0"
    sha256               x86_64_linux:  "ac25497f08b39d5ec724876fff9dd41a16ac469c388864d58ea710e307d577b9"
    sha256 cellar: :any, mavericks:     "9c12615d384a706feb8ddb693dadacfc5bfc48827e5722dd6476325bbe5e90b9"
  end

  depends_on "mad"

  conflicts_with "num-utils", because: "both install `normalize` binaries"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/normalize", "test.mp3"
  end
end
