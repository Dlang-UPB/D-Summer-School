# VM creation tutorial

Based on https://github.com/systems-cs-pub-ro/so

## Setting up the environment

Tested on Ubuntu 22.04.1.
Any reasonable recent Linux distribution should work.

```
sudo apt-get install vagrant virtualbox virtualbox-qt python-pip python-setuptools
pip install ansible
vagrant plugin install vagrant-disksize
vagrant plugin install vagrant-reload
```

## Building a VM

```
cd vagrantfile-pclp4
vagrant up
```

Running the `vagrant up` command will create and configure the VM.

## Building a VM using VMware

If you whish, you can use VMware, instead of VirtualBox, as a provider.
In order [to do so](https://www.vagrantup.com/docs/providers/vmware/installation), you must install the [Vagrant VMware Utility](https://www.vagrantup.com/vmware/downloads). Follow the [docs](https://www.vagrantup.com/docs/providers/vmware/vagrant-vmware-utility) in order to install it; you might need to use the `Manual Installation` guide.

After you've installed the utility, go ahead and install the `vagrant-vmware-desktop` plugin:
```
vagrant plugin install vagrant-vmware-desktop
```

Start the VM using:
```
vagrant up --provider=vmware_desktop
```

## Accessing the VM

To access the VM via `ssh` run the `vagrant ssh` command.

To accces the VM from the CLI using the `ssh` command, you first need
to dump the ssh config into a file and the instruct the `ssh` command
to load the configs from the file.
The config file will tell the `ssh` command where to find the ssh key
used to auth.

```
vagrant ssh-config > ssh-conf
ssh -F ssh-conf vagrant@default
```

The same applies to `scp`. Just add the `-F ssh-conf` argument to your scp command.

## Exporting the VM

Use the `playbooks-pclp4/export.sh` script to get an `.ova` image.
