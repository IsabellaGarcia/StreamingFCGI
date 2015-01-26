#!bin/bash
FF_DIR=~/ffmpeg_sources
#Remove the old files and then update the dependencies

#rm -rf ~/ffmpeg_build ~/bin/{ffmpeg,ffprobe,ffserver,lame,vsyasm,x264,yasm,ytasm}
#yum install autoconf automake gcc gcc-c++ git libtool make nasm pkgconfig zlib-devel

#update libx264
cd $FF_DIR/x264
make distclean
git pull
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install
make distclean

#update libfdk_aac
cd $FF_DIR/fdk-aac
make distclean
git pull
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
make distclean

#update libvpx
cd $FF_DIR/libvpx
make clean
git pull
./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make
make install
make clean

#update FFmpeg
cd $FF_DIR/ffmpeg
make distclean
git pull
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin" --enable-gpl --enable-nonfree --enable-libfdk_aac --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libfreetype --enable-libtheora
make
make install
make distclean
hash -r