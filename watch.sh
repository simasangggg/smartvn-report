#!/bin/bash
# Auto-rebuild khi file .md thay đổi

echo "🔍 Đang theo dõi thay đổi file .md..."
nodemon -e md -x './build.sh' --watch .
