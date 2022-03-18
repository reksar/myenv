.PHONY: config
config:
	ansible-playbook \
		--ask-become-pass \
		-i ansible/hosts \
		ansible/config/main.yml

.PHONY: pyenv
pyenv:
	ansible-playbook \
		--ask-become-pass \
		-i ansible/hosts \
		ansible/install/pyenv.yml

.PHONY: clean
clean:
	# Ansible creates *.retry files when something goes wrong.
	find ./ansible/ -type f -name '*.retry' -delete
