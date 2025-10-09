#!/bin/bash
INPUT="pthttm.md"
OUTPUT="bao-cao.docx"
TEMPLATE="template.docx"

if [ ! -f "$INPUT" ]; then
    echo "❌ Không tìm thấy file $INPUT"
    exit 1
fi

echo "🔄 Đang chuyển đổi $INPUT → $OUTPUT..."

if [ -f "$TEMPLATE" ]; then
    pandoc "$INPUT" -o "$OUTPUT" \
      --filter pandoc-crossref \
      --toc \
      --toc-depth=3 \
      --reference-doc="$TEMPLATE" \
      --highlight-style=tango
else
    pandoc "$INPUT" -o "$OUTPUT" \
      --filter pandoc-crossref \
      --toc \
      --toc-depth=3 \
      --highlight-style=tango
fi

if [ $? -eq 0 ]; then
    echo "✅ Đã tạo $OUTPUT thành công!"
    echo "📊 Kích thước: $(du -h $OUTPUT | cut -f1)"
else
    echo "❌ Có lỗi xảy ra!"
    exit 1
fi