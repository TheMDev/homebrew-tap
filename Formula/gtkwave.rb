class Gtkwave < Formula
  desc "GTKWave binary"
  homepage "https://gtkwave.sourceforge.net"
  head "https://github.com/gtkwave/gtkwave.git", branch: "master"
  license "GPL-2.0-or-later"

  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "cmake" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "glib" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-mac-integration" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "shared-mime-info" => :build

  def install
    # use std_meson_args without "--wrap-mode=nofallback" from brew/Library/Homebrew/formula.rb
    system "meson", "setup", "build", "-Dupdate_mime_database=false", "--prefix=#{prefix}", "--libdir=#{lib}", "--buildtype=release"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end
end
