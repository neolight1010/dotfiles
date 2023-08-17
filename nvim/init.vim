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

vim.g.livepreview_use_biber = 1

EOF

call plug#begin('~/.config/nvim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'josa42/vim-lightline-coc'

Plug 'kyazdani42/nvim-web-devicons'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'editorconfig/editorconfig-vim'

Plug 'tmsvg/pear-tree'
Plug 'tpope/vim-sleuth'
Plug 'puremourning/vimspector'
Plug 'SirVer/ultisnips'
Plug 'jparise/vim-graphql'
Plug 'neoclide/jsonc.vim'
Plug 'airblade/vim-gitgutter'
Plug 'dart-lang/dart-vim-plugin'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'mracos/mermaid.vim'
Plug 'hashivim/vim-terraform'

Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
Plug 'lervag/vimtex'

Plug 'mlaursen/vim-react-snippets'

Plug 'evanleck/vim-svelte', {'branch': 'main'}

Plug 'leafgarland/typescript-vim'
Plug 'yuezk/vim-js'

Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'ap/vim-css-color'

Plug 'jxnblk/vim-mdx-js'

Plug 'adelarsq/vim-matchit'
Plug 'jceb/vim-orgmode'

Plug 'Yggdroot/indentLine'

Plug 'purescript-contrib/purescript-vim'

Plug 'nvim-lua/plenary.nvim' " Dependency of typebreak and telescope
Plug 'nagy135/typebreak.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

Plug 'tpope/vim-repeat'
Plug 'ggandor/leap.nvim'

Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

Plug 'gen740/SmoothCursor.nvim'
Plug 'Olical/conjure'
Plug 'fedepujol/move.nvim'
Plug 'github/copilot.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'Bekaboo/deadcolumn.nvim'
Plug 'echasnovski/mini.nvim'

" Color schemes
Plug 'rafi/awesome-vim-colorschemes'
Plug 'Everblush/nvim'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'

let g:colorscheme_switcher_define_mappings = 0

" Leave vim-devicons at the bottom of plugins!!!
Plug 'ryanoasis/vim-devicons'
call plug#end()

" -------------Treesitter-------------
: lua << EOF

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
})

-------------SmoothCursor-------------
require('smoothcursor').setup({
  fancy = {
      enable = true,
  }
})

------------Mini.nvim---------------
require('mini.files').setup()
require('mini.animate').setup()

-----------------Leap.nvim------------
require('leap').add_default_mappings()

---------------Color scheme and theme configs-------------
vim.opt.termguicolors = true
vim.cmd.colorscheme("everblush")

-------------- DBUI -----------------
vim.g.db_ui_use_nerd_fonts = 1

----------------Svelte------------------
vim.g.svelte_preprocessors = { "typescript" }

-----------------ULTISNIPS---------------
vim.g.UltiSnipsExpandTrigger = "<NUL>"

-----------------PYTHON-------------------
vim.g.python3_host_prog = "~/.pyenv/versions/py3nvim/bin/python"

------------------VIM-DEVICONS-----------
vim.opt.encoding = "UTF-8"

------------------Lightline------------------
vim.g.lightline = {
  colorscheme = "everblush",
  active = {
    left = {
      { "mode", "paste" },
      { "readonly", "filename", "modified", "current_function" },
      { "coc_ok", "coc_errors", "coc_warnings", "coc_status" }
    }
  },
  component_function = {
    fugitive = "FugitiveStatusline",
    current_function = "CurrentFunction"
  }
}

EOF

function! CurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction

:lua << EOF

vim.fn["lightline#coc#register"]()

---------------------COC Autocompletion----------------------
-- TextEdit might fail if hidden is not set.
vim.opt.hidden = true


-- Some servers have issues with backup files, see #649.
vim.opt.backup = false
vim.opt.writebackup = false


-- Give more space for displaying messages.
vim.opt.cmdheight = 2


-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 300


-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

EOF

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" To make <CR> to confirm selection of selected complete item or notify coc.nvim
" to format on enter, use:
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[d` and `]d` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" ---------- Conjure -----------
let g:conjure#mapping#doc_word = "<localleader>k"
let g:conjure#filetypes = ["clojure"]

" ----------------My bindings-----------------
let mapleader=","
let maplocalleader="\\"

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

" CoC mappings
nnoremap <Leader>cd :CocList diagnostics<CR>
nnoremap <Leader>cl :CocList 
nnoremap <Leader>ck <Plug>(coc-codelens-action)
nnoremap <F5> :CocRestart<CR>

" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <Leader>co  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f :Format<Enter>

nmap <Space>r <Plug>(coc-rename)
nmap <leader>rr <Cmd>call CocAction('refactor')<CR>

nnoremap <Space>d S<Esc>

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

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
