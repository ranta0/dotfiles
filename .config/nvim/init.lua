vim.cmd.source("~/.vimrc")

local present, _ = pcall(require, "onedark")
if present then
  vim.cmd([[colorscheme onedark]])
end

present, _ = pcall(require, "nvim-treesitter")
if present then
  require("nvim-treesitter.configs").setup({
    auto_install = true,
    sync_install = true,
    highlight = {
      enable = true,
      disable = function(_, bufnr)
        return vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > 1024 * 1024 * 1.5
      end,
      additional_vim_regex_highlighting = { "php" },
    },
    indent = {
      enable = true,
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
  })
end

present, _ = pcall(require, "oil")
if present then
  require("oil").setup({
    view_options = {
      show_hidden = true,
    },
  })
  vim.keymap.set("n", "-", [[<CMD>Oil<CR>]], { silent = false })
end

present, _ = pcall(require, "mini.completion")
if present then
  require("mini.completion").setup()
  vim.keymap.set("i", "<TAB>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = false })
  vim.keymap.set("i", "<S-TAB>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true, silent = false })
end

present, _ = pcall(require, "mason")
if present then
  require("mason").setup()
end

present, _ = pcall(require, "mason-lspconfig")
if present then
  require("mason-lspconfig").setup()
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
  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup_handlers({
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,

    ["intelephense"] = function()
      lspconfig.intelephense.setup({
        settings = {
          intelephense = {
            enviroment = { version = "8.3.0" },
          },
        },
      })
    end,

    ["ts_ls"] = function()
      lspconfig.ts_ls.setup({
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = require("mason-registry").get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server",
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
    end,

    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
    end,
  })

  lspconfig.gdscript.setup({})
end

local formatters = {
  Prettier = "prettier --write",
  Stylua = "stylua",
}
local mason_path = vim.fn.stdpath("data") .. "/mason/bin/"
for formatter, cmd in pairs(formatters) do
  vim.api.nvim_create_user_command(formatter, function()
    vim.cmd("write")
    vim.cmd("silent !" .. mason_path .. cmd .. " %")
  end, {})
end
