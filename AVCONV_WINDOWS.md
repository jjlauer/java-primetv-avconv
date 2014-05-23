
## Compile avconv for Windows (on Linux)


### Helpful links

    http://libav.org/platform.html#Windows
    http://www.tinc-vpn.org/examples/cross-compiling-64-bit-windows-binary/


### Build tools (on more recent version of ubuntu)

    sudo apt-get install mingw-w64


### Prep for build

    mkdir -p avconv/build
    cd avconv

    export X264_VERSION="ac76440"
    # 10-beta2
    export LIBAV_VERSION="2b9ee7d"


### x264

    git clone git://git.videolan.org/x264.git
    cd x264
    
    # find SHA-1 of release you want: http://download.videolan.org/pub/x264/binaries/linux-x86_64/
    git checkout $X264_VERSION

    ./configure --prefix=$(realpath ../build) \
--cross-prefix=i686-w64-mingw32- --sysroot=/usr/i686-w64-mingw32/ --host=i686-w64-mingw32 --enable-win32thread \
--enable-static --disable-opencl
    
    make
    make install && make install-lib-static


### LibAV

    git -c http.sslVerify=false clone https://github.com/libav/libav.git
    cd libav

    # find SHA-1 of release you want: https://github.com/libav/libav/releases
    git checkout $LIBAV_VERSION 

    export CFLAGS="-I$(realpath ../build/include)"    
    export LDFLAGS="-L$(realpath ../build/lib)"

    ./configure --prefix=$(realpath ../build) \
--enable-cross-compile --enable-w32threads \
--cross-prefix=i686-w64-mingw32- --arch=i686 \
--target-os=mingw32 --sysroot=/usr/i686-w64-mingw32/ \
--enable-gpl --enable-version3 --enable-runtime-cpudetect --enable-memalign-hack \
--enable-libx264 \
--disable-protocol=gopher,crypto,httpproxy --disable-parser=hevc,adpcm_*,pcm_* \
--disable-decoder=hevc,adpcm_*,pcm_* --disable-encoder=hevc,adpcm_*,pcm_* \
--disable-demuxer=hevc,adpcm_*,pcm_* --disable-muxer=hevc,adpcm_*,pcm_*

    make
    make install
