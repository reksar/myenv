# My conf  

Configures Linux workspace with Ansible.  

- Adds `~/.vimrc` and `~/.vim/` from [Vim](https://github.com/reksar/vim)  
submodule.

- Deploys configuration from `linux` dir.  

- Makes some extra configuration, described in `ansible/configure.yml`.  

When make sense to ship whole configuration file, makes a link, so you can  
edit it as well at this repo, as at destination place.  

## Using  


```  
git clone --recurse-submodules https://github.com/reksar/myconf.git  

cd myconf  

make  
```

## Requirements  

- [Ansible](https://docs.ansible.com/ansible/latest/index.html)

- [GNU Make](https://www.gnu.org/software/make)
