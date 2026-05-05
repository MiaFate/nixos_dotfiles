-- Set leader key before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ==============================
--  Bootstrap lazy.nvim
-- ==============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==============================
--  Plugins
-- ==============================
require("lazy").setup({
  -- Rose Pine colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "moon",
        disable_background = true,
      })
      vim.cmd("colorscheme rose-pine")
    end
  },

  -- Mason
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  -- LSP setup
  { "neovim/nvim-lspconfig" },

  -- Completion (nvim-cmp + sources)
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/vim-vsnip" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter",
    opts = {
      ensure_installed = { "lua", "rust", "toml", "markdown", "markdown_inline" },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    }
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local colors = {
        blue   = "#89b4fa",
        cyan   = "#89dceb",
        black  = "#1e1e2e",
        white  = "#a6adc8",
        red    = "#f38ba8",
        violet = "#b4befe",
        grey   = "#6c7086",
      }

      local bubbles_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.blue },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.black, bg = colors.black },
        },
        insert = { a = { fg = colors.black, bg = colors.red } },
        visual = { a = { fg = colors.black, bg = colors.cyan } },
        replace = { a = { fg = colors.black, bg = colors.red } },
        inactive = {
          a = { fg = colors.white, bg = colors.black },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.black, bg = colors.black },
        },
      }

      require("lualine").setup {
        options = {
          theme = bubbles_theme,
          component_separators = "|",
          section_separators = { left = "", right = "" },
        },
      }
    end
  },

  -- Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      -- Atajo de teclado para abrir/cerrar Neo-tree
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })

      -- Configuración de navegación dentro de Neo-tree
      require("neo-tree").setup({
        window = {
          mappings = {
            ["h"] = "navigate_up",
            ["l"] = "open",
            [";"] = "close_node",
          }
        }
      })
    end
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
      })
    end,
  },

  -- Transparent
  { "xiyaowong/transparent.nvim" },

  -- Mini icons
  { "echasnovski/mini.icons", version = false },

  -- nvim-nio (Librería requerida por otros plugins)
  { "nvim-neotest/nvim-nio" },

  -- LÖVE 2D
  {
    "S1M0N38/love2d.nvim",
    cmd = "LoveRun",
    opts = {},
    keys = {
      { "<leader>v", desc = "LÖVE" },
      { "<leader>vv", "<cmd>LoveRun<cr>", desc = "Run LÖVE" },
      { "<leader>vs", "<cmd>LoveStop<cr>", desc = "Stop LÖVE" },
    },
  },

  -- Telescope (Fuzzy Finder)
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Buscar archivos' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Buscar texto (Grep)' })
    end
  },

  -- Snacks.nvim (Utilities)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      terminal = { enabled = true },
      notifier = { enabled = true },
    },
  },

  -- Gemini CLI Integration
  {
    "vaijab/gemini-cli.nvim",
    name = "gemini-mcp", -- Nombre único para evitar conflicto
    build = "go build -o bin/gemini-server ./cmd/gemini-server",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("gemini").setup(opts)
      -- Los comandos de vaijab suelen ser :GeminiDiff*
      vim.keymap.set("n", "<leader>gy", "<cmd>GeminiDiffAccept<cr>", { desc = "Aceptar Cambios Gemini" })
      vim.keymap.set("n", "<leader>gn", "<cmd>GeminiDiffDeny<cr>", { desc = "Rechazar Cambios Gemini" })
    end
  },

  {
    "marcinjahn/gemini-cli.nvim",
    -- Este plugin se registra como 'gemini-cli.nvim' por defecto
    dependencies = { "folke/snacks.nvim" },
    opts = {
      gemini_cmd = "gemini",
    },
    keys = {
      { "<leader>gt", "<cmd>Gemini toggle<cr>", desc = "Toggle Gemini CLI", mode = { "n", "t" } },
      { "<leader>ga", "<cmd>Gemini ask<cr>", desc = "Preguntar a Gemini", mode = { "n", "v" } },
      { "<leader>gf", "<cmd>Gemini add<cr>", desc = "Agregar archivo a Gemini", mode = "n" },
    },
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      local wk = require("which-key")
      wk.setup {}

      -- Documentar los atajos en Which-key
      wk.add({
        { "<leader>e", desc = "Explorador de Archivos (Neo-tree)", mode = "n" },
        { "<leader>a", desc = "Acciones de código (LSP)", mode = "n" },
        { "<leader>v", group = "LÖVE 2D", mode = "n" },
        { "<leader>g", group = "Gemini AI", mode = "n" },
        { "<leader>f", group = "Fuzzy Finder (Telescope)", mode = "n" },
        { "<C-l>", desc = "Aceptar sugerencia de Copilot", mode = "i" },
        { "<CR>", desc = "Aceptar autocompletado", mode = "i" },
      })
    end
  }
})

-- ==============================
--  Completion (nvim-cmp)
-- ==============================
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#jumpable"](1) == 1 then
        feedkey("<Plug>(vsnip-jump-next)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})



-- ==============================
--  LSP Setup
-- ==============================
pcall(function()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "",
        package_pending = "",
        package_uninstalled = "",
      },
    },
  })
  require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "lua_ls" },
    automatic_installation = true,
  })
  require("mason-lspconfig").setup_handlers {
    function(server_name)
      require("lspconfig")[server_name].setup {}
    end,
    ["lua_ls"] = function()
      require("lspconfig").lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,
    ["rust_analyzer"] = function()
      require("lspconfig").rust_analyzer.setup {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<C-space>", vim.lsp.buf.hover, { buffer = bufnr })
          vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, { buffer = bufnr })
        end,
      }
    end,
  }
end)

-- ==============================
--  Opciones generales
-- ==============================
vim.cmd("set number")
vim.cmd("set expandtab")
vim.cmd("set shiftwidth=4")
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.o.updatetime = 300

-- Transparency fix
local function set_transparency()
    local highlights = {
        "Normal",
        "NormalFloat",
        "NormalNC",
        "SignColumn",
        "MsgArea",
        "StatusLine",
        "StatusLineNC",
        "WinSeparator",
        "Pmenu",
        "NormalSB",
    }
    for _, hl in ipairs(highlights) do
        vim.api.nvim_set_hl(0, hl, { bg = "none", ctermbg = "none" })
    end
end

set_transparency()
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_transparency,
})
-- ==============================
--  Diagnósticos LSP
-- ==============================
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '' })
sign({ name = 'DiagnosticSignHint', text = '' })
sign({ name = 'DiagnosticSignInfo', text = '' })

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = true,
    header = '',
    prefix = '',
  },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- ==============================
--  Disable Provider Warnings
-- ==============================
-- Disable Node.js provider (not needed, and warning about missing 'neovim' package)
vim.g.loaded_node_provider = 0

-- Disable Ruby provider (not needed)
vim.g.loaded_ruby_provider = 0

-- Disable Perl provider (not needed)
vim.g.loaded_perl_provider = 0

-- Disable Python3 provider (not needed for this config)
vim.g.loaded_python3_provider = 0

-- ==============================
--  Terminal Mappings
-- ==============================
-- Usar Esc para salir del modo terminal de forma intuitiva en todos los terminales
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-terminal-settings", { clear = true }),
  callback = function()
    local opts = { buffer = 0, noremap = true, silent = true }
    vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
    -- Navegación directa entre ventanas desde el terminal
    vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts)
    vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts)
    vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts)
    vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts)
  end,
})

