.PHONY: test generate_filetypes lint luarocks_upload test_luarocks_install
test:
	nvim --headless --noplugin -u tests/minimal_init.vim -c "PlenaryBustedDirectory tests/ { minimal_init = "./tests/minimal_init.vim" }"
