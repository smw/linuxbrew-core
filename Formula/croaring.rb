class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.2.66.tar.gz"
  sha256 "df98bd8f6ff09097ada529a004af758ff4d33faf6a06fadf8fad9a6533afc241"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7d95a68b3c0ea2bf0e538bdc34293e4dedd08ad0a2b8fa1e991e4e9e8615cb98"
    sha256 cellar: :any,                 big_sur:       "e586a64b1397c4e93e5dd19a15cf3e36b0bc6c51c2a0245579d4eb690e162125"
    sha256 cellar: :any,                 catalina:      "755fadb67394a7b031626671412623348a561e290d379592b8c2925aa4e1f671"
    sha256 cellar: :any,                 mojave:        "b70622cb9515f3702faa0cf8f60a26c5e7481399d1a244a5217bffdf1ab269d3"
    sha256 cellar: :any,                 high_sierra:   "aee7d4e0440e29a2a27694bac0326758590bd36d86254de1888e4044b0de576e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73ccdd505e39a053d064cfff34bc98cbad8bbd96f724025e9e153c05c2dd6bf5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DROARING_BUILD_STATIC=ON", *std_cmake_args
    system "make"
    lib.install "src/libroaring.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
