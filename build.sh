#! /bin/sh

mkdir build

tar xvf libnl-3.5.0.tar.gz
cd libnl-3.5.0
./configure --prefix=`pwd`/../build --enable-static --disable-shared
make -j $(nproc) install
cd ..

tar xvf libpcap-1.9.1.tar.gz
cd libpcap-1.9.1
./configure --prefix=`pwd`/../build --disable-shared --disable-dbus
make -j $(nproc) install
cd ..

tar xvf SpeexDSP-1.2.0.tar.gz
cd speexdsp-SpeexDSP-1.2.0
./autogen.sh
./configure --prefix=`pwd`/../build --disable-shared --enable-static --disable-maintainer-mode
make -j $(nproc) install
cd ..

tar xvf libogg-1.3.4.tar.xz
cd libogg-1.3.4

./configure --prefix=`pwd`/../build --disable-shared --enable-static --disable-maintainer-mode
make -j $(nproc) install
cd ..

tar xvf flac-1.3.3.tar.xz
cd flac-1.3.3
./configure --prefix=`pwd`/../build --disable-shared --enable-static --disable-maintainer-mode --disable-debug --disable-thorough-tests --with-ogg-libraries=`pwd`/../build/lib/ --with-ogg-includes=`pwd`/../build/include/ --disable-examples --disable-rpath --disable-oggtest --disable-xmms-plugin  --disable-doxygen-docs
make -j $(nproc) install
cd ..

tar xvf opus-1.3.1.tar.gz
cd opus-1.3.1
./configure --prefix=`pwd`/../build --disable-shared --enable-static --disable-maintainer-mode --disable-doc --disable-extra-programs
make -j $(nproc) install
cd ..

tar xvf opusfile-0.11.tar.gz
cd opusfile-0.11
PKG_CONFIG_PATH=../build/lib/pkgconfig/ ./configure --prefix=`pwd`/../build --disable-shared --enable-static --disable-maintainer-mode --disable-doc --disable-examples --disable-http
make -j $(nproc) install
cd ..

tar xvf libopusenc-0.2.1.tar.gz
cd libopusenc-0.2.1
PKG_CONFIG_PATH=../build/lib/pkgconfig/ ./configure --prefix=`pwd`/../build --disable-shared --enable-static --disable-maintainer-mode --disable-doc --disable-examples
make -j $(nproc) install
cd ..

tar xvf opus-tools-0.2.tar.gz
cd opus-tools-0.2
# Make opusrtp
gcc -I/usr/local -I../build/include -I../build/include/opus -I../build/include/pcap -I../build/include/ogg -I../build/include/FLAC -Isrc/ ../build/lib/lib*.a src/diag_range.c src/opusrtp.c -o opusrtp -L../build/lib/ -logg -lopus -lopusfile -lopusenc -lopusurl -lm -lpcap -lnl-3 -lnl-genl-3 -lpthread
# Make opusdec
gcc -I/usr/local -I../build/include/speex -I../build/include -I../build/include/opus -I../build/include/pcap -I../build/include/ogg -I../build/include/FLAC -Isrc/ ../build/lib/lib*.a src/flac.c src/diag_range.c src/opus_header.c src/wav_io.c src/opusdec.c -o opusdec -L../build/lib/ -lopusfile -lopus -lm -lopusenc -lFLAC -lopusurl -logg -lspeexdsp
# Make opusenc
gcc -I/usr/local -I../build/include/speex -I../build/include -I../build/include/opus -I../build/include/pcap -I../build/include/ogg -I../build/include/FLAC -Isrc/ ../build/lib/lib*.a src/flac.c src/diag_range.c src/opus_header.c src/audio-in.c src/wav_io.c src/opusenc.c -o opusenc -L../build/lib/ -lopusenc -lopus -lm -lopusfile -lFLAC -lopusurl -logg -lspeexdsp
# Make opusinfo
# gcc -static -I/usr/local -I../build/include/speex -I../build/include -I../build/include/opus -I../build/include/pcap -I../build/include/ogg -I../build/include/FLAC -Isrc/ ../build/lib/lib*.a src/flac.c src/diag_range.c src/opus_header.c src/audio-in.c src/wav_io.c src/picture.c src/info_opus.c src/opusinfo.c -o opusinfo -L../build/lib/ -lopusenc -lopus -lm -lopusfile -lFLAC -lopusurl -logg -lspeexdsp
mv opus* ../build/bin/
echo -e "Done. Binary path: ../build/bin/\n"
