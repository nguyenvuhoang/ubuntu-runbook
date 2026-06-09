# OpenClaw Setup & Practice (Telegram + 3 AI Skills Demo)

## Overview
Runbook này hướng dẫn dựng **OpenClaw Gateway** (local hoặc VPS), kết nối **Telegram Bot**, và triển khai tối thiểu **1 skill/workflow chạy end-to-end**. Đồng thời cung cấp 3 bài demo mẫu:

- IELTS Study Assistant
- Office Excel Assistant
- Daily Tech News Assistant

Kiến trúc tổng quát:

User → Telegram/Dashboard → OpenClaw Gateway → Agent/LLM → Skill/Tool → Response

## When to use
- Workshop/hands-on để học cách dựng 1 AI Agent demo chạy thật qua Telegram.
- Cần môi trường demo ổn định (VPS 24/7) hoặc học nhanh (Local/WSL2).
- Cần khung chuẩn để thiết kế skill theo cấu trúc **SKILL.md**.

## Prerequisites
### Tài khoản / API
- Telegram account
- API key của 1 model provider (OpenAI / Anthropic / Google / Ollama…)
- (Tuỳ chọn) GitHub account nếu cần lưu code nội bộ

### Máy / VPS
- Node.js **24 khuyến nghị**
- Node.js **22.19+** vẫn hỗ trợ
- Quyền terminal/SSH

### Dữ liệu test (không dùng dữ liệu thật)
- File Excel giả lập (vd: `customers.xlsx`)
- Bài IELTS mẫu
- Danh sách chủ đề tin tức hoặc sample bài viết

### Security
- Không đưa token/API key lên slide, GitHub repo public, hoặc nhóm chat.
- Nếu thấy token xuất hiện trong file cấu hình/log, thay ngay.

## Steps

### 1) Chọn môi trường chạy (Local hoặc VPS)
**Local / WSL2**
- Dễ debug, xem log
- Không cần mở port public
- Tắt máy là agent dừng

**VPS Linux**
- Chạy 24/7, demo ổn định
- Cần SSH, update OS, firewall
- Không expose dashboard ra internet nếu chưa có bảo vệ

> Khuyến nghị khi học: dùng “môi trường trắng”, không có dữ liệu cá nhân.

---

### 2) Cài OpenClaw (Local)
#### 2.1 Kiểm tra Node
```bash
node --version
```

#### 2.2 Cài đặt
macOS / Linux / WSL2:
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

Windows PowerShell:
```powershell
iwr -useb https://openclaw.ai/install.ps1 | iex
```

#### 2.3 Checkpoint
Đảm bảo chạy được:
```bash
openclaw --version
```

---

### 3) Onboarding & kiểm tra Gateway/Dashboard
Chạy onboarding (có thể cài daemon):
```bash
openclaw onboard --install-daemon
```

Kiểm tra trạng thái gateway:
```bash
openclaw gateway status
```

Mở dashboard:
```bash
openclaw dashboard
```

Kiểm tra cấu hình/tình trạng hệ thống:
```bash
openclaw doctor
```

Ghi chú:
- Wizard sẽ hỏi model provider và API key.
- Dashboard local thường ở `127.0.0.1:18789`.

**Checkpoint:** `openclaw gateway status` trả về trạng thái running/listening và dashboard mở được.

---

### 4) Cài OpenClaw (VPS Ubuntu/Debian)
SSH vào VPS:
```bash
ssh user@<server-ip>
```

Update OS:
```bash
sudo apt update && sudo apt upgrade -y
```

Cài OpenClaw + onboarding:
```bash
curl -fsSL https://openclaw.ai/install.sh | bash
openclaw onboard --install-daemon
openclaw gateway status
```

Khuyến nghị vận hành VPS:
- Dùng user riêng cho OpenClaw (không dùng tài khoản production).
- Không mở dashboard public nếu chưa có reverse proxy + auth.
- Ưu tiên SSH tunnel hoặc VPN/Tailscale để vào dashboard.

**Checkpoint:** `openclaw gateway status` hiển thị gateway đang chạy.

---

### 5) Nắm vị trí config & workspace
Config chính:
- `~/.openclaw/openclaw.json`

Workspace học tập:
- `~/.openclaw/workspace`

