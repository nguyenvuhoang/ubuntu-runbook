# Hướng dẫn setup để bắn Core API Gateway

## Situation

Team cần một runbook hướng dẫn setup và sử dụng Postman để gọi Core API Gateway, bao gồm:

1. Tạo `accessToken` bằng API `CREATE_STATIC_TOKEN`.
2. Dùng `accessToken` để gọi `UMG_LOGIN` và lấy token core.
3. Gắn token core vào header `UID` và bắn API giao dịch.

## Error

Không có lỗi cụ thể. Đây là tài liệu thao tác setup và gọi API.

## Root cause

Chưa có runbook Markdown trong repository cho quy trình dùng Postman để bắn Core API Gateway. Tài liệu gốc nằm trong PDF và cần được chuyển sang Markdown để đưa vào:

```text
docs/tools/core-api-gateway.md
```

## Fix commands

Không áp dụng. Đây là thao tác biên soạn tài liệu, không phải xử lý sự cố hệ thống.

## Verification commands

Không áp dụng.

## Notes

- Các giá trị như `clientSecret`, `login_name`, `password`, token thật, account thật phải được bảo vệ và không commit lên repository công khai.
- Ví dụ JSON trong tài liệu chỉ mang tính minh họa; cần thay bằng biến môi trường hoặc secret nội bộ khi thao tác thực tế.
- Nếu collection Postman hoặc field request thực tế khác với ví dụ, cần cập nhật theo tài liệu nội bộ của hệ thống.

## Tags

`core-api-gateway`, `postman`, `api`, `token`, `core`, `transaction`, `backend`, `tools`