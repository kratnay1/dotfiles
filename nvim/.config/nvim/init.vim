" init.vim --> init.lua (eventually)

"" plugins
call plug#begin()
Plug 'tyrannicaltoucan/vim-quantum' 
call plug#end()
" fzf installed via apt
source /usr/share/doc/fzf/examples/fzf.vim


"" basic settings
let $BASH_ENV = "~/.bash_aliases"
set noswapfile
set undofile
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
set equalalways
set nohlsearch " <leader><leader> to toggle hlsearch
set inccommand=split " preview substitutions (nvim only)
set updatetime=300 " faster diagnostic messages (default is 4000)
set cmdheight=0 " new neovim nightly feature
set breakindent " indent wrapped lines, indicate with ..
set showbreak=↪\ \ 
set listchars=eol:¬,nbsp:␣,tab:\ \ 
set termguicolors " set true-color

" Enable mouse support
if has('mouse')
	set mouse=a
endif
let hlstate=0 " no persistent search highlighting
let g:tmux_navigator_save_on_switch = 1
" cursor shape/color
if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
	let &t_SI = "\<Esc>]50;CursorShape=1\x7"
	let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


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

	" cursorline only on focused split
	" augroup cline
	"     autocmd!
	"     autocmd WinLeave,InsertEnter * set nocursorline
	"     autocmd WinEnter,InsertLeave * set cursorline
	" augroup END

	""" auto save when focus is lost
	augroup auto_save
		autocmd!
		autocmd FocusLost * :wa
		let g:auto_save = 1
		let g:auto_save_silent = 1
	augroup END

	augroup highlighted_yank
		au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
	augroup END
endif " has("autocmd")


"" mappings
""" general mappings
map <Space> <leader>
nnoremap <C-y> <c-r> 
nmap <leader>q :q<cr>
noremap <C-s> :w<CR>
noremap S :w<CR>
nnoremap <c-p> :
nnoremap <c-;> :
nnoremap <silent> <leader><space> :set hlsearch!<CR>
nnoremap <silent> <leader>8 :set list!<CR>
nnoremap Y yy
nnoremap C cc
nmap cc c$
nnoremap <leader>p o<esc>mz"+p'zX==w
nnoremap <leader>= :let b:PlugView=winsaveview()<CR>:keepjumps call cursor([1,1])<cr>=G:call winrestview(b:PlugView)<CR>:echo "file indented"<CR><CR>
noremap ' `
imap <c-u> <Esc>u
vnoremap y "+y
vnoremap <silent> y y`]

" map . in visual mode
vnoremap . :norm.<cr>

" Don't use Ex mode
map Q @q

""" edit and source dotfiles
nmap <leader>V :edit $MYVIMRC<cr>
nmap <leader>v :source $MYVIMRC<cr><leader><space>
nmap <leader>br :edit ~/.bashrc<cr>
nmap <leader>ba :edit ~/.bash_aliases<cr>

""" coc
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Use <c-space> to trigger completion.
" if has('nvim')
"   inoremap <silent><expr> <c-space> coc#refresh()
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
			\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder.
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
" nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
" nmap <leader>f  <Plug>(coc-fix-current)

""" movement
nnoremap <C-e> <c-i>
nnoremap <C-D> 3<C-e>
nnoremap <C-U> 3<C-y>
nnoremap <C-I> 3<C-y>
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
nnoremap <a-,> <c-w>5<
nnoremap <a-.> <c-w>5>

" Sizing window vertically
" taller
nnoremap <a-t> <c-w>+
" shorter
nnoremap <a-s> <c-w>-

" Open new file adjacent to current file
nnoremap <leader>e :e <c-r>=expand("%:p:h") . "/"<cr>

" change working directory for all windows
nnoremap <leader>cd :windo lcd 

""" fzf 
" nnoremap <silent> <C-q> :Buffers<CR>
" nnoremap <silent> <C-g> :GFiles<CR>
" nnoremap <silent> <leader>g :Files<CR>
" nnoremap <silent> <leader>/ :Lines<CR>
" nnoremap <silent> <leader>h :History<CR>

"" colors

lua require('kush.bufferline')

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

"" folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=0
set foldcolumn=0
nnoremap <c-t> za :set foldcolumn=3<cr>
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

function! MyFoldText() 
	let line = getline(v:foldstart)

	let nucolwidth = &fdc + &number * &numberwidth
	let windowwidth = winwidth(0) - nucolwidth - 3
	let foldedlinecount = v:foldend - v:foldstart 

	let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
	let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
	let line = substitute(line, 'def', '', 'g')
	let line = substitute(line, '""', '', 'g')
	return '   ' . line . '…' . foldedlinecount . repeat("  ",fillcharcount) 
endfunction 

" function! MyFoldText() 
"     let line = getline(v:foldstart)

"     let nucolwidth = &fdc + &number * &numberwidth
"     let windowwidth = winwidth(0) - nucolwidth - 3
"     let foldedlinecount = v:foldend - v:foldstart 

"     let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
"     let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
"     let line = substitute(line, 'def', '', 'g')
"     return '   ' . line . '…' . foldedlinecount . repeat("  ",fillcharcount) 
" endfunction 

set foldtext=MyFoldText()

function! VimFolds(lnum)
	let s:thisline = getline(a:lnum)
	if match(s:thisline, '^\s*"" ') >= 0
		return '>1'
	elseif match(s:thisline, '^\s*""" ') >= 0
		return '>2'
	else
		return '='
	endif
endfunction

" """ defines a foldtext
" function! VimFoldText()
"   " handle special case of normal comment first
"   let s:info = '('.string(v:foldend-v:foldstart).' l)'
"   if v:foldlevel == 1
"     let s:line = ' ◇ '.getline(v:foldstart+1)[3:-2]
"   elseif v:foldlevel == 2
"     let s:line = '   ●  '.getline(v:foldstart)[3:]
"   elseif v:foldlevel == 3
"     let s:line = '     ▪ '.getline(v:foldstart)[4:]
"   endif
"   if strwidth(s:line) > 80 - len(s:info) - 3
"     return s:line[:79-len(s:info)-3+len(s:line)-strwidth(s:line)].'...'.s:info
"   else
"     return s:line.repeat(' ', 80 - strwidth(s:line) - len(s:info)).s:info
"   endif
" endfunction

""" set foldsettings automatically for vim files
augroup fold_vimrc
	autocmd!
	autocmd FileType vim 
				\ setlocal foldmethod=expr |
				\ setlocal foldexpr=VimFolds(v:lnum) |
				\ setlocal foldtext=MyFoldText() |
				\ set foldcolumn=3 |
				\ set foldlevelstart=0
augroup END


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

" bufferline
lua require('kush.bufferline')

" vim-tpipeline
lua vim.g.tpipeline_autoembed = 0
lua vim.g.tpipeline_cursormoved = 1
