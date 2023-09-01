:lua << EOF

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.mouse = "a"
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "2"
vim.opt.colorcolumn = "80"
vim.opt.laststatus = 3
vim.opt.spell = true
vim.opt.mousescroll = "ver:1,hor:5"
vim.opt.scrolloff = 5
vim.opt.path:append("**")
vim.opt.signcolumn = "auto"

if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))",
      ["*"] = "powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))",
    },
    cache_enabled = 0,
  }
end

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

--------------Plugins----------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "tpope/vim-fugitive",
  "tpope/vim-surround",
  "editorconfig/editorconfig-vim",
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  "tpope/vim-sleuth",
  "puremourning/vimspector",
  "jparise/vim-graphql",
  "neoclide/jsonc.vim",
  "airblade/vim-gitgutter",
  "dart-lang/dart-vim-plugin",
  "Vimjas/vim-python-pep8-indent",
  "mracos/mermaid.vim",
  "hashivim/vim-terraform",
  "lervag/vimtex",
  "mlaursen/vim-react-snippets", 
  {
    "evanleck/vim-svelte",
    branch = "main",
  },
  {
    "williamboman/mason.nvim",
    config = function ()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    config = function ()
      require("mason-lspconfig").setup()

      require("mason-lspconfig").setup_handlers({
          function (server_name)
              require("lspconfig")[server_name].setup({})
          end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function ()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {},
        window = {},
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          -- TODO Add buffer source
        })
      })
    end,
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
  },
  "leafgarland/typescript-vim",
  "yuezk/vim-js",
  "HerringtonDarkholme/yats.vim",
  "maxmellon/vim-jsx-pretty",
  "ap/vim-css-color",
  "jxnblk/vim-mdx-js",
  "adelarsq/vim-matchit",
  "jceb/vim-orgmode",
  "Yggdroot/indentLine",
  "purescript-contrib/purescript-vim",
  { "nagy135/typebreak.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function ()
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            preview_cutoff = 0,
            height = 0.9,
          }
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ["<c-d>"] = "delete_buffer",
              },
              n = {
                ["<c-d>"] = "delete_buffer",
              }
            }
          }
        }
      })
    end
  },
  "tpope/vim-repeat",
  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",
  "gen740/SmoothCursor.nvim",
  {
    "Olical/conjure",
    ft = { "clojure" },
    init = function ()
      vim.g["conjure#mapping#doc_word"] = "<localleader>k"
    end,
  },
  "fedepujol/move.nvim",
  "github/copilot.vim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        highlight = { enable = true },
      })
    end
  },
  "Bekaboo/deadcolumn.nvim",
  {
    "echasnovski/mini.nvim",
    version = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      require('mini.files').setup()
      require('mini.animate').setup()
      require("mini.jump").setup()
      require("mini.jump2d").setup({
        mappings = {
          start_jumping = "s"
        },
      })
      require('mini.tabline').setup()
      require('mini.comment').setup()
      require('mini.cursorword').setup()
      require('mini.indentscope').setup()
      require('mini.splitjoin').setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      require("lualine").setup()
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function ()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          }
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        }
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function ()
      vim.keymap.set("n", "<leader>xx", function() require("trouble").open() end)
      vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end)
      vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end)
      vim.keymap.set("n", "<leader>xq", function() require("trouble").open("quickfix") end)
      vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end)
      vim.keymap.set("n", "gr", function() require("trouble").open("lsp_references") end)
    end
  },

  -- Color schemes
  "rafi/awesome-vim-colorschemes",
  { 'Everblush/nvim', name = 'everblush' },
  { "xolox/vim-colorscheme-switcher", dependencies = { "xolox/vim-misc" } },
})

vim.g.colorscheme_switcher_define_mappings = 0

-------------SmoothCursor-------------
require('smoothcursor').setup({
  fancy = {
      enable = true,
  }
})

---------------Color scheme and theme configs-------------
vim.opt.background = "dark"
vim.cmd.colorscheme("everblush")
vim.opt.termguicolors = true

