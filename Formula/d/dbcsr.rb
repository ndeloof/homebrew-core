class Dbcsr < Formula
  desc "Distributed Block Compressed Sparse Row matrix library"
  homepage "https://cp2k.github.io/dbcsr/"
  url "https://github.com/cp2k/dbcsr/releases/download/v2.9.1/dbcsr-2.9.1.tar.gz"
  sha256 "fa5a4aeba0a07761511af2c26c779bd811b5ea0ef06a5d94535b6dd7b2e0ce59"
  license "GPL-2.0-or-later"

  depends_on "cmake" => :build
  depends_on "fypp" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  uses_from_macos "python" => :build

  fails_with :clang do
    cause "needs to be aligned with `cp2k` and `openblas` to avoid mixing OpenMP"
  end

  def install
    rm_r("tools/build_utils/fypp")

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUSE_MPI=OFF
      -DUSE_SMM=blas
      -DWITH_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/dbcsr_example_3.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"dbcsr_example_3.cpp", "-o", "test", "-fopenmp", "-L#{lib}", "-ldbcsr_c"
    system "./test"
  end
end
