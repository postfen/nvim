local M = {}
M.tools = {
    "prettierd",
    "stylua",
    "selene",
    "luacheck",
    "eslint_d",
    "shellcheck",
    "deno",
    "shfmt",
    "black",
    "isort",
    "flake8",
    "codelldb",
    "clang-format",
    "markdownlint",
    "flake8",
    "debugpy",
}

function M.check()
    local mr = require("mason-registry")
    for _, tool in ipairs(M.tools) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
            p:install()
        end
    end
end

function M.config()
    local status_ok, mason = pcall(require, "mason")
    if not status_ok then
        return
    end

    local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not status_ok_1 then
        return
    end

    local servers = {
        "tsserver",
        "clangd",
        "sumneko_lua",
        "tsserver",
        "pyright",
        "yamlls",
        "bashls",
        "omnisharp",
        "rust_analyzer",
        "jsonls",
        "marksman",
        "perlnavigator",
        "awk_ls",
        "tailwindcss",
        "jdtls"
    }

    local settings = {
        ui = {
            border = "rounded",
        },
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 4,
    }

    local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
    if not lspconfig_status_ok then
        return
    end

    mason.setup(settings)
    mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
    })

    local opts = {}

    for _, server in pairs(servers) do
        opts = {
            on_attach = require("fenvim.lsp.handlers").on_attach,
            capabilities = require("fenvim.lsp.handlers").capabilities,
        }

        server = vim.split(server, "@", {})[1]
        if server == "jsonls" then
            local jsonls_opts = require("fenvim.lsp.settings.jsonls")
            opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
        end

        if server == "omnisharp" then
            local omnisharp_opts = require("fenvim.lsp.settings.omnisharp")
            opts = vim.tbl_deep_extend("force", omnisharp_opts, opts)
        end

        if server == "bash-language-server" then
            local bash_opts = require("fenvim.lsp.settings.bash")
            opts = vim.tbl_deep_extend("force", bash_opts, opts)
        end

        if server == "tailwindcss" then
            -- local tailwindcss_opts = require("fenvim.lsp.settings.tailwindcss")
            -- opts = vim.tbl_deep_extend("force", tailwindcss_opts, opts)
        end

        if server == "yamlls" then
            local yamlls_opts = require("fenvim.lsp.settings.yamlls")
            opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
        end

        if server == "sumneko_lua" then
            local sumneko_opts = require("fenvim.lsp.settings.sumneko_lua")
            opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
        end

        if server == "clangd" then
            local clangd = require("fenvim.lsp.settings.clangd")
            opts = vim.tbl_deep_extend("force", clangd, opts)
        end

        if server == "tsserver" then
            local tsserver_opts = require("fenvim.lsp.settings.tsserver")
            require("typescript").setup({ server = opts, tsserver_opts })
            goto continue
        end

        if server == "pyright" then
            local pyright_opts = require("fenvim.lsp.settings.pyright")
            opts = vim.tbl_deep_extend("force", pyright_opts, opts)
        end

        if server == "rust_analyzer" then
            local rust_opts = require("fenvim.lsp.settings.rust")
            local rust_tools_status_ok, rust_tools = pcall(require, "rust-tools")
            rust_tools.setup(rust_opts)

            goto continue
        end

        if server == "jdtls" then
            -- goto continue
        end

        if server == "perlnavigator" then
            local perl_opts = require("fenvim.lsp.settings.perl")
            opts = vim.tbl_deep_extend("force", perl_opts, opts)
        end

        -- require'lspconfig'.perlnavigator.setup{}
        lspconfig[server].setup(opts)
        ::continue::
    end
end
return M