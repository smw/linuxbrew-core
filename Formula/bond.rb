class Bond < Formula
  desc "Cross-platform framework for working with schematized data"
  homepage "https://github.com/microsoft/bond"
  url "https://github.com/microsoft/bond/archive/9.0.4.tar.gz"
  sha256 "59392145dbe271c3f1fd4b784958a08cf5c9e38c1a769af007ce6ac7100daf01"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 big_sur:      "b777ee788ae5d9ee234cc7dea3f671d4d8e50edafdd2b48ecd990c6643ffcacb"
    sha256 cellar: :any,                 catalina:     "c4677d09cbf02e66671d9760ca64fcfbab1127b778c70719d9db58daca9b7c7e"
    sha256 cellar: :any,                 mojave:       "432c38ccaa1931fb8320cbbc8692d3982ce225732f70cdb5c7f3b8596c487f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7bc21302d8522e45aa284cc127ef910deb2c0129bde463c5d117c701adcb34ee"
  end

  depends_on "cmake" => :build
  depends_on "ghc@8.6" => :build
  depends_on "haskell-stack" => :build
  depends_on "boost"
  depends_on "rapidjson"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBOND_ENABLE_GRPC=FALSE",
                            "-DBOND_FIND_RAPIDJSON=TRUE",
                            "-DBOND_STACK_OPTIONS=--system-ghc;--no-install-ghc"
      system "make"
      system "make", "install"
    end
    chmod 0755, bin/"gbc"
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/cpp/core/serialization/.", testpath
    system bin/"gbc", "c++", "serialization.bond"
    system ENV.cxx, "-std=c++11", "serialization_types.cpp", "serialization.cpp",
                    "-o", "test", "-L#{lib}/bond", "-lbond", "-lbond_apply"
    system "./test"
  end
end
