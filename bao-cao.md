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

Ứng dụng **mobile Android** được phát triển bằng **Java** với kiến trúc **MVVM**, sử dụng **Retrofit 2** gọi REST API, **Room Database** cho lưu trữ cục bộ (offline-first), **LiveData/ViewModel** cho reactive UI, và **Material Design 3** cho giao diện hiện đại. Ứng dụng tích hợp đầy đủ: xác thực JWT/OAuth2, duyệt sản phẩm, giỏ hàng, đặt hàng, và thanh toán VNPay.

Kết quả kiểm thử hiệu năng với **Grafana k6** cho thấy hệ thống đạt hiệu suất ấn tượng: thời gian phản hồi trung bình giảm từ **47.81ms** xuống **8.66ms** (gấp **5.5 lần**) khi sử dụng Redis cache, throughput tăng **26%** từ 196.8 lên 248.5 requests/giây, và tỷ lệ lỗi giảm xuống **0%**.

Hệ thống được đóng gói hoàn toàn bằng **Docker Compose** với cơ chế health check và dependency ordering, đảm bảo khởi động ổn định và dễ dàng triển khai trên nhiều môi trường.

**Từ khóa:** Microservices, Spring Boot, Spring Cloud, Redis, JWT, OAuth2, Docker, VNPay, API Gateway, Eureka, Circuit Breaker, Android, Java, MVVM, Retrofit, Room Database, Material Design.

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
- Phát triển ứng dụng **mobile Android native** bằng Java với kiến trúc MVVM, tích hợp đầy đủ các chức năng: duyệt sản phẩm, giỏ hàng, đặt hàng, thanh toán VNPay.
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

**Phía Mobile (tập trung chính):**

- Ứng dụng Android native bằng Java, kiến trúc MVVM.
- Tích hợp Retrofit 2 gọi REST API, Room Database cho offline cache.
- Xác thực JWT + OAuth2 (Google), thanh toán VNPay.
- Giao diện Material Design 3.

**Phía Frontend (hỗ trợ demo):**

- Customer Frontend: Giao diện người dùng với React.
- Admin Frontend: Giao diện quản trị với React.

**Ngoài phạm vi:**

- Triển khai trên môi trường production thực tế.
- Tích hợp CI/CD pipeline.
- Tối ưu SEO và hiệu năng frontend.
- Push notification qua Firebase Cloud Messaging (FCM) — đã thiết kế nhưng chưa triển khai đầy đủ.

## Phương pháp thực hiện

Nhóm thực hiện đồ án theo các bước sau:

- **Bước 1 — Nghiên cứu và phân tích:** Tìm hiểu các công nghệ liên quan (Spring Boot, Spring Cloud, Redis, Docker), phân tích yêu cầu hệ thống.
- **Bước 2 — Thiết kế:** Thiết kế kiến trúc tổng thể, cơ sở dữ liệu, API, và luồng dữ liệu.
- **Bước 3 — Hiện thực hóa:** Lập trình từng microservice theo mô hình từ dưới lên (bottom-up), bắt đầu từ infrastructure services đến business services.
- **Bước 4 — Tích hợp:** Kết nối các dịch vụ, kiểm thử giao tiếp liên dịch vụ.
- **Bước 5 — Kiểm thử và đánh giá:** Thực hiện kiểm thử chức năng và kiểm thử hiệu năng với k6.
- **Bước 6 — Hoàn thiện báo cáo:** Tổng hợp kết quả, viết báo cáo và chuẩn bị bảo vệ.

Công cụ quản lý mã nguồn sử dụng **Git** với mô hình branching strategy. Quá trình phát triển được hỗ trợ bởi **VS Code** và **IntelliJ IDEA**.

\newpage

# CƠ SỞ LÝ THUYẾT & CÔNG NGHỆ

Chương này trình bày tổng quan về các công nghệ, framework và nguyên lý kiến trúc được sử dụng trong đồ án. Đây là nền tảng lý thuyết quan trọng giúp hiểu rõ cách tiếp cận và giải quyết bài toán.

## Kiến trúc Microservices

### Khái niệm và nguyên lý

Kiến trúc Microservices là một phương pháp thiết kế phần mềm trong đó một ứng dụng lớn được cấu thành từ nhiều dịch vụ nhỏ, chạy độc lập. Mỗi dịch vụ thực hiện một chức năng nghiệp vụ cụ thể và giao tiếp với các dịch vụ khác thông qua các giao thức nhẹ, thường là HTTP/REST hoặc message queue.

Theo Martin Fowler và James Lewis (2014), Microservices được định nghĩa như sau: *"Kiến trúc Microservices là phương pháp phát triển một ứng dụng duy nhất dưới dạng một tập hợp các dịch vụ nhỏ, mỗi dịch vụ chạy trong tiến trình riêng, giao tiếp qua cơ chế nhẹ, được triển khai độc lập, xung quanh các khả năng kinh doanh, và có thể được quản lý bởi các nhóm nhỏ."*

Các nguyên lý cốt lõi của Microservices bao gồm:

- **Tách biệt chức năng (Single Responsibility):** Mỗi dịch vụ chỉ đảm nhận một chức năng nghiệp vụ cụ thể.
- **Triển khai độc lập (Independent Deployment):** Mỗi dịch vụ có thể được build, test và deploy độc lập.
- **Cơ sở dữ liệu riêng (Database per Service):** Mỗi dịch vụ sở hữu cơ sở dữ liệu riêng, không chia sẻ trực tiếp.
- **Giao tiếp qua API (API-based Communication):** Các dịch vụ giao tiếp với nhau thông qua các API được định nghĩa rõ ràng.
- **Tự phục hồi (Self-healing):** Hệ thống có khả năng phát hiện và phục hồi khi một dịch vụ gặp lỗi.

### So sánh với kiến trúc Monolithic

