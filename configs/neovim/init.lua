-- Global config
vim.g.mapleader = ","
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "·", space = "." }
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.shortmess:append("I")
vim.o.clipboard = 'unnamedplus'

require('vim._core.ui2').enable({})

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

-- Pack
vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/stevearc/aerial.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/rachartier/tiny-inline-diagnostic.nvim',
  'https://github.com/dhananjaylatkar/cscope_maps.nvim',
  'https://github.com/nvim-tree/nvim-tree.lua',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/NMAC427/guess-indent.nvim',
})

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

require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = "powerline",
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'FugitiveHead', 'filename', 'diagnostics' },
    lualine_c = { 'location', 'filetype' },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = { 'mode' },
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
})

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath('data') .. '/site'
})
require('nvim-treesitter').install { "c", "cpp", "lua", "vim", "vimdoc", "python", "bash", "rust" }
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

require("aerial").setup({
  layout = {
    width = 40,
  },
  open_automatic = true,
  close_automatic_events = { "unsupported" },
  disable_max_lines = 20000,
  on_attach = function(bufnr)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

require("fzf-lua").setup({
  'fzf-vim',
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "pyright",
  }
})
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  end,
})
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      }
    }
  }
})

require('tiny-inline-diagnostic').setup({
  signs = {
    left = "",
    right = "",
    arrow = " <- ",
  }
})
vim.diagnostic.config({ virtual_text = false })

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

require 'treesitter-context'.setup {
  enable = true,
  multiwindow = false,
  max_lines = 0,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = 'outer',
  mode = 'cursor',
  separator = nil,
  zindex = 20,
  on_attach = nil,
}

require("guess-indent").setup({})

-- Keymap
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>:qall<CR>')
vim.keymap.set('n', '<leader>w', '<cmd>:wqall<CR>')
vim.keymap.set("n", "<F8>", "<cmd>AerialToggle!<CR>")
vim.keymap.set('n', '<leader>s', require('fzf-lua').files)
vim.keymap.set("n", "<leader>n", nvim_tree_toggle_custom, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gb', function()
  vim.cmd('Git blame')
  vim.cmd('normal i gg')
end)
vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format()
end)
