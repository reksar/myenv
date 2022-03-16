.PHONY: conf
conf:
	ansible-playbook \
		--ask-become-pass \
		-i ansible/hosts \
		ansible/conf.yml

.PHONY: pyenv
pyenv:
	ansible-playbook \
		--ask-become-pass \
		-i ansible/hosts \
		ansible/pyenv.yml

.PHONY: clean
clean:
	# Ansible creates *.retry files when something goes wrong.
	find ./ansible/ -type f -name '*.retry' -delete
