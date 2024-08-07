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
vim.opt_global.shortmess:remove("F")

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
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      enable_check_bracket_line = false,
    },
  },
  "tpope/vim-sleuth",
  {
    "lewis6991/gitsigns.nvim",
    config = function ()
    require("gitsigns").setup({
      numhl = true,
      word_diff = false,
      current_line_blame = true,
      on_attach = function (bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]c", function ()
          if vim.wo.diff then
            return "]c"
          end

          vim.schedule(function ()
            gs.next_hunk()
          end)

          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function ()
          if vim.wo.diff then
            return "[c"
          end

          vim.schedule(function ()
            gs.prev_hunk()
          end)

          return "<Ignore>"
        end, { expr = true })

        map("n", "<Leader>hs", gs.stage_hunk)
        map("n", "<Leader>hr", gs.reset_hunk)
        map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function () gs.blame_line({ full = true }) end)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)

        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>td', gs.toggle_deleted)
        map('n', '<leader>tw', gs.toggle_word_diff)
        map('n', '<leader>th', gs.toggle_linehl)

        map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    })
    end,
  },
  {
    "mhartington/formatter.nvim",
    config = function ()
      require("formatter").setup({
        filetype = {
          python = {
            require("formatter.filetypes.python").black,
          },
          typescript = {
            require("formatter.filetypes.typescript").prettier,
          },
          typescriptreact = {
            require("formatter.filetypes.typescriptreact").prettier,
          },
          ["*"] = {
            function ()
              local defined_types = require("formatter.config").values.filetype
              if defined_types[vim.bo.filetype] ~= nil then
                return nil
              end

              vim.lsp.buf.format({ async = true })
            end,
          },
        },
      })

      vim.keymap.set("n", "<Leader>f", "<Cmd>Format<CR>", { silent = true })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function ()
      require("lint").linters_by_ft = {
        python = { "pylint" }
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function ()
          local current_filetype = vim.bo.filetype
          local try_lint = require("lint").try_lint

          if current_filetype == "python" then
            if vim.fn.findfile(".pylintrc", ".;") ~= "" then
              try_lint()
              return
            end

            return
          end

          try_lint()
        end,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function ()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "mhartington/formatter.nvim",
    },
    config = function ()
      require("mason-lspconfig").setup()

      require("mason-lspconfig").setup_handlers({
        function (server_name)
          require("lspconfig")[server_name].setup({})
        end,

        ["tsserver"] = function ()
          local lspconfig = require("lspconfig")

          lspconfig.tsserver.setup({
            root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
            single_file_support = false,
          })
        end,

        ["denols"] = function ()
          local lspconfig = require("lspconfig")

          lspconfig.denols.setup({
            root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
            single_file_support = false,
          })
        end
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
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "nvim_lsp_signature_help" },
        }),
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
          }),
        }
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
        }
      })
    end,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind.nvim",
    },
  },

  {
    "scalameta/nvim-metals",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "scala" },
    config = function ()
      require("metals").initialize_or_attach({})
    end,
  },

  {
    "maxmellon/vim-jsx-pretty",
    ft = { "javascriptreact", "typescriptreact" },
  },
  "ap/vim-css-color",
  "adelarsq/vim-matchit", -- TODO How useful is this plugin?
  "Yggdroot/indentLine", -- TODO Lua alternative?
  
  {
    "purescript-contrib/purescript-vim",
    ft = { "purescript" },
  },
  
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
 
  {
    "Olical/conjure",
    ft = { "clojure" },
    init = function ()
      vim.g["conjure#mapping#doc_word"] = "<localleader>k"
    end,
  },
  "fedepujol/move.nvim",
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
      require("mini.jump").setup()
      require("mini.jump2d").setup({
        mappings = {
          start_jumping = "gw"
        },
      })
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
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      require("bufferline").setup({
        options = {
          indicator = {
          },
        },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function ()
      vim.keymap.set("n", "<leader>xx", "<Cmd>TroubleToggle<CR>")
      vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end)
      vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end)
      vim.keymap.set("n", "<leader>xq", function() require("trouble").open("quickfix") end)
      vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end)
      vim.keymap.set("n", "gr", function() require("trouble").open("lsp_references") end)
      vim.keymap.set("n", "gi", function() require("trouble").open("lsp_implementations") end)
      vim.keymap.set("n", "gd", function() require("trouble").open("lsp_definitions") end)
      vim.keymap.set("n", "gt", function() require("trouble").open("lsp_type_definitions") end)
    end
  },
  "famiu/bufdelete.nvim",
  {
    "gsuuon/tshjkl.nvim",
    config = true,
  },
  {
    "hedyhli/outline.nvim",
    config = function ()
      vim.keymap.set("n", "<Leader>o", "<Cmd>Outline<CR>", { desc = "Toggle Outline" })

      require("outline").setup({})
    end,
  },
  {
    "https://git.sr.ht/~swaits/scratch.nvim",
    lazy = true,
    keys = {
      { "<leader>bs", "<cmd>Scratch<cr>", desc = "Scratch Buffer", mode = "n" },
      { "<leader>bS", "<cmd>ScratchSplit<cr>", desc = "Scratch Buffer (split)", mode = "n" }
    },
    cmd = {
      "Scratch",
      "ScratchSplit",
    },
    opts = {},
  },
  {
      "tamton-aquib/keys.nvim",
      cmd = "KeysToggle"
  },

  {
    "folke/zen-mode.nvim",
    opts = {},
    cmd = { "ZenMode" },
    dependencies = { "folke/twilight.nvim" },
  },

  -- Color schemes
  "rafi/awesome-vim-colorschemes",
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  "katawful/kat.nvim",
  { "xolox/vim-colorscheme-switcher", dependencies = { "xolox/vim-misc" } },
})

vim.g.colorscheme_switcher_define_mappings = 0

---------------Color scheme and theme configs-------------
vim.opt.background = "dark"
vim.cmd.colorscheme("challenger_deep")
vim.opt.termguicolors = true
vim.cmd("highlight LineNr guifg=white")

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
nno remap <Leader>n <Cmd>nohlsearch\|diffupdate\|redraw<CR>
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

" File exploration
nnoremap <F6> :lua MiniFiles.open()<CR>
nnoremap <C-n> :lua MiniFiles.open()<CR>

nnoremap <Space>d S<Esc>

:lua << EOF

-- Custom mappings

vim.keymap.set("n", "[t", "<Cmd>tabprevious<CR>");
vim.keymap.set("n", "]t", "<Cmd>tabnext<CR>");
vim.keymap.set("n", "ga", "<Cmd>e #<CR>")

-- LSP configs
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set('n', '<Space>k', vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set('n', '<Space>r', vim.lsp.buf.rename, { buffer = args.buf })
    vim.keymap.set('n', '<Space>a', vim.lsp.buf.code_action, { buffer = args.buf })
    vim.keymap.set('v', '<Space>a', vim.lsp.buf.code_action, { buffer = args.buf })

    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = args.buf })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = args.buf })
  end,
})

local signs = { Error = "", Warning = "", Hint = "", Information = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function (ev)
    if vim.fn.argc() == 0 then
      vim.cmd("Scratch")
    end
  end,
})

EOF
