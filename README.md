# My conf

Configures the Linux workspace with 
[Ansible](https://docs.ansible.com/ansible/latest/index.html):

* Makes links at `~` to the:
    - `linux/home/*` dotfiles
    - `.vimrc` and `.vim/` from the [Vim](https://github.com/reksar/vim) 
    submodule

* Makes extra config, described in `ansible/config/*.yml`


## Getting

```
git clone --recurse-submodules https://github.com/reksar/myconf.git
```

## Using

**Note:** edit the `ansible/settings.yml` if nedded.

**Note:** Ansible asks for `sudo` password for a tasks with `become: true`.

- `make config` - configure Linux

- `make pyenv` - install [pyenv](https://github.com/pyenv/pyenv)

- `make clean` - cleanup


## Requirements

- [Ansible](https://docs.ansible.com/ansible/latest/index.html)

- [GNU Make](https://www.gnu.org/software/make)
