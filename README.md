# My ENV

Configures working environment with 
[Ansible](https://docs.ansible.com/ansible/latest/index.html)


## Linux

* Makes links at `~` to the:
  - `linux/home/*` dotfiles
  - `.vimrc` and `.vim/` from [Vim](https://github.com/reksar/vim) submodule

* Makes extra config, described in `ansible/config/*.yml`

* Allows to install some software with `ansible/install/*.yml`


## Getting

```
git clone --recurse-submodules https://github.com/reksar/myenv.git
```

## Using

**Note:** edit the `ansible/settings.yml` if nedded.

**Note:** Ansible asks for `sudo` password for a tasks with `become: true`.

### Configure Linux workspace

`config` to run main tasks.

`config <task>` to run tasks from `ansible/config/tasks/<task>.yml`.

### Install software

#### Linux

##### `ensure pyenv`

[pyenv](https://github.com/pyenv/pyenv)

##### `ensure nvim`

**Note:** run `config.sh` to update desktop (n)Vim settings.

#### Windows

##### `install.bat python`

### Cleanup

`clean`
