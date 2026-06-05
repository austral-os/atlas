#!/bin/bash

# build.sh - Atlas Kernel Build Script
# Usage: ./build.sh [clean]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$ROOT_DIR/build"
LINUX_DIR="$BUILD_DIR/linux"
OUT_DIR="$ROOT_DIR/out"

# --- Functions ---

check_dependencies() {
    local deps=("fakeroot" "bison" "flex" "bc" "dpkg-dev" "make" "gcc" "libssl-dev" "libelf-dev" "libncurses-dev")
    local missing=()
    for dep in "${deps[@]}"; do
        if ! dpkg-query -W -f='${Status}' "$dep" 2>/dev/null | grep -q "ok installed"; then
            missing+=("$dep")
        fi
    done

    if [ ${#missing[@]} -ne 0 ]; then
        echo "Error: Missing build dependencies."
        echo "Please install them by running:"
        echo "sudo apt-get install ${missing[@]}"
        exit 1
    fi
}

clean_build() {
    echo "Cleaning build directory..."
    rm -rf "$BUILD_DIR"
    echo "Done."
}

# --- Main Logic ---

if [ "$1" == "clean" ]; then
    clean_build
    exit 0
fi

echo "======================================"
echo "    Atlas Kernel Build Script         "
echo "======================================"

check_dependencies

mkdir -p "$BUILD_DIR"
mkdir -p "$OUT_DIR"

# Read metadata
ATLAS_VERSION=$(cat "$ROOT_DIR/metadata/version" || echo "1")
ATLAS_CODENAME=$(cat "$ROOT_DIR/metadata/release" || echo "Unknown")
echo "Building Atlas Kernel - Version $ATLAS_VERSION ($ATLAS_CODENAME)"

if [ ! -d "$LINUX_DIR" ]; then
    echo "Fetching Linux source from Debian..."
    cd "$BUILD_DIR"
    # apt-get source downloads and extracts the debian patched kernel
    # We grep the folder name to rename it consistently to 'linux'
    apt-get source linux --download-only
    dpkg-source -x *.dsc linux
    rm *.dsc *.tar.xz
    echo "Source prepared in $LINUX_DIR."
else
    echo "Persistent source directory found at $LINUX_DIR. Reusing it."
fi

cd "$LINUX_DIR"

echo "Applying Atlas configuration (Merge Debian Reference + Atlas Fragments)..."
# Merge the reference config with all our fragments
./scripts/kconfig/merge_config.sh -m "$ROOT_DIR/configs/reference.config" "$ROOT_DIR/configs/fragments/"*.cfg

echo "Injecting Atlas Branding..."
# Set LOCALVERSION dynamically without relying on fragments
./scripts/config --set-str LOCALVERSION "-atlas${ATLAS_VERSION}"

echo "Validating Configuration..."
make olddefconfig

# Optional: Save the generated config back to the repo for inspection
cp .config "$ROOT_DIR/configs/generated.config"

echo "Starting compilation..."
# Use bindeb-pkg to generate simple debian packages
make -j$(nproc) bindeb-pkg

echo "Compilation finished. Moving artifacts..."
mv ../*.deb "$OUT_DIR/" 2>/dev/null || true
mv ../*.buildinfo "$OUT_DIR/" 2>/dev/null || true
mv ../*.changes "$OUT_DIR/" 2>/dev/null || true

echo "Success! Packages are available in $OUT_DIR/"
