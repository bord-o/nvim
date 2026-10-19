local function gh(repo) return 'https://github.com/' .. repo end
local function cb(repo) return 'https://codeberg.org/' .. repo end
vim.api.nvim_create_user_command("PackUpdate", function()
    require("vim.pack").update()
end, { desc = "Update all plugins using vim.pack" })

vim.pack.add({
    gh('nvim-lua/plenary.nvim'),
    gh('nvim-treesitter/nvim-treesitter'),
    gh('nvim-telescope/telescope.nvim'),
    gh('nvim-telescope/telescope-frecency.nvim'),
    cb('andyg/leap.nvim'),
    gh('tpope/vim-surround'),
    gh('tpope/vim-fugitive'),
    gh('rktjmp/lush.nvim'),
    gh('zenbones-theme/zenbones.nvim'),
    gh('miikanissi/modus-themes.nvim'),
    gh('airblade/vim-gitgutter'),
    gh('neovim/nvim-lspconfig'),
    gh('stevearc/oil.nvim'),
    gh('Julian/lean.nvim'),
    gh('whonore/Coqtail'),
    gh('Olical/conjure'),
    gh('gpanders/nvim-parinfer'),
})

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'
vim.g.mapleader = " "
vim.g.maplocalleader = '\\'
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.scrolloff = 15
vim.opt.relativenumber = true
vim.cmd('dig TS 8866') -- digraph support for ⊢ 
vim.o.laststatus = 2
vim.opt.statusline = " %f %m %= %l:%c of %L ☀︎ "
vim.opt.termguicolors = true
vim.opt.completeopt = 'menu,menuone,noselect' -- Use the popup menu for completion, and don't auto-select an entry
vim.o.background='dark'
-- vim.o.background='light'
vim.cmd("colorscheme modus")

require('oil').setup()
require('telescope').load_extension('frecency')
require('telescope').setup({
    defaults = {
        path_display = { "smart" }
    }
})

local ts = require('telescope.builtin')
vim.keymap.set('i', '<Tab>',   function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>' end,   { expr = true })
vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end, { expr = true })
vim.keymap.set('i', '<C-Space>', function() vim.lsp.completion.get() end) 
vim.keymap.set('n', '<leader>ss', ':lua vim.lsp.buf.format()<CR>') 
vim.keymap.set('n', '<leader>ff', ts.find_files)        
vim.keymap.set('n', '<leader>fg', ts.live_grep)         
vim.keymap.set('n', '<leader>fb', ts.buffers)           
vim.keymap.set('n', '<leader>fH', ts.help_tags)         
vim.keymap.set('n', '<leader>fh', ':Telescope frecency<CR>') 
vim.keymap.set('n', '<leader>fc', ts.git_commits)       
vim.keymap.set('n', '<leader>fs', ts.git_status)        
vim.keymap.set('n', '<leader>fd', ts.diagnostics)       
vim.keymap.set('n', '<leader>bb', ':make build<CR>') 
vim.keymap.set('n', '<leader>br', ':make run<CR>') 
vim.keymap.set('n', '<leader>w', '<C-w>')
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>')  
vim.keymap.set('n', '<leader>gs', ':Git status<CR>') 
vim.keymap.set('n', '<leader>gg', ':Git<CR>')        
vim.keymap.set('n', 'gn', ':GitGutterNextHunk<CR>')  
vim.keymap.set('n', 'gp', ':GitGutterPrevHunk<CR>')  
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)') 
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')   
vim.keymap.set('n', '<leader>o', ':Oil<CR>') 

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev) pcall(vim.treesitter.start, ev.buf) end
})

vim.api.nvim_create_autocmd("InsertCharPre", {
    callback = function(ev) vim.lsp.completion.get() end
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('ocamllsp')
vim.lsp.enable('clangd')
vim.lsp.enable('rust-analyzer')
vim.lsp.enable('millet')
vim.lsp.enable('zls')
