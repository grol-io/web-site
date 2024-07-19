sync:
	# Assumes github.com/grol-io/grol is cloned in the sister directory
	cp ../grol/wasm/grol_wasm.html ./_includes/
	cp ../grol/wasm/wasm_exec.js .
	cp ../grol/wasm/grol.wasm .
	git diff
	git status


.PHONY: sync
