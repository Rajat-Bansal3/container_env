#!/bin/bash

VM_NAME=$1
TAP_NAME="tap_$VM_NAME"
USERNAME=$2  
VM_IP="192.168.1.$((100 + RANDOM % 10))"
MAC_ADDR=$(printf "%02X:%02X:%02X:%02X:%02X:%02X" $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
ROOT_FS="../alpine.rootfs.ext4"
CPU_COUNT=2
MEM_SIZE=512
kernal="../hello-vmlinux.bin"


sudo ip tuntap add $TAP_NAME mode tap
sudo ip addr add $VM_IP/24 dev $TAP_NAME
sudo ip link set $TAP_NAME up

cat <<EOF > net_config_$VM_NAME.json
{
  "iface_id": "eth0",
  "guest_mac": "$MAC_ADDR",
  "host_dev_name": "$TAP_NAME"
}
EOF


sudo mount -o loop $ROOT_FS /mnt
sudo chroot /mnt /bin/sh -c "
  adduser -D -s /bin/sh $USERNAME
  echo '$USERNAME:password' | chpasswd
  mkdir -p /home/$USERNAME/.ssh
  echo 'your-public-key-here' > /home/$USERNAME/.ssh/authorized_keys
  chmod 600 /home/$USERNAME/.ssh/authorized_keys
  chmod 700 /home/$USERNAME/.ssh
  chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
  rc-update add sshd default
"
sudo umount /mnt

FC_SOCk = "/tmp/firecracker_$VM_NAME.socket"
firecracker --api-sock $FC_SOCK &

sleep 2 

curl --unix-socket /tmp/firecracker.sock -i -X GET "http://localhost/machine-config" -H "Accept: application/json" -H "Content-Type: application/json" -d '{ "vcpu_count": 2, "mem_size_mib": 512,  "ht_enabled": false}'

curl --unix-socket /tmp/firecracker.sock -i \
    -X PUT 'http://localhost/boot-source'   \
    -H 'Accept: application/json'           \
    -H 'Content-Type: application/json'     \
    -d '{        "kernel_image_path": "$kernal", "boot_args": "console=ttyS0 reboot=k panic=1 pci=off"}'

curl --unix-socket /tmp/firecracker.sock -i \
    -X PUT 'http://localhost/drives/rootfs' \
    -H 'Accept: application/json'           \
    -H 'Content-Type: application/json'     \
    -d '{        "drive_id": "rootfs",        "path_on_host": "$ROOT_FS",        "is_root_device": true,        "is_read_only": false    }'



curl --unix-socket $FC_SOCK -X PUT "http://localhost/network-interfaces/eth0" -H "Content-Type: application/json" -d "
{
  \"iface_id\": \"eth0\",
  \"guest_mac\": \"$MAC_ADDR\",
  \"host_dev_name\": \"$TAP_NAME\"
}"

curl --unix-socket /tmp/firecracker.sock -i \
    -X PUT 'http://localhost/actions'       \
    -H  'Accept: application/json'          \
    -H  'Content-Type: application/json'    \
    -d '{        "action_type": "InstanceStart"     }'



