vim.cmd.source("~/.vimrc")

local present, _ = pcall(require, "onedark")
if present then
  vim.cmd([[colorscheme onedark]])
end

present, _ = pcall(require, "nvim-treesitter")
if present then
  pcall(require("nvim-treesitter.install").update({ with_sync = true }))
  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "php" },
      disable = function(lang, bufnr)
        return lang == "javascript" and vim.api.nvim_buf_line_count(bufnr) > 50000
      end,
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    ensure_installed = {
      "vimdoc",
      "markdown",
      "tsx",
      "typescript",
      "javascript",
      "toml",
      "json",
      "yaml",
      "rust",
      "css",
      "lua",
      "php",
      "go",
      "bash",
    },
    rainbow = {
      enable = true,
      disable = { "html" },
      extended_mode = false,
      max_file_lines = nil,
    },
    autotag = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
      },
    },
    indent = {
      enable = true,
    },
  })
end

present, _ = pcall(require, "conform")
if present then
  require("conform").setup({
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      svelte = { "prettier" },
      vue = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      lua = { "stylua" },
      sh = { "shfmt" },
    },
  })
end

present, _ = pcall(require, "mason")
if present then
  require("mason").setup()
end

present, _ = pcall(require, "cmp")
if present then
  local cmp = require("cmp")

  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete({}),
      ["<C-c>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
    }, {
      { name = "buffer" },
    }),
  })
end

present, _ = pcall(require, "lspconfig")
if present then
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
      vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
      vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
      vim.keymap.set("n", "<leader>rp", vim.lsp.buf.rename, { buffer = 0 })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
      vim.keymap.set("n", "<leader>mf", vim.lsp.buf.format, { buffer = 0 })
      vim.keymap.set("n", "<leader>ws", function()
        vim.lsp.buf.workspace_symbol()
      end, { buffer = 0 })
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
    end,
  })

  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim", "it", "describe", "before_each", "after_each" },
        },
        hint = { enable = true },
      },
    },
  })

  local mason_registry = require("mason-registry")
  local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"
  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vue_language_server_path,
          languages = { "vue" },
        },
      },
    },
    single_file_support = true,
    completions = {
      completeFunctionCalls = true,
    },
    filetypes = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "jsx",
      "tsx",
      "vue",
    },
  })

  lspconfig.intelephense.setup({
    capabilities = capabilities,
    settings = {
      intelephense = {
        enviroment = { version = "8.3.0" },
      },
    },
  })

  lspconfig.jsonls.setup({
    capabilities = capabilities,
  })

  lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
  })

  lspconfig.gopls.setup({
    capabilities = capabilities,
  })
end
