# Last check with upstream: 1b22e338f027ba2f58f72cf389a262e55b2d7167
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/ffmpeg.rb

class FfmpegIina < Formula
  desc "Play, record, convert, and stream audio and video"
  homepage "https://ffmpeg.org/"
  url "https://ffmpeg.org/releases/ffmpeg-5.0.tar.xz"
  sha256 "51e919f7d205062c0fd4fae6243a84850391115104ccf1efc451733bc0ac7298"
  head "https://github.com/FFmpeg/FFmpeg.git"

  keg_only <<EOS
it is intended to only be used for building IINA.
This formula is not recommended for daily use and has no binaraies (ffmpeg, ffplay etc.)
EOS

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "dav1d"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "frei0r"
  depends_on "gnutls"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libsoxr"
  depends_on "libvidstab"
  depends_on "rubberband"
  depends_on "snappy"
  depends_on "speex"
  depends_on "tesseract"
  depends_on "xz"
  depends_on "zeromq"
  depends_on "zimg"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-pthreads
      --enable-version3
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-ffplay
      --enable-gnutls
      --enable-gpl
      --enable-libbluray
      --enable-libdav1d
      --enable-librubberband
      --enable-libsnappy
      --enable-libtesseract
      --enable-libvidstab
      --enable-libxml2
      --enable-libfontconfig
      --enable-libfreetype
      --enable-frei0r
      --enable-libass
      --enable-libspeex
      --enable-libsoxr
      --enable-videotoolbox
      --enable-libzmq
      --enable-libzimg
      --disable-libjack
      --disable-indev=jack
      --disable-programs
    ]

    system "./configure", *args
    system "make", "install"

    # Build and install additional FFmpeg tools
    system "make", "alltools"
    bin.install Dir["tools/*"].select { |f| File.executable? f }

    # Fix for Non-executables that were installed to bin/
    mv bin/"python", pkgshare/"python", force: true
  end

  test do
    # Create an example mp4 file
    mp4out = testpath/"video.mp4"
    system bin/"ffmpeg", "-filter_complex", "testsrc=rate=1:duration=1", mp4out
    assert_predicate mp4out, :exist?
  end
end
