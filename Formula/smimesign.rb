class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/v0.0.13.tar.gz"
  sha256 "baf3e1c0a64ca1d49be8a4e99640679ba2b2870e907e88be1e9c7f1566d0f206"

  bottle do
    cellar :any_skip_relocation
    sha256 "035108c03c7bac00de054dd86576eca7c0e9fe540a2cdb57a9a7d79c8c5c3ad4" => :mojave
    sha256 "585b86ebd7baaf3c1499cfe7626730f329c68deb8fe9266a941946b64900338d" => :high_sierra
    sha256 "1a9f3ebbe95deb9aa66ab3cc627a5bed0e365efa4308cdbfe34a4b4f81fb544b" => :sierra
  end

  depends_on "go" => :build
  depends_on :macos => :sierra

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/smimesign").install buildpath.children

    cd "src/github.com/github/smimesign" do
      system "go", "build", "-o", bin/"smimesign", "-ldflags", "-X main.versionString=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity", shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
