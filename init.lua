-- Basic config
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'
vim.g.mapleader = " "
vim.g.maplocalleader = '  '
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.scrolloff = 15
-- vim.opt.termguicolors = true
vim.cmd('set relativenumber')

-- for menu
vim.g.netrw_menu = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 75
vim.g.netrw_browse_split = 4
vim.g.netrw_preview = 1
vim.g.netrw_liststyle = 3
--vim.cmd('set autochdir')
vim.cmd('dig TS 8866')
vim.opt.laststatus = 2 -- Or 3 for global statusline
vim.opt.statusline = " %f %m %= %l:%c ♥ "

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Completion
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')

-- TS
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = function() vim.fn['TSUpdate']() end })

-- Motion
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-telescope/telescope-frecency.nvim')
Plug('p00f/alabaster.nvim')

Plug('ggandor/leap.nvim')
Plug('tpope/vim-surround')
Plug('tpope/vim-fugitive', {['as'] = 'catpuccin'})

-- Themes
Plug('ellisonleao/gruvbox.nvim')
Plug('olimorris/onedarkpro.nvim')
Plug('ntk148v/komau.vim')

Plug('airblade/vim-gitgutter')


-- Lean
Plug('neovim/nvim-lspconfig')
Plug('nvim-lua/plenary.nvim')
Plug('Julian/lean.nvim')

Plug('whonore/Coqtail')
Plug('tomtomjhj/vsrocq.nvim')

-- Plug('syaiful6/koka.nvim')

vim.call('plug#end')

-- Configure plugins

require('telescope').load_extension('frecency')
require('telescope').setup({
    defaults = {
        path_display = {"smart"}
    }
})
require('lean').setup({
    mappings = true,
    -- infoview = {
    --   autoopen = true,
    --   orientation = "horizontal",
    --   height = 15,
    --   horizontal_position = "bottom",
    -- },
})

-- vim.cmd("set background=light")
vim.cmd("colorscheme retrobox")
vim.keymap.set('n', '<leader>pc', ':Telescope colorscheme<CR>', { noremap = true })

-- Completion setup
local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    },
})

-- Fuzzy
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { noremap = true })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { noremap = true })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { noremap = true })
vim.keymap.set('n', '<leader>fH', builtin.help_tags, { noremap = true })
vim.keymap.set('n', '<leader>fh', ':Telescope frecency<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fc', builtin.git_commits, { noremap = true })
vim.keymap.set('n', '<leader>fs', builtin.git_status, { noremap = true })

-- Git
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { noremap = true })
vim.keymap.set('n', '<leader>gs', ':Git status', { noremap = true })
vim.keymap.set('n', '<leader>gg', ':Git<CR>', { noremap = true })
vim.keymap.set('n', ']g', ':GitGutterNextHunk<CR>', { noremap = true })
vim.keymap.set('n', '[g', ':GitGutterPrevHunk<CR>', { noremap = true })

-- LSP
vim.keymap.set('n', '<c-alt>', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end
})

-- Rocq
-- vim.g.loaded_coqtail = 1
-- vim.api.nvim_set_var('coqtail#supported', 0)
--
-- require('vsrocq').setup({
--     vsrocq = {
--         completion = {
--             enable = false,
--         },
--     },
-- })

local bg = string.format('#%06x', vim.api.nvim_get_hl(0, {name = 'Normal'}).bg or 0)
vim.cmd('highlight CoqtailChecked guibg=' .. bg)
vim.cmd('highlight CoqtailSent guibg=' .. bg)

vim.keymap.set('n', '<leader>cl', ':VsRocq interpretToPoint<CR>', { noremap = true })
vim.keymap.set('n', '<leader>cj', ':VsRocq stepForward<CR>', { noremap = true })
vim.keymap.set('n', '<leader>ck', ':VsRocq stepBackward<CR>', { noremap = true })
vim.keymap.set('i', '<A-j>', '<Esc>:VsRocq stepForward<CR>a', { noremap = true })
vim.keymap.set('i', '<A-k>', '<Esc>:VsRocq stepBackward<CR>a', { noremap = true })
vim.keymap.set('n', '<leader>cm', ':VsRocq manual<CR>', { noremap = true })
vim.keymap.set('n', '<leader>cc', ':VsRocq continuous<CR>', { noremap = true })
vim.keymap.set('n', '<leader>cr', ':lua require("vsrocq").setup()<CR>', { noremap = true })

-- Koka
local parser_config = require('nvim-treesitter.parsers')
vim.treesitter.language.register('koka', 'koka')

parser_config.koka = {
  install_info = {
    url = "https://github.com/koka-lang/tree-sitter-koka",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "main",
  },
  filetype = "koka",
}
vim.filetype.add({
  extension = {
    kk = "koka",
  },
})

-- vim.lsp.enable('lua_ls')
vim.lsp.enable('ocamllsp')
vim.lsp.enable('koka')
vim.lsp.enable('clangd')
vim.lsp.enable('millet')
