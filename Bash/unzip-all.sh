$ find * -type f -name "*.zip" -or "*.7z" -or "*.rar" | xargs unzip -I {} "{}"
