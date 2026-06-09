# Danh sách tài nguyên thiết kế Store (App Store & Google Play)

## Overview
Tài liệu này liệt kê các tài nguyên hình ảnh cần chuẩn bị để gửi ứng dụng lên **Apple App Store** và **Google Play Store**. Bao gồm: tài nguyên bắt buộc/tùy chọn, số lượng khuyến nghị, kích thước và ghi chú thiết kế để bàn giao cho đội thiết kế/marketing.

## When to use
- Trước khi **submit app** lên App Store / Google Play.
- Khi **bàn giao tài nguyên** cho team thiết kế hoặc team release.
- Khi cần chuẩn hóa checklist asset để tránh bị từ chối hoặc listing thiếu chuyên nghiệp.

## Prerequisites
- Đã chốt **tên ứng dụng, logo, màu thương hiệu, font**, nội dung marketing chính.
- Có bản build/app UI ổn định để chụp screenshot.
- Có guideline nội bộ (nếu có) về branding.

## Steps

### 1) Chuẩn bị asset cho Apple App Store (iOS)

| Tài nguyên | Trạng thái | Số lượng / Yêu cầu | Thông số | Ghi chú |
|---|---|---:|---|---|
| Biểu tượng ứng dụng | Bắt buộc | 1 file | 1024 x 1024 px, PNG | Dùng làm biểu tượng ứng dụng trên App Store. Không nền trong suốt. |
| Screenshot iPhone | Bắt buộc | Tối thiểu: 1; Khuyến nghị: 5; Tối đa: 10 | Khuyến nghị: 1290 x 2796 px | Mockup/khung thiết bị là tùy chọn nhưng khuyến nghị. Cho phép thêm text marketing. |
| Screenshot iPad | Tùy chọn | Khuyến nghị: 3 | Khuyến nghị: 2064 x 2752 px | Dùng nếu app hỗ trợ iPad hoặc muốn listing đầy đủ hơn. |
| Video xem trước (App Preview) | Tùy chọn | Theo giới hạn của store | Tối đa: 30 giây; phải khớp kích thước screenshot | Hữu ích để trình bày luồng app; không bắt buộc khi gửi app. |

**Ghi chú thiết kế (Apple)**
- Mockup/khung thiết bị: **tùy chọn nhưng nên có** để trình bày chỉn chu.
- Có thể thêm **text marketing**, nhưng **không được mô tả sai** tính năng.
- Tránh đặt nội dung quan trọng gần **tai thỏ**, **góc bo tròn**, **mép màn hình**.
- Chỉ sử dụng **PNG/JPG**; tránh **nền trong suốt** cho screenshot store cuối cùng.

---

### 2) Chuẩn bị asset cho Google Play Store

| Tài nguyên | Trạng thái | Số lượng / Yêu cầu | Thông số | Ghi chú |
|---|---|---:|---|---|
| Biểu tượng ứng dụng | Bắt buộc | 1 file | 512 x 512 px, PNG | Biểu tượng chính cho store listing. |
| Feature Graphic / Banner lớn | Khuyến nghị | 1 file | 1024 x 500 px | **Bắt buộc nếu dùng video quảng bá**. Rất khuyến nghị để listing chuyên nghiệp. |
| Screenshot điện thoại | Bắt buộc | Tối thiểu: 2; Khuyến nghị: 5; Tối đa: 8 | Khuyến nghị: 1080 x 1920 px | Mockup/khung thiết bị là tùy chọn nhưng khuyến nghị. Cho phép thêm text marketing. |
| Screenshot tablet | Tùy chọn | Tùy chọn | Dùng kích thước screenshot tablet được store hỗ trợ | Chuẩn bị khi app tối ưu tablet hoặc muốn listing đầy đủ. |
| Video quảng bá | Tùy chọn | 1 link YouTube | Chỉ hỗ trợ link YouTube | Nếu dùng video, Feature Graphic là bắt buộc để làm ảnh cover. |

**Ghi chú thiết kế (Google Play)**
- Giữ nội dung quan trọng ở **giữa Feature Graphic** vì Google có thể crop ở nhiều vị trí hiển thị.
- Tránh đặt logo/text **quá sát mép**.
- Feature Graphic thường gồm: **logo app**, **slogan ngắn**, **mockup thiết bị**, **nền thương hiệu**.
- Chỉ sử dụng **PNG/JPG**; tránh **nền trong suốt** cho screenshot cuối cùng.

---

### 3) Khuyến nghị phong cách thiết kế (áp dụng chung)

**Nên**
- Dùng nền hiện đại/sạch: màu đơn, gradient nhẹ hoặc pattern thương hiệu.
- Headline lớn, dễ đọc; mỗi screenshot tập trung **1 thông điệp chính**.
- Dùng mockup thiết bị nếu giúp tăng chất lượng trình bày và tính nhất quán.
- Giữ đồng nhất spacing, typography, màu sắc và branding trên mọi asset.

**Tránh**
- Screenshot thô chưa layout/xử lý hình ảnh (trừ khi có yêu cầu cụ thể).
- Quá nhiều chữ hoặc font quá nhỏ.
- Layout rối vì cố nhồi nhiều tính năng trong một hình.
- Đặt text/logo quan trọng gần mép, tai thỏ hoặc góc bo tròn.

## Verification
- [ ] App Store: Có **app icon 1024x1024** và tối thiểu **1 screenshot iPhone** (khuyến nghị 5).
- [ ] Google Play: Có **app icon 512x512** và tối thiểu **2 screenshot điện thoại** (khuyến nghị 5).
- [ ] Nếu có video Google Play: đã có **Feature Graphic 1024x500**.
- [ ] Tất cả ảnh xuất **PNG/JPG**, không nền trong suốt cho screenshot cuối.
- [ ] Text/CTA không sai lệch tính năng; nội dung quan trọng không nằm sát mép/tai thỏ.

## Common errors
- Dùng sai kích thước khuyến nghị dẫn tới hình bị crop/xấu trên store.
- Screenshot có nền trong suốt hoặc xuất format không phù hợp.
- Text/logo đặt sát mép, bị cắt trên nhiều thiết bị/khung hiển thị.
- Feature Graphic thiếu hoặc thiết kế không safe-area (đặc biệt khi Google crop).
- Nội dung marketing mô tả quá mức tính năng → rủi ro bị từ chối.

## Notes
- Link tham khảo chính thức:
  - Apple Screenshot Specifications: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/
  - Google Play Store Listing Assets: https://support.google.com/googleplay/android-developer/answer/9866151
  - Google Play Graphic Assets: https://support.google.com/googleplay/android-developer/answer/1078870

## Tags
- app-store
- google-play
- store-listing
- design-assets
- screenshots
- feature-graphic
