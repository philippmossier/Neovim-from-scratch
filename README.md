# Customized (tsutils branch setup)

This nevim config focuses on typescript react development. 
- lsp for typescript autocompletion
- null-ls for linting (eslint_d) and formatting(eslint_d) which respects project related eslintrc/prettierrc 
- tailwindcss autocompletion with lsp tailwindcss (installed via :LspInstallInfo)
- autolint/code-action(eslint) on save 
- nvim-ts-autotag (treesitter extension) which automatically closes and renames html tags  


## How to install:

### install neovim 0.7 as long as 0.8 is not stable

```
cd ~
mkdir -p ~/.local/bin && rm -f ~/.local/bin/nvim && \
curl -L https://github.com/neovim/neovim/releases/download/v0.7.0/nvim.appimage \
-o ~/.local/bin/nvim && \
chmod u+x ~/.local/bin/nvim
```

### Prerequisites (uses everything what neovim-from-scratch provides incl. custom ts-react utils)

```
npm install -g eslint_d
npm install -g typescript-language-server
npm install -g typescript
npm install -g @fsouza/prettierd
**only install treesitter through npm if :PackerInstall does not work**
npm install -g tree-sitter-cli
```

### Setup steps after first clone neovim-from-scratch repo

```
cd ~
git clone git@github.com:philippmossier/Neovim-from-scratch.git .config/nvim
cd .config/nvim 
git checkout tsutils
nvim .
:PackerInstall
```
DONE!

### TODOS:
- Add debuging support for ts (nvim-dap)
- Add golang, python, graphql setup aswell

### Setup cssls language-server for css, scss, less
- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cssls
- https://github.com/hrsh7th/vscode-langservers-extracted

NOTE: make sure you use node >=14 (the cssls from nvim uses vscode-langservers-extracted version 4.1, which is not working with node 12 or node 13)

**Install steps:**
1. Inside nvim:
:LspInstallInfo
install cssls with typing i
