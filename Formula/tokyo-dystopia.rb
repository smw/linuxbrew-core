class TokyoDystopia < Formula
  desc "Lightweight full-text search system"
  homepage "https://fallabs.com/tokyodystopia/"
  url "https://fallabs.com/tokyodystopia/tokyodystopia-0.9.15.tar.gz"
  sha256 "28b43c592a127d1c9168eac98f680aa49d1137b4c14b8d078389bbad1a81830a"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9e0c8988268eec1f5fe33f5d7f494f636c64690f417e179e37a83f9b4880b315"
    sha256 cellar: :any,                 big_sur:       "f771602cfd9301739750f839295241f829528eee8ecfe02ac95b55fc24c3841e"
    sha256 cellar: :any,                 catalina:      "eb04133c9d459ee1ab9a4fe00b3f6b31621d9df2672a252784779a44a5991b77"
    sha256 cellar: :any,                 mojave:        "056aa0bfed85351c6296b0749dfa15a2e9471ef554796f726708438e312b5790"
    sha256 cellar: :any,                 high_sierra:   "3f00b619720603bd0712b52d01a355124604637c44cab5a3132fda942f195e2c"
    sha256 cellar: :any,                 sierra:        "0a7da80cf5e8892112986d9a51e8cd3804da2a7436b8a03b472f561b06c35890"
    sha256 cellar: :any,                 el_capitan:    "2a9e21b6f57781adb9e3dc673f2e466b817d4a00860b45fa49ded534d4cb0ed4"
    sha256 cellar: :any,                 yosemite:      "6fa4ed94aace1e4c3b2a9962f31055883325255f8175c63aa08f079a4974eb6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c93d571de8a5e796ff87b8ac385cf52190f0e2034698e22ad610f855a14df8"
    sha256 cellar: :any,                 mavericks:     "231960b2f9d41cc1ee48a66812b1f0fa5977613e39ddd1a62c22a46e21b3feaf"
  end

  depends_on "tokyo-cabinet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.tsv").write <<~EOS
      1\tUnited States
      55\tBrazil
      81\tJapan
    EOS

    system "#{bin}/dystmgr", "importtsv", "casket", "test.tsv"
    system "#{bin}/dystmgr", "put", "casket", "83", "China"
    system "#{bin}/dystmgr", "list", "-pv", "casket"
  end
end
