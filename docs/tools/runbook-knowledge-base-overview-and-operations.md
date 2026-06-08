# Runbook Knowledge Base (MkDocs) - Tổng quan & quy trình vận hành

## Overview
Runbook Knowledge Base là hệ thống tài liệu nội bộ để lưu trữ, tra cứu và chia sẻ:

- Lệnh vận hành/hardening server (Ubuntu)
- Docker
- Nginx
- Cloudflare
- SQL Server
- Git
- Troubleshooting (Errors)
- Các công cụ kỹ thuật khác (Tools)

Mục tiêu: tập trung hoá toàn bộ kinh nghiệm xử lý sự cố (từ chat, terminal history, note cá nhân, screenshot, tin nhắn...) về một nơi duy nhất, có thể search nhanh, dễ cập nhật và dễ chia sẻ cho team.

Hệ thống sử dụng:

- GitHub Repository để quản lý source
- Markdown để viết tài liệu
- MkDocs Material để build website (UI đẹp + search)
- Docker + Nginx để host website (serve static)
- Cloudflare để public domain cho team truy cập
- GitHub Issues làm kênh team gửi nội dung
- GitHub Actions + OpenAI API để chuyển issue thành tài liệu Markdown
- Self-hosted GitHub Runner trên server để tự động deploy khi merge

## When to use
Dùng runbook này khi bạn cần:

- Nắm kiến trúc và luồng hoạt động của hệ thống Runbook Knowledge Base
- Thực hiện deploy/update website tài liệu
- Hướng dẫn team đóng góp nội dung qua GitHub Issue và quy trình review/merge
- Troubleshoot các điểm hay lỗi trong luồng issue → PR → merge → deploy

## Prerequisites
- GitHub repo của runbook (ví dụ: `ubuntu-runbook`)
- MkDocs Material đã cấu hình trong repo
- Docker + Docker Compose trên server chạy web
- Nginx (thường chạy dưới dạng container hoặc reverse proxy)
- GitHub Actions workflows trong repo
- OpenAI API key được cấu hình dưới dạng GitHub Actions Secret (ví dụ: `${OPENAI_API_KEY}`)
- Self-hosted GitHub Runner đã đăng ký với repo/org và online
- (Tuỳ chọn) Cloudflare domain + cấu hình Access nếu cần giới hạn truy cập

> Lưu ý bảo mật: Không commit secrets vào repo. Chỉ lưu trong GitHub Secrets/Runner secrets. Nếu có giá trị nhạy cảm, dùng placeholder như `<OPENAI_API_KEY>`.

## Steps

### 1) Luồng đóng góp nội dung (Issue → AI → Pull Request)
1. Team member tạo GitHub Issue theo form chuẩn (khuyến nghị có các trường):
   - Category
   - Topic title
   - Situation
   - Error message
   - Commands used to fix
   - Verification commands
   - Final result
   - Tags
2. Gắn label `ai-note` cho issue để kích hoạt workflow.
3. GitHub Actions sẽ:
   - Đọc nội dung issue
   - Gửi nội dung sang OpenAI API
   - Sinh file Markdown theo format runbook
   - Tự động cập nhật `mkdocs.yml` để add nav entry
   - Tạo Pull Request để maintainer review
4. Maintainer review, chỉnh sửa nếu cần, rồi merge PR vào `main`.

### 2) Luồng deploy tự động (Merge → Runner → Build → Restart)
Khi PR được merge vào `main`, workflow deploy chạy trên self-hosted runner (server) và thực hiện (theo thiết kế hiện tại):

```bash
cd /opt/apps/ubuntu-runbook
git pull origin main
source .venv/bin/activate
mkdocs build
docker compose restart ubuntu-runbook
```

Giải thích ngắn:
- `git pull`: lấy nội dung docs mới
- `mkdocs build`: build static site (thường ra thư mục `site/`)
- `docker compose restart ...`: reload container để Nginx serve bản mới

