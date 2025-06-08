local set = vim.keymap.set
local opts = { noremap = true, silent = true }

set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Got to methods remapping
set('n', ']m', ']mzz')
set('n', '[m', '[mzz')

-- navigating panes
set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- indenting
set('v', '<', '<gv', { desc = 'Indent backwards' })
set('v', '>', '>gv', { desc = 'Indent forwards' })

-- save file
set('n', '<leader>w', ':w<CR>', { desc = 'Save file', silent = true })
set('n', '<leader>x', ':so<CR>', opts)
set('n', '<leader>q', ':q<CR>', opts)
set('n', '<D-s>', ':w<CR>', { desc = 'Save file', silent = true })

-- buffer navigation
set('n', '<leader><leader>h', ':bn<CR>', { desc = 'Move to next buffer' })
set('n', '<leader><leader>l', ':bp<CR>', { desc = 'Move to previous buffer' })

-- Move Lines
set('n', '<D-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
set('n', '<D-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
set('i', '<D-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
set('i', '<D-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
set('v', '<D-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
set('v', '<D-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

-- nvimtree
-- set("n", "<leader>t", ":NvimTreeToggle<CR>", opts)

-- lspsaga
set('n', '<leader>j', ':Lspsaga diagnostic_jump_next<cr>')
set('n', '<leader>k', ':Lspsaga diagnostic_jump_prev<cr>')

-- Terminal escape
set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit Terminal mode' })
