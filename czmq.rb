require "formula"

class Czmq < Formula
  homepage "http://czmq.zeromq.org/"
  url "http://download.zeromq.org/czmq-3.0.2.tar.gz" 
  sha256 "8bca39ab69375fa4e981daf87b3feae85384d5b40cef6adbe9d5eb063357699a"
  revision 3

  bottle do
    cellar :any
    sha1 "76953cbf02d8eb56aa0bea5caefa19d19f5e48c6" => :yosemite
    sha1 "5297d31b43353db09cc1931de2a529999ca0f2b5" => :mavericks
    sha1 "998759fe30f0e27fb994130dd7fe95c5930a8124" => :mountain_lion
  end

  head do
    url "https://github.com/zeromq/czmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "scryner/custom/zeromq"
  depends_on "libsodium" => :recommended

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    if build.stable?
      args << "--with-libsodium" if build.with? "libsodium"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"

    man3.install Dir["doc/*.3"]
    man7.install Dir["doc/*.7"]

    rm Dir["#{bin}/*.gsl"]
  end

  test do
    bin.cd do
      system "#{bin}/czmq_selftest"
    end
  end
end
