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
vim.g.maplocalleader = '  '
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.scrolloff = 15
vim.opt.relativenumber = true
vim.cmd('dig TS 8866') -- digraph support for ⊢
vim.opt.laststatus = 2 -- Or 3 for global statusline
vim.opt.statusline = " %f %m %= %l:%c of %L ♥ "
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
    gh('tomtomjhj/vsrocq.nvim'),
})
vim.api.nvim_create_user_command("PackUpdate", function()
    require("vim.pack").update()
end, { desc = "Update all plugins using vim.pack" })

-- Colorscheme
local function get_macos_appearance()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("Dark") and "dark" or "light"
  end
  return "light" -- fallback
end

vim.o.background = get_macos_appearance()-- sets 'dark' or 'light'

vim.cmd("colorscheme zenbones")

-- Configure plugins
require('oil').setup()
require('telescope').load_extension('frecency')
require('telescope').setup({
    defaults = {
        path_display = { "smart" }
    }
})

vim.g.lean_config = {
    mappings = true
}

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = true })
    end,
})

vim.keymap.set('i', '<Tab>',   function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>' end,   { expr = true })
vim.keymap.set('i', '<S-Tab>', function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end, { expr = true })
vim.keymap.set('i', '<C-Space>', function() vim.lsp.completion.get() end)

-- format document with lsp
vim.keymap.set('n', '<leader>ss', ':lua vim.lsp.buf.format()<CR>') 

-- Main keybindings

-- Fuzzy
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)        -- SPACE f f finds files in the current directory, minus those in gitignore
vim.keymap.set('n', '<leader>fg', builtin.live_grep)         -- SPACE f g finds text inside files in the current directory, minus those in gitignore
vim.keymap.set('n', '<leader>fb', builtin.buffers)           -- SPACE f b finds files currently opened
vim.keymap.set('n', '<leader>fH', builtin.help_tags)         -- SPACE f H looks through the help pages for neovim and plugins
vim.keymap.set('n', '<leader>fh', ':Telescope frecency<CR>') -- SPACE f h looks through files sorted by how often and how recently they've been opened
vim.keymap.set('n', '<leader>fc', builtin.git_commits)       -- SPACE f c looks through git commits and shows the diffs
vim.keymap.set('n', '<leader>fs', builtin.git_status)        -- SPACE f s looks through changed files (from git status)

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

-- Specialized languages
require('rocq')
require('koka')

-- Normal LSP's
vim.lsp.enable('lua_ls')
vim.lsp.enable('ocamllsp')
vim.lsp.enable('koka')     -- configured separately above
vim.lsp.enable('clangd')
vim.lsp.enable('millet')   -- SML language server
vim.lsp.enable('tinymist') -- typst language server
