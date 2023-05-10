class SpaceCadetPinball < Formula
  desc "Reverse engineering of 3D Pinball for Windows - Space Cadet, a game bundled with Windows."
  homepage "https://github.com/k4zmu2a/SpaceCadetPinball"
  url "https://github.com/k4zmu2a/SpaceCadetPinball/archive/refs/tags/Release_2.0.1.tar.gz"
  sha256 "7b71815339c86a428d3569a5235c6ece0e2d4ff1d8025984ede6f772ca4f5423"
  license "MIT"

  uses_from_macos "unrar"

  depends_on "timidity"
  depends_on "SDL2_mixer"
  depends_on "cmake" => :build

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
    resource("Space_Cadet").stage { system "/usr/local/bin/unrar e -y Space_Cadet.rar PINBALL.DAT \*.MID Sounds/\*.WAV #{prefix}/share/SpaceCadetPinball/" }
    resource("FULLTILT").stage { system "unzip -j -n FULLTILT.ZIP CADET/CADET.DAT CADET/SOUND/\* -d #{prefix}/share/SpaceCadetPinball/" }
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
  end
end
