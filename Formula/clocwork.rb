class Clocwork < Formula
  include Language::Python::Virtualenv

  desc "Chart lines of code, AI-assisted commits and token cost over Git history"
  homepage "https://github.com/nicktoumpelis/clocwork"
  url "https://files.pythonhosted.org/packages/bc/c2/a40adb6b31b4a4591e786ed50cc6d857c63ca3ce6a605875c03dc3fbe130/clocwork-0.1.1.tar.gz"
  sha256 "c11f68baf2e948dd702a69150aaf5e2f0880c6f3f71723d6e20ed773a96d8212"
  license "MIT"

  bottle do
    root_url "https://github.com/nicktoumpelis/homebrew-tap/releases/download/clocwork-0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "fef040e2f00d02cbc9ae35541f85606ed319f55883a05f7d3fc6af71256a74bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bd80b2e8ee76cf7f6f20172ff96ca762a7e9d791b40e824e45e242c97eb82fb3"
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
