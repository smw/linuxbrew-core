class Libmpeg2 < Formula
  desc "Library to decode mpeg-2 and mpeg-1 video streams"
  homepage "https://libmpeg2.sourceforge.io/"
  url "https://libmpeg2.sourceforge.io/files/libmpeg2-0.5.1.tar.gz"
  sha256 "dee22e893cb5fc2b2b6ebd60b88478ab8556cb3b93f9a0d7ce8f3b61851871d4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://libmpeg2.sourceforge.io/downloads.html"
    regex(/href=.*?libmpeg2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "e2f1a24fdb40a15928f35ae84326fab5b8d1293ca2b378aee8e45aab9bb5766c"
    sha256 cellar: :any, big_sur:       "9f2cfd80d47e975333747fdea41d336071282ae359e9a345835a70611467bd43"
    sha256 cellar: :any, catalina:      "9a8c812495f38eb0d46bff246c632c5dfd97413b2bc949defd9c5d318b9da439"
    sha256 cellar: :any, mojave:        "81161223100cfa38704d3194519be5651f4fcb47765b7e99f1d53ce05e433142"
    sha256 cellar: :any, x86_64_linux:  "38ea8d58877cb8e7fa0e9465ec78aa10abf5159b349ae9c5c939fb7d3d292a6a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "sdl"

  def install
    # Otherwise compilation fails in clang with `duplicate symbol ___sputc`
    ENV.append_to_cflags "-std=gnu89"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "doc/sample1.c"
  end

  test do
    system ENV.cc, "-I#{include}/mpeg2dec", "-L#{lib}", "-lmpeg2", pkgshare/"sample1.c"
  end
end