Tạo thư mục demo:
```bash
mkdir -p ~/.openclaw/workspace/demo-data
mkdir -p ~/.openclaw/workspace/skills
```

Sau khi đổi config lớn, restart gateway:
```bash
openclaw gateway restart
```

Nguyên tắc:
- Mỗi bài thực hành nên có thư mục riêng để tránh lẫn dữ liệu.

---

### 6) Kết nối Telegram (BotFather → Gateway)
#### 6.1 Tạo bot và lấy token
- Mở Telegram → chat `@BotFather`
- Chạy `/newbot`
- Lưu bot token (secret)

#### 6.2 Cấu hình Telegram channel trong OpenClaw
Thêm vào `~/.openclaw/openclaw.json` (ví dụ cấu trúc, thay bằng placeholder):

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "<TELEGRAM_BOT_TOKEN>",
      "dmPolicy": "pairing"
    }
  }
}
```

> Không commit file config có token lên repo public.

Restart gateway sau khi đổi config:
```bash
openclaw gateway restart
```

---

### 7) Bảo mật Telegram (allowlist + group policy)
#### 7.1 DM an toàn (allowlist)
Chỉ cho phép một số Telegram user ID:

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "<TELEGRAM_BOT_TOKEN>",
      "dmPolicy": "allowlist",
      "allowFrom": ["<YOUR_TELEGRAM_USER_ID>"],
      "groupPolicy": "allowlist",
      "groups": {
        "<GROUP_CHAT_ID>": { "requireMention": true }
      }
    }
  }
}
```

