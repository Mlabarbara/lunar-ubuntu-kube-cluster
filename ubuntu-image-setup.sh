### this is a script that will grab a cloud img, manipulate it, and create a vm from it
#it is a work in progress lol
#
#
apt upadate -y


#remove the existing image incase it failed the previous time and download a fresh img
wget https://cloud-images.ubuntu.com/lunar/current/lunar-server-cloudimg-amd64.img

# add qemu-guest-agent to the img (-a add image, --install)
virt-customize -a lunar-server-cloudimg-amd64.img --install qemu-guest-agent

#create the machine
qm create 9000 --name "ubuntu-2304-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 9000 focal-server-cloudimg-amd64.img nvme001
qm set 9000 --scsihw virtio-scsi-pci --scsi0 nvme001:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 nvme001:cloudinit
qm set 9000 --serial0 socket --vga serial0
qm set 9000 --agent enabled=1
qm template 9000 

#clone the template; create new VM. I
# I would like to make this interactive at some point, have the user
#  choose the IP and the name; grab from stdin
qm clone 9000 111 --name test-clone-template \
qm set 111 --sshkey ~/.ssh/id_rsa.pub\
qm set 111 --ipconfig0 ip=192.168.12.13/16,gw=192.168.10.1 \
qm start 111

# ssh into the new VM to make sure it wokrs
ssh ubuntu@192.168.12.13

# kill machine and destroy it 
qm stop 111 && qm destroy 111


