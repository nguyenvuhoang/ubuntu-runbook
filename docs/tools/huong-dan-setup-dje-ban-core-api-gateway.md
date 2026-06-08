##

# Hướng dẫn setup để bắn Core API Gateway

## Mục đích

Tài liệu này hướng dẫn cách setup và dùng Postman để bắn Core API Gateway, bao gồm các bước:

1. Tạo `accessToken` bằng API `CREATE_STATIC_TOKEN`.
2. Dùng `accessToken` để gọi `UMG_LOGIN` và lấy token core.
3. Dùng token core để gọi các API giao dịch.

> Lưu ý bảo mật: Không commit token thật, password thật, client secret thật hoặc thông tin tài khoản thật lên repository. Các giá trị nhạy cảm trong tài liệu cần được thay bằng placeholder như `<ACCESS_TOKEN>`, `<CLIENT_SECRET>`, `<CORE_TOKEN>`, `<LOGIN_NAME>`, `<ENCRYPTED_PASSWORD>`.

---

## 1. Chuẩn bị collection Postman

Đầu tiên cần có collection/API Postman dùng để bắn Core API Gateway.

Trong collection có các API thường dùng như:

- `UMG_LOGIN`
- `FUNC_CREDIT_INQUIRY`
- `FUNC_CREDIT_INQUIRY_VIA_DD`
- `FUNC_CHECK_STATUS`
- `FUNC_REPAYEMENT_LOAN_GL`
- `FUNC_REPAYEMENT_LOAN_GL_DD`
- `CREATE_STATIC_TOKEN`
- `REFRESH_STATIC_TOKEN`

---

## 2. Gọi `CREATE_STATIC_TOKEN` để tạo access token

Chọn API `CREATE_STATIC_TOKEN` trong Postman.

Tại tab **Body**, nhập thông tin `clientId`, `clientSecret`, `scopes`.

```json
{
  "clientId": "api-thuong",
  "clientSecret": "<CLIENT_SECRET>",
  "scopes": [
    "GET_INFO",
    "FO"
  ]
}
```

Bấm **Send**.

Kết quả trả về sẽ có dạng:

```json
{
  "accessToken": "<ACCESS_TOKEN>",
  "refreshToken": "<REFRESH_TOKEN>",
  "expiredAt": "2025-11-10T09:31:28.0763409Z",
  "expiredDuration": 604799
}
```

Copy value của `accessToken` để dùng ở bước tiếp theo.

---

## 3. Gọi `UMG_LOGIN` để login vào core

Chọn API `UMG_LOGIN` trong Postman.

Tại tab **Authorization**:

- Type: `Bearer Token`
- Token: dán `accessToken` vừa tạo ở bước trên

Tại tab **Body**, nhập thông tin tài khoản core gồm `login_name` và `password` đã mã hóa.

```json
{
  "workflow_id": "COREAPI_LOGIN",
  "data": {
    "login_name": "<LOGIN_NAME>",
    "password": "<ENCRYPTED_PASSWORD>"
  }
}
```

Bấm **Send**.

Kết quả trả về sẽ có dạng:

```json
{
  "workflow_id": "COREAPI_LOGIN",
  "data": {
    "expired_duration": "604799",
    "expired_in": "2025-11-10T09:49:04.6647479Z",
    "refresh_token": "<REFRESH_TOKEN>",
    "session": "<SESSION_ID>",
    "token": "<CORE_TOKEN>",
    "working_date": "28/05/2027"
  },
  "error": null
}
```

Copy value của `token`. Đây là token core dùng để bắn các API giao dịch.

---

## 4. Bắn API giao dịch

Chọn giao dịch cần bắn, ví dụ:

```text
FUNC_REPAYEMENT_LOAN_GL_DD
```

Tại tab **Headers**, dán value `token` vừa lấy được vào param:

```text
UID: <CORE_TOKEN>
```

Tại tab **Body**, nhập các field cần thiết của giao dịch.

Ví dụ:

```json
{
  "workflow_id": "COREAPI_FUNC",
  "data": {
    "transaction_code": "FUNC_REPAYEMENT_LOAN_GL_DD",
    "end_to_end": "eb1bc19e-27f7-4f22-97a5-48563eb09ecf",
    "fields": {
      "AccountNumber": "00010212001041153",
      "Amount": 10,
      "ReceiptNo": "456455554",
      "Description": "BEN TEST1 - Fund transfer Deposit to Accounting",
      "TRANSACTIONREF": "88866612233222230"
    }
  }
}
```

Bấm **Send**.

---

## 5. Kiểm tra kết quả giao dịch

Nếu giao dịch thành công, response sẽ có dạng:

```json
{
  "workflow_id": "COREAPI_FUNC",
  "data": {
    "error_code": 0,
    "error_description": "Transaction successfully!",
    "error_name": "TRANSACTION_SUCCESSFULLY",
    "error_source": "CBGW",
    "execution_id": null,
    "result": {
      "TransactionNumber": "270528000000836200",
      "Description": "BEN TEST1 - Fund transfer Deposit to Accounting",
      "TRANSACTIONREF": "88866612233222230",
      "Amount": 10,
      "TransactionCode": "API_GLDD",
      "GLAccount": "00010217110010",
      "TransactionDate": "28/05/2027 16:57:55",
      "AccountNumber": "00010212001041153"
    },
    "txbody": {
      "glaccount": "00010217110010",
      "description": "BEN TEST1 - Fund transfer Deposit to Accounting",
      "accountnumber": "00010212001041153",
      "amount": 10
    },
    "dataset": null
  },
  "error": null
}
```

Các field cần kiểm tra:

- `data.error_code`: bằng `0` là thành công.
- `data.error_name`: ví dụ `TRANSACTION_SUCCESSFULLY`.
- `data.error_description`: mô tả kết quả giao dịch.
- `data.result.TransactionNumber`: số giao dịch sinh ra từ core.
- `error`: bằng `null` là không có lỗi cấp wrapper/API.

---

## Quy trình tóm tắt

```text
CREATE_STATIC_TOKEN
        ↓
Lấy accessToken
        ↓
UMG_LOGIN bằng Bearer accessToken
        ↓
Lấy token core
        ↓
Gắn token core vào header UID
        ↓
Bắn API giao dịch
        ↓
Kiểm tra error_code, error_name, result
```

---

## Troubleshooting

### Không gọi được `UMG_LOGIN`

Kiểm tra lại:

- `accessToken` đã được dán đúng vào tab Authorization chưa.
- Authorization type có phải `Bearer Token` không.
- `accessToken` có hết hạn chưa.
- Body có đúng `workflow_id = COREAPI_LOGIN` không.

### Bắn giao dịch bị lỗi token/session

Kiểm tra lại:

- Header `UID` đã có token core chưa.
- Token lấy từ response của `UMG_LOGIN`, không phải `accessToken` của `CREATE_STATIC_TOKEN`.
- Token core có hết hạn chưa.

### Giao dịch trả lỗi nghiệp vụ

Kiểm tra lại:

- `transaction_code` có đúng không.
- Các field trong `data.fields` có đủ và đúng format không.
- Account, amount, transaction reference có hợp lệ không.
- Xem `error_code`, `error_name`, `error_description` để xác định lỗi nghiệp vụ.

### Tags

`core-api-gateway`, `postman`, `api`, `token`, `core`, `transaction`, `backend`, `tools`

### Tags

core-api-gateway, postman, api, token, core, transaction, backend, tools