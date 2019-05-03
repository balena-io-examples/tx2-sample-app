###########
# JetPack #
###########
FROM aarch64/ubuntu:14.04 as l4t-sources

ARG L4TVersion="28.2.1"

RUN \
  apt-get update && apt-get install -y \
  wget && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp*

WORKDIR /L4T

RUN \
  wget https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.2.1/m8u2ki/JetPackL4T_321_b23/Tegra186_Linux_R28.2.1_aarch64.tbz2 && \
  wget https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.2.1/m8u2ki/JetPackL4T_321_b23/Tegra_Multimedia_API_R28.2.1_aarch64.tbz2 && \
  wget https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.2.1/m8u2ki/JetPackL4T_321_b23/nv-tensorrt-repo-ubuntu1604-ga-cuda9.0-trt3.0.4-20180208_1-1_arm64.deb && \
  wget https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.2.1/m8u2ki/JetPackL4T_321_b23/cuda-repo-l4t-9-0-local_9.0.252-1_arm64.deb && \
  wget https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.2.1/m8u2ki/JetPackL4T_321_b23/libcudnn7-dev_7.0.5.15-1+cuda9.0_arm64.deb && \
  wget https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.2.1/m8u2ki/JetPackL4T_321_b23/libcudnn7_7.0.5.15-1+cuda9.0_arm64.deb && \
  wget http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/013/linux-x64/cuda-repo-l4t-8-0-local_8.0.84-1_arm64.deb && \
  mv Tegra186_Linux_R${L4TVersion}_aarch64.tbz2 Tegra186_Linux_aarch64.tbz2 && \
  mv Tegra_Multimedia_API_R${L4TVersion}_aarch64.tbz2 Tegra_Multimedia_API_aarch64.tbz2


WORKDIR /L4T/dpkg


###################
# Project example #
###################
FROM aarch64/ubuntu:14.04

# Install General Dependecies
RUN \
  apt-get update && apt-get install --no-install-recommends -y \
  bzip2 \
  sudo \
  git \
  cmake \
  ca-certificates \
  libboost-all-dev \
  pkg-config \
  xorg \
  xinit \
  libjpeg-dev \
  build-essential \
  software-properties-common \
  python-software-properties

# Install L4T
COPY --from=l4t-sources /L4T /tmp/L4T
RUN \
  tar -xf //tmp/L4T/Tegra186_Linux_aarch64.tbz2 -C /tmp/L4T && \
  ./tmp/L4T/Linux_for_Tegra/apply_binaries.sh -r / && \
    dpkg -i ./tmp/L4T/cuda-repo-l4t-8-0-local_8.0.84-1_arm64.deb && \
    apt-get update && apt-get install -y cuda-toolkit-8-0 && \
    dpkg -i ./tmp/L4T/libcudnn7_7.0.5.15-1+cuda9.0_arm64.deb && \
    dpkg -i ./tmp/L4T/libcudnn7-dev_7.0.5.15-1+cuda9.0_arm64.deb && \
    dpkg -i ./tmp/L4T/cuda-repo-l4t-9-0-local_9.0.252-1_arm64.deb && \
  echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && \
  ldconfig && \
  rm -rf /tmp/L4T

################
# OPENCV BUILD #
################

# Install GCC 7 for OpenCV Build
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN \
  apt-get update && apt-get install -y  \
  gcc-7 \
  g++-7

RUN \
  apt-get install -y \
  libglew-dev \
  libtiff5-dev \
  zlib1g-dev \
  libjpeg-dev \
  libpng12-dev \
  libjasper-dev \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libpostproc-dev \
  libswscale-dev \
  libeigen3-dev \
  libtbb-dev \
  libgtk2.0-dev \
  cmake \
  pkg-config \
  \
  python-dev \
  python-numpy \
  python-py \
  python-pytest \
  \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev \
  gstreamer1.0-tools \
  gstreamer1.0-alsa \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-libav \
  libgstreamer1.0-dev \
  libgstreamer-plugins-good1.0-dev \
  libgstreamer-plugins-bad1.0-dev

WORKDIR /src

# Clone OpenCV 3.3.0
RUN \
  git clone https://github.com/opencv/opencv.git && cd opencv && git checkout -b v3.3.0 3.3.0 && cd - && \
  git clone https://github.com/opencv/opencv_extra.git && cd opencv_extra && git checkout -b v3.3.0 3.3.0 && cd -

WORKDIR /src/opencv/build

# Build OpenCV
RUN \
  cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_PNG=OFF \
  -DBUILD_TIFF=OFF \
  -DBUILD_TBB=OFF \
  -DBUILD_JPEG=OFF \
  -DBUILD_JASPER=OFF \
  -DBUILD_ZLIB=OFF \
  -DBUILD_EXAMPLES=ON \
  -DBUILD_opencv_java=OFF \
  -DBUILD_opencv_python2=ON \
  -DBUILD_opencv_python3=OFF \
  -DENABLE_PRECOMPILED_HEADERS=OFF \
  -DWITH_OPENCL=OFF \
  -DWITH_OPENMP=OFF \
  -DWITH_FFMPEG=ON \
  -DWITH_GSTREAMER=ON \
  -DWITH_GSTREAMER_0_10=OFF \
  -DWITH_CUDA=ON \
  -DWITH_GTK=ON \
  -DWITH_VTK=OFF \
  -DWITH_TBB=ON \
  -DWITH_1394=OFF \
  -DWITH_OPENEXR=OFF \
  -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
  -DCUDA_ARCH_BIN=6.2 \
  -DCUDA_ARCH_PTX="" \
  -DINSTALL_C_EXAMPLES=ON \
  -DINSTALL_TESTS=ON \
  -DOPENCV_TEST_DATA_PATH=/src/opencv_extra/testdata \
  -DCMAKE_CXX_COMPILER=g++-7 \
  ../

RUN mkdir -p /src/opencv/build/package
RUN make DESTDIR=/src/opencv/build/package -j8 install

RUN cp /usr/lib/aarch64-linux-gnu/tegra/libGL.so.1 /usr/lib/aarch64-linux-gnu/mesa/libGL.so.1

RUN make -j8 all

RUN rm -rf /src/opencv_extra/.git && rm -rf /src/opencv/.git

RUN ldconfig

WORKDIR /usr/app


ENV INITSYSTEM on

CMD ["bash"]
