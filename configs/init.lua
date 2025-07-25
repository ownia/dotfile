local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.o.number = true
vim.o.list = true
vim.opt.listchars = { tab = ">-", trail = "·", space = "." }
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>:qall<CR>')
vim.keymap.set('n', '<leader>w', '<cmd>:wqall<CR>')

-- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') or ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

require("lazy").setup({
  {
    'NMAC427/guess-indent.nvim',
    config = function()
      require("guess-indent").setup({})
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
        transparent = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
        },
        on_highlights = function(hl, colors)
          hl.LineNr = {
            fg = "#505878",
          }
          hl.CursorLineNr = {
            fg = colors.yellow,
          }
        end,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = "powerline",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'FugitiveHead', 'filename', 'diagnostics'},
          lualine_c = {'location', 'filetype'},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        inactive_sections = {
          lualine_a = {'mode'},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "python", "bash", "rust" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    'stevearc/aerial.nvim',
    config = function()
      require("aerial").setup({
        open_automatic = true,
        close_automatic_events = { "unsupported" },
        on_attach = function(bufnr)
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        end,
      })
      vim.keymap.set("n", "<F8>", "<cmd>AerialToggle!<CR>")
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        'fzf-vim',
      })
      vim.keymap.set('n', '<leader>f', require('fzf-lua').files)
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = "BufReadPost",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "pyright"
        }
      })
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            }
          }
        }
      })
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup({
        signs = {
          left = "",
          right = "",
          arrow = " <- ",
        }
      })
      vim.diagnostic.config({ virtual_text = false })
    end
  },
  {
    "dhananjaylatkar/cscope_maps.nvim",
    config = function()
      require('cscope_maps').setup({
        skip_input_prompt = true,
        prefix = "<C-\\>",
        cscope = {
          picker = "fzf-lua",
          picker_opts = {
            window_size = 10,
          },
          skip_picker_for_single_result = true,
        },
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    init = function()
      local function nvim_tree_toggle_custom()
        local view = require("nvim-tree.view")
        if view.is_visible() then
          if vim.bo.filetype == "NvimTree" then
            require("nvim-tree.api").tree.close()
          else
            require("nvim-tree.api").tree.focus()
          end
        elseif vim.bo.filetype == "NvimTree" then
          require("nvim-tree.api").tree.toggle()
        else
          require("nvim-tree.api").tree.find_file({ open = true, focus = true })
        end
      end
      vim.keymap.set("n", "<leader>n", nvim_tree_toggle_custom, { noremap = true, silent = true })
    end,
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 40,
        },
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = true,
              git = false,
              modified = false,
              hidden = false,
              diagnostics = false,
              bookmarks = false,
            },
            glyphs = {
              folder = {
                arrow_closed = "▸",
                arrow_open = "▾",
              }
            }
          }
        }
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set('n', '<leader>gb', function()
        vim.cmd('Git blame')
        vim.cmd('normal i gg')
      end)
    end,
  },
})
