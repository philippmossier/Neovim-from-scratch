local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)
keymap("i", "jj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Jest https://github.com/David-Kunz/jester
keymap("n", "<leader>j", "<cmd>lua require\"jester\".run_file({cmd = \"./node_modules/.bin/jest '$result' -- $file\", terminal_cmd = \":split | terminal\"})<CR>", opts)
-- keymap("n", "gl", '<cmd>lua vim.diagnostic.open_float()<CR>', opts)




-- dap
keymap('n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>', opts)
keymap('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>', opts)
keymap('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>', opts)
keymap('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>', opts)
keymap('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>', opts)

keymap('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>', opts)
keymap('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>', opts)
keymap('v', '<leader>dhv',
          '<cmd>lua require"dap.ui.variables".visual_hover()<CR>', opts)

keymap('n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>', opts)
keymap('n', '<leader>duf',
          "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>", opts)

keymap('n', '<leader>dsbr',
          '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', opts)
keymap('n', '<leader>dsbm',
          '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', opts)
keymap('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>', opts)
keymap('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>', opts)


-- telescope-dap
keymap('n', '<leader>dcc',
          '<cmd>lua require"telescope".extensions.dap.commands{}<CR>', opts)
keymap('n', '<leader>dco',
          '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>', opts)
keymap('n', '<leader>dlb',
          '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>', opts)
keymap('n', '<leader>dv',
          '<cmd>lua require"telescope".extensions.dap.variables{}<CR>', opts)
keymap('n', '<leader>df',
          '<cmd>lua require"telescope".extensions.dap.frames{}<CR>', opts)