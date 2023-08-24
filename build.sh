#!/bin/bash
if [ $1 = 'windows' ]
then
    x86_64-w64-mingw32.static-cmake . -Bbuild-w64 -GNinja -DVCPKG_TARGET_TRIPLET=x64-mingw-static -DCMAKE_BUILD_TYPE:STRING=Debug && \
    x86_64-w64-mingw32.static-cmake --build build-w64;
elif [ $1 = 'wasm' ]
then
    docker run -it --rm -v "${PWD}:/home/user" stateoftheartio/qt6:6.5-wasm-aqt \
    sh -c './wasmbuild.sh';
    
else
    cmake . -Bbuild -GNinja && cmake --build build;
fi
