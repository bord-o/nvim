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

