# Check Disk on Ubuntu or Linux

## Check disk usage

```bash
df -h
```

## Check folder size

```bash
du -sh /path/to/folder
```

## Find large folders

```bash
sudo du -h --max-depth=1 / | sort -hr | head -20
```

## Find large files

```bash
sudo find / -type f -size +500M -exec ls -lh {} \; 2>/dev/null
```

## Check mounted disks

```bash
lsblk
```

## Tags

`linux`, `ubuntu`, `disk`, `storage`, `df`, `du`, `lsblk`