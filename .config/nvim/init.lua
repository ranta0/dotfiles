vim.cmd.source("~/.vimrc")

vim.cmd [[colorscheme onedark]]

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
    }
)
