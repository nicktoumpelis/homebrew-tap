class Clocwork < Formula
  include Language::Python::Virtualenv

  desc "Chart lines of code, AI-assisted commits and token cost over Git history"
  homepage "https://github.com/nicktoumpelis/clocwork"
  url "https://files.pythonhosted.org/packages/89/c7/7e5c0e63fc372a37a26543a16da6b35955b1524b171da17342ec49d1083c/clocwork-0.4.0.tar.gz"
  sha256 "223c72033846633974adbb5bd954db3318a9f6b8758c453ad1560a62b3b04b79"
  license "MIT"

  bottle do
    root_url "https://github.com/nicktoumpelis/homebrew-tap/releases/download/clocwork-0.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "e19f99a155190e3d2fa6011af1d930aea4eb77c63f4d28dd537f585937f9e92a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8028bf6061ed6065f8e88683320d718f1a77484d09eb1d2697505443c7bd67c1"
  end

  depends_on "cloc"
  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
    man1.install "man/clocwork.1"
  end

  test do
    assert_match "clocwork #{version}", shell_output("#{bin}/clocwork --version")

    repo = testpath/"demo"
    repo.mkpath
    (repo/"main.py").write "def main():\n    return 1\n"
    (repo/"tests/test_main.py").write "def test_main():\n    assert True\n"
    git = %w[git -c user.name=Test -c user.email=test@example.com -c commit.gpgsign=false]
    system(*git, "-C", repo, "init", "--quiet", "--initial-branch=main")
    system(*git, "-C", repo, "add", ".")
    system(*git, "-C", repo, "commit", "--quiet", "--message=Add a module and its test")

    output = shell_output("#{bin}/clocwork #{repo} --no-open --no-tokens --cache-dir #{testpath}/cache")
    assert_match "Test code at main: 2 of 4 code lines (50.0%)", output
    assert_path_exists testpath/"demo-stats/index.html"

    assert_match "no git repository found", shell_output("#{bin}/clocwork #{testpath} --no-open 2>&1", 2)
  end
end
