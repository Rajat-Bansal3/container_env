#!/usr/bin/env bash
set -eo pipefail  

VM_NAME="$1"
USERNAME="$2"
TAP_NAME="tap_$VM_NAME"
BRIDGE="br0"
ROOT_FS="/home/rajat/Documents/side_projects/Docker_ubuntu/vm-provisioning/hello-rootfs.ext4"
KERNEL="/home/rajat/Documents/side_projects/Docker_ubuntu/vm-provisioning/hello-vmlinux.bin"
CPU_COUNT=2
MEM_SIZE=512

MAC_ADDR="06:$(dd if=/dev/urandom bs=1 count=5 2>/dev/null | hexdump -e '/1 ":%02X"')"
VM_IP="192.168.1.$((100 + RANDOM % 154))"

sudo ip tuntap add dev "$TAP_NAME" mode tap user "$USER"
sudo ip link set "$TAP_NAME" master "$BRIDGE"
sudo ip link set dev "$TAP_NAME" up


## put your public key path here
cat <<EOF > user-data
#cloud-config
users:
  - name: $USERNAME
    ssh_authorized_keys:
      - $(cat ~/.ssh/id_ed25519.pub)
EOF

genisoimage -output seed.iso -V cidata -r -J user-data meta-data

FC_SOCK="/tmp/fc-$VM_NAME.sock"
firecracker --api-sock "$FC_SOCK" --seccomp-level 0 --no-api-thread &

while [ ! -S "$FC_SOCK" ]; do sleep 0.1; done

curl -X PUT --unix-socket "$FC_SOCK" \
  -d "{
    \"vcpu_count\": $CPU_COUNT,
    \"mem_size_mib\": $MEM_SIZE,
    \"smt\": false
  }" "http://localhost/machine-config"

curl -X PUT --unix-socket "$FC_SOCK" \
  -d "{
    \"kernel_image_path\": \"$KERNEL\",
    \"boot_args\": \"console=ttyS0 reboot=k panic=1 pci=off\"
  }" "http://localhost/boot-source"

curl -X PUT --unix-socket "$FC_SOCK" \
  -d "{
    \"drive_id\": \"rootfs\",
    \"path_on_host\": \"$ROOT_FS\",
    \"is_root_device\": true,
    \"is_read_only\": false
  }" "http://localhost/drives/rootfs"

curl -X PUT --unix-socket "$FC_SOCK" \
  -d "{
    \"iface_id\": \"eth0\",
    \"guest_mac\": \"$MAC_ADDR\",
    \"host_dev_name\": \"$TAP_NAME\"
  }" "http://localhost/network-interfaces/eth0"

curl -X PUT --unix-socket "$FC_SOCK" \
  -d "{ \"action_type\": \"InstanceStart\" }" \
  "http://localhost/actions"

echo "VM $VM_NAME started! Connect via SSH: ssh $USERNAME@$VM_IP"
