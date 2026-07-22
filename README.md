# zephyr-builder

Docker контейнер для сборки приложений под zephyr.  
Содержит в себе:
- Toolchain-ы для сборки.
- Инструменты для прошивки: openocd, pyocd и т.п.
- west.
- spore-codegen для простейшей кодо-генерации.

## Получение контейнера

После любых правок в main контейнер автоматически пересобирается и выкладывается в registry.docker.io  
Скачать можно командой:
```bash
docker pull jodzikk/zephyr-builder
```

## Пример скрипта запуска контейнера

```bash
#!/bin/bash

set -e

if [[ -z "$1" ]]; then
    echo "No one path specified, at least one required."
    exit 22
fi

readonly main_dir_name="$(basename $1)"

for target_path in "$@"
do
    real_target_path="$(realpath $target_path)"
    target_dir_name="$(basename $real_target_path)"
    forward_paths="$forward_paths -v $real_target_path:/workdir/$target_dir_name"
done

docker run -it --privileged \
    -v /dev/bus/usb:/dev/bus/usb \
    $forward_paths \
    jodzikk/zephyr-builder \
    /bin/bash -c "cd $main_dir_name && exec /bin/bash"
```
