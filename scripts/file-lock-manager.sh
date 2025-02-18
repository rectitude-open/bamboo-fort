#!/bin/bash
# File Lock Manager

TARGET_PATHS=(
    "/home/wwwroot/aaa.com/public/wp-admin"  # Lock this folder and everything inside it.
    "/home/wwwroot/aaa.com/public/wp-config.php" # Lock this file
)

EXCLUDE_PATHS=(
    "/home/wwwroot/aaa.com/public/wp-admin/images/*" # Exclude everything inside this folder, but not the folder itself
    "/home/wwwroot/aaa.com/public/wp-admin/plugin-temp/*.tmp" # Support wildcard exclusions
)

echo "[Operation Mode]"
select operation in "LOCK" "UNLOCK" "DRY-RUN"; do
    case $operation in
        LOCK)   FLAG="+i"; break;;
        UNLOCK) FLAG="-i"; break;;
        DRY-RUN) FLAG="test"; break;;
        *)      echo "Invalid selection"; exit 1;;
    esac
done

normalize_path() {
    local path="${1%/}"
    echo "${path//\/\///}"
}

build_find_excludes() {
    local -a excludes=()
    for raw_path in "${EXCLUDE_PATHS[@]}"; do
        path=$(normalize_path "$raw_path")
        excludes+=("! -path" "$path" "! -path" "${path}/*")
    done
    echo "${excludes[@]}"
}

process_target() {
    local target=$(normalize_path "$1")
    
    [ "$FLAG" != "test" ] && chattr $FLAG "$target" 2>/dev/null
    
    if [ -d "$target" ]; then
        IFS=' ' read -ra find_excludes <<< "$(build_find_excludes)"
        
        if [ "$FLAG" = "test" ]; then
            find "$target" -mindepth 1 "${find_excludes[@]}" -exec lsattr -d {} \; 2>/dev/null
        else
            find "$target" -mindepth 1 "${find_excludes[@]}" -exec chattr $FLAG {} \; 2>/dev/null
        fi
    fi
}

echo "=== Processing ${#TARGET_PATHS[@]} targets ==="
for raw_target in "${TARGET_PATHS[@]}"; do
    process_target "$raw_target"
done

if [ "$FLAG" != "test" ]; then
    echo -e "\n[Verification]"
    for raw_target in "${TARGET_PATHS[@]}"; do
        target=$(normalize_path "$raw_target")
        echo "=== $target ==="

        lsattr -d "$target" 2>/dev/null | awk '/^[^ ]*i/ {print $1 " " $2}'

        if [ -d "$target" ]; then
            find "$target" -mindepth 1 -exec lsattr -d {} \; 2>/dev/null | 
            awk '/^[^ ]*i/ {print $1 " " $2}'
        fi
    done
fi
