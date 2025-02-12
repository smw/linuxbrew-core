class Hdf5AT18 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  # NOTE: 1.8.23 is expected to be the last release for HDF5-1.8
  # (see: https://portal.hdfgroup.org/display/support/HDF5%201.8.22#HDF51.8.22-futureFutureofHDF5-1.8).
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.22/src/hdf5-1.8.22.tar.bz2"
  sha256 "689b88c6a5577b05d603541ce900545779c96d62b6f83d3f23f46559b48893a4"
  revision OS.mac? ? 1 : 2

  livecheck do
    url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/"
    regex(%r{href=["']?hdf5[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "3c096b8675616ada699dbed4166448607ee962d9be0d204b4bfee7bed9a79dcc"
    sha256 cellar: :any,                 catalina:     "9e89965d4c4a107868f480a8ec339cd8e73e49bd919eb07e377f375a40558bef"
    sha256 cellar: :any,                 mojave:       "5510c91c49d43e1b3f1b60a7792449f5133816ea9384c652c2120e489a975c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "af4a12304ab00133bb97b23ba6bd78ca2b4c280c7abec5dc256220da362550b4"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "szip"

  uses_from_macos "m4" => :build

  def install
    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in bin/h5cc.in],
      "${libdir}/libhdf5.settings",
      "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am", "settingsdir=$(libdir)", "settingsdir=#{pkgshare}"

    system "autoreconf", "-fiv"

    # necessary to avoid compiler paths that include shims directory being used
    ENV["CC"] = "/usr/bin/cc"
    ENV["CXX"] = "/usr/bin/c++"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-build-mode=production
      --enable-fortran
      --disable-cxx
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "hdf5.h"
      int main()
      {
        printf("%d.%d.%d\\n", H5_VERS_MAJOR, H5_VERS_MINOR, H5_VERS_RELEASE);
        return 0;
      }
    EOS
    system "#{bin}/h5cc", "test.c"
    assert_equal version.to_s, shell_output("./a.out").chomp

    (testpath/"test.f90").write <<~EOS
      use hdf5
      integer(hid_t) :: f, dspace, dset
      integer(hsize_t), dimension(2) :: dims = [2, 2]
      integer :: error = 0, major, minor, rel

      call h5open_f (error)
      if (error /= 0) call abort
      call h5fcreate_f ("test.h5", H5F_ACC_TRUNC_F, f, error)
      if (error /= 0) call abort
      call h5screate_simple_f (2, dims, dspace, error)
      if (error /= 0) call abort
      call h5dcreate_f (f, "data", H5T_NATIVE_INTEGER, dspace, dset, error)
      if (error /= 0) call abort
      call h5dclose_f (dset, error)
      if (error /= 0) call abort
      call h5sclose_f (dspace, error)
      if (error /= 0) call abort
      call h5fclose_f (f, error)
      if (error /= 0) call abort
      call h5close_f (error)
      if (error /= 0) call abort
      CALL h5get_libversion_f (major, minor, rel, error)
      if (error /= 0) call abort
      write (*,"(I0,'.',I0,'.',I0)") major, minor, rel
      end
    EOS
    system "#{bin}/h5fc", "test.f90"
    assert_equal version.to_s, shell_output("./a.out").chomp
  end
end
