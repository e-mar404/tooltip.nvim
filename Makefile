.PHONY: test generate_filetypes lint luarocks_upload test_luarocks_install
test:
	nvim --headless --noplugin -u scripts/minimal.vim -c "PlenaryBustedDirectory tests/tooltip/ {minimal_init = 'tests/minimal_init.vim', sequential = true}"