: So sánh kiến trúc Monolithic và Microservices {#tbl:so-sanh-kien-truc}

| Tiêu chí | Monolithic | Microservices |
|---|---|---|
| Cấu trúc | Ứng dụng đơn khối | Nhiều dịch vụ nhỏ |
| Triển khai | Deploy toàn bộ | Deploy từng dịch vụ |
| Ngôn ngữ | Một ngôn ngữ | Đa ngôn ngữ |
| Cơ sở dữ liệu | Chia sẻ CSDL | Mỗi dịch vụ CSDL riêng |
| Mở rộng | Scale toàn bộ | Scale từng dịch vụ |
| Bảo trì | Khó khi codebase lớn | Dễ bảo trì từng phần |
| Công nghệ | Một stack công nghệ | Đa stack công nghệ |
| Độ phức tạp ban đầu | Thấp | Cao |
| Phù hợp | Dự án nhỏ, team nhỏ | Dự án lớn, team lớn |

Như thể hiện trong @tbl:so-sanh-kien-truc, kiến trúc Microservices có ưu điểm vượt trội về khả năng mở rộng và triển khai, tuy nhiên đòi hỏi độ phức tạp cao hơn trong giai đoạn phát triển ban đầu.

### Ưu nhược điểm

**Ưu điểm của Microservices:**

- **Khả năng mở rộng cao:** Có thể mở rộng từng dịch vụ theo nhu cầu, không cần mở rộng toàn bộ hệ thống.
- **Tính linh hoạt công nghệ:** Mỗi dịch vụ có thể sử dụng ngôn ngữ, framework khác nhau phù hợp với bài toán cụ thể.
- **Triển khai liên tục:** Hỗ trợ CI/CD hiệu quả, cho phép cập nhật từng phần mà không ảnh hưởng đến hệ thống.
- **Tách biệt lỗi:** Một dịch vụ gặp sự cố không làm sập toàn bộ hệ thống.
- **Dễ bảo trì:** Codebase nhỏ, dễ hiểu, dễ bảo trì cho từng nhóm phát triển.

**Nhược điểm của Microservices:**

- **Độ phức tạp phân tán:** Quản lý nhiều dịch vụ đòi hỏi công cụ giám sát, logging tập trung.
- **Giao tiếp liên dịch vụ:** Chi phí mạng và độ trễ khi giao tiếp giữa các dịch vụ.
- **Tính nhất quán dữ liệu:** Khó đảm bảo tính nhất quán khi dữ liệu phân tán trên nhiều CSDL.
- **Yêu cầu hạ tầng:** Cần hạ tầng container, orchestration, service discovery.

## Spring Boot & Spring Cloud

### Spring Boot 3.3

Spring Boot là framework phát triển ứng dụng Java dựa trên nền tảng Spring Framework, giúp tạo ra các ứng dụng Spring có thể chạy standalone với cấu hình tối thiểu. Spring Boot 3.3, được phát hành vào năm 2024, là phiên bản mới nhất với nhiều cải tiến đáng chú ý.

**Đặc điểm chính của Spring Boot 3.3:**

- **Hỗ trợ Java 21:** Tận dụng các tính năng mới của Java 21 như Virtual Threads (Project Loom), Pattern Matching, và Records.
- **Native Compilation:** Hỗ trợ biên dịch native với GraalVM, giúp khởi động ứng dụng nhanh hơn.
- **Observability:** Tích hợp sẵn Micrometer cho metrics, tracing và logging.
- **Auto-configuration:** Tự động cấu hình các bean dựa trên classpath và dependencies.

Cấu trúc cơ bản của một microservice Spring Boot:

```java
@SpringBootApplication
public class UserServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
    }
}
```

### Spring Cloud

Spring Cloud là tập hợp các công cụ xây dựng trên nền Spring Boot, cung cấp các giải pháp cho các bài toán phổ biến trong kiến trúc Microservices. Hệ sinh thái Spring Cloud được sử dụng trong đồ án bao gồm:

**Eureka Server (Service Discovery):**

Eureka là dịch vụ registry cho phép các microservice đăng ký và tìm kiếm lẫn nhau. Khi một service khởi động, nó đăng ký thông tin (tên, địa chỉ IP, port) vào Eureka Server. Các service khác có thể tra cứu Eureka để biết địa chỉ của service cần gọi.

```java
@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }
}
```

**Config Server (Centralized Configuration):**

Config Server quản lý cấu hình tập trung cho tất cả các microservice. Thay vì mỗi service lưu cấu hình riêng, tất cả được lưu tại một repository Git và phân phối qua Config Server.

**Spring Cloud Gateway (API Gateway):**

API Gateway đóng vai trò là điểm vào duy nhất cho tất cả các yêu cầu từ client. Gateway chịu trách nhiệm định tuyến yêu cầu đến đúng service, xác thực JWT, và quản lý CORS.

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: user-service-route
          uri: lb://user-service
          predicates:
            - Path=/api/v1/auth/**, /api/v1/users/**
          filters:
            - StripPrefix=0
            - Authentication
```

**OpenFeign (Declarative HTTP Client):**

OpenFeign cho phép gọi HTTP giữa các dịch vụ một cách declarative. Thay vì viết code thủ công để gọi REST API, developer chỉ cần khai báo interface với các annotation.

```java
@FeignClient(name = "product-service",
             configuration = FeignClientConfig.class)
public interface ProductServiceClient {
    @GetMapping("/internal/products/{id}")
    ProductDTO getProductById(@PathVariable("id") Long id,
                              @RequestHeader("X-API-KEY") String apiKey);
}
```

## Cơ sở dữ liệu MySQL 8.0

MySQL 8.0 là hệ quản trị cơ sở dữ liệu quan hệ (RDBMS) mã nguồn mở, được sử dụng rộng rãi trong các ứng dụng web. Phiên bản 8.0 mang lại nhiều cải tiến quan trọng.

**Đặc điểm chính của MySQL 8.0:**

- **Window Functions:** Hỗ trợ các hàm phân tích dữ liệu phức tạp như ROW_NUMBER(), RANK(), DENSE_RANK().
- **Common Table Expressions (CTE):** Cho phép viết truy vấn phức tạp dễ đọc hơn với cú pháp WITH.
- **JSON improvements:** Hỗ trợ mạnh mẽ cho kiểu dữ liệu JSON.
- **InnoDB Cluster:** Hỗ trợ clustering với khả năng chịu lỗi cao.
- **Character set utf8mb4:** Hỗ trợ đầy đủ Unicode, bao gồm cả emoji.

Trong đồ án, MySQL 8.0 được sử dụng làm cơ sở dữ liệu chính cho tất cả các business services. Mỗi service có schema riêng trong cùng một database instance, được quản lý bởi Spring Data JPA/Hibernate.

## Hệ thống cache Redis 7

### Khái niệm Redis

Redis (Remote Dictionary Server) là hệ thống lưu trữ dữ liệu dạng key-value trong bộ nhớ (in-memory), thường được sử dụng làm cache, message broker và database. Redis nổi tiếng với tốc độ cực nhanh do dữ liệu được lưu trữ hoàn toàn trong RAM.

**Đặc điểm chính của Redis:**

- **Tốc độ cao:** Có thể xử lý hàng trăm nghìn thao tác đọc/ghi mỗi giây.
- **Kiểu dữ liệu phong phú:** Hỗ trợ String, List, Set, Hash, Sorted Set, Stream, Bitmap.
- **Persistence:** Hỗ trợ lưu dữ liệu ra đĩa với RDB snapshots và AOF (Append Only File).
- **Pub/Sub:** Hỗ trợ mô hình publish/subscribe cho messaging.
- **Cluster:** Hỗ trợ clustering với khả năng sharding tự động.

### Cache-aside pattern

Cache-aside (còn gọi là lazy loading) là chiến lược cache phổ biến nhất, trong đó ứng dụng chịu trách nhiệm quản lý cache. Quy trình hoạt động:

- **Đọc dữ liệu:** Ứng dụng kiểm tra cache trước. Nếu có (cache hit), trả về dữ liệu từ cache. Nếu không có (cache miss), truy vấn database, lưu kết quả vào cache, rồi trả về.
- **Ghi dữ liệu:** Ứng dụng ghi vào database, sau đó xóa (evict) cache để đảm bảo consistency.

Triển khai trong Spring Boot sử dụng annotation:

**Code snippet:** `ProductService` sử dụng `@Cacheable` annotation để tự động cache kết quả query vào Redis. Khi data thay đổi, `@CacheEvict` xóa cache cũ.



![Luồng xử lý Redis Cache](diagrams/redis-cache.png){#fig:redis-cache width=80%}

### Chiến lược TTL

TTL (Time To Live) là thời gian sống của dữ liệu trong cache. Sau khi hết TTL, dữ liệu sẽ bị xóa tự động.

: Cấu hình TTL cho các cache trong hệ thống {#tbl:redis-ttl}

| Cache Name | TTL | Lý do |
|---|---|---|
| productDetail | 10 phút | Dữ liệu sản phẩm thay đổi thường xuyên |
| categories | 1 giờ | Danh mục ít thay đổi, được truy xuất频繁 |

## Spring Security & JWT

### JWT (JSON Web Token)

JWT là một chuẩn mở (RFC 7519) định nghĩa một cách nhỏ gọn, tự chứa để truyền thông tin giữa hai bên dưới dạng đối tượng JSON. Thông tin trong JWT có thể được xác minh và tin cậy vì nó được ký kỹ thuật số.

Cấu trúc của JWT bao gồm ba phần:

- **Header:** Chứa loại token (JWT) và thuật toán ký (HS256, RS256).
- **Payload:** Chứa claims (thông tin) về người dùng (userId, email, role, thời gian hết hạn).
- **Signature:** Chữ ký được tạo từ header + payload + secret key.

**Code snippet:** `JwtUtils` — sinh và validate JWT token bằng HMAC-SHA256. Access token hết hạn 15 phút, refresh token 7 ngày.


### OAuth2 (Google, GitHub)

OAuth2 là giao thức ủy quyền cho phép ứng dụng bên thứ ba truy cập tài nguyên của người dùng mà không cần biết mật khẩu. Trong đồ án, hệ thống hỗ trợ đăng nhập bằng Google và GitHub.

Luồng OAuth2 đăng nhập:

- Người dùng nhấn "Đăng nhập bằng Google" trên frontend.
- Frontend chuyển hướng người dùng đến trang đăng nhập của Google.
- Người dùng xác thực với Google và cấp quyền cho ứng dụng.
- Google chuyển hướng về callback URL với authorization code.
- Backend đổi authorization code lấy access token và lấy thông tin người dùng.
- Backend tạo JWT token và trả về cho frontend.

### API Key cho inter-service communication

Đối với giao tiếp giữa các dịch vụ nội bộ, hệ thống sử dụng API Key thay vì JWT. Mỗi yêu cầu từ service này đến service khác đều phải chứa header `X-API-KEY` với giá trị key được cấu hình sẵn.

**Code snippet:** `ApiKeyAuthFilter` — filter kiểm tra header `X-API-Key` cho inter-service communication, bỏ qua các endpoint public.


## Docker & Docker Compose

Docker là nền tảng containerization cho phép đóng gói ứng dụng cùng tất cả dependencies vào trong một container. Docker Compose là công cụ định nghĩa và chạy nhiều container Docker.

**Lợi ích của Docker trong Microservices:**

- **Nhất quán môi trường:** Container chạy giống nhau trên mọi môi trường (dev, staging, production).
- **Cô lập:** Mỗi service chạy trong container riêng, không xung đột.
- **Dễ triển khai:** Một lệnh docker-compose up có thể khởi động toàn bộ hệ thống.
- **Version control:** Docker image có thể version hóa và rollback dễ dàng.

Cấu hình Dockerfile cho một microservice Spring Boot:

```dockerfile
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## VNPay Payment Gateway

VNPay là cổng thanh toán trực tuyến phổ biến tại Việt Nam, hỗ trợ thanh toán qua thẻ ATM nội địa, thẻ quốc tế (Visa, Mastercard) và ví điện tử.

Luồng thanh toán VNPay trong hệ thống:

- Người dùng chọn phương thức thanh toán VNPay khi đặt hàng.
- Backend tạo URL thanh toán VNPay với các tham số: mã đơn hàng, số tiền, mã ngân hàng.
- Frontend chuyển hướng người dùng đến trang thanh toán VNPay.
- Người dùng xác nhận thanh toán trên VNPay.
- VNPay gọi callback URL về backend để thông báo kết quả.
- Backend cập nhật trạng thái đơn hàng và thanh toán.

## Resilience4j Circuit Breaker

Resilience4j là thư viện lightweight cung cấp các pattern resilience cho ứng dụng Java, bao gồm Circuit Breaker, Rate Limiter, Retry, Bulkhead.

**Circuit Breaker** là pattern bảo vệ hệ thống khi một service bên ngoài gặp lỗi. Nó hoạt động như cầu chì điện: khi tỷ lệ lỗi vượt ngưỡng, circuit sẽ mở (open), ngăn chặn các yêu cầu tiếp theo, tránh tình trạng cascade failure.

Ba trạng thái của Circuit Breaker:

- **Closed:** Bình thường, tất cả yêu cầu được chuyển tiếp.
- **Open:** Ngưỡng lỗi đạt, tất cả yêu cầu bị chặn, trả về fallback.
- **Half-Open:** Cho phép một số lượng nhỏ yêu cầu thử nghiệm để kiểm tra service đã phục hồi chưa.

Cấu hình Circuit Breaker trong Admin Service:

**Code snippet:** `AdminService` sử dụng `@CircuitBreaker` annotation — khi User Service hoặc Product Service fail, fallback method trả về giá trị mặc định thay vì crash.



\newpage


![Sơ đồ trạng thái Circuit Breaker](diagrams/circuit-breaker.png){#fig:circuit-breaker width=70%}

# PHÂN TÍCH & YÊU CẦU HỆ THỐNG

Chương này trình bày quá trình phân tích yêu cầu chức năng và phi chức năng của hệ thống SmartVN. Từ các yêu cầu nghiệp vụ, nhóm tiến hành xác định rõ ràng phạm vi, chức năng và đặc tả kỹ thuật cho từng microservice.

## Yêu cầu chức năng

Hệ thống SmartVN được phân thành 4 microservice chính, mỗi service đảm nhận một nhóm chức năng nghiệp vụ cụ thể.

### User Service

User Service chịu trách nhiệm quản lý toàn bộ thông tin người dùng và xác thực. Các chức năng chính bao gồm:

**Quản lý tài khoản:**

- Đăng ký tài khoản mới với xác thực OTP qua email.
- Đăng nhập bằng email/mật khẩu.
- Đăng nhập bằng OAuth2 (Google, GitHub).
- Làm mới token (refresh token).
- Đăng xuất.
- Quên mật khẩu và đặt lại mật khẩu.

**Quản lý hồ sơ:**

- Xem thông tin cá nhân.
- Cập nhật thông tin cá nhân (tên, số điện thoại, ảnh đại diện).
- Quản lý danh sách địa chỉ giao hàng (thêm, sửa, xóa, đặt mặc định).

**Quản lý người dùng (Admin):**

- Danh sách người dùng với phân trang và tìm kiếm.
- Cấm/bỏ cấm người dùng.
- Thay đổi vai trò người dùng.
- Xem thống kê người dùng.

**Theo dõi tương tác:**

- Ghi nhận hành vi người dùng (xem sản phẩm, thêm vào giỏ hàng).
- Xuất dữ liệu tương tác cho hệ thống gợi ý AI.

: Các endpoint của User Service {#tbl:user-api}

| Method | Endpoint | Mô tả | Auth |
|---|---|---|---|
| POST | /api/v1/auth/register | Đăng ký | No |
| POST | /api/v1/auth/login | Đăng nhập | No |
| POST | /api/v1/auth/refresh | Làm mới token | Cookie |
| POST | /api/v1/auth/logout | Đăng xuất | JWT |
| GET | /api/v1/users/me | Thông tin cá nhân | JWT |
| PUT | /api/v1/users/me | Cập nhật thông tin | JWT |
| GET | /api/v1/users/{id} | Xem thông tin user | JWT |
| GET | /api/v1/users | Danh sách user | Admin JWT |
| PUT | /api/v1/users/{id}/status | Cấm/bỏ cấm | Admin JWT |
| POST | /api/v1/users/me/addresses | Thêm địa chỉ | JWT |
| PUT | /api/v1/users/me/addresses/{id} | Sửa địa chỉ | JWT |
| DELETE | /api/v1/users/me/addresses/{id} | Xóa địa chỉ | JWT |
| POST | /api/v1/interactions | Ghi nhận tương tác | JWT |

### Product Service

Product Service quản lý toàn bộ thông tin sản phẩm, danh mục, tồn kho, đánh giá và hình ảnh. Đây là service có lưu lượng truy cập cao nhất trong hệ thống, được áp dụng cơ chế cache Redis.

**Quản lý sản phẩm:**

- Danh sách sản phẩm với phân trang, lọc theo danh mục, giá, thương hiệu.
- Chi tiết sản phẩm (có cache Redis).
- Tìm kiếm sản phẩm theo từ khóa.
- Sản phẩm nổi bật, sản phẩm bán chạy.

**Quản lý danh mục:**

- Danh sách danh mục (có cache Redis, TTL 1 giờ).
- Danh mục theo cấp bậc (parent-child).
- Chi tiết danh mục.

**Quản lý tồn kho:**

- Xem tồn kho theo size, màu sắc.
- Cập nhật số lượng tồn kho.
- Kiểm tra tồn kho khi đặt hàng.

**Quản lý đánh giá:**

- Xem đánh giá của sản phẩm.
- Thêm đánh giá (chỉ người đã mua).
- Tính điểm trung bình.

: Các endpoint của Product Service {#tbl:product-api}

| Method | Endpoint | Mô tả | Auth |
|---|---|---|---|
| GET | /api/v1/products | Danh sách sản phẩm | JWT |
| GET | /api/v1/products/{id} | Chi tiết sản phẩm | JWT |
| POST | /api/v1/products | Tạo sản phẩm | Admin JWT |
| PUT | /api/v1/products/{id} | Cập nhật sản phẩm | Admin JWT |
| DELETE | /api/v1/products/{id} | Xóa sản phẩm | Admin JWT |
| GET | /api/v1/categories | Danh sách danh mục | JWT |
| GET | /api/v1/categories/{id} | Chi tiết danh mục | JWT |
| POST | /api/v1/reviews | Thêm đánh giá | JWT |
| GET | /api/v1/reviews/product/{id} | Đánh giá sản phẩm | JWT |
| GET | /api/v1/products/{id}/inventory | Tồn kho sản phẩm | JWT |

### Order Service

Order Service quản lý giỏ hàng, đơn hàng và thanh toán. Service này tích hợp cổng thanh toán VNPay.

**Quản lý giỏ hàng:**

- Xem giỏ hàng.
- Thêm sản phẩm vào giỏ hàng.
- Cập nhật số lượng sản phẩm trong giỏ.
- Xóa sản phẩm khỏi giỏ hàng.
- Kiểm tra tồn kho trước khi thêm.

**Quản lý đơn hàng:**

- Tạo đơn hàng từ giỏ hàng.
- Danh sách đơn hàng của người dùng.
- Chi tiết đơn hàng.
- Hủy đơn hàng.
- Cập nhật trạng thái đơn hàng (Admin).

**Thanh toán:**

- Tạo URL thanh toán VNPay.
- Xử lý callback từ VNPay.
- Kiểm tra trạng thái thanh toán.

: Các endpoint của Order Service {#tbl:order-api}

| Method | Endpoint | Mô tả | Auth |
|---|---|---|---|
| GET | /api/v1/cart | Xem giỏ hàng | JWT |
| POST | /api/v1/cart/items | Thêm vào giỏ | JWT |
| PUT | /api/v1/cart/items/{id} | Cập nhật giỏ | JWT |
| DELETE | /api/v1/cart/items/{id} | Xóa khỏi giỏ | JWT |
| POST | /api/v1/orders | Tạo đơn hàng | JWT |
| GET | /api/v1/orders | Danh sách đơn hàng | JWT |
| GET | /api/v1/orders/{id} | Chi tiết đơn hàng | JWT |
| PATCH | /api/v1/orders/{id}/cancel | Hủy đơn hàng | JWT |
| POST | /api/v1/payment/vnpay/create | Tạo thanh toán | JWT |
| GET | /api/v1/payment/vnpay/callback | Callback VNPay | No |

### Admin Service

Admin Service tổng hợp dữ liệu từ tất cả các service khác để cung cấp dashboard quản trị. Service này sử dụng Circuit Breaker để đảm bảo tính bền vững khi gọi các service khác.

**Dashboard:**

- Tổng quan doanh thu, đơn hàng, người dùng, sản phẩm.
- Biểu đồ doanh thu theo thời gian.
- Top sản phẩm bán chạy.

**Quản lý người dùng:**

- Gọi User Service để lấy danh sách, thống kê người dùng.

**Quản lý sản phẩm:**

- Gọi Product Service để quản lý sản phẩm, danh mục.

**Quản lý đơn hàng:**

- Gọi Order Service để quản lý đơn hàng, doanh thu.

**Xuất dữ liệu AI:**

- Xuất danh sách sản phẩm cho hệ thống gợi ý.
- Xuất dữ liệu tương tác người dùng.
- Xuất dữ liệu đơn hàng cho training model.

: Các endpoint của Admin Service {#tbl:admin-api}

| Method | Endpoint | Mô tả | Auth |
|---|---|---|---|
| GET | /api/v1/admin/dashboard | Dashboard tổng quan | Admin JWT |
| GET | /api/v1/admin/users/stats | Thống kê user | Admin JWT |
| GET | /api/v1/admin/products/stats | Thống kê sản phẩm | Admin JWT |
| GET | /api/v1/admin/orders/stats | Thống kê đơn hàng | Admin JWT |
| GET | /api/v1/admin/orders/revenue | Doanh thu | Admin JWT |
| GET | /api/v1/internal/admin/export/products | Xuất sản phẩm | API Key |
| GET | /api/v1/internal/admin/export/interactions | Xuất tương tác | API Key |
| GET | /api/v1/internal/admin/export/orders | Xuất đơn hàng | API Key |

## Yêu cầu phi chức năng

Ngoài các yêu cầu chức năng, hệ thống cần đáp ứng các yêu cầu phi chức năng quan trọng sau:

: Yêu cầu phi chức năng của hệ thống {#tbl:nfr}

| Tiêu chí | Yêu cầu | Giải pháp |
|---|---|---|
| Hiệu năng | Thời gian phản hồi < 200ms cho 95% request | Redis caching, connection pooling |
| Khả năng mở rộng | Hỗ trợ 100+ VU đồng thời | Microservices, horizontal scaling |
| Tính sẵn sàng | 99.5% uptime | Circuit Breaker, health checks |
| Bảo mật | Bảo vệ JWT, CORS, API Key | Spring Security, HTTPS |
| Khả năng duy trì | Code sạch, tài liệu đầy đủ | Clean code, Swagger docs |
| Khả năng kiểm thử | Test coverage > 70% | Unit test, integration test |
| Monitoring | Theo dõi health các service | Actuator, Eureka dashboard |

## Use Case tổng quan

Hệ thống có 3 loại actor chính:

**Actor 1 — Khách hàng (Customer):**

- Đăng ký/đăng nhập tài khoản.
- Duyệt và tìm kiếm sản phẩm.
- Xem chi tiết sản phẩm.
- Thêm sản phẩm vào giỏ hàng.
- Đặt hàng và thanh toán.
- Xem lịch sử đơn hàng.
- Đánh giá sản phẩm đã mua.
- Quản lý địa chỉ giao hàng.

**Actor 2 — Quản trị viên (Admin):**

- Xem dashboard tổng quan.
- Quản lý sản phẩm (CRUD).
- Quản lý danh mục.
- Quản lý đơn hàng (xem, cập nhật trạng thái).
- Quản lý người dùng (xem, cấm/bỏ cấm).
- Xem thống kê doanh thu.

**Actor 3 — Hệ thống (System):**

- Xác thực JWT khi có yêu cầu API.
- Cache dữ liệu sản phẩm với Redis.
- Gửi OTP qua email khi đăng ký.
- Xử lý callback thanh toán từ VNPay.
- Ghi nhận tương tác người dùng.
- Circuit Breaker bảo vệ khi service lỗi.

: Bảng tổng hợp Use Case {#tbl:usecase}

| ID | Use Case | Actor | Mô tả tóm tắt |
|---|---|---|---|
| UC01 | Đăng ký tài khoản | Customer | Đăng ký với email, xác thực OTP |
| UC02 | Đăng nhập | Customer/Admin | Email/password hoặc OAuth2 |
| UC03 | Duyệt sản phẩm | Customer | Xem danh sách, lọc, tìm kiếm |
| UC04 | Xem chi tiết sản phẩm | Customer | Thông tin đầy đủ, đánh giá |
| UC05 | Quản lý giỏ hàng | Customer | Thêm, sửa, xóa sản phẩm |
| UC06 | Đặt hàng | Customer | Tạo đơn từ giỏ hàng |
| UC07 | Thanh toán VNPay | Customer | Chuyển hướng đến VNPay |
| UC08 | Xem đơn hàng | Customer | Danh sách và chi tiết |
| UC09 | Đánh giá sản phẩm | Customer | Rate và comment |
| UC10 | Xem dashboard | Admin | Tổng quan hệ thống |
| UC11 | Quản lý sản phẩm | Admin | CRUD sản phẩm |
| UC12 | Quản lý đơn hàng | Admin | Xem, cập nhật trạng thái |
| UC13 | Quản lý người dùng | Admin | Xem, cấm/bỏ cấm |


\newpage

# THIẾT KẾ HỆ THỐNG

Chương này trình bày chi tiết quá trình thiết kế hệ thống SmartVN, bao gồm kiến trúc tổng thể, thiết kế cơ sở dữ liệu, thiết kế API Gateway, thiết kế từng microservice, và cơ chế giao tiếp liên dịch vụ.

## Kiến trúc tổng thể

### Sơ đồ kiến trúc

![Sơ đồ kiến trúc Microservices SmartVN](diagrams/architecture.png){#fig:arch-diagram width=95%}

Hệ thống SmartVN được thiết kế theo kiến trúc Microservices với nhiều tầng (layer) phân tách rõ ràng.

![Sơ đồ kiến trúc tổng thể hệ thống SmartVN](images/kien-truc-tong-the.png){#fig:kien-truc width=90%}

Như thể hiện trong @fig:kien-truc, hệ thống bao gồm các tầng chính:

**Tầng Client:**

- **Mobile App (Android/Java):** Ứng dụng di động native cho khách hàng — thành phần chính của hệ thống, được phát triển bằng Java trên Android SDK với kiến trúc MVVM.
- Customer Frontend (React, port 5173): Giao diện web cho khách hàng.
- Admin Frontend (React, port 5174): Giao diện quản trị cho admin.

**Tầng Entry (API Gateway):**

- API Gateway (Spring Cloud Gateway, port 8080): Điểm vào duy nhất, xử lý routing, JWT validation, CORS.

**Tầng Infrastructure:**

- Eureka Server (port 8761): Service discovery và registry.
- Config Server (port 8888): Quản lý cấu hình tập trung.

**Tầng Business Services:**

- User Service (port 8081): Quản lý người dùng, xác thực.
- Product Service (port 8082): Quản lý sản phẩm, cache.
- Order Service (port 8083): Quản lý đơn hàng, thanh toán.
- Admin Service (port 8084): Quản trị, dashboard.

**Tầng Data:**

- MySQL 8.0 (port 3306): Cơ sở dữ liệu chính.
- Redis 7 (port 6379): Bộ nhớ đệm.

### Luồng dữ liệu

Luồng dữ liệu trong hệ thống tuân theo mô hình request-response qua API Gateway.

**Luồng đọc sản phẩm (cache hit):**

- Client gửi GET /api/v1/products/5 với JWT token.
- API Gateway xác thực JWT, trích xuất userId, chuyển tiếp yêu cầu với header X-User-Id.
- Product Service kiểm tra cache Redis với key "productDetail::5".
- Cache hit → trả về dữ liệu từ Redis (không cần query database).
- Response quay ngược lại: Product Service → Gateway → Client.

**Luồng đọc sản phẩm (cache miss):**

- Tương tự bước 1-3.
- Cache miss → Product Service query MySQL.
- Lưu kết quả vào Redis cache với TTL 10 phút.
- Trả về dữ liệu cho client.

**Luồng đặt hàng:**

- Client gửi POST /api/v1/orders với thông tin giỏ hàng.
- Gateway chuyển tiếp đến Order Service.
- Order Service gọi Product Service (qua Feign) để kiểm tra tồn kho.
- Order Service gọi User Service (qua Feign) để lấy địa chỉ giao hàng.
- Tạo đơn hàng trong database.
- Trả về thông tin đơn hàng.

## Thiết kế cơ sở dữ liệu

### ER Diagram

Cơ sở dữ liệu hệ thống SmartVN được thiết kế theo mô hình quan hệ, bao gồm các bảng chính phục vụ cho 4 microservice.

![Sơ đồ ERD hệ thống SmartVN](diagrams/erd.png){#fig:er-diagram width=95%}

### Chi tiết các bảng

**Bảng user:**

: Cấu trúc bảng user {#tbl:user-schema}

| Cột | Kiểu dữ liệu | Khóa | Mô tả |
|---|---|---|---|
| id | BIGINT | PK | Mã người dùng |
| email | VARCHAR(255) | UNIQUE | Email đăng nhập |
| password | VARCHAR(255) | | Mật khẩu đã mã hóa |
| first_name | VARCHAR(100) | | Tên |
| last_name | VARCHAR(100) | | Họ |
| phone | VARCHAR(20) | | Số điện thoại |
| avatar_url | VARCHAR(500) | | URL ảnh đại diện |
| is_active | BOOLEAN | | Trạng thái hoạt động |
| is_banned | BOOLEAN | | Trạng thái cấm |
| warning_count | INT | | Số lần cảnh cáo |
| oauth_provider | VARCHAR(50) | | Nhà cung cấp OAuth |
| oauth_id | VARCHAR(255) | | ID OAuth |
| created_at | DATETIME | | Thời gian tạo |
| updated_at | DATETIME | | Thời gian cập nhật |

**Bảng product:**

: Cấu trúc bảng product {#tbl:product-schema}

| Cột | Kiểu dữ liệu | Khóa | Mô tả |
|---|---|---|---|
| id | BIGINT | PK | Mã sản phẩm |
| category_id | BIGINT | FK | Mã danh mục |
| title | VARCHAR(500) | | Tên sản phẩm |
| brand | VARCHAR(200) | | Thương hiệu |
| description | TEXT | | Mô tả sản phẩm |
| is_active | BOOLEAN | | Trạng thái hiển thị |
| average_rating | DOUBLE | | Điểm đánh giá TB |
| quantity_sold | BIGINT | | Số lượng đã bán |

**Bảng category:**

: Cấu trúc bảng category {#tbl:category-schema}

| Cột | Kiểu dữ liệu | Khóa | Mô tả |
|---|---|---|---|
| id | BIGINT | PK | Mã danh mục |
| parent_category_id | BIGINT | FK | Danh mục cha |
| name | VARCHAR(200) | | Tên danh mục |
| level | INT | | Cấp độ (1, 2, 3) |

**Bảng inventory:**

: Cấu trúc bảng inventory {#tbl:inventory-schema}

| Cột | Kiểu dữ liệu | Khóa | Mô tả |
|---|---|---|---|
| id | BIGINT | PK | Mã tồn kho |
| product_id | BIGINT | FK | Mã sản phẩm |
| size | VARCHAR(10) | | Size (S, M, L, XL) |
| quantity | INT | | Số lượng tồn |
| price | DECIMAL(15,2) | | Giá gốc |
| discount_percent | INT | | Phần trăm giảm giá |
| discounted_price | DECIMAL(15,2) | | Giá sau giảm |

**Bảng order:**

: Cấu trúc bảng order {#tbl:order-schema}

| Cột | Kiểu dữ liệu | Khóa | Mô tả |
|---|---|---|---|
| id | BIGINT | PK | Mã đơn hàng |
| user_id | BIGINT | FK | Mã người đặt |
| shipping_address_id | BIGINT | FK | Địa chỉ giao hàng |
| order_status | VARCHAR(50) | | Trạng thái đơn hàng |
| payment_status | VARCHAR(50) | | Trạng thái thanh toán |
| total_price | DECIMAL(15,2) | | Tổng tiền |
| created_at | DATETIME | | Thời gian tạo |

**Bảng order_item:**

: Cấu trúc bảng order_item {#tbl:order-item-schema}

| Cột | Kiểu dữ liệu | Khóa | Mô tả |
|---|---|---|---|
| id | BIGINT | PK | Mã chi tiết đơn |
| order_id | BIGINT | FK | Mã đơn hàng |
| product_id | BIGINT | FK | Mã sản phẩm |
| size | VARCHAR(10) | | Size sản phẩm |
| quantity | INT | | Số lượng |
| price | DECIMAL(15,2) | | Đơn giá |

**Bảng payment_detail:**

: Cấu trúc bảng payment_detail {#tbl:payment-schema}

| Cột | Kiểu dữ liệu | Khóa | Mô tả |
|---|---|---|---|
| id | BIGINT | PK | Mã thanh toán |
| order_id | BIGINT | FK | Mã đơn hàng |
| payment_method | VARCHAR(50) | | Phương thức TT |
| payment_status | VARCHAR(50) | | Trạng thái TT |
| transaction_id | VARCHAR(255) | | Mã giao dịch |
| amount | DECIMAL(15,2) | | Số tiền |

**Bảng user_interaction:**

: Cấu trúc bảng user_interaction {#tbl:interaction-schema}

| Cột | Kiểu dữ liệu | Khóa | Mô tả |
|---|---|---|---|
| id | BIGINT | PK | Mã tương tác |
| user_id | BIGINT | FK | Mã người dùng |
| product_id | BIGINT | FK | Mã sản phẩm |
| interaction_type | VARCHAR(20) | | Loại tương tác |
| weight | FLOAT | | Trọng số |
| created_at | DATETIME | | Thời gian tạo |

Trọng số tương tác: VIEW/CLICK = 1.0, ADD_TO_CART = 2.0, PURCHASE = 3.0.

## Thiết kế API Gateway

### Routing configuration

API Gateway được cấu hình với Spring Cloud Gateway, sử dụng service discovery (lb://) để định tuyến yêu cầu đến các microservice phù hợp.

Cấu hình routing trong `application.yml`:

**Code snippet:** Gateway routing config — mỗi route định nghĩa URI đích, predicates (path matching), và filters (JWT validation, header injection).


### JWT Authentication filter

Gateway implements custom Authentication filter để xác thực JWT trước khi chuyển tiếp yêu cầu đến service đích.

**Code snippet:** Custom `AuthenticationGatewayFilterFactory` — validate JWT token trước khi chuyển request đến downstream service. Trả 401 nếu token invalid.


### CORS configuration

CORS được cấu hình tại Gateway để frontend có thể gọi API từ domain khác:

**Code snippet:** CORS configuration cho Gateway — cho phép origins cụ thể, methods GET/POST/PUT/DELETE, và credentials.


## Thiết kế các Microservices

### User Service

User Service được thiết kế theo mô hình Layered Architecture với các tầng: Controller → Service → Repository → Database.

**Cấu trúc package:**

```
user-service/
├── controller/
│   ├── AuthController.java
│   ├── UserController.java
│   └── AddressController.java
├── service/
│   ├── AuthService.java
│   ├── UserService.java
│   └── AddressService.java
├── repository/
│   ├── UserRepository.java
│   ├── RoleRepository.java
│   └── AddressRepository.java
├── model/
│   ├── User.java
│   ├── Role.java
│   └── Address.java
├── dto/
│   ├── request/
│   └── response/
├── config/
│   ├── SecurityConfig.java
│   └── OAuth2Config.java
└── exceptions/
    ├── GlobalExceptionHandler.java
    └── AppException.java
```

**Entity User:**

**Code snippet:** `User` entity với JPA annotations — `@Entity`, `@Table`, `@GeneratedValue` cho auto-increment ID. Các field: name, email, password (BCrypt encoded), phone, role.


### Product Service (với Redis caching)

Product Service là service có lưu lượng cao nhất, được áp dụng chiến lược caching toàn diện.

**Cache configuration:**

- `productDetail`: Cache chi tiết sản phẩm, TTL 10 phút.
- `categories`: Cache danh mục, TTL 1 giờ.
- Serialization: `GenericJackson2JsonRedisSerializer` với `JavaTimeModule`.
- Cache-aside pattern với auto-eviction on write.

**ProductService với caching:**

**Code snippet:** `ProductService` — xử lý CRUD sản phẩm với pagination, search, và category filter. Sử dụng `Specification` pattern cho dynamic queries.


### Order Service (với VNPay)

Order Service quản lý toàn bộ quy trình đặt hàng và thanh toán.

**Order lifecycle:**

Đơn hàng trong hệ thống trải qua các trạng thái:

![Sơ đồ trạng thái đơn hàng](images/order-lifecycle.png){#fig:order-lifecycle width=80%}

- **PENDING:** Đơn hàng mới tạo, chờ xử lý.
- **CONFIRMED:** Đơn hàng đã được xác nhận.
- **SHIPPING:** Đơn hàng đang được giao.
- **DELIVERED:** Đơn hàng đã giao thành công.
- **CANCELLED:** Đơn hàng đã bị hủy.

### Admin Service (với Circuit Breaker)

Admin Service tổng hợp dữ liệu từ tất cả service khác. Để đảm bảo tính bền vững, service sử dụng Resilience4j Circuit Breaker cho mọi cuộc gọi đi.

**Dashboard aggregation với Circuit Breaker:**

**Code snippet:** `DashboardService` — aggregate thống kê từ nhiều service (User, Product, Order) thông qua Feign clients với Circuit Breaker.


## Thiết kế Communication giữa các Service

### OpenFeign Clients

Tất cả giao tiếp liên dịch vụ sử dụng OpenFeign với cấu hình chung.

**FeignClientConfig:**

```java
public class FeignClientConfig implements RequestInterceptor {

    @Value("${internal.api.key}")
    private String apiKey;

    @Override
    public void apply(RequestTemplate template) {
        template.header("X-API-KEY", apiKey);
        template.header("Content-Type", "application/json");
    }
}
```

**UserServiceClient (trong Order Service):**

**Code snippet:** `UserClient` — Feign client để gọi User Service từ Admin Service, với fallback class xử lý khi service down.


### Fallback strategies

Mỗi Feign Client đều có fallback để xử lý khi service đích gặp lỗi.

**Code snippet:** `UserServiceFallback` — implement fallback methods trả về giá trị mặc định khi User Service không khả dụng.


## Thiết kế hệ thống cache Redis

### Cache configuration

Hệ thống cache Redis được thiết kế với các nguyên tắc:

- **Cache-aside pattern:** Application quản lý cache, không phải database.
- **TTL hợp lý:** Dữ liệu thường xuyên thay đổi có TTL ngắn.
- **Serialization hiệu quả:** Sử dụng JSON serializer để có thể debug dễ dàng.
- **Null-safe:** Không cache giá trị null.

**RedisConfig chi tiết:**

**Code snippet:** `RedisConfig` — cấu hình Redis Template với JSON serializer, TTL strategy, và cache key generator.


### Cache eviction strategy

Chiến lược xóa cache trong hệ thống:

: Chiến lược cache eviction {#tbl:cache-eviction}

| Sự kiện | Cache bị ảnh hưởng | Hành động |
|---|---|---|
| Cập nhật sản phẩm | productDetail::{id} | @CacheEvict |
| Cập nhật danh mục | categories | @CacheEvict all |
| Hết TTL | Tự động | Redis tự xóa |
| Restart Redis | Tất cả | Mất toàn bộ cache |

Hệ thống sử dụng kết hợp TTL-based eviction (tự động hết hạn) và event-based eviction (xóa khi dữ liệu thay đổi) để đảm bảo tính fresh của dữ liệu.


\newpage

# HIỆN THỰC HỆ THỐNG

Chương này trình bày quá trình triển khai và hiện thực hóa hệ thống SmartVN, bao gồm cấu hình Docker Compose, cài đặt từng microservice, triển khai frontend và demo các chức năng chính.

## Triển khai với Docker Compose

### Cấu hình các container

Toàn bộ hệ thống được đóng gói và triển khai bằng Docker Compose. File `docker-compose.yml` định nghĩa 9 services, 1 network bridge và 1 volume persistent.

: Danh sách các Docker container {#tbl:docker-containers}

| Container | Image | Port | Depends On |
|---|---|---|---|
| techshop-mysql | mysql:8.0 | 3306 | — |
| techshop-redis | redis:7-alpine | 6379 | — |
| discovery-service | eureka-server | 8761 | — |
| config-server | config-server | 8888 | discovery-service |
| user-service | user-service | 8081 | mysql-db, discovery, config |
| product-service | product-service | 8082 | mysql-db, discovery, config, redis |
| order-service | order-service | 8083 | mysql-db, discovery, config, user, product |
| admin-service | admin-service | 8084 | mysql-db, discovery, config, user, product, order |
| api-gateway | api-gateway | 8080 | discovery, config, all services |
| customer-frontend | smartvn-frontend | 5173 | — |
| admin-frontend | admin-smartVN | 5174 | — |

### Health checks & dependency ordering

Mỗi service đều được cấu hình health check để Docker Compose có thể xác định trạng thái sẵn sàng trước khi khởi động service phụ thuộc.

**Health check cho MySQL:**

```yaml
mysql-db:
  image: mysql:8.0
  healthcheck:
    test: ["CMD", "mysqladmin", "ping", "-h", "localhost",
           "-u", "root", "-prootpassword"]
    interval: 10s
    timeout: 5s
    retries: 10
    start_period: 30s
```

**Health check cho Spring Boot services:**

```yaml
user-service:
  healthcheck:
    test: ["CMD", "wget", "--no-verbose", "--tries=1",
           "--spider", "http://localhost:8081/actuator/health"]
    interval: 10s
    timeout: 5s
    retries: 10
    start_period: 30s
```

### Service start order

Thứ tự khởi động của hệ thống được quản lý tự động bởi Docker Compose:

- **Giai đoạn 1:** MySQL + Redis (database và cache).
- **Giai đoạn 2:** Eureka Server (service discovery).
- **Giai đoạn 3:** Config Server (cấu hình tập trung).
- **Giai đoạn 4:** User Service → Product Service → Order Service → Admin Service.
- **Giai đoạn 5:** API Gateway (entry point).
- **Giai đoạn 6:** Customer Frontend + Admin Frontend.

Lệnh khởi động toàn bộ hệ thống:

```bash
git clone https://github.com/simasangggg/smartvn-microservices.git
cd smartvn-microservices
export GIT_SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)"
docker compose up -d
docker compose logs -f api-gateway
docker compose ps
```

## Cài đặt & cấu hình

### Eureka Server

Eureka Server là dịch vụ registry đầu tiên cần khởi động.

```java
@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(
            EurekaServerApplication.class, args);
    }
}
```

Cấu hình `application.yml`:

```yaml
server:
  port: 8761

spring:
  application:
    name: discovery-service

eureka:
  client:
    register-with-eureka: false
    fetch-registry: false
  server:
    enable-self-preservation: true
```

### Config Server

Config Server quản lý cấu hình tập trung từ Git repository.

```java
@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(
            ConfigServerApplication.class, args);
    }
}
```

### API Gateway

API Gateway là điểm vào duy nhất, xử lý routing, JWT validation và CORS.

**SecurityConfig:**

**Code snippet:** Security Config cho Gateway — `SecurityWebFilterChain` với CSRF disabled, CORS enabled, tất cả request đều permit (JWT validation ở filter).


### User Service

User Service xử lý xác thực và quản lý người dùng.

**SecurityConfig cho User Service:**

**Code snippet:** Security Config cho Business Services — `SecurityFilterChain` với JWT authentication filter, role-based access control.


### Product Service (với Redis caching)

Product Service tích hợp Redis cache để cải thiện hiệu năng.

**Code snippet:** Redis Config nâng cao — `RedisCacheManager` với custom TTL cho từng cache name, JSON serializer thay vì JDK serialization.


### Order Service

Order Service tích hợp VNPay payment gateway.

**PaymentService:**

**Code snippet:** `PaymentService` — tạo VNPay payment URL với hash SHA512, xử lý callback response, cập nhật trạng thái đơn hàng.


### Admin Service

Admin Service sử dụng Circuit Breaker cho tất cả cuộc gọi đi.

**Code snippet:** Resilience4j config — sliding window 10 calls, failure rate threshold 50%, wait duration 10s ở trạng thái Open.


## Triển khai Frontend

### Customer Frontend (React)

Customer Frontend là ứng dụng React được build và deploy qua Docker.

**Dockerfile:**

```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**nginx.conf:**

```nginx
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://api-gateway:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Demo hệ thống

### Đăng ký/Đăng nhập

![Giao diện đăng ký tài khoản](images/demo-register.png){#fig:demo-register width=80%}

Quy trình đăng ký:

- Người dùng nhập email, mật khẩu, họ tên.
- Hệ thống gửi OTP đến email.
- Người dùng nhập OTP để xác thực.
- Tài khoản được tạo thành công.

Hỗ trợ 3 phương thức đăng nhập:

- Email + Mật khẩu.
- Đăng nhập bằng Google (OAuth2).
- Đăng nhập bằng GitHub (OAuth2).

### Duyệt sản phẩm

![Giao diện danh sách sản phẩm](images/demo-products.png){#fig:demo-products width=80%}

Trang sản phẩm hỗ trợ:

- Hiển thị danh sách sản phẩm với phân trang.
- Lọc theo danh mục, khoảng giá, thương hiệu.
- Sắp xếp theo giá, độ phổ biến, đánh giá.
- Tìm kiếm theo từ khóa.

### Giỏ hàng & Đặt hàng

![Giao diện giỏ hàng](images/demo-cart.png){#fig:demo-cart width=80%}

Quy trình đặt hàng:

- Người dùng thêm sản phẩm vào giỏ hàng.
- Kiểm tra tồn kho tự động.
- Chọn địa chỉ giao hàng.
- Xác nhận đơn hàng.
- Chọn phương thức thanh toán.

### Thanh toán VNPay

![Giao diện thanh toán VNPay](images/demo-vnpay.png){#fig:demo-vnpay width=85%}

Quy trình thanh toán:

- Người dùng chọn "Thanh toán qua VNPay".
- Backend tạo URL thanh toán VNPay.
- Frontend chuyển hướng đến VNPay.
- Người dùng chọn ngân hàng và xác nhận.
- VNPay callback về backend.
- Backend cập nhật trạng thái đơn hàng.

### Admin Dashboard

![Giao diện Admin Dashboard](images/demo-dashboard.png){#fig:demo-dashboard width=85%}

Dashboard cung cấp cái nhìn tổng quan về hệ thống:

- Thống kê tổng quan: tổng người dùng, sản phẩm, đơn hàng, doanh thu.
- Biểu đồ doanh thu theo thời gian.
- Top sản phẩm bán chạy.
- Đơn hàng gần đây.
- Trạng thái các service (healthy/unhealthy).


\newpage



# CHƯƠNG 5: ỨNG DỤNG MOBILE — ANDROID CLIENT

## 5.1 Giới thiệu tổng quan

Ứng dụng mobile SmartVN là thành phần trung tâm trong hệ thống thương mại điện tử, đóng vai trò là cầu nối trực tiếp giữa người dùng và hệ thống backend microservices. Được phát triển bằng ngôn ngữ Java trên nền tảng Android SDK, ứng dụng cung cấp trải nghiệm mua sắm liền mạch, tối ưu cho thiết bị di động.

Trong kiến trúc Microservices của SmartVN, ứng dụng mobile hoạt động ở tầng Client cùng với các ứng dụng frontend web. Tuy nhiên, mobile client có những đặc điểm riêng biệt:

- **Trải nghiệm native:** Tận dụng đầy đủ khả năng phần cứng của thiết bị di động như camera, GPS, cảm biến vân tay, và hệ thống thông báo đẩy.
- **Khả năng hoạt động ngoại tuyến:** Lưu trữ dữ liệu cục bộ cho phép người dùng xem sản phẩm đã lưu trữ ngay cả khi mất kết nối mạng.
- **Hiệu năng tối ưu:** Sử dụng các thành phần Android gốc, không qua lớp trung gian như WebView, đảm bảo trải nghiệm mượt mà.
- **Thông báo đẩy:** Nhận thông báo về trạng thái đơn hàng, khuyến mãi theo thời gian thực.

### 5.1.1 Phạm vi chức năng

Ứng dụng mobile SmartVN cung cấp đầy đủ các chức năng nghiệp vụ cho người dùng cuối:

- Đăng ký và đăng nhập (hỗ trợ xác thực qua Google).
- Duyệt sản phẩm theo danh mục, tìm kiếm, lọc theo giá và đánh giá.
- Xem chi tiết sản phẩm với hình ảnh, mô tả, đánh giá từ người dùng khác.
- Quản lý giỏ hàng (thêm, sửa số lượng, xóa sản phẩm).
- Đặt hàng và chọn địa chỉ giao hàng.
- Thanh toán trực tuyến qua cổng VNPay.
- Theo dõi trạng thái đơn hàng và lịch sử mua hàng.
- Quản lý tài khoản cá nhân (cập nhật thông tin, đổi mật khẩu, quản lý địa chỉ).

### 5.1.2 Mục tiêu phát triển

- Xây dựng ứng dụng Android native với kiến trúc MVVM, đảm bảo tính maintainability và scalability.
- Tích hợp đầy đủ với hệ thống backend microservices thông qua API Gateway.
- Cung cấp trải nghiệm người dùng mượt mà, tuân thủ nguyên tắc Material Design 3.
- Hỗ trợ chế độ ngoại tuyến (offline-first) cho các thao tác xem sản phẩm và quản lý giỏ hàng.
- Đảm bảo bảo mật với xác thực JWT và cơ chế refresh token tự động.

## 5.2 Phương pháp phát triển

### 5.2.1 Phương pháp nghiên cứu lý thuyết

- Nghiên cứu kiến trúc MVVM (Model-View-ViewModel) và các nguyên tắc thiết kế Android hiện đại.
- Tìm hiểu về các thư viện Retrofit 2, Room Database, LiveData, ViewModel trong hệ sinh thái Android.
- Nghiên cứu nguyên tắc Material Design 3 của Google.
- Tham khảo tài liệu chính thức của Android Developers và các best practices.

### 5.2.2 Phương pháp nghiên cứu thực nghiệm

- Thiết kế giao diện người dùng theo nguyên tắc UX mobile.
- Xây dựng prototype và kiểm thử trên nhiều kích thước màn hình.
- Tích hợp với backend API và kiểm thử luồng dữ liệu end-to-end.
- Đánh giá hiệu năng và trải nghiệm người dùng trên thiết bị thật.

## 5.3 Đóng góp của đề tài

### 5.3.1 Về mặt kỹ thuật

- Triển khai thành công kiến trúc MVVM với Android Architecture Components.
- Xây dựng cơ chế cache-first với NetworkBoundResource, kết hợp giữa Room Database và Retrofit.
- Thiết kế hệ thống xác thực JWT với khả năng refresh token tự động.
- Tích hợp thanh toán VNPay thông qua Chrome Custom Tab.

### 5.3.2 Về mặt thực tiễn

- Cung cấp ứng dụng mua sắm hoàn chỉnh trên nền tảng di động.
- Nâng cao trải nghiệm người dùng với giao diện Material Design 3 hiện đại.
- Hỗ trợ người dùng mua sắm mọi lúc, mọi nơi thông qua thiết bị di động.

## 5.4 Nội dung chương

Chương này trình bày toàn bộ quá trình phát triển ứng dụng mobile SmartVN, bao gồm:

- Phần 5: Giới thiệu tổng quan, mục tiêu và phạm vi ứng dụng.
- Phần 6: Cơ sở lý thuyết và công nghệ sử dụng (MVVM, Retrofit, Room, Material Design 3).
- Phần 7: Phân tích và thiết kế (Use Case, Sequence Diagram, thiết kế giao diện, cơ sở dữ liệu cục bộ).
- Phần 8: Xây dựng ứng dụng (giao diện các màn hình, tích hợp API, xử lý ngoại lệ).
# CHƯƠNG 6: CƠ SỞ LÝ THUYẾT VÀ CÔNG NGHỆ MOBILE

## 6.1 Kiến trúc MVVM (Model-View-ViewModel)

### 6.1.1 Giới thiệu

MVVM là mô hình kiến trúc phần mềm được Google khuyến nghị cho phát triển ứng dụng Android hiện đại. Mô hình này tách biệt rõ ràng ba tầng: Model (quản lý dữ liệu), View (hiển thị giao diện), và ViewModel (cầu nối logic giữa hai tầng). Việc tách biệt này giúp mã nguồn dễ bảo trì, dễ kiểm thử và giảm thiểu các lỗi liên quan đến vòng đời Activity/Fragment.

### 6.1.2 Nguyên lý hoạt động

**Tầng Model (Data Layer):**

- Quản lý dữ liệu và business logic.
- Bao gồm Repository, Remote Data Source (gọi API), Local Data Source (cơ sở dữ liệu cục bộ).
- Chịu trách nhiệm quyết định lấy dữ liệu từ bộ nhớ đệm hay từ server.

**Tầng View (UI Layer):**

- Hiển thị dữ liệu và nhận tương tác người dùng.
- Bao gồm Activity, Fragment, XML Layout.
- Quan sát (observe) LiveData từ ViewModel để cập nhật giao diện tự động.

**Tầng ViewModel (Logic Layer):**

- Cầu nối giữa View và Model.
- Lưu trữ và quản lý dữ liệu giao diện, tồn tại qua các thay đổi cấu hình (như xoay màn hình).
- Cung cấp LiveData cho View quan sát, gọi Repository để lấy dữ liệu.

### 6.1.3 Lợi ích của MVVM

- **Testability:** ViewModel có thể kiểm thử độc lập, không cần Android framework.
- **Lifecycle awareness:** LiveData tự động hủy đăng ký khi View bị hủy, tránh rò rỉ bộ nhớ.
- **Separation of concerns:** Logic giao diện tách biệt hoàn toàn khỏi business logic.
- **Configuration changes:** ViewModel sống sót qua xoay màn hình, không mất dữ liệu.
- **Reactive UI:** LiveData và Observer pattern giúp giao diện tự động cập nhật khi dữ liệu thay đổi.

## 6.2 Retrofit 2 — HTTP Client

### 6.2.1 Giới thiệu

Retrofit 2 là thư viện HTTP client mạnh mẽ do Square phát triển, giúp gọi REST API một cách an toàn về kiểu dữ liệu (type-safe) và rõ ràng. Đây là thư viện phổ biến nhất trong phát triển Android để giao tiếp với backend thông qua giao thức HTTP/REST.

### 6.2.2 Đặc điểm nổi bật

- **Type-safe HTTP calls:** Định nghĩa API dưới dạng interface Java, Retrofit tự động chuyển đổi thành các yêu cầu HTTP.
- **Converter linh hoạt:** Hỗ trợ nhiều định dạng dữ liệu (JSON, XML) thông qua các converter như Gson, Moshi.
- **Tích hợp OkHttp:** Sử dụng OkHttp làm HTTP client底层, hỗ trợ interceptors cho việc xử lý token, logging.
- **Hỗ trợ bất đồng bộ:** Tích hợp với Callback và RxJava để xử lý phản hồi từ server một cách bất đồng bộ.

### 6.2.3 Interceptor và JWT Authentication

Trong kiến trúc microservices, mọi yêu cầu từ client đều đi qua API Gateway. Để xác thực người dùng, mỗi yêu cầu HTTP cần đính kèm JWT token trong header Authorization. Cơ chế Interceptor của Retrofit cho phép tự động thêm token vào mọi yêu cầu mà không cần thao tác thủ công ở từng API call.

Ngoài ra, hệ thống sử dụng Authenticator để tự động làm mới token khi nhận được phản hồi 401 (Unauthorized) từ server, đảm bảo trải nghiệm người dùng liền mạch.

## 6.3 Room Database — Lưu trữ cục bộ

### 6.3.1 Giới thiệu

Room là tầng abstraction trên SQLite, được Google phát triển như một phần của Android Architecture Components. Room cung cấp xác minh truy vấn SQL tại thời điểm biên dịch (compile-time SQL verification) và tích hợp chặt chẽ với LiveData, giúp truy xuất dữ liệu cục bộ một cách an toàn và hiệu quả.

### 6.3.2 Các thành phần chính

- **Entity:** Đại diện cho một bảng trong cơ sở dữ liệu, được ánh xạ từ lớp Java.
- **DAO (Data Access Object):** Định nghĩa các phương thức truy xuất dữ liệu (truy vấn, chèn, cập nhật, xóa).
- **Database:** Lớp chính quản lý cơ sở dữ liệu, cung cấp truy cập đến các DAO.

### 6.3.3 Chiến lược Cache-First (NetworkBoundResource)

Hệ thống sử dụng mô hình NetworkBoundResource để quản lý luồng dữ liệu:

1. **Ưu tiên đọc từ bộ nhớ đệm:** Hiển thị dữ liệu từ Room Database ngay lập tức.
2. **Kiểm tra thời hạn:** Nếu dữ liệu quá cũ (vượt quá TTL), gửi yêu cầu đến server.
3. **Cập nhật từ server:** Khi nhận dữ liệu mới, lưu vào Room Database và tự động cập nhật giao diện.
4. **Xử lý ngoại tuyến:** Nếu mất mạng, hiển thị dữ liệu từ bộ nhớ đệm và thông báo cho người dùng.

Chiến lược này giúp ứng dụng phản hồi nhanh, giảm tải cho server, và hoạt động tốt ngay cả khi mất kết nối mạng.

## 6.4 LiveData và ViewModel

### 6.4.1 LiveData

LiveData là một lớp dữ liệu có thể quan sát (observable data holder), nhận thức về vòng đời của Android component. LiveData tự động:

- Hủy đăng ký observer khi Activity/Fragment bị hủy.
- Không gửi dữ liệu khi View không ở trạng thái hoạt động.
- Cập nhật giao diện trên main thread khi dữ liệu thay đổi.

### 6.4.2 ViewModel

ViewModel là lớp chịu trách nhiệm chuẩn bị và quản lý dữ liệu cho Activity/Fragment. ViewModel:

- Tồn tại qua các thay đổi cấu hình (xoay màn hình, thay đổi ngôn ngữ).
- Lưu trữ trạng thái giao diện (loading, error, data).
- Giao tiếp với Repository để lấy và xử lý dữ liệu.

## 6.5 ViewBinding

ViewBinding là tính năng của Android Gradle Plugin, thay thế cho `findViewById()` truyền thống. ViewBinding tạo ra một lớp binding cho mỗi layout XML, cung cấp truy cập type-safe đến các view. Điều này giúp:

- Loại bỏ lỗi NullPointerException khi truy cập view.
- Phát hiện lỗi tại thời điểm biên dịch thay vì runtime.
- Giảm thiểu boilerplate code.

## 6.6 Glide — Tải hình ảnh

Glide là thư viện tải và hiển thị hình ảnh hiệu quả, được tối ưu hóa cho Android. Các tính năng chính:

- **Memory và disk caching:** Tự động cache hình ảnh, giảm thiểu tải lại từ mạng.
- **Placeholder và error image:** Hiển thị hình ảnh tạm thời khi đang tải và hình ảnh lỗi khi tải thất bại.
- **Transformation:** Hỗ trợ cắt, resize, và chuyển đổi hình ảnh.
- **Lifecycle awareness:** Tự động hủy tải hình ảnh khi Activity/Fragment bị hủy.

## 6.7 Material Design 3

### 6.7.1 Giới thiệu

Material Design 3 (Material You) là ngôn ngữ thiết kế mới nhất của Google, mang đến giao diện hiện đại, cá nhân hóa và nhất quán trên toàn hệ thống. Ứng dụng SmartVN tuân thủ các nguyên tắc của Material Design 3.

### 6.7.2 Các component sử dụng

- **TopAppBar:** Thanh tiêu đề với biểu tượng điều hướng.
- **BottomNavigationView:** Thanh điều hướng dưới cùng (Trang chủ, Giỏ hàng, Đơn hàng, Tài khoản).
- **CardView:** Hiển thị sản phẩm dạng thẻ với bóng đổ và hiệu ứng ripple.
- **Chip:** Bộ lọc danh mục sản phẩm.
- **FloatingActionButton:** Nút hành động chính (Thêm vào giỏ hàng).
- **MaterialButton:** Các nút hành động (Đăng nhập, Đặt hàng, Thanh toán).
- **TextInputLayout:** Trường nhập liệu với xác thực.
- **Snackbar:** Thông báo ngắn hạn (đã thêm vào giỏ, lỗi mạng).

### 6.7.3 Hệ thống màu sắc

Ứng dụng sử dụng bảng màu Material Design 3 với tông màu chủ đạo:

- **Màu chính (Primary):** Xanh lá cây — đại diện cho thương hiệu SmartVN.
- **Màu bề mặt (Surface):** Trắng ngà — nền chính cho nội dung.
- **Màu giá sản phẩm:** Đỏ — nổi bật cho giá tiền.
- **Màu đánh giá:** Vàng — cho biểu tượng sao đánh giá.

## 6.8 Firebase Cloud Messaging (FCM)

### 6.8.1 Giới thiệu

FCM là dịch vụ nhắn tin đám mây của Google, cho phép gửi thông báo đẩy (push notification) đến ứng dụng Android. Trong hệ thống SmartVN, FCM được sử dụng để:

- Thông báo trạng thái đơn hàng (đã xác nhận, đang giao, đã giao).
- Thông báo khuyến mãi và sự kiện.
- Nhắc nhở giỏ hàng bỏ quên.

## 6.9 Công nghệ và thư viện sử dụng

### 6.9.1 Nền tảng phát triển

- **Ngôn ngữ:** Java 17
- **Android SDK:** API 26+ (Android 8.0 Oreo) — tương thích với hơn 95% thiết bị Android.
- **Build Tool:** Gradle với Android Gradle Plugin.
- **IDE:** Android Studio.

### 6.9.2 Các thư viện chính

| Thư viện | Phiên bản | Vai trò |
|---|---|---|
| Retrofit 2 | 2.9.0 | HTTP Client — gọi REST API |
| OkHttp | 4.12.0 | HTTP engine, interceptor, logging |
| Room | 2.6.1 | ORM — lưu trữ cơ sở dữ liệu cục bộ |
| Lifecycle (ViewModel + LiveData) | 2.7.0 | Quản lý dữ liệu theo vòng đời |
| Glide | 4.16.0 | Tải và hiển thị hình ảnh |
| Material Components | 1.11.0 | UI components theo Material Design 3 |
| Firebase Messaging | 23.4.0 | Thông báo đẩy |
| ViewPager2 | 1.0.0 | Banner carousel, image slider |
| SwipeRefreshLayout | 1.1.0 | Kéo để làm mới danh sách |

### 6.9.3 Hỗ trợ hệ điều hành và triển khai

- Ứng dụng hoạt động trên mọi thiết bị chạy Android 8.0 (API 26) trở lên.
- Đóng gói thành tệp APK hoặc AAB (Android App Bundle) để triển khai trên Google Play Store.
- Tương thích với kiến trúc ARM và x86.
# CHƯƠNG 7: PHÂN TÍCH VÀ THIẾT KẾ ỨNG DỤNG MOBILE

## 7.1 Thiết kế Use Case

### 7.1.1 Sơ đồ Use Case tổng quan — Phía người dùng mobile

![Sơ đồ Use Case tổng quan ứng dụng Mobile — Phía người dùng](images/mobile-use-case-user.png){#fig:mobile-uc-user width=90%}

Như thể hiện trong @fig:mobile-uc-user, ứng dụng mobile SmartVN hỗ trợ các tác nhân chính:

- **Khách vãng lai (Guest):** Có thể duyệt sản phẩm, tìm kiếm, xem chi tiết sản phẩm.
- **Khách hàng đã đăng nhập (Customer):** Toàn bộ chức năng bao gồm giỏ hàng, đặt hàng, thanh toán, quản lý đơn hàng, tài khoản.

### 7.1.2 Đặc tả Use Case

**Use Case: Đăng ký tài khoản (UC-M01)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M01 |
| Tác nhân | Khách vãng lai |
| Mô tả | Cho phép người dùng tạo tài khoản mới trên ứng dụng SmartVN |
| Điều kiện tiên quyết | Người dùng đang ở trang đăng ký |
| Luồng sự kiện chính | 1. Người dùng nhập Họ, Tên, Email, Mật khẩu. 2. Nhấn nút "Đăng ký". 3. Hệ thống kiểm tra tính hợp lệ. 4. Hệ thống kiểm tra email đã tồn tại chưa. 5. Tạo tài khoản mới trong cơ sở dữ liệu. 6. Chuyển đến trang đăng nhập. |
| Luồng thay thế | 4a. Email đã tồn tại: Hiển thị lỗi "Email này đã được sử dụng". 3a. Thông tin không hợp lệ: Hiển thị lỗi cụ thể cho từng trường. |
| Điều kiện sau | Tài khoản mới được tạo, người dùng có thể đăng nhập |

**Use Case: Đăng nhập (UC-M02)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M02 |
| Tác nhân | Khách vãng lai |
| Mô tả | Cho phép người dùng truy cập tài khoản bằng email/mật khẩu hoặc Google |
| Điều kiện tiên quyết | Người dùng đang ở trang đăng nhập |
| Luồng sự kiện chính | 1. Người dùng nhập email và mật khẩu. 2. Nhấn "Đăng nhập". 3. Hệ thống xác thực thông tin. 4. Hệ thống tạo JWT token. 5. Lưu token vào bộ nhớ an toàn. 6. Chuyển đến trang chủ. |
| Luồng thay thế | 2a. Sai email/mật khẩu: Hiển thị lỗi. 2b. Tài khoản bị khóa: Thông báo tài khoản đã bị khóa. |
| Điều kiện sau | Người dùng được xác thực, có thể truy cập các chức năng |

**Use Case: Đăng nhập bằng Google (UC-M03)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M03 |
| Tác nhân | Khách vãng lai |
| Mô tả | Cho phép đăng nhập nhanh bằng tài khoản Google |
| Điều kiện tiên quyết | Thiết bị có cài đặt Google Play Services |
| Luồng sự kiện chính | 1. Nhấn nút "Đăng nhập bằng Google". 2. Hiển thị chọn tài khoản Google. 3. Người dùng chọn tài khoản. 4. Gửi ID token đến backend. 5. Backend xác thực và tạo JWT. 6. Lưu token, chuyển đến trang chủ. |
| Điều kiện sau | Người dùng đăng nhập thành công |

**Use Case: Duyệt và tìm kiếm sản phẩm (UC-M04)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M04 |
| Tác nhân | Khách vãng lai, Khách hàng |
| Mô tả | Xem danh sách sản phẩm, lọc theo danh mục, tìm kiếm theo từ khóa |
| Điều kiện tiên quyết | Ứng dụng đã kết nối mạng hoặc có dữ liệu cache |
| Luồng sự kiện chính | 1. Mở trang chủ. 2. Hệ thống hiển thị sản phẩm từ cache hoặc server. 3. Người dùng chọn danh mục (Chip filter). 4. Hệ thống lọc sản phẩm theo danh mục. 5. Hoặc nhập từ khóa vào ô tìm kiếm. 6. Hệ thống hiển thị kết quả tìm kiếm. |
| Luồng thay thế | 1a. Mất mạng: Hiển thị dữ liệu từ cache, thông báo "Đang offline". |
| Điều kiện sau | Người dùng xem được danh sách sản phẩm |

**Use Case: Xem chi tiết sản phẩm (UC-M05)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M05 |
| Tác nhân | Khách vãng lai, Khách hàng |
| Mô tả | Xem thông tin chi tiết của một sản phẩm |
| Điều kiện tiên quyết | Người dùng đã chọn một sản phẩm |
| Luồng sự kiện chính | 1. Nhấn vào sản phẩm từ danh sách. 2. Hệ thống hiển thị chi tiết: hình ảnh (slider), tên, giá, đánh giá, mô tả, thông số kỹ thuật. 3. Xem đánh giá từ khách hàng khác. 4. Nhấn "Thêm vào giỏ" (nếu đã đăng nhập). |
| Điều kiện sau | Người dùng xem được toàn bộ thông tin sản phẩm |

**Use Case: Quản lý giỏ hàng (UC-M06)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M06 |
| Tác nhân | Khách hàng |
| Mô tả | Thêm, sửa số lượng, xóa sản phẩm khỏi giỏ hàng |
| Điều kiện tiên quyết | Người dùng đã đăng nhập |
| Luồng sự kiện chính | 1. Nhấn "Thêm vào giỏ" từ chi tiết sản phẩm. 2. Hệ thống thêm sản phẩm vào giỏ (lưu cục bộ). 3. Hiển thị Snackbar xác nhận. 4. Truy cập trang giỏ hàng. 5. Thay đổi số lượng hoặc xóa sản phẩm. 6. Hệ thống cập nhật tổng tiền tự động. |
| Luồng thay thế | 1a. Sản phẩm đã có trong giỏ: Tăng số lượng. 5a. Vuốt để xóa: Xóa sản phẩm khỏi giỏ. |
| Điều kiện sau | Giỏ hàng được cập nhật theo thao tác |

**Use Case: Đặt hàng (UC-M07)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M07 |
| Tác nhân | Khách hàng |
| Mô tả | Tiến hành đặt hàng từ các sản phẩm trong giỏ |
| Điều kiện tiên quyết | Giỏ hàng có ít nhất một sản phẩm |
| Luồng sự kiện chính | 1. Nhấn "Tiến hành thanh toán". 2. Hiển thị trang checkout. 3. Nhập/chọn địa chỉ giao hàng. 4. Chọn phương thức thanh toán (COD / VNPay). 5. Nhấn "Đặt hàng". 6. Hệ thống kiểm tra tồn kho. 7. Tạo đơn hàng mới. 8. Xóa giỏ hàng. 9. Hiển thị xác nhận thành công. |
| Luồng thay thế | 6a. Sản phẩm hết hàng: Hiển thị lỗi, yêu cầu cập nhật giỏ. 4a. Chọn VNPay: Mở trang thanh toán VNPay. |
| Điều kiện sau | Đơn hàng được tạo, giỏ hàng được làm trống |

**Use Case: Thanh toán VNPay (UC-M08)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M08 |
| Tác nhân | Khách hàng |
| Mô tả | Thanh toán đơn hàng qua cổng VNPay |
| Điều kiện tiên quyết | Đơn hàng đã tạo, chọn phương thức VNPay |
| Luồng sự kiện chính | 1. Hệ thống tạo URL thanh toán VNPay. 2. Mở Chrome Custom Tab với URL thanh toán. 3. Người dùng chọn ngân hàng và xác nhận thanh toán. 4. VNPay xử lý thanh toán. 5. Chuyển hướng về ứng dụng với kết quả. 6. Hệ thống cập nhật trạng thái đơn hàng. |
| Điều kiện sau | Đơn hàng được xác nhận thanh toán |

**Use Case: Theo dõi đơn hàng (UC-M09)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M09 |
| Tác nhân | Khách hàng |
| Mô tả | Xem danh sách và chi tiết đơn hàng đã đặt |
| Điều kiện tiên quyết | Người dùng đã đăng nhập và có đơn hàng |
| Luồng sự kiện chính | 1. Truy cập tab "Đơn hàng". 2. Hệ thống hiển thị danh sách đơn hàng. 3. Nhấn vào đơn hàng để xem chi tiết. 4. Hiển thị: trạng thái, danh sách sản phẩm, tổng tiền, địa chỉ giao hàng. |
| Điều kiện sau | Người dùng xem được thông tin đơn hàng |

**Use Case: Quản lý tài khoản (UC-M10)**

| Mục | Mô tả |
|---|---|
| Mã số | UC-M10 |
| Tác nhân | Khách hàng |
| Mô tả | Cập nhật thông tin cá nhân, đổi mật khẩu, quản lý địa chỉ |
| Điều kiện tiên quyết | Người dùng đã đăng nhập |
| Luồng sự kiện chính | 1. Truy cập tab "Tài khoản". 2. Xem thông tin cá nhân. 3. Chỉnh sửa thông tin (tên, số điện thoại). 4. Đổi mật khẩu. 5. Quản lý danh sách địa chỉ giao hàng. 6. Đăng xuất. |
| Điều kiện sau | Thông tin tài khoản được cập nhật |

### 7.1.3 Bảng tổng hợp Use Case

| Mã | Tên Use Case | Tác nhân | Mô tả ngắn |
|---|---|---|---|
| UC-M01 | Đăng ký tài khoản | Khách vãng lai | Tạo tài khoản mới |
| UC-M02 | Đăng nhập | Khách vãng lai | Xác thực bằng email/mật khẩu |
| UC-M03 | Đăng nhập Google | Khách vãng lai | Xác thực qua Google OAuth2 |
| UC-M04 | Duyệt/tìm kiếm sản phẩm | Tất cả | Xem danh mục, tìm kiếm, lọc |
| UC-M05 | Xem chi tiết sản phẩm | Tất cả | Xem thông tin đầy đủ sản phẩm |
| UC-M06 | Quản lý giỏ hàng | Khách hàng | Thêm/sửa/xóa sản phẩm trong giỏ |
| UC-M07 | Đặt hàng | Khách hàng | Tạo đơn hàng từ giỏ hàng |
| UC-M08 | Thanh toán VNPay | Khách hàng | Thanh toán trực tuyến qua VNPay |
| UC-M09 | Theo dõi đơn hàng | Khách hàng | Xem trạng thái và lịch sử đơn hàng |
| UC-M10 | Quản lý tài khoản | Khách hàng | Cập nhật thông tin, đổi mật khẩu |

## 7.2 Thiết kế Sequence Diagram

### 7.2.1 Luồng đăng nhập

![Biểu đồ trình tự đăng nhập](diagrams/seq-login.png){#fig:seq-login width=90%}

**Mô tả luồng:**

1. Người dùng nhập email và mật khẩu, nhấn "Đăng nhập".
2. LoginActivity gọi LoginViewModel.login().
3. LoginViewModel gọi AuthRepository.login().
4. AuthRepository gửi POST request đến API Gateway (endpoint /api/v1/auth/login).
5. API Gateway chuyển tiếp đến User Service.
6. User Service xác thực thông tin, tạo JWT token.
7. Phản hồi trả về: Access Token + Refresh Token + thông tin người dùng.
8. AuthRepository lưu token vào TokenManager (SharedPreferences mã hóa).
9. Cập nhật LiveData<AuthResult> với kết quả thành công.
10. LoginActivity nhận kết quả, chuyển đến MainActivity.

### 7.2.2 Luồng đăng ký

![Biểu đồ trình tự — Đăng ký tài khoản](images/mobile-seq-register.png){#fig:seq-register width=90%}

**Mô tả luồng:**

1. Người dùng nhập thông tin (Họ, Tên, Email, Mật khẩu).
2. RegisterActivity gọi RegisterViewModel.register().
3. RegisterViewModel kiểm tra tính hợp lệ phía client.
4. Gọi AuthRepository.register().
5. Gửi POST request đến API Gateway (endpoint /api/v1/auth/register).
6. Backend kiểm tra email đã tồn tại, tạo tài khoản mới.
7. Phản hồi thành công.
8. Chuyển đến trang đăng nhập với thông báo "Đăng ký thành công".

### 7.2.3 Luồng xem sản phẩm (Cache-First)

![Biểu đồ trình tự — Xem danh sách sản phẩm](images/mobile-seq-products.png){#fig:seq-products width=90%}

**Mô tả luồng (cache hit):**

1. HomeFragment hiển thị, gọi ProductViewModel.getProducts().
2. ProductViewModel gọi ProductRepository.getProducts().
3. Repository kiểm tra Room Database (cache).
4. Nếu cache còn hạn (TTL 10 phút) → trả về dữ liệu từ cache.
5. Cập nhật LiveData<List<Product>>.
6. HomeFragment nhận dữ liệu, hiển thị RecyclerView.

**Mô tả luồng (cache miss):**

1-3. Tương tự, nhưng cache hết hạn hoặc trống.
4. Repository gửi GET request đến API Gateway.
5. Backend trả về danh sách sản phẩm.
6. Repository lưu kết quả vào Room Database (cập nhật cache).
7. Cập nhật LiveData, giao diện tự động refresh.

### 7.2.4 Luồng đặt hàng

![Biểu đồ trình tự đặt hàng](diagrams/seq-order.png){#fig:seq-order width=90%}

**Mô tả luồng:**

1. Người dùng nhấn "Đặt hàng" từ CheckoutActivity.
2. CheckoutViewModel gọi OrderRepository.createOrder().
3. OrderRepository gửi POST request đến API Gateway (endpoint /api/v1/orders).
4. Backend kiểm tra tồn kho, tạo đơn hàng.
5. Phản hồi thông tin đơn hàng.
6. Nếu chọn VNPay: Gọi API tạo payment URL.
7. Mở Chrome Custom Tab với URL thanh toán VNPay.
8. Người dùng hoàn tất thanh toán trên VNPay.
9. VNPay chuyển hướng về ứng dụng.
10. Backend xác nhận thanh toán, cập nhật trạng thái đơn hàng.
11. Xóa giỏ hàng (Room Database).
12. Chuyển đến trang xác nhận thành công.

### 7.2.5 Luồng quản lý giỏ hàng

![Biểu đồ trình tự — Quản lý giỏ hàng](images/mobile-seq-cart.png){#fig:seq-cart width=90%}

**Mô tả luồng thêm vào giỏ:**

1. Người dùng nhấn "Thêm vào giỏ" từ ProductDetailActivity.
2. ProductDetailViewModel gọi CartRepository.addToCart().
3. CartRepository kiểm tra sản phẩm đã có trong giỏ chưa (Room Database).
4. Nếu có: tăng số lượng. Nếu chưa: thêm mới.
5. Cập nhật Room Database trên background thread.
6. LiveData<List<CartItemEntity>> tự động cập nhật.
7. Hiển thị Snackbar "Đã thêm vào giỏ hàng" với nút "XEM GIỎ".

### 7.2.6 Luồng đồng bộ giỏ hàng

![Biểu đồ trình tự — Đồng bộ giỏ hàng với server](images/mobile-seq-sync.png){#fig:seq-sync width=90%}

**Mô tả luồng:**

1. Khi người dùng mở ứng dụng hoặc có kết nối mạng trở lại.
2. CartRepository kiểm tra trạng thái đồng bộ.
3. Nếu có dữ liệu cục bộ chưa đồng bộ: gửi POST request đến API Gateway.
4. Backend cập nhật giỏ hàng trên server.
5. Phản hồi đồng bộ thành công.

## 7.3 Thiết kế giao diện người dùng (UI/UX)

### 7.3.1 Hệ thống điều hướng

Ứng dụng sử dụng kiến trúc Single Activity kết hợp với Navigation Component và BottomNavigationView. Cấu trúc bao gồm:

- **MainActivity:** Container chính, chứa BottomNavigationView và Fragment container.
- **Các Fragment chính:** HomeFragment, SearchFragment, CartFragment, OrderFragment, ProfileFragment.
- **Các Activity riêng:** ProductDetailActivity, LoginActivity, RegisterActivity, CheckoutActivity, OrderDetailActivity.

### 7.3.2 Thiết kế từng màn hình

**Màn hình Trang chủ (HomeFragment):**

![Thiết kế giao diện Trang chủ](images/mobile-ui-home.png){#fig:ui-home width=80%}

Cấu trúc bao gồm:

- **Top App Bar:** Logo SmartVN, biểu tượng tìm kiếm và thông báo.
- **Banner Carousel:** Quảng cáo, khuyến mãi (tự động chuyển sau 5 giây).
- **Category Chips:** Bộ lọc danh mục dạng thanh ngang cuộn được.
- **Flash Sale Section:** Sản phẩm giảm giá với đồng hồ đếm ngược.
- **Sản phẩm phổ biến:** Hiển thị dạng lưới 2 cột.

**Màn hình Chi tiết sản phẩm (ProductDetailActivity):**

![Thiết kế giao diện Chi tiết sản phẩm](images/mobile-ui-product-detail.png){#fig:ui-product-detail width=80%}

Cấu trúc bao gồm:

- **Image Slider:** Hiển thị nhiều hình ảnh sản phẩm với indicator dots.
- **Thông tin cơ bản:** Tên sản phẩm, giá, đánh giá, số lượng đã bán.
- **Mô tả sản phẩm:** Văn bản mở rộng (xem thêm / thu gọn).
- **Đánh giá từ khách hàng:** Danh sách đánh giá.
- **Bottom Bar cố định:** Giá + nút "Thêm vào giỏ" + nút "Mua ngay".

**Màn hình Giỏ hàng (CartFragment):**

![Thiết kế giao diện Giỏ hàng](images/mobile-ui-cart.png){#fig:ui-cart width=80%}

Cấu trúc bao gồm:

- **RecyclerView:** Danh sách sản phẩm với thao tác vuốt để xóa.
- **Mỗi item:** Ảnh sản phẩm, tên, giá, nút tăng/giảm số lượng, tổng tiền dòng.
- **Bottom Summary Bar:** Tổng tiền + nút "Tiến hành thanh toán".
- **Empty State:** Hình minh họa + thông báo "Giỏ hàng trống".

**Màn hình Đăng nhập (LoginActivity):**

![Thiết kế giao diện Đăng nhập](images/mobile-ui-login.png){#fig:ui-login width=80%}

Cấu trúc bao gồm:

- **Logo SmartVN** ở trên cùng.
- **Trường nhập liệu:** Email + Mật khẩu với xác thực.
- **Nút Đăng nhập.**
- **Đăng nhập xã hội:** Nút Google.
- **Liên kết:** "Chưa có tài khoản? Đăng ký ngay".

**Màn hình Checkout (CheckoutActivity):**

![Thiết kế giao diện Checkout](images/mobile-ui-checkout.png){#fig:ui-checkout width=80%}

Cấu trúc bao gồm:

- **Section 1 — Địa chỉ giao hàng:** Tên, số điện thoại, địa chỉ chi tiết.
- **Section 2 — Phương thức thanh toán:** COD / VNPay (RadioGroup).
- **Section 3 — Tóm tắt đơn hàng:** Danh sách sản phẩm, tổng tiền, phí vận chuyển.
- **Bottom Bar:** Tổng tiền + nút "Đặt hàng".

**Màn hình Đơn hàng (OrderFragment):**

![Thiết kế giao diện Danh sách đơn hàng](images/mobile-ui-orders.png){#fig:ui-orders width=80%}

Cấu trúc bao gồm:

- **RecyclerView:** Danh sách đơn hàng với trạng thái màu sắc.
- **Mỗi item:** Mã đơn hàng, ngày đặt, số lượng sản phẩm, tổng tiền, trạng thái.
- **Empty State:** Thông báo "Chưa có đơn hàng nào".

**Màn hình Tài khoản (ProfileFragment):**

![Thiết kế giao diện Tài khoản](images/mobile-ui-profile.png){#fig:ui-profile width=80%}

Cấu trúc bao gồm:

- **Avatar và tên người dùng** ở trên cùng.
- **Menu items:** Đơn hàng của tôi, Địa chỉ giao hàng, Đổi mật khẩu, Đăng xuất.

## 7.4 Thiết kế cơ sở dữ liệu cục bộ

### 7.4.1 Bảng Cached Products (Sản phẩm đã cache)

| Trường | Kiểu dữ liệu | Mô tả |
|---|---|---|
| productId | Long (PK) | Mã sản phẩm |
| name | String | Tên sản phẩm |
| description | String | Mô tả sản phẩm |
| price | Double | Giá sản phẩm |
| imageUrl | String | URL hình ảnh |
| category | String | Danh mục |
| rating | Double | Đánh giá trung bình |
| reviewCount | Integer | Số lượng đánh giá |
| cachedAt | Long | Thời điểm cache (timestamp) |

### 7.4.2 Bảng Cart Items (Giỏ hàng cục bộ)

| Trường | Kiểu dữ liệu | Mô tả |
|---|---|---|
| id | Integer (PK, auto) | Mã tự tăng |
| productId | Long | Mã sản phẩm |
| productName | String | Tên sản phẩm |
| productImage | String | URL hình ảnh |
| unitPrice | Double | Đơn giá |
| quantity | Integer | Số lượng |
| totalPrice | Double | Thành tiền (đơn giá × số lượng) |

### 7.4.3 Mô hình ERD cục bộ

![Mô hình ERD cơ sở dữ liệu cục bộ trên Android](images/mobile-erd-local.png){#fig:mobile-erd width=70%}

## 7.5 Thiết kế kiến trúc tổng thể mobile

### 7.5.1 Sơ đồ kiến trúc ứng dụng

![Sơ đồ kiến trúc MVVM](diagrams/mvvm.png){#fig:mobile-arch width=85%}

### 7.5.2 Luồng dữ liệu tổng thể

![Luồng dữ liệu trong ứng dụng Mobile](images/mobile-data-flow.png){#fig:mobile-data-flow width=90%}

**Mô tả luồng:**

1. **View (UI):** Hiển thị dữ liệu, nhận tương tác người dùng.
2. **ViewModel:** Xử lý logic giao diện, gọi Repository.
3. **Repository:** Quyết định nguồn dữ liệu (cache hay network).
4. **Remote Data Source:** Gọi API thông qua Retrofit.
5. **Local Data Source:** Đọc/ghi Room Database.
6. **API Gateway → Backend Services:** Xử lý nghiệp vụ và trả về dữ liệu.

### 7.5.3 Cấu trúc thư mục dự án

```
com.smartvn.app/
├── data/
│   ├── local/          # Room Database, DAO, Entity
│   ├── remote/         # Retrofit, API Interface, Interceptor
│   ├── model/          # Data classes (Product, Order, User)
│   └── repository/     # Repository pattern implementations
├── ui/
│   ├── auth/           # Login, Register screens
│   ├── main/           # MainActivity, Navigation
│   ├── home/           # Home screen, Product list
│   ├── search/         # Search functionality
│   ├── product/        # Product detail
│   ├── cart/           # Shopping cart
│   ├── checkout/       # Checkout flow
│   ├── order/          # Order list, Order detail
│   └── profile/        # User profile, Settings
├── utils/              # Utility classes (Network, Token, Format)
└── widget/             # Custom views (Badge, Price formatter)
```
# CHƯƠNG 8: XÂY DỰNG ỨNG DỤNG MOBILE

## 8.1 Cấu hình dự án

### 8.1.1 Cấu hình Gradle

Dự án Android được cấu hình với các thông số chính:

- **Application ID:** com.smartvn.app
- **Min SDK:** API 26 (Android 8.0 Oreo)
- **Target SDK:** API 34 (Android 14)
- **Compile SDK:** API 34
- **Java Version:** 17

ViewBinding được bật để hỗ trợ truy cập type-safe đến các view trong layout XML.

### 8.1.2 Cấu hình kết nối API

Ứng dụng kết nối với hệ thống backend thông qua API Gateway — điểm vào duy nhất cho tất cả yêu cầu HTTP. Lưu ý quan trọng khi chạy trên Android Emulator:

- Địa chỉ `10.0.2.2` trỏ về `localhost` của máy host (dùng cho phát triển).
- Khi chạy trên thiết bị thật, cần thay bằng IP thực của server.
- Môi trường production sử dụng domain thật.

## 8.2 Xây dựng các màn hình chức năng

### 8.2.1 Màn hình Đăng ký

![Giao diện trang Đăng ký](images/mobile-screen-register.png){#fig:screen-register width=70%}

Màn hình đăng ký bao gồm các trường nhập liệu (Họ, Tên, Email, Mật khẩu) với xác thực thời gian thực. Hệ thống kiểm tra:

- Email đúng định dạng và chưa được sử dụng.
- Mật khẩu tối thiểu 6 ký tự.
- Tất cả trường bắt buộc phải được điền.

Khi đăng ký thành công, người dùng được chuyển đến trang đăng nhập với thông báo xác nhận.

### 8.2.2 Màn hình Đăng nhập

![Giao diện trang Đăng nhập](images/mobile-screen-login.png){#fig:screen-login width=70%}

Màn hình đăng nhập hỗ trợ hai phương thức:

- **Email/Mật khẩu:** Nhập thông tin và nhấn "Đăng nhập".
- **Đăng nhập Google:** Nhấn nút Google, chọn tài khoản, hệ thống tự động xác thực.

Sau khi đăng nhập thành công, JWT token được lưu vào SharedPreferences mã hóa. Token này được tự động đính kèm vào mọi yêu cầu HTTP thông qua Interceptor.

### 8.2.3 Màn hình Trang chủ

![Giao diện Trang chủ](images/mobile-screen-home.png){#fig:screen-home width=70%}

Trang chủ hiển thị nội dung theo cấu trúc:

- **Banner quảng cáo:** ViewPager2 với auto-scroll, hiển thị các chương trình khuyến mãi.
- **Bộ lọc danh mục:** ChipGroup cuộn ngang — Tất cả, Điện tử, Thời trang, Gia dụng, Sách, Mỹ phẩm.
- **Flash Sale:** Sản phẩm giảm giá với đồng hồ đếm ngược.
- **Sản phẩm phổ biến:** RecyclerView dạng lưới 2 cột, hỗ trợ kéo để làm mới (SwipeRefreshLayout).

### 8.2.4 Màn hình Chi tiết sản phẩm

![Giao diện Chi tiết sản phẩm](images/mobile-screen-product-detail.png){#fig:screen-product-detail width=70%}

Màn hình chi tiết hiển thị đầy đủ thông tin sản phẩm:

- **Hình ảnh:** ViewPager2 cho phép xem nhiều hình ảnh với indicator dots.
- **Thông tin cơ bản:** Tên, giá (định dạng VNĐ), đánh giá sao, số lượng đã bán.
- **Mô tả:** Văn bản mô tả chi tiết với khả năng mở rộng/thu gọn.
- **Đánh giá:** Danh sách đánh giá từ khách hàng khác.
- **Hành động:** Bottom bar cố định với nút "Thêm vào giỏ" và "Mua ngay".

Khi nhấn "Thêm vào giỏ", sản phẩm được lưu vào Room Database và hiển thị Snackbar xác nhận với nút "XEM GIỎ" để chuyển nhanh đến trang giỏ hàng.

### 8.2.5 Màn hình Tìm kiếm

![Giao diện Tìm kiếm sản phẩm](images/mobile-screen-search.png){#fig:screen-search width=70%}

Màn hình tìm kiếm với cơ chế debounce (chờ 500ms sau khi ngừng gõ):

- Trường nhập liệu tìm kiếm ở trên cùng.
- Kết quả hiển thị dạng lưới sản phẩm.
- Hiển thị "Không tìm thấy kết quả" khi không có sản phẩm phù hợp.
- Tìm kiếm tối thiểu 2 ký tự.

### 8.2.6 Màn hình Giỏ hàng

![Giao diện Giỏ hàng](images/mobile-screen-cart.png){#fig:screen-cart width=70%}

Giỏ hàng hiển thị danh sách sản phẩm đã thêm:

- Mỗi sản phẩm hiển thị: hình ảnh, tên, đơn giá, nút tăng/giảm số lượng, thành tiền.
- Thao tác vuốt sang trái để xóa sản phẩm (ItemTouchHelper).
- Tự động cập nhật tổng tiền khi thay đổi số lượng.
- Bottom bar hiển thị tổng tiền và nút "Tiến hành thanh toán".
- Khi giỏ trống: hiển thị hình minh họa và thông báo.

Giỏ hàng sử dụng Room Database làm nguồn dữ liệu chính (offline-first), đảm bảo hoạt động ngay cả khi mất mạng.

### 8.2.7 Màn hình Checkout

![Giao diện Checkout](images/mobile-screen-checkout.png){#fig:screen-checkout width=70%}

Trang checkout bao gồm ba phần:

- **Địa chỉ giao hàng:** Nhập tên, số điện thoại, địa chỉ chi tiết.
- **Phương thức thanh toán:** COD (thanh toán khi nhận hàng) hoặc VNPay (thanh toán trực tuyến).
- **Tóm tắt đơn hàng:** Danh sách sản phẩm, tổng tiền hàng, phí vận chuyển, tổng cộng.

Sau khi nhấn "Đặt hàng", hệ thống kiểm tra tồn kho, tạo đơn hàng và chuyển đến trang xác nhận.

### 8.2.8 Màn hình Thanh toán VNPay

![Giao diện Thanh toán VNPay](images/mobile-screen-vnpay.png){#fig:screen-vnpay width=70%}

Khi chọn phương thức VNPay:

- Hệ thống tạo URL thanh toán thông qua API backend.
- Mở Chrome Custom Tab (trình duyệt trong ứng dụng) với URL thanh toán VNPay.
- Người dùng chọn ngân hàng, nhập thông tin và xác nhận thanh toán.
- Sau khi thanh toán, VNPay chuyển hướng về ứng dụng.
- Hệ thống cập nhật trạng thái đơn hàng dự trên kết quả callback.

### 8.2.9 Màn hình Đặt hàng thành công

![Giao diện Đặt hàng thành công](images/mobile-screen-order-success.png){#fig:screen-order-success width=70%}

Sau khi đặt hàng thành công:

- Hiển thị biểu tượng xác nhận (checkmark animation).
- Thông báo "Đặt hàng thành công!".
- Mã đơn hàng để theo dõi.
- Nút "Xem đơn hàng" để chuyển đến chi tiết đơn hàng.
- Nút "Tiếp tục mua sắm" để quay về trang chủ.

### 8.2.10 Màn hình Danh sách đơn hàng

![Giao diện Danh sách đơn hàng](images/mobile-screen-orders.png){#fig:screen-orders width=70%}

Danh sách đơn hàng hiển thị:

- Mã đơn hàng, ngày đặt hàng.
- Số lượng sản phẩm trong đơn.
- Tổng tiền.
- Trạng thái đơn hàng với màu sắc tương ứng:
  - Chờ xác nhận (vàng)
  - Đã xác nhận (xanh dương)
  - Đang giao (tím)
  - Đã giao (xanh lá)
  - Đã hủy (đỏ)

### 8.2.11 Màn hình Chi tiết đơn hàng

![Giao diện Chi tiết đơn hàng](images/mobile-screen-order-detail.png){#fig:screen-order-detail width=70%}

Chi tiết đơn hàng bao gồm:

- Mã đơn hàng và ngày đặt.
- Trạng thái đơn hàng hiện tại.
- Danh sách sản phẩm đã đặt (tên, số lượng, đơn giá, thành tiền).
- Địa chỉ giao hàng.
- Phương thức thanh toán.
- Tổng tiền.

### 8.2.12 Màn hình Tài khoản

![Giao diện Quản lý tài khoản](images/mobile-screen-profile.png){#fig:screen-profile width=70%}

Trang tài khoản cho phép:

- Xem và chỉnh sửa thông tin cá nhân (tên, số điện thoại).
- Quản lý danh sách địa chỉ giao hàng.
- Đổi mật khẩu.
- Đăng xuất khỏi ứng dụng.

## 8.3 Xử lý lỗi và ngoại lệ

### 8.3.1 Xử lý lỗi mạng

Hệ thống xử lý các loại lỗi mạng phổ biến:

| Loại lỗi | Thông báo hiển thị |
|---|---|
| Hết thời gian kết nối | "Hết thời gian kết nối. Vui lòng thử lại." |
| Không kết nối được server | "Không thể kết nối đến server. Kiểm tra kết nối mạng." |
| Không tìm thấy server | "Không tìm thấy server. Kiểm tra kết nối mạng." |
| Lỗi mạng chung | "Lỗi mạng. Vui lòng thử lại." |

### 8.3.2 Xử lý lỗi HTTP

| Mã lỗi | Thông báo hiển thị |
|---|---|
| 400 | "Yêu cầu không hợp lệ." |
| 401 | "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại." |
| 403 | "Bạn không có quyền truy cập." |
| 404 | "Không tìm thấy tài nguyên." |
| 429 | "Quá nhiều yêu cầu. Vui lòng đợi." |
| 500 | "Lỗi server nội bộ." |
| 503 | "Server đang bảo trì." |

### 8.3.3 Xử lý 401 Unauthorized tự động

Khi nhận phản hồi 401 từ server, hệ thống tự động:

1. Thử làm mới token bằng Refresh Token.
2. Nếu refresh thành công: gửi lại yêu cầu ban đầu với token mới.
3. Nếu refresh thất bại: xóa token, chuyển về trang đăng nhập.

Cơ chế này đảm bảo trải nghiệm liền mạch, người dùng không cần đăng nhập lại thường xuyên.

### 8.3.4 Kiểm tra kết nối mạng

Trước mỗi yêu cầu API, hệ thống kiểm tra trạng thái kết nối mạng:

- Nếu có mạng: gửi yêu cầu bình thường.
- Nếu mất mạng: hiển thị dữ liệu từ cache (nếu có) và thông báo "Đang offline".

## 8.4 Demo ứng dụng

### 8.4.1 Luồng sử dụng chính

Luồng sử dụng hoàn chỉnh của ứng dụng:

1. **Mở ứng dụng** → Màn hình Splash → Trang chủ (hiển thị sản phẩm từ cache hoặc server).
2. **Duyệt sản phẩm** → Lọc danh mục → Tìm kiếm → Xem chi tiết.
3. **Đăng nhập** → Nhập email/mật khẩu hoặc chọn Google → Xác thực thành công.
4. **Mua sắm** → Thêm vào giỏ → Xem giỏ hàng → Điều chỉnh số lượng.
5. **Đặt hàng** → Nhập địa chỉ → Chọn thanh toán → Xác nhận.
6. **Thanh toán VNPay** → Chọn ngân hàng → Xác nhận → Quay về ứng dụng.
7. **Theo dõi đơn hàng** → Xem trạng thái → Xem chi tiết.

### 8.4.2 Trạng thái đơn hàng trong ứng dụng

| Trạng thái | Màu sắc | Ý nghĩa |
|---|---|---|
| Chờ xác nhận | Vàng | Đơn hàng mới tạo, chờ shop xác nhận |
| Đã xác nhận | Xanh dương | Shop đã xác nhận, chuẩn bị đóng gói |
| Đang giao | Tím | Đơn hàng đang được vận chuyển |
| Đã giao | Xanh lá | Đơn hàng đã giao thành công |
| Đã hủy | Đỏ | Đơn hàng bị hủy bởi người dùng hoặc hệ thống |

### 8.4.3 Tổng kết chương

Ứng dụng mobile SmartVN Android được xây dựng với các nguyên tắc:

- **Kiến trúc MVVM:** Tách biệt rõ ràng giữa UI, logic và dữ liệu.
- **Offline-first:** Ưu tiên dữ liệu cục bộ, cập nhật từ server khi có mạng.
- **Cache-first (NetworkBoundResource):** Hiển thị nhanh từ cache, đồng thời cập nhật từ network.
- **Material Design 3:** Giao diện hiện đại, nhất quán với design system của Google.
- **Type-safe API:** Retrofit giảm thiểu lỗi runtime khi gọi API.
- **Auto token refresh:** Trải nghiệm đăng nhập liền mạch.
- **Reactive UI:** LiveData tự động cập nhật giao diện khi dữ liệu thay đổi.


ewpage

# KIỂM THỬ & ĐÁNH GIÁ

Chương này trình bày quá trình kiểm thử chức năng, kiểm thử hiệu năng (benchmark) và đánh giá tổng quan hệ thống SmartVN.

## Kiểm thử chức năng

### Test cases cho từng service

Nhóm thực hiện kiểm thử chức năng cho từng microservice bằng cách test API endpoints thông qua curl và Postman.

**User Service test cases:**

: Test cases cho User Service {#tbl:user-test}

| ID | Test Case | Input | Kết quả mong đợi | Kết quả |
|---|---|---|---|---|
| TC01 | Đăng ký thành công | email, password, name | 201, OTP gửi email | Pass |
| TC02 | Đăng ký email trùng | email đã tồn tại | 409 Conflict | Pass |
| TC03 | Đăng nhập đúng | email, password | 200, JWT token | Pass |
| TC04 | Đăng nhập sai mk | email, wrong password | 401 Unauthorized | Pass |
| TC05 | Refresh token | valid refresh token | 200, new access token | Pass |
| TC06 | OAuth2 Google | Google callback | 200, JWT token | Pass |
| TC07 | Xem profile | JWT token | 200, user info | Pass |
| TC08 | Cập nhật profile | JWT, new info | 200, updated info | Pass |
| TC09 | Thêm địa chỉ | JWT, address data | 201, address created | Pass |
| TC10 | Admin ban user | Admin JWT, userId | 200, user banned | Pass |

**Product Service test cases:**

: Test cases cho Product Service {#tbl:product-test}

| ID | Test Case | Input | Kết quả mong đợi | Kết quả |
|---|---|---|---|---|
| TC11 | Danh sách sản phẩm | page, size, filters | 200, paginated list | Pass |
| TC12 | Chi tiết sản phẩm | productId | 200, product detail | Pass |
| TC13 | Chi tiết (cache hit) | productId (cached) | 200, from Redis | Pass |
| TC14 | Tìm sản phẩm | keyword | 200, search results | Pass |
| TC15 | Danh mục (cache) | — | 200, cached categories | Pass |
| TC16 | Thêm đánh giá | JWT, rating, comment | 201, review created | Pass |
| TC17 | Admin tạo sản phẩm | Admin JWT, product data | 201, product created | Pass |
| TC18 | Admin sửa sản phẩm | Admin JWT, updates | 200, product updated | Pass |
| TC19 | Kiểm tra tồn kho | productId, size | 200, stock quantity | Pass |
| TC20 | Upload hình ảnh | JWT, image file | 200, image URL | Pass |

**Order Service test cases:**

: Test cases cho Order Service {#tbl:order-test}

| ID | Test Case | Input | Kết quả mong đợi | Kết quả |
|---|---|---|---|---|
| TC21 | Xem giỏ hàng | JWT | 200, cart items | Pass |
| TC22 | Thêm vào giỏ | JWT, productId, qty | 201, item added | Pass |
| TC23 | Cập nhật giỏ | JWT, itemId, new qty | 200, item updated | Pass |
| TC24 | Xóa khỏi giỏ | JWT, itemId | 200, item removed | Pass |
| TC25 | Tạo đơn hàng | JWT, addressId | 201, order created | Pass |
| TC26 | Tạo đơn (hết hàng) | JWT, out-of-stock | 400, insufficient stock | Pass |
| TC27 | Danh sách đơn hàng | JWT | 200, order list | Pass |
| TC28 | Chi tiết đơn hàng | JWT, orderId | 200, order detail | Pass |
| TC29 | Hủy đơn hàng | JWT, orderId | 200, order cancelled | Pass |
| TC30 | Tạo thanh toán VNPay | JWT, orderId | 200, payment URL | Pass |

**Admin Service test cases:**

: Test cases cho Admin Service {#tbl:admin-test}

| ID | Test Case | Input | Kết quả mong đợi | Kết quả |
|---|---|---|---|---|
| TC31 | Dashboard tổng quan | Admin JWT | 200, dashboard data | Pass |
| TC32 | Thống kê user | Admin JWT | 200, user stats | Pass |
| TC33 | Thống kê sản phẩm | Admin JWT | 200, product stats | Pass |
| TC34 | Thống kê đơn hàng | Admin JWT | 200, order stats | Pass |
| TC35 | Doanh thu theo TG | Admin JWT, date range | 200, revenue chart | Pass |
| TC36 | Export sản phẩm | API Key | 200, JSON export | Pass |
| TC37 | Export tương tác | API Key | 200, JSON export | Pass |
| TC38 | Circuit Breaker fallback | service down | 200, fallback data | Pass |
| TC39 | Unauthorized access | no token | 401 Forbidden | Pass |
| TC40 | Admin user access | User JWT (not admin) | 403 Forbidden | Pass |

## Đánh giá hiệu năng (Benchmark)

### Thiết lập kiểm thử với k6

Để đánh giá hiệu năng hệ thống, nhóm sử dụng **Grafana k6** — công cụ load testing hiện đại, hỗ trợ scripting với JavaScript.

**Benchmark script (benchmark.js):**

**Code snippet:** k6 load test script — 100 virtual users, 5 phút duration, đo response time, throughput, và error rate cho Product Service endpoints.


### Kết quả: No Cache vs Redis Cache

Kết quả benchmark được thực hiện trên môi trường Docker local với cùng cấu hình phần cứng.

**Kết quả Without Cache:**

![Kết quả benchmark không sử dụng cache](images/benchmark-no-cache.png){#fig:bench-no-cache width=85%}

**Kết quả With Redis Cache:**

![Kết quả benchmark với Redis cache](images/benchmark-with-cache.png){#fig:bench-with-cache width=85%}

### Phân tích: Response time, Throughput, Failure rate

**So sánh Response Time:**

: So sánh thời gian phản hồi {#tbl:response-time}

| Metric | No Cache | With Redis | Cải thiện |
|---|---|---|---|
| Average | 47.81 ms | 8.66 ms | **5.5x nhanh hơn** |
| Minimum | 2.06 ms | 1.76 ms | 1.2x nhanh hơn |
| Median (p50) | 23.37 ms | 9.66 ms | **2.4x nhanh hơn** |
| p(90) | 119.49 ms | 15.67 ms | **7.6x nhanh hơn** |
| p(95) | 172.88 ms | 19.11 ms | **9x nhanh hơn** |
| Maximum | 627.15 ms | 60.73 ms | **10.3x nhanh hơn** |

Như thể hiện trong @tbl:response-time, Redis cache giúp giảm đáng kể thời gian phản hồi ở mọi percentile. Đặc biệt, percentile 95 giảm từ 172.88ms xuống 19.11ms — cải thiện gấp **9 lần**.

**So sánh Throughput:**

: So sánh throughput {#tbl:throughput}

| Metric | No Cache | With Redis | Cải thiện |
|---|---|---|---|
| Requests/sec | 196.8 | 248.5 | **+26.3%** |
| Total Requests | 7,918 | 12,468 | **+57.4%** |
| Iterations | 3,959 | 6,234 | **+57.4%** |

Throughput tăng 26% cho thấy hệ thống có thể xử lý nhiều yêu cầu hơn trong cùng một đơn vị thời gian khi sử dụng cache.

**So sánh Failure Rate:**

: So sánh tỷ lệ lỗi {#tbl:failure-rate}

| Metric | No Cache | With Redis |
|---|---|---|
| Failure Rate | 0.02% | **0.00%** |
| Failed Requests | 2 | 0 |
| Status 200 | 7,916 | 12,468 |

Redis cache không chỉ cải thiện hiệu năng mà còn loại bỏ hoàn toàn tỷ lệ lỗi.

### Đánh giá tác động của Redis caching

Từ kết quả benchmark, nhóm rút ra các nhận định sau:

**Về hiệu năng:**

- Redis cache giúp giảm thời gian phản hồi trung bình **5.5 lần**, từ 47.81ms xuống 8.66ms.
- 95% request có thời gian phản hồi dưới **19.11ms** khi có cache, so với **172.88ms** khi không có cache.
- Thời gian phản hồi tối đa giảm từ 627.15ms xuống 60.73ms — giảm **10 lần**.

**Về throughput:**

- Throughput tăng **26%**, từ 196.8 lên 248.5 requests/giây.
- Tổng số request được xử lý tăng **57%** trong cùng thời gian test.

**Về độ ổn định:**

- Tỷ lệ lỗi giảm từ 0.02% xuống **0%**.
- Cache giúp giảm tải cho database, tránh hiện tượng connection pool exhaustion.

## Đánh giá tổng quan

### Ưu điểm hệ thống

**Về kiến trúc:**

- Kiến trúc Microservices cho phép phát triển, triển khai và mở rộng độc lập từng service.
- Service discovery (Eureka) giúp các service tự động tìm kiếm nhau.
- Config Server giúp quản lý cấu hình tập trung, dễ dàng thay đổi mà không cần redeploy.

**Về hiệu năng:**

- Redis cache giúp cải thiện hiệu năng vượt trội (5.5x nhanh hơn).
- Connection pooling giúp quản lý kết nối database hiệu quả.
- Health checks đảm bảo chỉ chuyển tiếp request đến service sẵn sàng.

**Về bảo mật:**

- JWT và OAuth2 cung cấp cơ chế xác thực đa tầng.
- API Gateway kiểm soát tất cả request vào hệ thống.
- API Key bảo vệ giao tiếp nội bộ giữa các service.

**Về độ bền vững:**

- Circuit Breaker ngăn chặn cascade failure.
- Fallback cung cấp dữ liệu mặc định khi service lỗi.
- Docker health checks đảm bảo service sẵn sàng trước khi nhận request.

### Hạn chế

**Về kiến trúc:**

- Chưa implement distributed tracing (Jaeger, Zipkin).
- Chưa có centralized logging (ELK Stack).
- Chưa implement API versioning.

**Về hiệu năng:**

- Chưa test hiệu năng trên môi trường production thực tế.
- Chưa test với lượng user lớn (> 1000 concurrent users).
- Frontend chưa implement lazy loading và code splitting.

**Về bảo mật:**

- Chưa implement rate limiting tại API Gateway.
- Chưa implement HTTPS trong môi trường development.
- Chưa có cơ chế audit logging.

**Về DevOps:**

- Chưa có CI/CD pipeline.
- Chưa có monitoring (Prometheus, Grafana).
- Chưa có auto-scaling.

\newpage

# KẾT LUẬN & HƯỚNG PHÁT TRIỂN

## Kết quả đạt được

Qua quá trình nghiên cứu, thiết kế và hiện thực hóa, đồ án đã đạt được các kết quả sau:

**Về mặt kiến trúc:**

- Thiết kế và triển khai thành công hệ thống thương mại điện tử SmartVN với kiến trúc Microservices, bao gồm 7 microservices backend, 1 ứng dụng mobile Android native, và 2 ứng dụng frontend web.
- Triển khai đầy đủ các thành phần infrastructure: Eureka Server, Config Server, API Gateway.
- Áp dụng thành công mô hình giao tiếp liên dịch vụ với OpenFeign và Circuit Breaker (Resilience4j).

**Về mặt chức năng:**

- Hoàn thiện đầy đủ các chức năng nghiệp vụ: quản lý người dùng, quản lý sản phẩm, quản lý đơn hàng, thanh toán VNPay, và quản trị hệ thống.
- Tích hợp thành công thanh toán trực tuyến VNPay.
- Tích hợp xác thực OAuth2 với Google và GitHub.

**Về mặt hiệu năng:**

- Triển khai thành công hệ thống cache Redis với chiến lược TTL phù hợp.
- Kết quả benchmark: thời gian phản hồi trung bình giảm **5.5 lần**, throughput tăng **26%**, tỷ lệ lỗi giảm xuống **0%**.

**Về mặt triển khai:**

- Đóng gói toàn bộ hệ thống bằng Docker Compose với cơ chế health check và dependency ordering.

## Bài học kinh nghiệm

**Về kiến trúc Microservices:**

- Microservices mang lại nhiều lợi ích nhưng cũng tăng độ phức tạp. Cần cân nhắc kỹ khi lựa chọn kiến trúc phù hợp.
- Service discovery và centralized config là hai thành phần không thể thiếu.
- Circuit Breaker và Fallback là cơ chế quan trọng để đảm bảo tính bền vững.

**Về công nghệ:**

- Spring Boot và Spring Cloud cung cấp bộ công cụ mạnh mẽ cho Microservices.
- Redis là giải pháp cache hiệu quả, nhưng cần thiết kế chiến lược TTL phù hợp.
- Docker Compose giúp đơn giản hóa việc triển khai.

**Về quy trình phát triển:**

- Thiết kế API trước khi lập trình giúp giảm thiểu xung đột giữa các team.
- Kiểm thử tự động giúp phát hiện lỗi sớm.
- Tài liệu hóa quá trình phát triển giúp team mới dễ dàng tiếp cận dự án.

## Hướng phát triển

**Ngắn hạn:**

- Triển khai distributed tracing với Jaeger hoặc Zipkin.
- Thiết lập centralized logging với ELK Stack.
- Implement rate limiting tại API Gateway.
- Bổ sung API versioning.

**Trung hạn:**

- Triển khai CI/CD pipeline với GitHub Actions.
- Thiết lập monitoring với Prometheus và Grafana.
- Implement message queue (RabbitMQ, Kafka).
- Tối ưu frontend với lazy loading, code splitting và SSR.
- Nâng cấp ứng dụng Android: thêm chatbot AI, AR xem sản phẩm, barcode scanner.

**Dài hạn:**

- Triển khai trên Kubernetes.
- Implement auto-scaling dựa trên metrics.
- Tích hợp AI recommendation engine.
- Triển khai trên cloud provider (AWS, GCP, Azure).
- Phát triển phiên bản iOS (Swift/SwiftUI) và cross-platform (Flutter/React Native).
- Tích hợp ví điện tử (MoMo, ZaloPay) và Apple Pay / Google Pay.

\newpage

# TÀI LIỆU THAM KHẢO {-}

[1] Fowler, M. & Lewis, J. (2014). *Microservices: A definition of this new architectural term*. Martin Fowler's Blog.

[2] Richardson, C. (2018). *Microservices Patterns: With examples in Java*. Manning Publications.

[3] Spring Cloud Project. *Spring Cloud Documentation*. https://spring.io/projects/spring-cloud

[4] Spring Boot Project. *Spring Boot Reference Documentation*. https://docs.spring.io/spring-boot/docs/current/reference/html/

[5] Redis Ltd. (2024). *Redis Documentation*. https://redis.io/documentation

[6] Docker Inc. (2024). *Docker Documentation*. https://docs.docker.com/

[7] MySQL Developer. (2024). *MySQL 8.0 Reference Manual*. https://dev.mysql.com/doc/refman/8.0/en/

[8] JWT.io. *Introduction to JSON Web Tokens*. https://jwt.io/introduction

[9] VNPay. (2024). *VNPay API Documentation*. https://sandbox.vnpayment.vn/apis/

[10] Resilience4j. (2024). *Resilience4j Documentation*. https://resilience4j.readme.io/

[11] Grafana Labs. (2024). *k6 Documentation*. https://k6.io/docs/

[12] Netflix OSS. (2024). *Eureka Documentation*. https://github.com/Netflix/eureka

[13] OpenFeign. (2024). *Feign Documentation*. https://github.com/OpenFeign/feign

[14] Cloudinary. (2024). *Cloudinary SDK Documentation*. https://cloudinary.com/documentation

[15] Johnson, R. et al. (2023). *Spring Data JPA Reference Documentation*.

[16] Walls, C. (2022). *Spring Boot in Action* (2nd Edition). Manning Publications.

[17] Carnell, J. & Illarramendi, A. (2023). *Spring Microservices in Action* (2nd Edition). Manning Publications.

[18] Sharma, S. (2023). *Mastering Spring Boot 3.0*. Packt Publishing.

[19] Nguyen, T. (2024). *Xay dung he thong Microservices voi Spring Boot va Spring Cloud*. Dai hoc Bach khoa Ha Noi.

[20] Tran, V. (2024). *Kien truc Microservices: Thiet ke va trien khai*. NXB Giao duc Viet Nam.

\newpage

# PHỤ LỤC {-}

## Phân công công việc

: Bảng phân công công việc {#tbl:phan-cong}

| Thành viên | Nhiệm vụ | Tỷ lệ |
|---|---|---|
| Nguyễn Văn Sang | Thiết kế kiến trúc, User Service, API Gateway, Docker Compose, benchmark, viết báo cáo | 40% |
| Thành viên 2 | Product Service, Redis caching, Admin Service, Circuit Breaker | 30% |
| Thành viên 3 | Order Service, VNPay integration, Frontend, testing | 30% |

## Danh sách API Endpoints đầy đủ

: Danh sách đầy đủ API endpoints {#tbl:full-api}

| # | Method | Endpoint | Service | Auth |
|---|---|---|---|---|
| 1 | POST | /api/v1/auth/register | User | No |
| 2 | POST | /api/v1/auth/login | User | No |
| 3 | POST | /api/v1/auth/refresh | User | Cookie |
| 4 | POST | /api/v1/auth/logout | User | JWT |
| 5 | POST | /api/v1/auth/forgot-password | User | No |
| 6 | POST | /api/v1/auth/reset-password | User | No |
| 7 | GET | /api/v1/users/me | User | JWT |
| 8 | PUT | /api/v1/users/me | User | JWT |
| 9 | GET | /api/v1/users/{id} | User | JWT |
| 10 | GET | /api/v1/users | User | Admin |
| 11 | PUT | /api/v1/users/{id}/status | User | Admin |
| 12 | PUT | /api/v1/users/{id}/role | User | Admin |
| 13 | GET | /api/v1/users/me/addresses | User | JWT |
| 14 | POST | /api/v1/users/me/addresses | User | JWT |
| 15 | PUT | /api/v1/users/me/addresses/{id} | User | JWT |
| 16 | DELETE | /api/v1/users/me/addresses/{id} | User | JWT |
| 17 | POST | /api/v1/interactions | User | JWT |
| 18 | GET | /api/v1/products | Product | JWT |
| 19 | GET | /api/v1/products/{id} | Product | JWT |
| 20 | POST | /api/v1/products | Product | Admin |
| 21 | PUT | /api/v1/products/{id} | Product | Admin |
| 22 | DELETE | /api/v1/products/{id} | Product | Admin |
| 23 | GET | /api/v1/categories | Product | JWT |
| 24 | GET | /api/v1/categories/{id} | Product | JWT |
| 25 | POST | /api/v1/categories | Product | Admin |
| 26 | PUT | /api/v1/categories/{id} | Product | Admin |
| 27 | DELETE | /api/v1/categories/{id} | Product | Admin |
| 28 | GET | /api/v1/products/{id}/inventory | Product | JWT |
| 29 | POST | /api/v1/reviews | Product | JWT |
| 30 | GET | /api/v1/reviews/product/{id} | Product | JWT |
| 31 | POST | /api/v1/images/upload | Product | Admin |
| 32 | GET | /api/v1/cart | Order | JWT |
| 33 | POST | /api/v1/cart/items | Order | JWT |
| 34 | PUT | /api/v1/cart/items/{id} | Order | JWT |
| 35 | DELETE | /api/v1/cart/items/{id} | Order | JWT |
| 36 | POST | /api/v1/orders | Order | JWT |
| 37 | GET | /api/v1/orders | Order | JWT |
| 38 | GET | /api/v1/orders/{id} | Order | JWT |
| 39 | PATCH | /api/v1/orders/{id}/cancel | Order | JWT |
| 40 | PATCH | /api/v1/orders/{id}/status | Order | Admin |
| 41 | POST | /api/v1/payment/vnpay/create | Order | JWT |
| 42 | GET | /api/v1/payment/vnpay/callback | Order | No |
| 43 | GET | /api/v1/admin/dashboard | Admin | Admin |
| 44 | GET | /api/v1/admin/users/stats | Admin | Admin |
| 45 | GET | /api/v1/admin/products/stats | Admin | Admin |
| 46 | GET | /api/v1/admin/orders/stats | Admin | Admin |
| 47 | GET | /api/v1/admin/orders/revenue | Admin | Admin |
| 48 | GET | /internal/export/products | Admin | API Key |
| 49 | GET | /internal/export/interactions | Admin | API Key |
| 50 | GET | /internal/orders/export/interactions | Admin | API Key |

## Hướng dẫn chạy dự án

**Yêu cầu hệ thống:**

- Docker >= 20.10
- Docker Compose >= 2.0
- RAM >= 4GB (khuyến nghị 8GB)
- Disk >= 10GB trống

**Bước 1: Clone repository**

```bash
git clone https://github.com/simasangggg/smartvn-microservices.git
cd smartvn-microservices
```

**Bước 2: Cấu hình biến môi trường**

```bash
cp .env.example .env
# Chỉnh sửa file .env với các giá trị phù hợp
```

**Bước 3: Khởi động hệ thống**

```bash
DOCKER_BUILDKIT=1 docker compose build --parallel --progress=plain
docker compose up -d
docker compose ps
docker compose logs -f api-gateway
```

**Bước 4: Kiểm tra health**

```bash
curl http://localhost:8080/actuator/health  # API Gateway
curl http://localhost:8081/actuator/health  # User Service
curl http://localhost:8082/actuator/health  # Product Service
curl http://localhost:8083/actuator/health  # Order Service
curl http://localhost:8084/actuator/health  # Admin Service
curl http://localhost:8761/actuator/health  # Eureka Server
curl http://localhost:8888/actuator/health  # Config Server
```

**Bước 5: Truy cập hệ thống**

- Customer App: http://localhost:5173
- Admin Panel: http://localhost:5174
- Eureka Dashboard: http://localhost:8761
- Swagger UI: http://localhost:8081/swagger-ui.html

**Bước 6: Chenchmark (tùy chọn)**

```bash
brew install k6
TOKEN=$(curl -s -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"admin123"}' \
  | jq -r '.data.accessToken')
k6 run benchmark.js -e ACCESS_TOKEN=$TOKEN
k6 run test-no-cache.js -e ACCESS_TOKEN=$TOKEN
```

**Dừng hệ thống:**

```bash
docker compose down
docker compose down -v  # Reset database
docker system prune -f
```
