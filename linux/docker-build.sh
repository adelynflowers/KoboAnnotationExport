#!/bin/sh
sudo apt update; 
sudo apt install -y \
    libgl-dev \
    libvulkan-dev \
    curl \
    zip \
    unzip \
    tar \
    pkg-config \
    wget \
    libxcb-xkb-dev \
    libxkbcommon-x11-dev \
    libxkbcommon-dev \
    libx11-xcb-dev \
    libx11-xcb1 \
    build-essential \
    libxcb-util-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxrender-dev \
    libxcb1-dev \
    libxcb-cursor-dev \
    libxcb-glx0-dev \
    libxcb-keysyms1-dev \
    libxcb-image0-dev \
    libxcb-shm0-dev \
    libxcb-icccm4-dev \
    libxcb-sync-dev \
    libxcb-xfixes0-dev \
    libxcb-shape0-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-util-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxrender-dev \
    libxcb1-dev \
    libxcb-cursor-dev \
    libxcb-glx0-dev \
    libxcb-keysyms1-dev \
    libxcb-image0-dev \
    libxcb-shm0-dev \
    libxcb-icccm4-dev \
    libxcb-sync-dev \
    libxcb-xfixes0-dev \
    libxcb-shape0-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    libxcb-util-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    file;

# Build gtk2 platform theme
# git clone http://code.qt.io/qt/qtstyleplugins.git
# cd qtstyleplugins
# qmake
# make -j$(nproc)
# make install 
# ls
# cd -
# ls
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/1-alpha-20231206-1/linuxdeploy-x86_64.AppImage
wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage
sed 's|AI\x02|\x00\x00\x00|g' -i linuxdeploy-x86_64.AppImage
sed 's|AI\x02|\x00\x00\x00|g' -i linuxdeploy-plugin-qt-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-plugin-qt-x86_64.AppImage
export APPIMAGE_EXTRACT_AND_RUN=1
cd /home/user/project;
chmod +x ./vcpkg.sh;
./vcpkg.sh;
qt-cmake . -G Ninja -B ./build-linux; cmake --build ./build-linux;
export QML_SOURCES_PATHS=/home/user/project/build-linux
mkdir deploy || true;
~/linuxdeploy-x86_64.AppImage --plugin qt -e ./build-linux/kae --appdir ./build-linux/deploy -d ./linux/kae.desktop -i ./linux/kae.png --output appimage;
mv kae*.AppImage ./deploy;

