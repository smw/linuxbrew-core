class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/liquidata-inc/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.24.4.tar.gz"
  sha256 "da81c35375579cb9bbbdb8c9092510e19c52ae91065f8dfa895f8c389d9f3be2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbaf36902480942eb4fb43790fc5460a45972a4e498b4b2cc102e3484f8b0b8e"
    sha256 cellar: :any_skip_relocation, big_sur:       "24ffeeaecec8a5197c2bc8b571d6ab98859c9f6e326ed6f1366b73d23aa4659e"
    sha256 cellar: :any_skip_relocation, catalina:      "9ed078048dce427720e5c7412160372197f3b0575c6680a26c76d9d23f6a9b80"
    sha256 cellar: :any_skip_relocation, mojave:        "87b32e0f2041a479f64e204e7cd00fd27bf2258f70f0a26c4db9fa8bf7fa9686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2405982ff72808353ed910d2cab3ee1de833ba2d7e8fc34ade9c9be7ce0d3632"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt", "./cmd/git-dolt"
      system "go", "build", *std_go_args, "-o", bin/"git-dolt-smudge", "./cmd/git-dolt-smudge"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
