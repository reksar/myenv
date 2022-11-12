# My ENV

Configures working environment with 
[Ansible](https://docs.ansible.com/ansible/latest/index.html)

```sh
git clone --recurse-submodules https://github.com/reksar/myenv.git
```

# Linux

## Notes

### Settings

Edit the `ansible/settings.yml` if nedded.

### sudo

Ansible asks for **sudo** password for a tasks that `become: true`.

Additionally, a shell script may ask for **sudo** password during ensuring the
Ansible / Python / pyenv. Usually just at the first run on min system.

### Ensuring the Ansible

The `ensure` or `config` will automatically invoke this script chain:
* `linux/scripts/ensure-ansible.sh`
* `linux/scripts/ensure-python.sh`
* `linux/scripts/install/pyenv.sh`

This allows to ensure the Ansible awailability. If the Ansible is not installed
in the system, it will be installed into the `venv` dir after ensuring the
Python.

If the system Python's version < `MIN_PY_VERSION` that is set in the
`ensure-python.sh`, then Python will be installed with the `pyenv`.

## Config

`config` to run default tasks.

`config <task>` to run specific `ansible/config/tasks/<task>.yml`.

## Ensure

`ensure <program>` to install specific <program> using the
`ansible/install/<program>.yml` task and then automatically configure it with
`ansible/config/tasks/<task>.yml` if needed.

## Cleanup

`clean` to remove `venv` dir and Ansible's `*.retry` files.

# Windows

Entry point: `windows\myenv.lnk`.

You can use `myenv-test` cmd.
