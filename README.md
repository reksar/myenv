# My conf

Configures the Linux workspace with 
[Ansible](https://docs.ansible.com/ansible/latest/index.html):

* Makes links at `~` to the:
  - `linux/home/*` dotfiles
  - `.vimrc` and `.vim/` from [Vim](https://github.com/reksar/vim) submodule

* Makes extra config, described in `ansible/config/*.yml`

* Allows to install some software with `ansible/install/*.yml`


## Getting

```
git clone --recurse-submodules https://github.com/reksar/myconf.git
```

## Using

**Note:** edit the `ansible/settings.yml` if nedded.

**Note:** Ansible asks for `sudo` password for a tasks with `become: true`.

### Configure Linux workspace

`config.sh`

### Install software

#### `install.sh pyenv`

[pyenv](https://github.com/pyenv/pyenv)

### Cleanup

`clean.sh`
