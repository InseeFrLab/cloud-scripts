cf https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner/blob/master/docs/operations.md#use-a-whole-disk-as-a-filesystem-pv

```
mkdir /mnt/minio-disks

mkfs.ext4 /dev/sda
DISK_UUID=$(blkid -s UUID -o value /dev/sda)
mkdir /mnt/minio-disks/$DISK_UUID
mount -t ext4 /dev/sda /mnt/minio-disks/$DISK_UUID
echo UUID=`blkid -s UUID -o value /dev/sda` /mnt/minio-disks/$DISK_UUID ext4 defaults 0 2 | tee -a /etc/fstab

mkfs.ext4 /dev/sdb
DISK_UUID=$(blkid -s UUID -o value /dev/sdb)
mkdir /mnt/minio-disks/$DISK_UUID
mount -t ext4 /dev/sdb /mnt/minio-disks/$DISK_UUID
echo UUID=`blkid -s UUID -o value /dev/sdb` /mnt/minio-disks/$DISK_UUID ext4 defaults 0 2 | tee -a /etc/fstab
```
