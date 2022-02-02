class Kismet < Formula
  desc "Wireless network and device detector, sniffer, wardriving tool, and WIDS framework."
  homepage "https://www.kismetwireless.net/"
  url "https://github.com/kismetwireless/kismet/archive/refs/tags/kismet-2022-01-R3a.tar.gz"
  sha256 "5f9cfc2c5a5c2b12faf4c458ee765474eb1cb75c94701cb19fee9e3a80da967d"
  version "2022-01-R3a"
  head "https://github.com/kismetwireless/kismet.git"
  license "GPL-2.0-only"

  depends_on "libbtbb"
  depends_on "libmicrohttpd"
  depends_on "libpcap"
  depends_on "librtlsdr"
  depends_on "libusb"
  depends_on "libwebsockets"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on "protobuf-c"
  depends_on "python3"
  depends_on "ubertooth"

  def install
    inreplace "Makefile.in" do |s|
      s.gsub! "-o $(INSTUSR) -g $(SUIDGROUP)", ""
      s.gsub! "-o $(INSTUSR) -g $(INSTGRP)", ""
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Kismet #{version}", shell_output("#{bin}/kismet --version", 1)
  end
end
