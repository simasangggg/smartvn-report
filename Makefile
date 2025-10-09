# Makefile cho dự án báo cáo

.PHONY: build watch clean open help

# Build file Word
build:
	@./build.sh

# Watch và auto-build
watch:
	@./watch.sh

# Xóa file output
clean:
	@rm -f bao-cao.docx
	@echo "✨ Đã xóa file output"

# Mở file Word
open:
	@if [ -f "bao-cao.docx" ]; then \
		libreoffice bao-cao.docx & \
	else \
		echo "❌ File chưa được tạo. Chạy 'make build' trước"; \
	fi

# Hiển thị help
help:
	@echo "📖 Các lệnh có sẵn:"
	@echo "  make build  - Build file Word"
	@echo "  make watch  - Auto-build khi có thay đổi"
	@echo "  make open   - Mở file Word"
	@echo "  make clean  - Xóa file output"
