all: lint

puppet-lint:
	puppet-lint **/*.pp

lint: puppet-lint
