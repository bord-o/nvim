local initialized = false

vim.api.nvim_create_autocmd("FileType", {
    pattern = "coq",
    callback = function()
        if not initialized then
            initialized = true
            vim.g.loaded_coqtail = 1
            vim.api.nvim_set_var('coqtail#supported', 0)
            require('vsrocq').setup({
                vsrocq = {
                    completion = { enable = false },
                },
            })
            local bg = string.format('#%06x', vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or 0)
            vim.cmd('highlight CoqtailChecked guibg=' .. bg)
            vim.cmd('highlight CoqtailSent guibg=' .. bg)
        end

        local opts = { noremap = true, buffer = true }
        vim.keymap.set('n', '<leader>cl', ':VsRocq interpretToPoint<CR>', opts)
        vim.keymap.set('n', '<leader>cj', ':VsRocq stepForward<CR>', opts)
        vim.keymap.set('n', '<leader>ck', ':VsRocq stepBackward<CR>', opts)
        vim.keymap.set('i', '<A-j>', '<Esc>:VsRocq stepForward<CR>a', opts)
        vim.keymap.set('i', '<A-k>', '<Esc>:VsRocq stepBackward<CR>a', opts)
        vim.keymap.set('n', '<leader>cm', ':VsRocq manual<CR>', opts)
        vim.keymap.set('n', '<leader>cc', ':VsRocq continuous<CR>', opts)
        vim.keymap.set('n', '<leader>cr', ':lua require("vsrocq").setup()<CR>', opts)
    end,
})
