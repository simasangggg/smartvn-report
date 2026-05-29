---
title: |
  HỌC VIỆN CÔNG NGHỆ BƯU CHÍNH VIỄN THÔNG
  CƠ SỞ THÀNH PHỐ HỒ CHÍ MINH
subtitle: |
  BÁO CÁO ĐỒ ÁN MÔN HỌC

  **ĐỀ TÀI: XÂY DỰNG HỆ THỐNG THƯƠNG MẠI ĐIỆN TỬ VỚI KIẾN TRÚC MICROSERVICES SỬ DỤNG SPRING BOOT VÀ REDIS**
author:
  - "**Môn học:** Lập trình Mobile"
  - "**Giảng viên hướng dẫn:** GV. Nguyễn Văn A"
  - "**Lớp:** D22CQCNPM01-N"
  - ""
  - "**Thành viên nhóm:**"
  - "Nguyễn Văn Sang — 22110001 — Nhóm trưởng"
  - "Thành viên 2 — 22110002 — Thành viên"
  - "Thành viên 3 — 22110003 — Thành viên"
date: "Thành phố Hồ Chí Minh, tháng 5 năm 2026"
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
reference-section-title: "TÀI LIỆU THAM KHẢO"
---

# LỜI CẢM ƠN {-}

Nhóm chúng em xin gửi lời cảm ơn chân thành nhất đến **Học viện Công nghệ Bưu chính Viễn thông — Cơ sở Thành phố Hồ Chí Minh** đã tạo điều kiện thuận lợi cho chúng em trong quá trình học tập và nghiên cứu.

Chúng em xin đặc biệt cảm ơn **Giảng viên hướng dẫn** đã tận tình chỉ bảo, hướng dẫn và đồng hành cùng nhóm trong suốt quá trình thực hiện đồ án. Những góp ý, nhận xét của thầy là động lực lớn giúp nhóm hoàn thiện sản phẩm.

Ngoài ra, nhóm cũng xin cảm ơn các bạn trong lớp đã hỗ trợ, chia sẻ kiến thức và cùng nhau thảo luận trong quá trình học tập.

Cuối cùng, nhóm xin cảm ơn gia đình và bạn bè đã luôn ủng hộ tinh thần trong suốt thời gian thực hiện đồ án này.

Thành phố Hồ Chí Minh, tháng 5 năm 2026

**Nhóm thực hiện**

\newpage

# TÓM TẮT {-}

Báo cáo này trình bày quá trình thiết kế và hiện thực hóa hệ thống thương mại điện tử **SmartVN** ứng dụng kiến trúc **Microservices** với nền tảng **Spring Boot 3.3** và **Spring Cloud**. Hệ thống được xây dựng nhằm giải quyết bài toán quản lý cửa hàng trực tuyến với yêu cầu cao về khả năng mở rộng, hiệu năng và tính sẵn sàng.

Kiến trúc Microservices cho phép hệ thống được chia thành nhiều dịch vụ nhỏ, độc lập bao gồm: **User Service** (quản lý người dùng, xác thực JWT/OAuth2), **Product Service** (quản lý sản phẩm với bộ nhớ đệm Redis), **Order Service** (quản lý đơn hàng và thanh toán VNPay), và **Admin Service** (quản trị hệ thống). Các dịch vụ giao tiếp với nhau thông qua **OpenFeign** với cơ chế **Circuit Breaker** của Resilience4j đảm bảo tính bền vững.

Hệ thống sử dụng **MySQL 8.0** làm cơ sở dữ liệu chính, **Redis 7** làm tầng cache nhằm giảm thời gian truy xuất cho các truy vấn phổ biến. **API Gateway** đóng vai trò là điểm vào duy nhất, xử lý định tuyến, xác thực JWT và quản lý CORS.

Kết quả kiểm thử hiệu năng với **Grafana k6** cho thấy hệ thống đạt hiệu suất ấn tượng: thời gian phản hồi trung bình giảm từ **47.81ms** xuống **8.66ms** (gấp **5.5 lần**) khi sử dụng Redis cache, throughput tăng **26%** từ 196.8 lên 248.5 requests/giây, và tỷ lệ lỗi giảm xuống **0%**.

Hệ thống được đóng gói hoàn toàn bằng **Docker Compose** với cơ chế health check và dependency ordering, đảm bảo khởi động ổn định và dễ dàng triển khai trên nhiều môi trường.

**Từ khóa:** Microservices, Spring Boot, Spring Cloud, Redis, JWT, OAuth2, Docker, VNPay, API Gateway, Eureka, Circuit Breaker.

\newpage

# TỔNG QUAN ĐỀ TÀI

## Giới thiệu bài toán và bối cảnh

Trong thời đại số hóa ngày nay, thương mại điện tử (e-commerce) đã trở thành một phần không thể thiếu trong cuộc sống. Theo báo cáo của Statista, doanh thu thương mại điện tử toàn cầu năm 2025 đạt hơn 6.000 tỷ USD và dự kiến sẽ tiếp tục tăng trưởng mạnh trong những năm tới. Tại Việt Nam, thị trường thương mại điện tử cũng đang phát triển nhanh chóng với sự tham gia của nhiều nền tảng lớn như Shopee, Lazada, Tiki, và Sendo.

