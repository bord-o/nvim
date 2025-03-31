-- Basic config 
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'
vim.g.mapleader = " "
vim.g.netrw_liststyle = 3


-- Theme
vim.cmd('colorscheme retrobox')

-- Env
vim.env.FZF_DEFAULT_COMMAND = 'rg --files'

-- Fuzzy
vim.opt.rtp:append('/opt/local/share/fzf/vim')
vim.keymap.set('n', '<leader>f', ':FZF<CR>', { noremap = true })

-- Completion
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = false })
    end,
})


-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end
})

-- LSP
vim.lsp.config('lua_ls', {
    cmd = { "/opt/local/bin/lua-language-server" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    filetypes = { "lua" },
})

vim.lsp.config('ocamllsp', {
    cmd = { "ocamllsp" },
    root_markers = {"dune-project"},
    filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },

})

vim.lsp.config('gopls', {
    cmd = { "gopls" },
    root_markers = {"go.mod"},
    filetypes = { "go" },

})

vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ocamllsp')

