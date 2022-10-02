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

### Configure Linux workspace with Ansible

`config` to run main tasks.

`config <task>` to run specific `ansible/config/tasks/<task>.yml`.

### Install software

#### Linux

If the Ansible is not installed in the system globally, invoking the `ensure`
or `config` will automatically invoke this chain:
* `linux/scripts/ensure-ansible.sh`
* `linux/scripts/ensure-python.sh`
* `linux/scripts/install/pyenv.sh`

Python will be installed with the pyenv and the Ansible will be installed into
the `venv` dir.

`MIN_PY_VERSION` can be set in `linux/scripts/ensure-python.sh`.

##### `ensure nvim`

#### Windows

##### `install.bat python`

### Cleanup

`clean`
