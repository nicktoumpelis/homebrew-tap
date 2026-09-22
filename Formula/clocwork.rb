class Clocwork < Formula
  include Language::Python::Virtualenv

  desc "Chart lines of code, AI-assisted commits and token cost over Git history"
  homepage "https://github.com/nicktoumpelis/clocwork"
  url "https://files.pythonhosted.org/packages/62/01/c9eaab6ac3fb6c4986c2f5844054d07dcec7bebeb8df1ab49d1d91a57787/clocwork-0.2.0.tar.gz"
  sha256 "76fa8dfaab1d910ddde3dda188b44070e5511197128953370596d3f99e6c08c2"
  license "MIT"

  bottle do
    root_url "https://github.com/nicktoumpelis/homebrew-tap/releases/download/clocwork-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "010f11a14d46a16e35d9eb7a770c9fa32ec4d732c3c5ea53af4777e982bd6dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "66af0828dc16fbbe1d67558a66bef0d3e3cfc03a3d0e4c3bed95b1c2bc56438a"
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
