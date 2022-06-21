vim.cmd([[
try
  " colorscheme tokyonight
  " colorscheme gruvbox
  " colorscheme onedark
   colorscheme nightfox "nightfox,nordfox,dayfox,dawnfox,duskfox
  " colorscheme darkplus
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])
