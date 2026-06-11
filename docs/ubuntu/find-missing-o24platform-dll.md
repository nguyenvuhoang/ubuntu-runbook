# Tìm nhanh folder chưa có O24Platform.dll

## Khi nào dùng?

Dùng khi trên server Ubuntu có nhiều thư mục service dạng `emi-*` như:

```txt
emi-act
emi-cbg
emi-cms
emi-cth
emi-dts
emi-dwh
emi-log
emi-nch
emi-rpt
emi-stl
emi-wfo
```

và cần kiểm tra nhanh service nào chưa có file `O24Platform.dll` sau khi publish/build source.

---

## Vào thư mục cha chứa các service

Ví dụ:

```bash
cd /App/backend
```

Hoặc vào đúng thư mục đang chứa các folder `emi-*`.

---

## Kiểm tra folder nào chưa có O24Platform.dll

Lệnh này sẽ quét toàn bộ bên trong từng thư mục `emi-*`:

```bash
for d in emi-*; do
  [ -d "$d" ] || continue

  found=$(find "$d" -type f -iname "O24Platform.dll" -print -quit 2>/dev/null)

  if [ -z "$found" ]; then
    echo "MISSING: $d"
  else
    echo "OK:      $d -> $found"
  fi
done
```

Kết quả ví dụ:

```bash
OK:      emi-cbg -> emi-cbg/publish/O24Platform.dll
MISSING: emi-cms
OK:      emi-cth -> emi-cth/publish/O24Platform.dll
MISSING: emi-wfo
```

---

## Nếu DLL bắt buộc nằm trong thư mục publish

Dùng lệnh này để kiểm tra đúng đường dẫn `$service/publish/O24Platform.dll`:

```bash
for d in emi-*; do
  [ -d "$d" ] || continue

  if [ ! -f "$d/publish/O24Platform.dll" ]; then
    echo "MISSING: $d/publish/O24Platform.dll"
  else
    echo "OK:      $d/publish/O24Platform.dll"
  fi
done
```

---

## Xem toàn bộ vị trí đang có O24Platform.dll

```bash
find . -type f -iname "O24Platform.dll" 2>/dev/null
```

---

## Chỉ hiện danh sách folder bị thiếu

```bash
for d in emi-*; do
  [ -d "$d" ] || continue
  find "$d" -type f -iname "O24Platform.dll" -print -quit 2>/dev/null | grep -q . || echo "$d"
done
```

---

## Ghi chú

- Nếu service đang chạy bằng Docker nhưng folder publish thiếu DLL, cần kiểm tra lại bước build/publish image.
- Nếu file tồn tại ở folder khác nhưng không nằm trong `publish`, Dockerfile có thể copy sai path.
- Nếu quyền đọc bị lỗi, chạy lại bằng `sudo`:

```bash
sudo find . -type f -iname "O24Platform.dll" 2>/dev/null
```

## Tags

`ubuntu`, `find`, `dll`, `O24Platform`, `publish`, `emi`, `docker`
