class Scheme48 < Formula
  desc "Scheme byte-code interpreter"
  homepage "https://www.s48.org/"
  url "https://s48.org/1.9.2/scheme48-1.9.2.tgz"
  sha256 "9c4921a90e95daee067cd2e9cc0ffe09e118f4da01c0c0198e577c4f47759df4"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "5a2ff16cfe2c0cad8648b4057552a19f3389408d3e90b884c0b4d4f3c4116d30"
    sha256 big_sur:       "c11d8062b6115384d18f174cd7f5ce5fef434b3ed35b914b85a7c9df041cc450"
    sha256 catalina:      "50398406b73f7b6b5ce3c0f220694673e42b83bd63f11149a855498e4caf3c94"
    sha256 mojave:        "42cacccaf71990813012cdc819702fe24a93555998ac86d54e389ea40f6f2a87"
    sha256 high_sierra:   "590f06c7c31910eed48da06080959628982226e7b09e2aedd352fa6e4a6c2007"
    sha256 sierra:        "e9751df2e3cfd1a007d74d541ca494a439645e3006ad354ddf65b0abfb370864"
    sha256 el_capitan:    "af2ced8a13fdad5478f745c698b09071e71d84daca01c6e3e3c35961b06cbea4"
    sha256 yosemite:      "475d12c64562fc2498fcd8d9a8bab76d4f290444e43fcf04c40c745a7f6c6923"
    sha256 x86_64_linux:  "509943ce4c8fddcdd8eb1b23fd61051056d63a9a54d9c3652c458bd3a264229e"
    sha256 mavericks:     "6ae24159bb6e2485465135ba60d60291be7681dfc9662e42f176bb9f9d4a6f00"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-gc=bibop"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.scm").write <<~EOS
      (display "Hello, World!") (newline)
    EOS

    expected = <<~EOS
      Hello, World!\#{Unspecific}

      \#{Unspecific}

    EOS

    assert_equal expected, shell_output("#{bin}/scheme48 -a batch < hello.scm")
  end
end
