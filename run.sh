#!/bin/bash

set -e

readonly ZEPHYR_BUILDER_HEADERS_DIR_NAME="zephyr_headers"

if [[ -z "$1" ]]; then
    echo "No one path specified, at least one required."
    exit 22
fi

readonly target_dir_path="$(dirname $1)"

for target_path in "$@"
do
    real_target_path="$(realpath $target_path)"
    target_dir_name="$(basename $real_target_path)"
    forward_paths="$forward_paths -v $real_target_path:/workdir/$target_dir_name"
done

docker run -it --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    $forward_paths \
    -v "$target_dir_path/$ZEPHYR_BUILDER_HEADERS_DIR_NAME:/workdir/$ZEPHYR_BUILDER_HEADERS_DIR_NAME/" \
    zephyr-builder
