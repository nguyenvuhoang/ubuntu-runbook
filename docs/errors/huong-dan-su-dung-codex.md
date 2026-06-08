# Hướng dẫn sử dụng Codex

## Situation

Team cần một tài liệu hướng dẫn cách sử dụng Codex để hỗ trợ công việc kỹ thuật như:
- đọc source code
- phân tích lỗi
- refactor code
- tạo prompt cho task
- review thay đổi
- tạo Pull Request
- lưu kinh nghiệm sử dụng vào Ubuntu Runbook

## Error

Không có lỗi hệ thống. Đây là tài liệu hướng dẫn sử dụng công cụ.

## Root cause

Chưa có runbook chuẩn để team dùng Codex theo cùng một quy trình, dẫn đến cách giao việc, review và ghi nhận kết quả chưa thống nhất.

## Fix commands

Không có lệnh sửa lỗi. Dùng Codex theo quy trình sau:

1. Xác định mục tiêu task rõ ràng
   - Mô tả bối cảnh, repo, nhánh, file liên quan và kết quả mong muốn.
   - Nêu rõ phạm vi: đọc, phân tích, refactor, viết test, hay đề xuất PR.

2. Chuẩn bị prompt cho Codex
   - Cung cấp thông tin đủ để Codex hiểu task.
   - Chỉ rõ ràng buộc: kiến trúc hiện có, style guide, không đổi behavior nếu không cần.
   - Yêu cầu output cụ thể: tóm tắt, danh sách file, patch đề xuất, hoặc checklist.

3. Yêu cầu Codex đọc source và phân tích lỗi
   - Đưa log lỗi, bước tái hiện, file liên quan.
   - Yêu cầu Codex:
     - xác định nguyên nhân khả dĩ
     - chỉ ra vị trí code liên quan
     - đề xuất cách kiểm tra và hướng fix

4. Yêu cầu Codex sửa code
   - Nêu rõ không được phá vỡ kiến trúc hiện có.
   - Yêu cầu thay đổi nhỏ, có kiểm soát.
   - Ưu tiên:
     - sửa đúng nguyên nhân gốc
     - thêm/điều chỉnh test
     - giữ thay đổi tối thiểu

5. Review kết quả Codex tạo ra
   - Kiểm tra lại diff trước khi merge.
   - Xác nhận:
     - code có đúng yêu cầu không
     - có ảnh hưởng phụ không
     - có test phù hợp không
     - có vi phạm style hoặc security không

6. Tạo Pull Request an toàn
   - Tạo branch riêng cho task.
   - Đưa mô tả PR rõ ràng: mục tiêu, thay đổi chính, cách test, rủi ro.
   - Không đưa secrets, token, hoặc dữ liệu nhạy cảm vào PR description hay prompt.

7. Ghi lại kinh nghiệm vào Ubuntu Runbook
   - Sau khi hoàn tất, ghi lại:
     - prompt hiệu quả
     - lỗi thường gặp
     - cách review
     - lưu ý bảo mật
   - Giữ tài liệu ngắn gọn, dễ tái sử dụng.

## Verification commands

Không áp dụng. Có thể tự xác minh bằng cách:
- đọc lại nội dung runbook
- kiểm tra tính rõ ràng của quy trình
- rà soát bảo mật trước khi áp dụng cho task thực tế

## Notes

- Giả định đây là hướng dẫn nội bộ cho team kỹ thuật.
- Không có repo, môi trường, hay lệnh CLI cụ thể được cung cấp.
- Nếu dùng Codex với source code thật, chỉ chia sẻ thông tin cần thiết và đã được phép.
- Luôn review thủ công trước khi merge, kể cả khi Codex tạo thay đổi đúng.

## Tags

codex, tools, ai, developer, guide, github, pull-request, code-review, team