### 3) Kiến trúc tổng thể (tóm tắt)
- Team member
  → Create GitHub Issue
  → Add label `ai-note`
  → GitHub Actions
  → OpenAI API generates Markdown
  → Create Pull Request
  → Maintainer reviews and merges
  → GitHub Actions deploy workflow
  → Self-hosted runner on server
  → MkDocs build
  → Docker Nginx serves static website
  → Team truy cập website Runbook Knowledge Base

### 4) Vận hành category và nội dung
Các category hiện có (khuyến nghị giữ consistent với cấu trúc `docs/`):
- Ubuntu
- Docker
- Nginx
- Cloudflare
- SQL Server
- Git
- Errors
- Tools
- Templates

Khuyến nghị quy ước:
- File name: lowercase kebab-case
- Mỗi bài theo format runbook chuẩn (Overview/When to use/Prerequisites/Steps/Verification/Common errors/Notes/Tags)
- Commands phải copy-paste friendly

### 5) Kế hoạch mở rộng (định hướng)
- Gắn domain chính thức qua Cloudflare (ví dụ: `runbook.<domain>`)
- Bật Cloudflare Access để chỉ team được truy cập
- Bổ sung nhiều tài liệu thực tế từ các lỗi đã xử lý
- Chuẩn hoá quy trình tạo issue đóng góp
- Mở rộng category (ví dụ: IIS, Next.js, Oracle, Redis, RabbitMQ, ...)
- Viết hướng dẫn sử dụng cho team ngay trên site
- Theo dõi chất lượng PR do AI tạo trước khi merge

## Verification

### 1) Verify website sau khi merge
- Truy cập URL nội bộ/production của runbook và:
  - Search thấy bài mới
  - Menu/nav có entry mới
  - Nội dung hiển thị đúng định dạng

### 2) Verify workflow chạy thành công
- Vào GitHub Actions:
  - Workflow tạo PR (issue → PR) có status success
  - Workflow deploy (sau merge) có status success
- Trên server (nếu có quyền):
  - Runner online
  - Container `ubuntu-runbook` đang running

Ví dụ lệnh kiểm tra container:
```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

## Common errors

### 1) Issue đã gắn `ai-note` nhưng không tạo PR
Nguyên nhân thường gặp:
- Workflow không trigger do thiếu permission
- Thiếu/ sai GitHub Secrets (OpenAI API key)
- Template issue thiếu dữ liệu tối thiểu làm prompt quá mơ hồ

Cách xử lý:
- Check log GitHub Actions job
- Xác nhận secret tồn tại (ví dụ `OPENAI_API_KEY`)
- Thử tạo lại issue với đầy đủ trường

### 2) PR đã merge nhưng website không cập nhật
Nguyên nhân thường gặp:
- Self-hosted runner offline
- Workflow deploy fail
- `mkdocs build` fail do lỗi syntax/links
- Docker container restart không thành công

Cách xử lý:
- Check GitHub Actions deploy logs
- Kiểm tra runner status
- Trên server, chạy lại các lệnh deploy thủ công (nếu được phép):

```bash
cd /opt/apps/ubuntu-runbook
git pull origin main
source .venv/bin/activate
mkdocs build
docker compose restart ubuntu-runbook
```

### 3) Build MkDocs lỗi
Nguyên nhân thường gặp:
- `mkdocs.yml` nav trỏ sai đường dẫn file
- Duplicate nav entry
- Markdown có lỗi cú pháp plugin/extension

Cách xử lý:
- Chạy `mkdocs build` để xem error cụ thể
- Sửa đường dẫn trong `mkdocs.yml` cho khớp cấu trúc `docs/`

## Notes
- Mô hình issue → AI → PR giúp team không cần rành Markdown/MkDocs nhưng vẫn đóng góp được.
- Luôn review PR trước khi merge để đảm bảo chất lượng và tránh đưa nội dung nhạy cảm vào kho.
- Không lưu credential trong tài liệu. Nếu cần hướng dẫn cấu hình, dùng placeholder như:
  - `<OPENAI_API_KEY>`
  - `<CLOUDFLARE_API_TOKEN>`
  - `<DOMAIN>`

## Tags
- mkdocs
- runbook
- knowledge-base
- github-actions
- self-hosted-runner
- docker
- nginx
- cloudflare
- openai
