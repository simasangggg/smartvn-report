---
title: |
  HỌC VIỆN CÔNG NGHỆ BƯU CHÍNH VIỄN THÔNG
  CƠ SỞ THÀNH PHỐ HỒ CHÍ MINH
subtitle: |
  BÁO CÁO ĐỒ ÁN MÔN HỌC

  **ĐỀ TÀI: XÂY DỰNG HỆ THỐNG PHÁT HIỆN VÀ CẢNH BÁO BUỒN NGỦ CHO TÀI XẾ SỬ DỤNG ESP32-CAM VÀ CẢM BIẾN MẮT**
author:
  - "**Môn học:** Xây dựng các hệ thống nhúng"
  - "**Giảng viên hướng dẫn:** TS. Nguyễn Trọng Kiên"
  - "**Lớp:** D22CQCNPM01-N"
  - ""
  - "**Thành viên nhóm:**"
  - "[Tên nhóm trưởng] — [MSSV] — Nhóm trưởng"
  - "[Tên thành viên 1] — [MSSV] — Thành viên"
  - "[Tên thành viên 2] — [MSSV] — Thành viên"
  - "[Tên thành viên 3] — [MSSV] — Thành viên"
date: "Thành phố Hồ Chí Minh, tháng 4 năm 2026"
lang: vi-VN
papersize: a4
fontsize: 13pt
geometry:
  - margin=2.5cm
  - top=3cm
  - bottom=3cm
linestretch: 1.5
toc: true
toc-title: "MỤC LỤC"
lof: true
lof-title: "DANH SÁCH HÌNH VẼ"
lot: true
lot-title: "DANH SÁCH BẢNG"
numbersections: false
figureTitle: "Hình"
tableTitle: "Bảng"
figPrefix:
  - "Hình"
  - "Hình"
tblPrefix:
  - "Bảng"
  - "Bảng"
eqnPrefix: "Phương trình"
chaptersDepth: 0
sectionsDepth: 0
tables: true
link-citations: true
reference-section-title: "TÀI LIỆU THAM KHẢO"
autoSectionLabels: true
---

<!--
=======================================================================
RULES CHO GITHUB COPILOT — ĐỌC KỸ, TUÂN THEO TUYỆT ĐỐI
=======================================================================

== QUY TẮC HEADING ==

numbersections: false → pandoc KHÔNG tự đánh số
template.docx ĐÃ CÓ numPr (danh sách tự động) cho Heading 1/2/3
→ KHÔNG được tự thêm số, chữ "Chương", hay bất kỳ tiền tố nào vào heading

ĐÚNG:
  # TỔNG QUAN ĐỀ TÀI
  ## Giới thiệu bài toán
  ### Bối cảnh và động lực

SAI (KHÔNG ĐƯỢC LÀM):
  # CHƯƠNG I. TỔNG QUAN ĐỀ TÀI   ← template.docx tự thêm "Chương I" rồi
  # 1. TỔNG QUAN ĐỀ TÀI           ← tự đánh số → bị trùng
  ## 1.1. Giới thiệu bài toán     ← tự đánh số → bị trùng
  ## 1.1 Giới thiệu bài toán      ← tự đánh số → bị trùng

Heading đặc biệt (không đánh số):
  # LỜI CẢM ƠN {-}
  # TÓM TẮT {-}
  # TÀI LIỆU THAM KHẢO {-}
  # PHỤ LỤC {-}

== QUY TẮC HÌNH ẢNH ==

Cú pháp chèn hình với pandoc-crossref:
  ![Mô tả hình](đường/dẫn/ảnh.png){#fig:ten-nhan width=80%}

Caption sẽ tự render: "Hình X: Mô tả hình"
Tham chiếu trong văn bản: @fig:ten-nhan → render thành "Hình X"

VÍ DỤ ĐÚNG:
  ![Sơ đồ kiến trúc tổng thể hệ thống](images/kien_truc.png){#fig:kien-truc width=85%}
  Kiến trúc tổng thể được mô tả trong @fig:kien-truc.

  ![Confusion Matrix của Model 1](images/confusion_matrix.png){#fig:cm width=70%}
  Kết quả phân loại thể hiện trong @fig:cm cho thấy...

Lưu ý:
  - ten-nhan chỉ dùng chữ thường, số, dấu gạch ngang (không dấu tiếng Việt)
  - width= không bắt buộc nhưng nên có để kiểm soát kích thước

== QUY TẮC BẢNG ==

Caption bảng đặt TRÊN bảng, dùng cú pháp:
  : Tiêu đề bảng {#tbl:ten-nhan}

Tham chiếu: @tbl:ten-nhan → render thành "Bảng X"

VÍ DỤ ĐÚNG:
  : So sánh ưu nhược điểm hai phương án triển khai {#tbl:so-sanh}

  | Tiêu chí | Phương án 1 (Server) | Phương án 2 (Edge AI) |
  |---|---|---|
  | Độ trễ | Cao hơn | Thấp hơn |
  | Độ chính xác | Cao | Trung bình |

  Kết quả so sánh trong @tbl:so-sanh cho thấy...

== QUY TẮC CHUNG ==

- KHÔNG dùng HTML tags (<a>, <div>, <br>, <img>, v.v.)
- KHÔNG dùng \newpage
- KHÔNG dùng <a id="..."> làm anchor
- Danh sách dùng - (gạch ngang), không dùng *
- Mỗi đoạn văn cách nhau 1 dòng trống
- Code block dùng triple backtick + tên ngôn ngữ:
    ```python
    code ở đây
    ```
- Văn xuôi tiếng Việt, học thuật, trang trọng
=======================================================================
-->

# LỜI CẢM ƠN {-}

Nội dung lời cảm ơn...

---

# TÓM TẮT {-}

Nội dung tóm tắt...

---

# TỔNG QUAN ĐỀ TÀI

## Giới thiệu bài toán

Nội dung...

## Mục tiêu hệ thống

Nội dung...

---

# CƠ SỞ LÝ THUYẾT & CÔNG NGHỆ

## Thuật toán EAR và PERCLOS

Nội dung...

Ví dụ hình:

![Minh họa 6 điểm landmark tính EAR](images/ear.png){#fig:ear width=60%}

Như thể hiện trong @fig:ear, công thức EAR được tính từ 6 điểm.

## MediaPipe FaceLandmarker

Ví dụ bảng:

: Thông số cấu hình MediaPipe {#tbl:mediapipe}

| Tham số | Giá trị |
|---|---|
| num_faces | 1 |
| min_face_detection_confidence | 0.5 |

Các thông số trong @tbl:mediapipe được giữ nguyên mặc định.

---

# THIẾT KẾ HỆ THỐNG

## Kiến trúc tổng thể

Nội dung...

---

# TRIỂN KHAI & KẾT QUẢ

## Thiết lập phần cứng

Nội dung...

---

# KẾT LUẬN & HƯỚNG PHÁT TRIỂN

## Kết quả đạt được

Nội dung...

## Hướng cải tiến

Nội dung...

---

# TÀI LIỆU THAM KHẢO {-}

[1] Tác giả. (Năm). *Tên tài liệu*. Nhà xuất bản.

---

# PHỤ LỤC {-}

## Phân công công việc

: Bảng phân công công việc {#tbl:phan-cong}

| Thành viên | Nhiệm vụ |
|---|---|
| [Tên] | [Công việc] |