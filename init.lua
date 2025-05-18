-- Basic config 
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'
vim.g.mapleader = " "
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.scrolloff = 12

-- for menu
vim.g.netrw_menu=0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize=75
vim.g.netrw_browse_split=4
vim.g.netrw_preview=1
vim.g.netrw_liststyle = 3
--vim.cmd('set autochdir')

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('junegunn/fzf.vim')
Plug('junegunn/fzf', { ['do'] = function()
  vim.fn['fzf#install']()
end })
Plug('ggandor/leap.nvim')
Plug('tpope/vim-surround')
Plug('tpope/vim-fugitive')
Plug('navarasu/onedark.nvim')

vim.call('plug#end')


require('leap').set_default_mappings()
require('onedark').setup {
    style = 'dark'
}
require('onedark').load()

-- Theme
-- vim.cmd('colorscheme retrobox')

-- Env
vim.env.FZF_DEFAULT_COMMAND = 'rg --files'

-- Fuzzy
vim.opt.rtp:append('/opt/local/share/fzf/vim')
vim.keymap.set('n', '<leader>ff', ':FZF<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fg', ':RG<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fl', ':Lines<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fh', ':History<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fb', ':Buffers<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fw', ':Windows<CR>', { noremap = true })

-- Git
vim.keymap.set('n', '<leader>fc', ':Commits<CR>', { noremap = true })
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { noremap = true })
vim.keymap.set('n', '<leader>gs', ':Git switch ', { noremap = true })
vim.keymap.set('n', '<leader>gg', ':Git status<CR>', { noremap = true })

-- Completion
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
    end,
})

vim.keymap.set('n', '<c-alt>', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)


vim.keymap.set('i', '<c-space>', function()
  vim.lsp.completion.get()
end)

vim.opt.completeopt = "menu,menuone,noselect"

-- Map Tab, Shift-Tab, and Enter for completion menu navigation
vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  else
    return '<Tab>'
  end
end, {expr = true, noremap = true})

vim.keymap.set('i', '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>'
  else
    return '<S-Tab>'
  end
end, {expr = true, noremap = true})

vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  else
    return '<CR>'
  end
end, {expr = true, noremap = true})


-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end
})

-- LSP
vim.lsp.config('gopls', {
    cmd = { "gopls" },
    root_markers = {"go.mod"},
    filetypes = { "go" },

})

vim.lsp.enable('gopls')
