## Build for Windows
## Note: The following packages are required to build for Windows:
## From chocolatey: cmake, ninja, mingw, wixtoolset, python3.9, git
## From pip: aqtinstall
## From aqt: qt 6.6.1 windows desktop mingw-64
## Environment variables: AQT_DIR 
## Expects mingw compilers to be on path which chocolatey does be default
## Note that to put cmake on path, you must install it with 
##  choco install cmake --installargs 'ADD_CMAKE_TO_PATH=System'

if (Test-Path build-windows) {
    Remove-Item -Recurse -Force build-windows
}
if (Test-Path vcpkg) {
    Remove-Item -Recurse -Force vcpkg
}

$env:CC=$(where.exe x86_64-w64-mingw32-gcc)
$env:CXX=$(where.exe x86_64-w64-mingw32-g++)
$env:VCPKG_TARGET_TRIPLET="x64-mingw-dynamic"
$env:VCPKG_HOST_TRIPLET="x64-mingw-dynamic"

git clone https://www.github.com/microsoft/vcpkg.git
./vcpkg/bootstrap-vcpkg.bat

cmake . `
-B build-windows `
-G Ninja `
-D VCPKG_TARGET_TRIPLET=x64-mingw-dynamic `
-D VCPKG_HOST_TRIPLET=x64-mingw-dynamic `
-D CMAKE_TOOLCHAIN_FILE=.\qt\6.6.1\mingw_64\lib\cmake\Qt6\qt.toolchain.cmake `
-D CMAKE_BUILD_TYPE=Release `
-D CMAKE_INSTALL_PREFIX=./deploy/windows `
-D X_VCPKG_APPLOCAL_DEPS_INSTALL=ON

cmake --build build-windows --target package