-------------- DBUI -----------------
vim.g.db_ui_use_nerd_fonts = 1

----------------Svelte------------------
vim.g.svelte_preprocessors = { "typescript" }

-----------------PYTHON-------------------
vim.g.python3_host_prog = "~/.pyenv/versions/py3nvim/bin/python"

------------------VIM-DEVICONS-----------
vim.opt.encoding = "UTF-8"

EOF

" ----------------My bindings-----------------

nnoremap <Leader>tn :tabnew %<CR>
nnoremap <Leader>n <Cmd>nohlsearch\|diffupdate\|redraw<CR>
imap kj <Esc>
nnoremap [b <Cmd>bprevious<CR>
nnoremap ]b <Cmd>bnext<CR>

" New line below without insert mode
nnoremap <Space>o o<Esc>
nnoremap W :w<CR>

" Telescope mappings
nnoremap <Space>f <cmd>Telescope find_files<cr>
nnoremap <Space>g <cmd>Telescope live_grep<cr>
nnoremap <Space>b <cmd>Telescope buffers<cr>
nnoremap <Space>h <cmd>Telescope help_tags<cr>

" GitGutter mappings
nnoremap [c :GitGutterPrevHunk<CR>
nnoremap ]c :GitGutterNextHunk<CR>

nnoremap <Leader>ga :GitGutterStageHunk<CR>
nnoremap <Leader>gp :GitGutterPreviewHunk<CR>
nnoremap <Leader>gu :GitGutterUndoHunk<CR>

nnoremap <Leader>G :G 
nnoremap <Leader>gs :G<CR>
nnoremap <Leader>gb :G blame<CR>

" Colorscheme mappings
nnoremap <silent> <F12> :NextColorScheme<CR>
nnoremap <silent> <S-F12> :PrevColorScheme<CR>
nnoremap <silent> <C-F12> :RandomColorScheme<CR>

nnoremap <leader>tb :lua require("typebreak").start()<CR>

" Vimspector
" let g:vimspector_enable_mappings = 'HUMAN'
nnoremap <Leader>dd :call vimspector#Launch()
nnoremap <Leader>de :call vimspector#Reset()
nnoremap <Leader>dr :call vimspector#Restart()
nnoremap <Leader>dc :call vimspector#Continue() <CR>

nnoremap <Leader>dj :call vimspector#StepInto() <CR>
nnoremap <Leader>dl :call vimspector#StepOver() <CR>
nnoremap <Leader>do :call vimspector#StepOut() <CR>
nnoremap <Leader>drc :call vimspector#RunToCursor() <CR>

nnoremap <Leader>db :call vimspector#ToggleBreakpoint() <CR>

" Normal-mode commands
nnoremap <silent> <C-j> :MoveLine(1)<CR>
nnoremap <silent> <C-k> :MoveLine(-1)<CR>
nnoremap <silent> <C-l> :MoveHChar(1)<CR>
nnoremap <silent> <C-h> :MoveHChar(-1)<CR>

" Visual-mode commands
vnoremap <silent> <C-j> :MoveBlock(1)<CR>
vnoremap <silent> <C-k> :MoveBlock(-1)<CR>
vnoremap <silent> <C-l> :MoveHBlock(1)<CR>
vnoremap <silent> <C-h> :MoveHBlock(-1)<CR>

" Copilot
imap <silent><script><expr> <C-l> copilot#Accept("")
let g:copilot_no_tab_map = v:true

" File exploration
nnoremap <F6> :lua MiniFiles.open()<CR>
nnoremap <C-n> :lua MiniFiles.open()<CR>

nnoremap <Space>d S<Esc>

:lua << EOF

-- LSP configs
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, { buffer = args.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = args.buf })
    vim.keymap.set('n', '<Space>r', vim.lsp.buf.rename, { buffer = args.buf })

    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, { buffer = args.buf })
    vim.keymap.set('v', '<Leader>c', vim.lsp.buf.code_action, { buffer = args.buf })

    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = args.buf })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = args.buf })
  end,
})

local signs = { Error = "", Warning = "", Hint = "", Information = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

EOF
