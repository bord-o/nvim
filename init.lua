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

-- Plugins
local function gh(repo) return 'https://github.com/' .. repo end
local function cb(repo) return 'https://codeberg.org/' .. repo end

vim.pack.add({
    gh('nvim-lua/plenary.nvim'),
    gh('hrsh7th/nvim-cmp'),
    gh('hrsh7th/cmp-nvim-lsp'),
    gh('nvim-treesitter/nvim-treesitter'),
    gh('nvim-telescope/telescope.nvim'),
    gh('nvim-telescope/telescope-frecency.nvim'),
    gh('p00f/alabaster.nvim'),
    cb('andyg/leap.nvim'),
    gh('tpope/vim-surround'),
    gh('tpope/vim-fugitive'),
    gh('ellisonleao/gruvbox.nvim'),
    gh('rktjmp/lush.nvim'),
    gh('zenbones-theme/zenbones.nvim'),
    gh('olimorris/onedarkpro.nvim'),
    gh('ntk148v/komau.vim'),
    gh('airblade/vim-gitgutter'),
    gh('neovim/nvim-lspconfig'),
    gh('Julian/lean.nvim'),
    gh('whonore/Coqtail'),
    gh('tomtomjhj/vsrocq.nvim'),
    gh('stevearc/oil.nvim')
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

vim.api.nvim_create_user_command("ToggleBackground", function()
    if vim.o.background == 'dark' then vim.o.background = 'light' else vim.o.background = 'dark' end
end, { desc = "Toggles the vim.opt.background setting" })

vim.cmd("colorscheme zenbones")

-- Configure plugins
require('oil').setup()
require('telescope').load_extension('frecency')
require('telescope').setup({
    defaults = {
        path_display = { "smart" }
    }
})
require('lean').setup({
    mappings = true,
})

-- Completion setup (tab to cycle completions, enter to accept them)
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
-- autoformat on save
local format_on_save = false
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
    callback = function()
        if format_on_save then
            vim.lsp.buf.format()
        end
    end,
})

vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
    format_on_save = not format_on_save
    vim.notify("Format on save: " .. (format_on_save and "enabled" or "disabled"))
end, { desc = "Toggles format on save" })
vim.keymap.set('n', '<leader>ss', ':ToggleFormatOnSave<CR>') -- SPACE f f finds files in the current directory, minus those in gitignore

-- Quickfix
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", function()
      local qflist = vim.fn.getqflist()
      local line = vim.fn.line(".") - 1  -- 0-indexed
      table.remove(qflist, line + 1)
      vim.fn.setqflist(qflist)
    end, { buffer = true })
  end,
})

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

--
vim.keymap.set('n', '<leader>b', ':ToggleBackground<CR>') -- [ g goes to the previous changed piece of code


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

local caps = vim.lsp.protocol.make_client_capabilities()
caps.workspace.didChangeWatchedFiles.dynamicRegistration = false
vim.lsp.config('*', { capabilities = caps })

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

-- Custom macros for dumb shit

vim.keymap.set('n', '<leader>cc', 'olet goal = make_goal [%term ] in') -- SPACE f f finds files in the current directory, minus those in gitignore
