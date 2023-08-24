rm -rf build-wasm;
sudo apt update;
sudo apt install -y build-essential curl zip unzip tar pkg-config;
./vcpkg.sh;
qt-cmake . -G Ninja -B ./build-wasm -DVCPKG_TARGET_TRIPLET=wasm32-emscripten; 
cmake --build ./build-wasm;