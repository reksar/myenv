# My conf

Configures Linux workspace with 
[Ansible](https://docs.ansible.com/ansible/latest/index.html):

- Adds `~/.vimrc` and `~/.vim/` from [Vim](https://github.com/reksar/vim) 
submodule.

- Ships configuration files from `linux` dir as a *links*.

- Makes some extra configuration, described in `ansible/configure.yml`.


## Getting

```
git clone --recurse-submodules https://github.com/reksar/myconf.git

cd myconf
```

## Using

- `make config` - configure Linux

- `make pyenv` - install [pyenv](https://github.com/pyenv/pyenv)

- `make clean` - cleanup


## Requirements

- [Ansible](https://docs.ansible.com/ansible/latest/index.html)

- [GNU Make](https://www.gnu.org/software/make)
