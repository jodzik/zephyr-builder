#!/bin/bash

if [[ -z "$ZEPHYR_BUILDER_HEADERS_DIR" ]]; then
    ZEPHYR_BUILDER_HEADERS="/workdir/zephyr_headers"
else
    ZEPHYR_BUILDER_HEADERS="/workdir/$ZEPHYR_BUILDER_HEADERS_DIR"
fi

echo "ZEPHYR_BUILDER_HEADERS=$ZEPHYR_BUILDER_HEADERS"

sudo chmod oug+rw -R "$ZEPHYR_BUILDER_HEADERS"

rsync -avpcm --include='*.h' --include='*.dts' --include='*.dtsi' --include='*.yaml' --include='*.yml' --include='*.Kconfig' --include='*/' --exclude='*' "/workdir/zephyr" "$ZEPHYR_BUILDER_HEADERS/"
rsync -avpcm --include='*.h' --include='*/' --exclude='*' "/workdir/modules" "$ZEPHYR_BUILDER_HEADERS/"

exec "$@"
