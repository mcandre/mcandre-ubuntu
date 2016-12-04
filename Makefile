all: lint

puppet-lint:
	find . -type f -name '*.pp' -exec puppet-lint {} \;

shlint:
	find . \( -wholename '*/node_modules*' \) -prune -o -type f \( -wholename '*/lib/*' -o -name '*.sh' -o -name '*.bashrc*' -o -name '.*profile*' -o -name '*.envrc*' \) -print | xargs shlint

checkbashisms:
	find . \( -wholename '*/node_modules*' \) -prune -o -type f \( -wholename '*/lib/*' -o -name '*.sh' -o -name '*.bashrc*' -o -name '.*profile*' -o -name '*.envrc*' \) -print | xargs checkbashisms -n -p

shellcheck:
	find . \( -wholename '*/node_modules*' \) -prune -o -type f \( -wholename '*/lib/*' -o -name '*.sh' -o -name '*.bashrc*' -o -name '.*profile*' -o -name '*.envrc*' \) -print | xargs shellcheck

lint: puppet-lint shlint checkbashisms shellcheck
