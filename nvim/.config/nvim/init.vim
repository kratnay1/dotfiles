" init.vim --> init.lua (eventually)

"" plugins
call plug#begin()
Plug 'tyrannicaltoucan/vim-quantum' 
call plug#end()

"" basic settings
let $BASH_ENV = "~/.bash_aliases"
set noswapfile
set undofile
set nofoldenable
set tabstop=2 " expand tab chars to 2 spaces
set shiftwidth=2 
set softtabstop=2
set hidden " allow switching buffers without saving
set ignorecase " case insensitive search
set smartcase " unless pattern contains uppercase letters
set scrolloff=2 " start scrolling 2 lines before top/bottom
set number " relative line numbering except for current line
set relativenumber
set synmaxcol=500 " limit syntax highlighting on long lines
set lazyredraw " speed up scrolling
set wrap linebreak nolist
set wildoptions=pum " popup menu for comand line completion
set pumblend=17 " transparent completion menu
set wildmode=longest:full
set wildignore+=*.class,*.sw?,*~,*.png,*.jpg,*.gif,*.min.js,*.o,*.pyc,*pycache*
set splitright " more natural splits
set splitbelow
set inccommand=split " preview substitutions (nvim only)
set updatetime=250 " faster diagnostic messages (default is 4000)
set timeoutlen=300 " decrease mapped sequence wait time
set cmdheight=0 " new neovim feature
set breakindent " indent wrapped lines, indicate with showbreak
set showbreak=↪\ \ 
set listchars=eol:¬,nbsp:␣,tab:\ \ 
set termguicolors " set true-color
set clipboard=unnamedplus 

let hlstate=0 " no persistent search highlighting
let g:tmux_navigator_save_on_switch = 1

"" autocmd
if has("autocmd")
	""" general settings
	augroup general
		autocmd!
		" For all text files set 'textwidth' to 78 characters.
		" Enable file type detection
		autocmd FileType text setlocal textwidth=78
		autocmd FileType * setlocal formatoptions-=r formatoptions-=o

		" When editing a file, jump to the last known cursor position
		autocmd BufReadPost *
					\ if line("'\"") > 1 && line("'\"") <= line("$") |
					\   exe "normal! g`\"" |
					\ endif
	augroup END
	""" LaTeX macros for compiling and viewing
	augroup latex_macros 
		autocmd!
		autocmd FileType tex :set showbreak=\ \ \ 
		autocmd FileType tex :nnoremap <leader>c :w<CR>:!rubber --pdf --warn all %<CR><CR>
		autocmd FileType tex :nnoremap <leader>v :!evince %:r.pdf &<CR><CR>
		autocmd FileType tex :nnoremap <C-m> :!touch main.tex<CR> :make<CR><CR><C-e>
	augroup END 

	""" auto save when focus is lost
	augroup auto_save
		autocmd!
		autocmd FocusLost * :wa
		let g:auto_save = 1
		let g:auto_save_silent = 1
	augroup END

	augroup highlighted_yank
		au TextYankPost * silent! lua vim.highlight.on_yank {higroup="Search", timeout=150}
	augroup END
endif " has("autocmd")


"" mappings
""" general mappings
map <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>
map <Space> <leader>
nnoremap <C-y> <c-r> 
nmap <leader>q :q<cr>
nmap <leader><leader>q :wq<cr>
noremap <C-s> :w<CR>
noremap S :w<CR>
nnoremap <c-p> :
" nnoremap <c-;> : " doesn't work
nnoremap <silent> <leader>8 :set list!<CR>
nnoremap Y yy
nnoremap C cc
nmap cc c$
nnoremap <leader>= :let b:PlugView=winsaveview()<CR>:keepjumps call cursor([1,1])<cr>=G:call winrestview(b:PlugView)<CR>:echo "file indented"<CR><CR>
noremap ' `
" escape before scroll page up in insert mode
imap <c-u> <Esc>u
" clear search highlighting
nnoremap <cr> :nohl<cr>

" map . in visual mode
vnoremap . :norm.<cr>

" Don't use Ex mode
map Q @q