Sự phát triển mạnh mẽ này đặt ra nhiều thách thức cho các nhà phát triển trong việc xây dựng hệ thống thương mại điện tử có khả năng:

- **Mở rộng linh hoạt:** Hệ thống cần xử lý lượng lớn người dùng đồng thời, đặc biệt vào các dịp khuyến mãi lớn.
- **Đảm bảo tính sẵn sàng:** Một dịch vụ bị lỗi không nên làm ảnh hưởng đến toàn bộ hệ thống.
- **Bảo mật cao:** Bảo vệ thông tin người dùng, giao dịch thanh toán là ưu tiên hàng đầu.
- **Duy trì và phát triển:** Hệ thống cần dễ dàng bảo trì, cập nhật từng phần mà không ảnh hưởng đến toàn bộ.

Kiến trúc **Monolithic** truyền thống, mặc dù đơn giản trong giai đoạn phát triển ban đầu, nhưng bộc lộ nhiều hạn chế khi hệ thống phát triển lớn hơn: khó mở rộng theo chiều ngang, khó deploy từng phần, và một lỗi nhỏ có thể làm sập toàn bộ hệ thống.

Để giải quyết những vấn đề trên, nhóm lựa chọn kiến trúc **Microservices** — một phương pháp thiết kế hệ thống trong đó ứng dụng được chia thành nhiều dịch vụ nhỏ, chạy độc lập và giao tiếp với nhau thông qua API. Kết hợp với hệ sinh thái **Spring Cloud**, bài toán xây dựng hệ thống thương mại điện tử trở nên khả thi và hiệu quả hơn.

## Mục tiêu đề tài

Đồ án hướng đến đạt được các mục tiêu sau:

- Thiết kế và hiện thực hóa hệ thống thương mại điện tử **SmartVN** với kiến trúc Microservices sử dụng Spring Boot và Spring Cloud.
- Triển khai đầy đủ các dịch vụ: quản lý người dùng, quản lý sản phẩm, quản lý đơn hàng, thanh toán trực tuyến, và quản trị hệ thống.
- Áp dụng cơ chế **cache Redis** nhằm cải thiện hiệu năng truy xuất dữ liệu.
- Tích hợp **xác thực đa tầng** với JWT và OAuth2 (Google, GitHub).
- Triển khai hệ thống thanh toán trực tuyến thông qua cổng **VNPay**.
- Đảm bảo tính bền vững với **Circuit Breaker** và **Fallback** sử dụng Resilience4j.
- Đóng gói và triển khai hệ thống bằng **Docker Compose** với cơ chế health check.
- Kiểm thử và đánh giá hiệu năng hệ thống thông qua công cụ **Grafana k6**.

## Phạm vi đề tài

Phạm vi thực hiện của đồ án bao gồm:

**Phía Backend (tập trung chính):**

- Xây dựng 7 microservices: Eureka Server, Config Server, API Gateway, User Service, Product Service, Order Service, Admin Service.
- Thiết kế và triển khai cơ sở dữ liệu MySQL với đầy đủ schema.
- Triển khai hệ thống cache Redis cho Product Service.
- Tích hợp xác thực JWT và OAuth2.
- Tích hợp thanh toán VNPay.
- Triển khai Circuit Breaker cho giao tiếp liên dịch vụ.

**Phía Frontend (hỗ trợ demo):**

- Customer Frontend: Giao diện người dùng với React.
- Admin Frontend: Giao diện quản trị với React.

**Ngoài phạm vi:**

- Triển khai trên môi trường production thực tế.
- Tích hợp CI/CD pipeline.
- Tối ưu SEO và hiệu năng frontend.

## Phương pháp thực hiện

Nhóm thực hiện đồ án theo các bước sau:

- **Bước 1 — Nghiên cứu và phân tích:** Tìm hiểu các công nghệ liên quan (Spring Boot, Spring Cloud, Redis, Docker), phân tích yêu cầu hệ thống.
- **Bước 2 — Thiết kế:** Thiết kế kiến trúc tổng thể, cơ sở dữ liệu, API, và luồng dữ liệu.
- **Bước 3 — Hiện thực hóa:** Lập trình từng microservice theo mô hình từ dưới lên (bottom-up), bắt đầu từ infrastructure services đến business services.
- **Bước 4 — Tích hợp:** Kết nối các dịch vụ, kiểm thử giao tiếp liên dịch vụ.
- **Bước 5 — Kiểm thử và đánh giá:** Thực hiện kiểm thử chức năng và kiểm thử hiệu năng với k6.
- **Bước 6 — Hoàn thiện báo cáo:** Tổng hợp kết quả, viết báo cáo và chuẩn bị bảo vệ.

Công cụ quản lý mã nguồn sử dụng **Git** với mô hình branching strategy. Quá trình phát triển được hỗ trợ bởi **VS Code** và **IntelliJ IDEA**.
