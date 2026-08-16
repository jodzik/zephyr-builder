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

set -eu

if [[ -z "${1:-}" ]]; then
    echo "No one path specified, at least one required."
    exit 22
fi

readonly main_dir_name="$(basename $1)"
readonly container_name="$main_dir_name"

forward_paths=""
for target_path in "$@"
do
    real_target_path="$(realpath $target_path)"
    target_dir_name="$(basename $real_target_path)"
    forward_paths="$forward_paths -v $real_target_path:/workdir/$target_dir_name"
done

if docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null | grep -q "true"; then
    echo "Container is running, exec bash in $container_name"
    docker exec -it "$container_name" bash -c "cd $main_dir_name && exec bash"
elif docker inspect -f '{{.State.Status}}' "$container_name" 2>/dev/null | grep -q "exited"; then
    echo "Container exists, start and exec bash in $container_name"
    docker start "$container_name"
    docker exec -it "$container_name" bash -c "cd $main_dir_name && exec bash"
else
    echo "Container not exists, create and run new $container_name"
    docker run -it --privileged \
        --name "$container_name" \
        -v /dev/bus/usb:/dev/bus/usb \
        $forward_paths \
        jodzikk/zephyr-builder \
        bash -c "cd $main_dir_name && exec bash"
fi
```