Lưu ý:
- Group ID thường là số âm bắt đầu bằng `-100...`
- Với group, nên dùng `requireMention: true` để tránh bot “nghe nhầm” mọi tin nhắn.
- Tránh cấu hình “open/*” cho bot cá nhân.

---

### 8) Smoke test sau khi cấu hình Telegram
Checklist:

1) Gateway chạy?
```bash
openclaw gateway status
```

2) Dashboard mở?
```bash
openclaw dashboard
```

3) Token đúng?
- Nếu gọi API kiểu `getMe` mà trả `401` → token sai (tuỳ cách OpenClaw log/hiển thị).

4) User có quyền?
- Kiểm tra `allowFrom` hoặc cơ chế `pairing`.

5) Group có mention?
- Ping trong group: `@<bot_username> ...`

Quy tắc debug:
- Đọc log trước, sửa **1 lỗi mỗi lần**, restart gateway, test lại.

Xem log (nếu có):
```bash
openclaw logs --follow
```

---

### 9) Tạo skill: cấu trúc và nguyên tắc
Skill là một thư mục có file `SKILL.md`.

Ví dụ cấu trúc:
```
skills/
  office-excel-summary/
    SKILL.md
    examples/
    templates/
    output/
```

`SKILL.md` có YAML frontmatter:
- `name`
- `description`

Nguyên tắc skill tốt:
- Trigger rõ
- Phạm vi hẹp
- Output format cố định

---

### 10) Tạo skill đầu tiên (mini-report)
Tạo thư mục:
```bash
mkdir -p ~/.openclaw/workspace/skills/mini-report
```

Tạo file `~/.openclaw/workspace/skills/mini-report/SKILL.md` với nội dung:
```md
---
name: mini-report
description: Create a concise Vietnamese report.
---

When the user asks for a short report:
1. Identify input data and missing fields.
2. Ask one clarification if required.
3. Return: Summary, Key findings, Next actions.
```

Test prompt:
- “Hãy tạo báo cáo ngắn từ 5 dòng dữ liệu khách hàng giả lập này.”

**Checkpoint:** Agent trả về đúng 3 phần: `Summary` / `Key findings` / `Next actions`.

---

## Verification
### A) Verify nền tảng
- `openclaw --version` chạy được
- `openclaw gateway status` = running/listening
- Dashboard mở và gửi message nhận response

### B) Verify Telegram
- Bot trả lời đúng DM user allowlist hoặc flow pairing
- Trong group chỉ trả lời khi được mention (nếu bật `requireMention`)

### C) Verify skill
- Gọi prompt liên quan skill và output đúng format đã thiết kế
- Có thể lưu input/output demo trong `~/.openclaw/workspace/` để trình bày

## Common errors
### 1) Gateway không chạy / status không “running”
- Chạy:
```bash
openclaw doctor
openclaw logs --follow
```
- Kiểm tra Node version, quyền chạy daemon, cấu hình provider/API key.

### 2) Telegram bot không phản hồi
- Sai `botToken` → thường thấy lỗi 401 (tuỳ log)
- Chưa restart gateway sau khi đổi config:
```bash
openclaw gateway restart
```
- `dmPolicy`/`allowFrom` chặn user
- Group không mention bot khi `requireMention: true`

### 3) Output skill không đúng format
- SKILL.md trigger chưa rõ hoặc quá rộng
- Thiếu yêu cầu format trong phần mô tả
- Tách skill nhỏ hơn, giảm scope, cố định output

### 4) Rủi ro lộ secret
- Token/API key xuất hiện trong chat/log/screenshot
- Khắc phục: rotate token, thay bằng placeholder trong tài liệu, kiểm tra lại repo

## Notes
### 3 bài demo thực hành (mẫu nội dung để thiết kế skill)

#### Demo 1: IELTS Study Assistant
Mục tiêu: sửa bài writing, gợi ý rewrite, kế hoạch ôn tập.

Output format gợi ý:
1) Top 5 errors
2) Corrected version
3) Better phrases
4) 10-minute practice task

Demo prompt:
- "Bạn là IELTS Study Assistant. Hãy sửa bài Writing Task 2 này, chỉ ra 5 lỗi quan trọng và viết lại đoạn mở bài tốt hơn."

Tiêu chí pass:
- Dễ hiểu, lỗi cụ thể, rewrite không chung chung.

#### Demo 2: Office Excel Assistant
Mục tiêu: đọc dữ liệu giả lập, tóm tắt insight, gửi báo cáo.

Dataset mẫu: `demo-data/customers.xlsx`
- Columns: `CustomerName, Segment, Status, Amount, Note`

Yêu cầu:
- Đếm theo Status
- Tổng Amount theo Segment
- Top 3 khách hàng cần follow-up
- Báo cáo ngắn cho Telegram

Prompt test:
- "Đọc file demo-data/customers.xlsx, tạo báo cáo 5 dòng bằng tiếng Việt và đề xuất 3 hành động tiếp theo."

Tiêu chí pass:
- Có số liệu + nhận xét + next actions rõ.

#### Demo 3: Daily Tech News Assistant
Mục tiêu: tổng hợp tin theo chủ đề, tóm tắt gọn.

Report format gợi ý:
- `# Daily Tech Brief`
- 3–5 headlines, mỗi mục có Summary / Why it matters / Impact
- Kết thúc: 3 actions follow up

Demo prompt:
- "Tạo bản tin công nghệ sáng nay về AI Agent và cybersecurity, tối đa 5 mục, tiếng Việt."

Nếu chưa có web search:
- Dùng 3–5 bài viết mẫu trong `demo-data/news`.

### Guardrails (an toàn khi demo)
- Không dùng dữ liệu thật (Excel/IELTS/news đều dùng mock/sample)
- Không gửi secret qua chat hoặc commit repo public
- Không chạy lệnh nhạy cảm (xoá file, gọi shell, gửi email) nếu chưa có xác nhận
- Telegram nên dùng allowlist, group nên requireMention

Audit (nếu có):
```bash
openclaw security audit
openclaw security audit --deep
```

### Checklist demo cuối buổi
- Gateway status OK
- Telegram bot chỉ phản hồi đúng người được phép
- Có ít nhất 1 skill/workflow chạy end-to-end
- Có input mẫu và output report lưu lại
- Có slide/video ngắn mô tả flow: Vấn đề → Cách xử lý → Demo Telegram → Kết quả

### Command cheat sheet
```bash
# Install (macOS/Linux/WSL2)
curl -fsSL https://openclaw.ai/install.sh | bash

# Install (Windows PowerShell)
iwr -useb https://openclaw.ai/install.ps1 | iex

# Onboard & run
openclaw onboard --install-daemon
openclaw gateway status
openclaw dashboard
openclaw doctor

# Logs & security
openclaw logs --follow
openclaw security audit
```

## Tags
- OpenClaw
- Telegram
- Skills
- Gateway
- Workshop
