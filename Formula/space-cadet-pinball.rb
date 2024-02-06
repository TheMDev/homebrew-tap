class SpaceCadetPinball < Formula
  desc "Reverse engineering of 3D Pinball for Windows - Space Cadet, a game bundled with Windows."
  homepage "https://github.com/k4zmu2a/SpaceCadetPinball"
  url "https://github.com/k4zmu2a/SpaceCadetPinball/archive/refs/tags/Release_2.1.0.tar.gz"
  sha256 "b647dc59abad3d52378b9f67ff4fb70a37e9752afaff1d098b71028cad29b8d6"
  license "MIT"

  depends_on "timidity"
  depends_on "SDL2_mixer"
  depends_on "cmake" => :build
  depends_on "libarchive" => :build

  resource "Space_Cadet" do
    url "https://archive.org/download/SpaceCadet_Plus95/Space_Cadet.rar", using: :nounzip
    sha256 "3cc5dfd914c2ac41b03f006c7ccbb59d6f9e4c32ecfd1906e718c8e47f130f4a"
  end

  resource "FULLTILT" do
    url "https://archive.org/download/win311_ftiltpball/FULLTILT.ZIP", using: :nounzip
    sha256 "183a2219865b3f2199403928b817b7c967837ea6298de14fb8a379944c7b4599"
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_OSX_ARCHITECTURES=arm64", *std_cmake_args
    end
    if OS.mac? && Hardware::CPU.intel?
      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_OSX_ARCHITECTURES=x86_64", *std_cmake_args
    end
    system "cmake", "--build", "build"
    bin.install "bin/SpaceCadetPinball"

    mkdir "#{prefix}/share/SpaceCadetPinball/"
    resource("Space_Cadet").stage { system "#{HOMEBREW_PREFIX}/opt/libarchive/bin/bsdtar -x -f Space_Cadet.rar --include='PINBALL.DAT' --include='*.MID' --include='*.WAV' -s'#Sounds\/##' -C #{prefix}/share/SpaceCadetPinball/" }
    resource("FULLTILT").stage { system "unzip -j -n FULLTILT.ZIP CADET/CADET.DAT CADET/SOUND/\* -d #{prefix}/share/SpaceCadetPinball/" }
  end
end
