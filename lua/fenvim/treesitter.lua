local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "p00f/nvim-ts-rainbow",
        "nvim-treesitter/playground",
        "nvim-treesitter/nvim-treesitter-context",
        "JoosepAlviste/nvim-ts-context-commentstring",
        {
            "windwp/nvim-ts-autotag",
            config = true,
        },
    },
    lazy = true,
    event = "BufReadPost",
}
function M.config()
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
        return
    end

    --local configs = require("nvim-treesitter.configs")
    configs.setup({
        ensure_installed = {
            "python",
            "c",
            "c_sharp",
            "bash",
            "rust",
            "lua",
            "javascript",
            "markdown",
            "typescript",
            "tsx",
            "css",
            "html",
        },
        sync_install = false,
        ignore_install = { "" }, -- List of parsers to ignore installing
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = { "text", "txt" }, -- list of language that will be disabled
            additional_vim_regex_highlighting = true,
        },
        rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, -- list of languages you want to disable plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {"#518387", "#a86885", "#548287", "#6E9054", "#CD9E39", "#C87924" }, -- table of hex strings
            -- term colors = {}, -- table of colour name strings
        },
        indent = { enable = true, disable = { "yaml", "python" } },
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
    })
end
return M
