
## Compile avconv for Linux/OSX

### Helpful links:
    http://ffmpegmac.net/HowTo/


### Prep for build

    mkdir -p avconv/build
    cd avconv

    export X264_VERSION="ac76440"
    # 10-beta2
    export LIBAV_VERSION="2b9ee7d"

### YASM 1.2.0 or above is REQUIRED to build

OSX:
    brew install yasm
    
Linux:
    wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
    tar xf yasm-1.2.0.tar.gz
    cd yasm-1.2.0
    ./configure
    make
    sudo make install


### Realpath for OSX

OSX:
    git clone https://github.com/harto/realpath-osx.git
    cd realpath-osx
    make
    export PATH=$PATH:`pwd`


### x264

    git clone git://git.videolan.org/x264.git
    cd x264
    
    # find SHA-1 of release you want: http://download.videolan.org/pub/x264/binaries/linux-x86_64/
    git checkout $X264_VERSION

    ./configure --prefix=$(realpath ../build) --disable-shared --enable-static --disable-opencl
    make
    make install && make install-lib-static


### LibAV

    git -c http.sslVerify=false clone https://github.com/libav/libav.git
    cd libav

    # find SHA-1 of release you want: https://github.com/libav/libav/releases
    git checkout $LIBAV_VERSION 

    export CFLAGS="-I$(realpath ../build/include)"    
    export LDFLAGS="-L$(realpath ../build/lib) "

    ./configure --prefix=$(realpath ../build) \
--enable-gpl --enable-version3 --enable-runtime-cpudetect --enable-memalign-hack \
--enable-libx264 \
--disable-protocol=gopher,crypto,httpproxy --disable-parser=hevc,adpcm_*,pcm_* \
--disable-decoder=hevc,adpcm_*,pcm_* --disable-encoder=hevc,adpcm_*,pcm_* \
--disable-demuxer=hevc,adpcm_*,pcm_* --disable-muxer=hevc,adpcm_*,pcm_*

    make
    make install


# excluding support for certain web standards...
#--enable-avisynth --enable-libvpx --enable-libvorbis





Compile good, redistributable faac lib:
    
    wget http://downloads.sourceforge.net/faac/faac-1.28.tar.gz
    tar zxvf faac-1.28.tar.gz
    cd faac-1.28
    ./configure --prefix=$(realpath ../root) --enable-static

Compile the best AAC lib out there:
    
    wget http://sourceforge.net/projects/opencore-amr/files/fdk-aac/fdk-aac-0.1.3.tar.gz
    tar xzvf fdk-aac-0.1.3.tar.gz
    cd fdk-aac-0.1.3
    ./configure --prefix=$(realpath ../root) --enable-static --disable-shared
    make
    make install

RTMP:

    wget http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz
    tar zxvf rtmpdump-2.3.tgz
    cd rtmpdump-2.3
    make
    cp librtmp/librtmp.a ../root/lib/
    cp librtmp/rtmp.h ../root/include/
    

Compile latest and greatest libx264

    

    git clone git://git.videolan.org/x264.git
    cd x264
    # find SHA-1 of stable release here http://download.videolan.org/pub/x264/binaries/linux-x86_64/
    git checkout 956c8d8
    ./configure --prefix=$(realpath ../root) --enable-static --without-mp4v2
    make
    make install

    wget http://www.ffmpeg.org/releases/ffmpeg-2.1.4.tar.gz
    tar zxvf ffmpeg-2.1.4.tar.gz
    cd ffmpeg-2.1.4
    ./configure --prefix=$(realpath ../root) \
    --extra-cflags='-I$(realpath ../root/include) -static' \
    --extra-ldflags='-L$(realpath ../root/lib) -static' --extra-libs="-ldl -lexpat -lfreetype" \
    --enable-static --disable-shared --disable-ffserver --disable-doc --enable-nonfree --disable-libspeex \
    --enable-libfaac --enable-libfdk_aac --enable-bzlib --enable-zlib --enable-postproc --enable-runtime-cpudetect --enable-libx264 \
    --enable-gpl --enable-libtheora --enable-libvorbis --enable-libmp3lame --enable-gray \
    --enable-libopenjpeg --enable-version3 --enable-libvpx --enable-openssl
    make
    make install