""" edit and source dotfiles
nmap <leader>V :edit $MYVIMRC<cr>
nmap <leader>v :source $MYVIMRC<cr><leader><space>
nmap <leader>br :edit ~/.bashrc<cr>
nmap <leader>ba :edit ~/.bash_aliases<cr>

""" movement
nnoremap <C-e> <c-i>
nnoremap <C-D> 7<C-e>
nnoremap <C-U> 7<C-y>
nnoremap <C-I> 7<C-y>
" nnoremap <C-D> <C-d>zz
" nnoremap <C-U> <C-u>zz
" nnoremap <C-I> <C-u>zz
nnoremap j gj
nnoremap k gk
" For moving quickly up and down (taken from tjdevries)
" Goes to the first line above/below that isn't whitespace
" Thanks to: http://vi.stackexchange.com/a/213
nnoremap <silent> gj :let _=&lazyredraw<cr>:set lazyredraw<cr>/\%<c-r>=virtcol(".")<cr>v\S<cr>:nohl<cr>:let &lazyredraw=_<cr>
nnoremap <silent> gk :let _=&lazyredraw<cr>:set lazyredraw<cr>?\%<c-r>=virtcol(".")<cr>v\S<cr>:nohl<cr>:let &lazyredraw=_<cr>
" Store relative line number jumps in the jumplist if they exceed a threshold.
nnoremap <expr> k (v:count > 8 ? "m'" . v:count : '') . 'gk'
nnoremap <expr> j (v:count > 8 ? "m'" . v:count : '') . 'gj'
" Move visual block
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv
" buffers
nnoremap <leader>1 :b1<cr>
nnoremap <leader>2 :b2<cr>
nnoremap <leader>3 :b3<cr>
nnoremap <leader>4 :b4<cr>
nnoremap <leader>5 :b5<cr>
nnoremap <silent> <c-w> :b#<cr>
" quickfix list
nmap cn :cn<cr>
nmap cp :cp<cr>
nmap cl :cl<cr>
nmap cz :cw<cr>
nmap co :copen<cr>
nmap cq :cclose<cr>
" centering on search and move to EOF
nnoremap n nzz
nnoremap N Nzz
nnoremap G Gzz

" vim-commentary
nmap <c-_> gcc
vmap <c-_> gc

" shebang
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

" splits
nnoremap <silent> <leader>s :vsplit<cr>
nnoremap <silent> <leader>S :split<cr>

" Sizing window horizontally
nnoremap <s-n> <c-w>5<
nnoremap <s-w> <c-w>5>
" Sizing window vertically
"taller
nnoremap <s-t> <c-w>+
" shorter
nnoremap <s-s> <c-w>-

" Open new file adjacent to current file
nnoremap <leader>n :e <c-r>=expand("%:p:h") . "/"<cr>

" change working directory for all windows
nnoremap <leader>cd :windo lcd 

""" GitGutter
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)

"" colors -- move to after colors
colorscheme quantum
let g:quantum_black=1

hi LineNr ctermfg=none ctermbg=none guifg=#737373 guibg=none cterm=none
hi CursorLineNr guifg=#737373 guibg=none
hi CursorLine guibg=none 
hi error ctermbg=none ctermfg=none cterm=none gui=none guifg=#d2d2d2 guibg=#A76363
hi errormsg ctermbg=none ctermfg=none cterm=none gui=none guifg=#A76363 guibg=none
hi errormsg ctermbg=none ctermfg=none cterm=none gui=none guifg=#A76363 guibg=none
hi VertSplit guifg=#303030 guibg=#303030 
hi StatusLineNC ctermfg=none guifg=#393939 guibg=#7e7e7e ctermfg=none cterm=none ctermbg=none
hi StatusLine ctermfg=none guibg=#393939 guifg=#9a9a9a ctermfg=none cterm=none ctermbg=none
hi Conceal guifg=#acacac guibg=#303030
hi Pmenu guibg=#303030
hi PmenuSel guibg=#434343 guifg=#9a9a9a
hi CocErrorHighlight guibg=#303030
hi GitGutterAdd    guifg=#779659 ctermfg=2
hi GitGutterChange guifg=#bbbb00 ctermfg=3
hi GitGutterDelete guifg=#a76363 ctermfg=1

"" folding -- rethink keymaps
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=0
set foldcolumn=0
nnoremap <c-t> za 
vnoremap <c-t> za
" nnoremap <C-j> zj
" nnoremap <C-k> zk
nnoremap <leader>o zo
nnoremap <leader>O zCzO
nnoremap <leader>c zc
nnoremap <leader>C zC
nnoremap <leader>r zr
nnoremap <leader>R zR
nnoremap <leader>m zm
nnoremap <leader>M zM
nnoremap <leader>z zMzvzz
nnoremap <leader>9 :set foldcolumn=3<cr>
nnoremap <leader>0 :set foldcolumn=0<cr>

"" lua

" global helper functions to reload and vim.inspect
lua require('kush.globals')

" manage plugins with packer
lua require('kush.plugins')

" built-in LSP configuration
lua require('kush.lsp')

" telescope
lua require('kush.telescope.setup')
lua require('kush.telescope.mappings')

" statusline
lua require('kush.statusline')

" luasnip
lua require('kush.snips')

" mappings
lua require('kush.mappings')

" bufferline
" lua require('kush.bufferline')

" vim-tpipeline
lua vim.g.tpipeline_autoembed = 0
lua vim.g.tpipeline_cursormoved = 1
