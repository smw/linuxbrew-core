class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.26",
    revision: "26be4445542b8aa1aa0233a856ade7161644035c"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "de91d8053b75c1268fb683b94cd74a873af5395595208788a51fdf2c885f9b5c"
    sha256 cellar: :any_skip_relocation, big_sur:       "d363409ef73963e427e1af1df473993c40fa1ee57fd471eb5e726b5ab9f31bc5"
    sha256 cellar: :any_skip_relocation, catalina:      "15cde7a009c074ded83f8293fdbeb0b21e61dc44776e3907b5c9ba924ff45ca3"
    sha256 cellar: :any_skip_relocation, mojave:        "3386a4a8e1cd2952e08454483f4611b16589e7829ac1ba0a76e1fe6e715cdc8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5dab32de93d0abc6a0518336289a0ccc829d5a4e2892233b477d85a12e91d4b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"config.yml").write <<~EOS
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    EOS
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end
