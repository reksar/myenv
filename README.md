# My ENV

Configs for my working environment. Mainly for Windows and Debian based Linux.

```sh
git clone --recurse-submodules https://github.com/reksar/myenv.git
```

Edit `./settings.yml` if needed.

# Linux

## sudo

Prompts for the *sudo* password for some shell scripts or
[Ansible](https://docs.ansible.com/ansible/latest/index.html) tasks with
`become: true`.

## Ensuring the Ansible

Automatically runs this script chain on before `./ensure` or `./config`:
* `linux/scripts/install/ansible/ansible.sh`
* `linux/scripts/install/python/python.sh`
* `linux/scripts/install/pyenv/pyenv.sh`

This allows to ensure the Ansible availability. If the Ansible is not installed
in the system, it will be installed into the `./venv` dir after ensuring the
Python virtual environment there.

If the system Python version < `MIN_PY_VERSION`, that is set in the `python.sh`
installation script, then Python >= `MIN_PY_VERSION` will be installed with
`pyenv`.

## Config

`./config` to run default tasks.

`./config <task>` to run specific `./ansible/config/tasks/<task>.yml`.

## Ensure

`./ensure <program>` to install specific *program* using the
`./ansible/install/<program>.yml` task and then automatically configure it with
`./ansible/config/tasks/<program>.yml` if needed.

## Cleanup

`./clean` to remove the `./venv` dir and Ansible's `*.retry` files.

# Windows

Entry point: `.\windows\myenv.lnk`.

The `myenv-test` cmd can be useful.
