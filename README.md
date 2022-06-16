# Customized (custom1 branch setup)

This nevim config focuses on typescript react development. 
- lsp for typescript autocompletion
- null-ls for linting (eslint_d) and formatting(eslint_d) which respects project related eslintrc/prettierrc 
- tailwindcss autocompletion with lsp tailwindcss (installed via :LspInstallInfo)
- autolint/code-action(eslint) on save 
- nvim-ts-autotag (treesitter extension) which automatically closes and renames html tags  

TODOS:
- Setup ts-utils-plugin(github.com/jose-elias-alvarez/nvim-lsp-ts-utils)
- Add lua linter 
- Add golang, python, graphql setup aswell

## Setup cssls language-server for css, scss, less
DOCS: 
- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cssls
- https://github.com/hrsh7th/vscode-langservers-extracted

NOTE: make sure you use node >=14 (the cssls from nvim uses vscode-langservers-extracted version 4.1, which is not working with node 12 or node 13)

**Install steps:**
1. Inside nvim:
:LspInstallInfo
install cssls with typing i

2. Inside shell
npm install -g eslint_d
npm install -g typescript-language-server
npm install -g typescript
npm install -g @fsouza/prettier
npm install -g tree-sitter-cli


## Setup steps after first clone neovim-from-scratch repo

```
cd ~
git clone git@github.com:philippmossier/Neovim-from-scratch.git .config/nvim
cd .config/nvim 
git checkout tsutils
npm install -g eslint_d
npm install -g typescript-language-server
npm install -g typescript
npm install -g @fsouza/prettier
npm install -g tree-sitter-cli
nvim .
:PackerInstall
```

---

## Neovim from scratch

Each video will be associated with a branch so checkout the one you are interested in, you can follow along with this [playlist](https://www.youtube.com/watch?v=ctH-a-1eUME&list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ).

## Try out this config

Make sure to remove or move your current `nvim` directory

**IMPORTANT** Requires [Neovim v0.6.0](https://github.com/neovim/neovim/releases/tag/v0.6.0) or [Nightly](https://github.com/neovim/neovim/releases/tag/nightly). 
```
git clone https://github.com/LunarVim/Neovim-from-scratch.git ~/.config/nvim
```

Run `nvim` and wait for the plugins to be installed 

**NOTE** (You will notice treesitter pulling in a bunch of parsers the next time you open Neovim) 

## Get healthy

Open `nvim` and enter the following:

```
:checkhealth
```

You'll probably notice you don't have support for copy/paste also that python and node haven't been setup

So let's fix that

First we'll fix copy/paste

- On mac `pbcopy` should be builtin

- On Ubuntu

  ```
  sudo apt install xsel
  ```

- On Arch Linux

  ```
  sudo pacman -S xsel
  ```

Next we need to install python support (node is optional)

- Neovim python support

  ```
  pip install pynvim
  ```

- Neovim node support

  ```
  npm i -g neovim
  ```
---

**NOTE** make sure you have [node](https://nodejs.org/en/) installed, I recommend a node manager like [fnm](https://github.com/Schniz/fnm).

> The computing scientist's main challenge is not to get confused by the complexities of his own making. 

\- Edsger W. Dijkstra
