# Backup SQL Server trên Ubuntu

## Khi nào dùng?

Dùng khi SQL Server được cài trực tiếp trên Ubuntu bằng `mssql-server.service`, không phải chạy trong Docker.

Tình huống thường gặp:

```bash
sudo docker exec -u root sqlserver mkdir -p /var/opt/mssql/backup
```

Bị lỗi:

```txt
Error response from daemon: No such container: sqlserver
```

Nguyên nhân là server không có container tên `sqlserver`. Cần kiểm tra SQL Server đang chạy bằng systemd.

---

## 1. Kiểm tra SQL Server chạy trực tiếp trên Ubuntu

```bash
sudo systemctl status mssql-server --no-pager
```

Nếu thấy:

```txt
Active: active (running)
```

thì backup theo kiểu SQL Server Linux native, không dùng `docker exec`.

Kiểm tra port 1433:

```bash
sudo ss -tulpn | grep 1433
```

Kiểm tra `sqlcmd`:

```bash
ls /opt/mssql-tools18/bin/sqlcmd
ls /opt/mssql-tools/bin/sqlcmd
```

---

## 2. Tạo thư mục backup

```bash
sudo mkdir -p /backup/sqlserver
sudo chown -R mssql:mssql /backup/sqlserver
sudo chmod 755 /backup/sqlserver
```

---

## 3. Nhập SA password

```bash
read -s -p "SA Password: " SA_PASSWORD
echo
```

Không gõ password trực tiếp vào command để tránh lộ trong history.

---

## 4. Test kết nối SQL Server

```bash
/opt/mssql-tools18/bin/sqlcmd \
  -S 127.0.0.1,1433 \
  -U sa \
  -P "$SA_PASSWORD" \
  -C \
  -Q "SELECT @@VERSION;"
```

Nếu server dùng tool cũ thì đổi:

```bash
/opt/mssql-tools/bin/sqlcmd
```

---

## 5. Xem danh sách database user

```bash
/opt/mssql-tools18/bin/sqlcmd \
  -S 127.0.0.1,1433 \
  -U sa \
  -P "$SA_PASSWORD" \
  -C \
  -Q "SELECT name, state_desc FROM sys.databases WHERE database_id > 4;"
```

---

## 6. Backup tất cả database ONLINE

```bash
/opt/mssql-tools18/bin/sqlcmd \
  -S 127.0.0.1,1433 \
  -U sa \
  -P "$SA_PASSWORD" \
  -C \
  -b <<'SQL'
DECLARE @name sysname;
DECLARE @file nvarchar(500);
DECLARE @sql nvarchar(max);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE database_id > 4
  AND state_desc = 'ONLINE';

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @file = N'/backup/sqlserver/'
              + @name
              + N'_'
              + CONVERT(varchar(8), GETDATE(), 112)
              + N'_'
              + REPLACE(CONVERT(varchar(8), GETDATE(), 108), ':', '')
              + N'.bak';

    SET @sql = N'BACKUP DATABASE ' + QUOTENAME(@name)
             + N' TO DISK = N''' + @file + N''''
             + N' WITH INIT, COMPRESSION, CHECKSUM, STATS = 10;';

    PRINT @sql;
    EXEC (@sql);

    FETCH NEXT FROM db_cursor INTO @name;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
SQL
```

---

## 7. Kiểm tra file backup

```bash
ls -lh /backup/sqlserver/
```

File backup sẽ có dạng:

```txt
DatabaseName_YYYYMMDD_HHMMSS.bak
```

---

## 8. Verify toàn bộ file `.bak`

```bash
for f in /backup/sqlserver/*.bak; do
  echo "VERIFY: $f"
  /opt/mssql-tools18/bin/sqlcmd \
    -S 127.0.0.1,1433 \
    -U sa \
    -P "$SA_PASSWORD" \
    -C \
    -Q "RESTORE VERIFYONLY FROM DISK = N'$f';"
done
```

Kết quả đúng:

```txt
The backup set on file 1 is valid.
```

---

## 9. Nén backup thành một file

```bash
cd /backup/sqlserver
sudo tar -czvf o24_sqlserver_backup_$(date +%Y%m%d_%H%M%S).tar.gz *.bak
ls -lh
```

Đổi quyền để dễ copy ra ngoài:

```bash
sudo chmod 644 /backup/sqlserver/*.tar.gz
```

---

## 10. Copy file backup về Windows bằng SCP

Lưu ý: lệnh `scp` để tải về ổ `D:\Backup` phải chạy trên máy Windows, không chạy bên trong SSH session của Ubuntu server.

Trên Windows PowerShell:

```powershell
mkdir D:\Backup
scp jits@SERVER_IP:/backup/sqlserver/o24_sqlserver_backup_YYYYMMDD_HHMMSS.tar.gz D:/Backup/
```

Nếu dùng Git Bash trên Windows:

```bash
scp jits@SERVER_IP:/backup/sqlserver/o24_sqlserver_backup_YYYYMMDD_HHMMSS.tar.gz /d/Backup/
```

Nếu SSH dùng port khác 22:

```powershell
scp -P 2222 jits@SERVER_IP:/backup/sqlserver/o24_sqlserver_backup_YYYYMMDD_HHMMSS.tar.gz D:/Backup/
```

---

## Lỗi thường gặp

### No such container: sqlserver

```txt
Error response from daemon: No such container: sqlserver
```

Kiểm tra lại:

```bash
sudo docker ps | grep -i sql
sudo systemctl status mssql-server --no-pager
```

Nếu `mssql-server.service` đang active thì dùng hướng dẫn backup native Ubuntu ở trên.

### Could not resolve hostname d

```txt
ssh: Could not resolve hostname d: Temporary failure in name resolution
```

Nguyên nhân: chạy lệnh `scp ... D:\Backup` ngay trên Ubuntu server. Ubuntu không hiểu ổ Windows `D:`.

Cách đúng: chạy lệnh `scp` trên máy Windows cần nhận file.

### Could not resolve hostname ip_server

```txt
ssh: Could not resolve hostname ip_server
```

Nguyên nhân: chưa thay `IP_SERVER` hoặc `SERVER_IP` bằng IP/domain thật.

Lấy IP server:

```bash
hostname -I
```

Hoặc nếu cần IP public:

```bash
curl ifconfig.me
```

---

## Ghi chú vận hành

- Backup nên lưu ra khỏi server chính sau khi tạo xong.
- Luôn chạy `RESTORE VERIFYONLY` để kiểm tra file `.bak`.
- Không nên lưu SA password trong script plain text nếu không có bảo vệ quyền file.
- Với production, nên có lịch backup tự động và chính sách retention.

## Tags

`sqlserver`, `mssql`, `ubuntu`, `backup`, `restore-verifyonly`, `scp`
