vim.cmd("command! Retab set et|retab")

vim.o.hlsearch = true
vim.o.textwidth = 120
vim.o.number = true
vim.o.mouse = 'a'
vim.o.breakindent = true

vim.opt.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.termguicolors = true
vim.o.timeout = 500
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 50
vim.o.updatetime = 250

-- No tabs allowed
vim.o.tabstop = 2
vim.o.scrolloff = 999

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

vim.cmd [[
filetype plugin indent on
syntax enable
let mapleader = " "
set noswapfile
set title
set scrolloff=999
set number
set expandtab tabstop=2 shiftwidth=2
set splitbelow
set splitright
set cursorline
set ignorecase
set smartindent
set virtualedit=block
set whichwrap+=<,>,h,l,[,]
set autowrite
set autoread
set autowriteall
set gdefault
set inccommand=split
" set grepprg=rg
set synmaxcol=1500
set list
set nobackup
set nowritebackup
set shortmess+=c
set cmdheight=2
set showtabline=2
set fillchars+=diff:\
set diffopt=internal,filler,algorithm:patience,foldcolumn:0,context:4
set laststatus=3
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
" Set min win height
" set winheight=33

" Folding
set nofoldenable
set foldmethod=indent
set foldexpr=nvim_treesitter#foldexpr()
set foldtext=getline(v:foldstart).'...'.trim(getline(v:foldend))
set foldnestmax=5
set foldminlines=2
set fillchars+=fold:\

map <F1> <Esc>
imap <F1> <Esc>
nnoremap <silent> <ESC> :noh  <CR><ESC>
nnoremap <space>s :w<CR>
nnoremap gp `[v`]
nnoremap Q @q
nnoremap gj J
nnoremap <backspace> <c-^>
nnoremap <c-g> :let @+ = expand("%:p") . ":" . line(".") \| echo 'copied ' . @+ . ' to the clipboard.'<CR>
nmap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>
nmap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>
map J }
map K {
noremap gf gF
noremap H ^
noremap L $
nnoremap j gj
nnoremap k gk
vnoremap > >gv
map gx <Cmd>call jobstart(["xdg-open", expand("<cfile>")])<CR>
]]
