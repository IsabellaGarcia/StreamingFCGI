#!/bin/bash
#Get the dependencies
yum install autoconf automake gcc gcc-c++ git libtool make nasm pkgconfig zlib-devel

FF_DIR=~/ffmpeg_sources
if [ -d "$FF_DIR" ]; then
   echo "$FF_DIR found"
else
   mkdir $FF_DIR
fi

#Yasm
cd $FF_DIR

if [ -d "./yasm" ]; then
   rm -rf ./yasm
   echo "delete original yasm folder"
fi
   mkdir yasm

git clone --depth 1 git://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
make distclean
echo "DONE YASM"



#libx264
cd $FF_DIR
#create folder
if [ -d "./x264" ]; then
   rm -rf ./x264
   echo "delete original x264 folder"
fi
   mkdir x264

#clone from git
git clone --depth 1 git://git.videolan.org/x264
cd x264

#make and configure
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install
make distclean
echo "DONE LIBX264"



#libfdk_aac
cd $FF_DIR
#create folder
if [ -d "./fdk-aac" ]; then
   rm -rf ./fdk-aac
   echo "delete original fdk-aac folder"
fi
   mkdir fdk-aac

#clone from git
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv

#make and configure
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
echo "DONE LIBFDK_AAC"



#libmp3lame
cd $FF_DIR
#create folder
if [ -d "./lame-3.99.5" ]; then
   rm -rf ./lame-3.99.5
   echo "delete original lame-3.99.5 folder"
fi
   mkdir lame-3.99.5

#curl from ..
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
make
make install
make distclean
echo "DONE libmp3lame"




#libopus
cd $FF_DIR
#create folder
if [ -d "./opus" ]; then
   rm -rf ./opus
   echo "delete original fdk-aac folder"
fi
   mkdir opus

#clone from git
git clone git://git.opus-codec.org/opus.git
cd opus
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
echo "DONE libopus"



#libogg
cd $FF_DIR
#create folder
if [ -d "./libogg-1.3.2" ]; then
   rm -rf ./libogg-1.3.2
   echo "delete original libogg-1.3.2 folder"
fi
   mkdir libogg-1.3.2

#curl from ...
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
echo "DONE libogg"




#libvorbis
cd $FF_DIR
#create folder
if [ -d "./libvorbis-1.3.4" ]; then
   rm -rf ./libvorbis-1.3.4
   echo "delete original libvorbis-1.3.4 folder"
fi
   mkdir libvorbis-1.3.4

#curl from ...
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean
echo "DONE libvorbis"

#libvpx
cd $FF_DIR

#create folder
if [ -d "./libvpx" ]; then
   rm -rf ./libvpx
   echo "delete original libvpx folder"
fi
   mkdir libvpx
#clone from git
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make
make install
make clean
echo "DONE Libvpx"

#libfreetype
yum install freetype-devel

#libtheora
cd $FF_DIR

#create folder
if [ -d "./libtheora-1.1.1" ]; then
   rm -rf ./libtheora-1.1.1
   echo "delete original libtheora-1.1.1 folder"
fi
   mkdir libtheora-1.1.1
#curl from ..
curl -O http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz
tar xzvf libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-examples --disable-shared --disable-sdltest --disable-vorbistest
make
make install
make distclean
echo "DONE Libtheora"

#FFmpeg
cd $FF_DIR
#create folder
if [ -d "./ffmpeg" ]; then
   rm -rf ./ffmpeg
   echo "delete original ffmpeg folder"
fi
   mkdir ffmpeg
#curl from ..
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin" --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libfreetype --enable-libtheora
make
make install
make distclean
hash -r

cp ~/bin/ff* /bin/

exit #
