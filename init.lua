-- Requires: neovim 0.12+, ripgrep (for telescope live_grep), a nerd font (optional)

-- Basic config
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
-- vim.o.statusline = "%{expand('%:p')}:%l %m%r%=%l,%c %P"
vim.opt.termguicolors = true

-- Use the popup menu for completion, and don't auto-select an entry
vim.opt.completeopt = 'menu,menuone,noselect'

-- Plugins
local function gh(repo) return 'https://github.com/' .. repo end
local function cb(repo) return 'https://codeberg.org/' .. repo end

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
    gh('airblade/vim-gitgutter'),
    gh('neovim/nvim-lspconfig'),
    gh('stevearc/oil.nvim'),
    gh('Julian/lean.nvim'),
    gh('whonore/Coqtail'),
    gh('Olical/conjure'),
    gh('gpanders/nvim-parinfer'),
})
vim.api.nvim_create_user_command("PackUpdate", function()
    require("vim.pack").update()
end, { desc = "Update all plugins using vim.pack" })

-- Colorscheme
vim.o.background='dark'
-- vim.cmd("colorscheme warm-springs")
vim.cmd("colorscheme zenbones")

-- Configure plugins
require('oil').setup()
require('telescope').load_extension('frecency')
require('telescope').setup({
    defaults = {
        path_display = { "smart" }
    }
})

-- vim.g.coqtail_noimap=true
vim.api.nvim_set_hl(0, "CoqtailChecked", { bg = "#2e2923" })
vim.api.nvim_set_hl(0, "CoqtailSent",    { bg = "#483f36" }) 

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
    end,
})

vim.keymap.set('i', '<Tab>',   function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>' end,   { expr = true })
vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end, { expr = true })
vim.keymap.set('i', '<C-Space>', function() vim.lsp.completion.get() end)

-- Main keybindings

-- format document with lsp
vim.keymap.set('n', '<leader>ss', ':lua vim.lsp.buf.format()<CR>') 

-- Fuzzy
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)        -- SPACE f f finds files in the current directory, minus those in gitignore
vim.keymap.set('n', '<leader>fg', builtin.live_grep)         -- SPACE f g finds text inside files in the current directory, minus those in gitignore
vim.keymap.set('n', '<leader>fb', builtin.buffers)           -- SPACE f b finds files currently opened
vim.keymap.set('n', '<leader>fH', builtin.help_tags)         -- SPACE f H looks through the help pages for neovim and plugins
vim.keymap.set('n', '<leader>fh', ':Telescope frecency<CR>') -- SPACE f h looks through files sorted by how often and how recently they've been opened
vim.keymap.set('n', '<leader>fc', builtin.git_commits)       -- SPACE f c looks through git commits and shows the diffs
vim.keymap.set('n', '<leader>fs', builtin.git_status)        -- SPACE f s looks through changed files (from git status)
vim.keymap.set('n', '<leader>fd', builtin.diagnostics)       -- SPACE f d looks through lsp diagnostics


vim.keymap.set('n', '<leader>bb', ':make build<CR>') 
vim.keymap.set('n', '<leader>br', ':make run<CR>') 

-- window management
vim.keymap.set('n', '<leader>wv', '<C-w>v')
vim.keymap.set('n', '<leader>wq', '<C-w>q')

vim.keymap.set('n', '<leader>wo', '<C-w>o')

vim.keymap.set('n', '<leader>wh', '<C-w>h') 
vim.keymap.set('n', '<leader>wj', '<C-w>j') 
vim.keymap.set('n', '<leader>wk', '<C-w>k') 
vim.keymap.set('n', '<leader>wl', '<C-w>l') 


-- Git
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>')  -- SPACE g b shows an inline git blame for the current file
vim.keymap.set('n', '<leader>gs', ':Git status<CR>') -- SPACE g s shows a quick overview of the git status
vim.keymap.set('n', '<leader>gg', ':Git<CR>')        -- SPACE g g opens a full git fugitive window for managing changes and more
vim.keymap.set('n', ']g', ':GitGutterNextHunk<CR>')  -- ] g goes to the next changed piece of code
vim.keymap.set('n', '[g', ':GitGutterPrevHunk<CR>')  -- [ g goes to the previous changed piece of code

-- Leap
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)') -- s triggers vim leap, to jump to another part of the screen by character tags
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')   -- S triggers the same but more globally

-- File management
vim.keymap.set('n', '<leader>o', ':Oil<CR>') -- SPACE o opens interactive file explorer with ability to rename/delete/move files as a buffer

-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end
})

-- Normal LSP's
vim.lsp.enable('lua_ls')
vim.lsp.enable('ocamllsp')
vim.lsp.enable('clangd')
vim.lsp.enable('rust-analyzer')
vim.lsp.enable('millet')
vim.lsp.enable('zls')

-- Conjure for lispy stuff
vim.g["conjure#mapping#doc_word"] = false
vim.filetype.add({
  extension = {
    rhm = 'rhombus',
    scrbl = 'scribble',
  },
})

vim.lsp.config('racket_langserver', {
  cmd = { 'racket', '-l', 'racket-langserver' },
  filetypes = { 'racket', 'rhombus', "scribble" },  -- add 'rhombus' here
  root_markers = { 'info.rkt', '.git' },
})
vim.lsp.enable('racket_langserver')
vim.g.no_racket_maps = 1

vim.g["conjure#filetypes"] = {
  "clojure", "fennel", "janet", "hy", "julia", "racket",
  "scheme", "lua", "lisp", "python", "rust", "sql",
  "rhombus", "scribble"
}
vim.g["conjure#client#rhombus#stdio#command"] = "racket -I rhombus"
vim.g["conjure#client#scheme#stdio#command"] = "petite"
vim.g["conjure#client#scheme#stdio#prompt_pattern"] = "> $?"
vim.g["conjure#filetype#scribble"] = "conjure.client.racket.stdio"
vim.g["conjure#filetype#rhombus"] = "conjure.client.racket.stdio"

