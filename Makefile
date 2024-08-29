.PHONY: test generate_filetypes lint luarocks_upload test_luarocks_install
test:
	nvim --headless --noplugin -u test/minrc.vim -c "PlenaryBustedDirectory tests/ { minimal_init = "./tests/minimal_init.vim" }"
