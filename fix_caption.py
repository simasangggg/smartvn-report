"""
fix_caption.py — Tự động đổi style Caption → Figure Caption / Table Caption
Chạy sau pandoc: python fix_caption.py output.docx

Cài đặt: pip install python-docx
"""

import sys
import re
from docx import Document
from docx.oxml.ns import qn
from docx.oxml import OxmlElement
from copy import deepcopy


def set_paragraph_style(para, style_name: str):
    """Đổi style của paragraph."""
    try:
        para.style = para._p.getparent().getparent().part.styles[style_name]
    except KeyError:
        pass


def is_figure_caption(text: str) -> bool:
    """Kiểm tra dòng có phải Figure Caption không."""
    t = text.strip()
    return (
        t.startswith("Hình")
        or t.startswith("Figure")
        or re.match(r"^(fig\.|hình)\s*\d+", t, re.IGNORECASE) is not None
    )


def is_table_caption(text: str) -> bool:
    """Kiểm tra dòng có phải Table Caption không."""
    t = text.strip()
    return (
        t.startswith("Bảng")
        or t.startswith("Table")
        or re.match(r"^(bảng|table)\s*\d+", t, re.IGNORECASE) is not None
    )


def fix_captions(docx_path: str):
    doc = Document(docx_path)
    fixed_figure = 0
    fixed_table = 0

    for para in doc.paragraphs:
        # Chỉ xử lý các paragraph có style Caption (do pandoc tạo)
        if para.style.name.lower() not in ("caption", "figure caption", "table caption"):
            continue

        text = para.text.strip()
        if not text:
            continue

        if is_figure_caption(text):
            try:
                para.style = doc.styles["Figure Caption"]
                fixed_figure += 1
            except KeyError:
                pass  # Style không tồn tại trong template
        elif is_table_caption(text):
            try:
                para.style = doc.styles["Table Caption"]
                fixed_table += 1
            except KeyError:
                pass

    doc.save(docx_path)
    print(f"   → Figure Caption: {fixed_figure} dòng")
    print(f"   → Table Caption : {fixed_table} dòng")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Dùng: python fix_caption.py <file.docx>")
        sys.exit(1)

    path = sys.argv[1]
    print(f"   Đang xử lý: {path}")
    fix_captions(path)