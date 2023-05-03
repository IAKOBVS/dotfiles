call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'tribela/vim-transparent'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'lervag/vimtex'
Plug 'bkad/CamelCaseMotion'
Plug 'mechatroner/rainbow_csv'
Plug 'godlygeek/tabular'
Plug 'dart-lang/dart-vim-plugin'
Plug 'vim-scripts/LargeFile'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale'
call plug#end()

" skeleton
autocmd BufNewFile *.c,*.cpp 0r ~/.config/nvim/templates/skeleton.c | $delete _
autocmd BufNewFile *.pl 0r ~/.config/nvim/templates/skeleton.pl

" only use clang-tidy for ALE
let g:ale_linters = {
\	'cpp': ['clangtidy'],
\	'c': ['clangtidy']
\}

" let g:ale_perl_perlcritic_options = '--stern'
" let g:ale_cpp_options = '-std=gnu++17'
" let g:ale_clang_cxx_standard = 'c++17'

let g:ale_c_cc_options = '-Wall -Wextra -Wshadow -Warray-bounds -Wuninitialized'
let g:ale_cpp_cc_options = '-Wall -Wextra -Wshadow -Warray-bounds -Wshadow -Wuninitialized'

let g:ale_c_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling']
let g:ale_cpp_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling']

let g:coc_max_preview_height = 30
let g:coc_scroll_accelerated = 1
let g:coc_scroll_accelerated_chunk_size = 30

set maxmempattern=2000000

let g:AutoPairsMultilineClose = 0

set inccommand=nosplit

nnoremap - :vertical resize -25<CR>
nnoremap = :vertical resize +25<CR>

function! TabularizeMacro()
  let lnum = line('.')
  execute '/^$\\ze\\n{/;/^}$/normal! vip:substitute/\\zs$/\\\\/ | ' . &tabstop . 'retab'
  call cursor(lnum, 1)
endfunction

vnoremap ff :call TabularizeMacro()<CR>

nnoremap <space>o :History<CR>
nnoremap <space>h :cd ~ \| Files<CR>
nnoremap <space>f :call fzf#vim#files(expand('%:p:h'))<CR>
nnoremap <space>r :Rg<CR>
nnoremap <space>s :w<CR>:let @a=expand('%')<CR>:silent !sd % >/dev/null 2>&1 & disown &<CR>:e!<CR>:let &modified=0<CR>:let @" = @a<CR>

nmap eq <C-w>=

nmap <leader>m :call RecheckMacros()<Return>G
nmap cm :call CheckMacros()<Return>G
nmap cn :call CheckMacrosNow()<Return>G

function! CheckMacrosNow()
	:silent! execute '!coenow % &' | vsplit | edit /tmp/%:t-deb.c | normal <CR> | normal G
endfunction

function! CheckMacros()
	:silent! execute '!coe % &' | vsplit | edit /tmp/%:t-deb.c | normal <CR> | normal G
endfunction

function! RecheckMacros()
	:silent! execute '!coe % &' | vsplit | edit /tmp/%:t-deb.c | normal <CR> | normal G
endfunction

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'

if stridx(&runtimepath, expand(vimDir)) == -1
  " vimDir is not on runtimepath, add it
  let &runtimepath.=','.vimDir
endif

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" surround word with paranthesis
nnoremap <Leader>s :let @/='\<'.expand('<cword>').'\>'<CR>:s//(&)/e<CR>:set nohlsearch<CR>:redraw!<CR>

autocmd BufNewFile,BufRead *.h set filetype=c

nmap <Leader>f VggVG:Tabularize /\\$<CR>
vmap ff :Tabularize /\\$<CR>

set t_8f=^[[38;2;%lu;%lu;%lum        " set foreground color
set t_8b=^[[48;2;%lu;%lu;%lum        " set background color
set t_Co=256                         " Enable 256 colors

" unmacro c
" vmap M :exe "'<,'>s/$/ \/"<Return>
vmap M :exe ":s/$/ \/""<Return>

" open terminal
map <C-w><Return> :split<Return> :exe "resize 10"<Return> :exe "terminal"<Return>A

" copy paste
set pastetoggle=<F1>
vnoremap <C-c> "+y
vnoremap <C-d> "+y:delete<Return>
map <C-p> <F1> :set paste "+P :set nopaste <F1>
map <C-p> <F1> :set paste "+p :set nopaste <F1>
vnoremap <C-c> "*y :let @+=@*<CR>
nnoremap <C-y> ggVG

" disable case indent
set cinoptions+=:0

" respect camelCase
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

" Ctrl + s to save
map <C-s> :w<Return>

" J and K to jump between paragraphs
map J }
map K {
map <C-j> <C-d>
map <C-k> <C-u>
" hop to top or bottom
noremap H b
noremap L w

" q to quote
map q ysiw"hxp
nmap Q F"xf"x

nnoremap <C-q> :Goyo<Return>
" nnoremap ff :Files<Return>
" nnoremap q :Sex<Return>

" disable autoquote
" let b:coc_pairs_disabled = ['"',"'",'<','>']
" let b:coc_pairs_disabled = ['<','>']

" automatically edits swap warning
autocmd SwapExists * let v:swapchoice = "e" | echomsg "swap exists"

" map <C-b> :%s/\[[^][]*\]//g<Return> :%s/[ \t]*$//g<Return> :%s/\/\ /\//g<Return> :%s/\ /-/g<Return>

" spellcheck
noremap <C-n> :set nospell!<Return>
" set spell spelllang=ID_ID
" setlocal spell spelllang=id_id,en_us
" noremap <C-i> :set spell spelllang=ID_ID<Return>
" noremap <C-e> :set spell spelllang=EN_US<Return>

" space to tab
" map T :%s/ \s/\t/g<Return>

if has('nvim')
	autocmd VimEnter * call timer_start(8, { tid -> execute(':set termguicolors')})
endif
let g:Hexokinase_highlighters = ['backgroundfull']

autocmd VimEnter * call timer_start(8, { tid -> execute(':set spelllang=id_id')})

" defaults and dash syntax highlighting
set linebreak
set nocompatible
colorscheme murphy
" syntax on
autocmd BufRead * if getline(1) == '#!/usr/bin/dash' | set filetype=sh | endif

" vim insert cursor mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" vimtex
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'
map cc :VimtexCompile<Return>:VimtexCompile<Return>
map C :VimtexCompile<Return>

" save as sudo
cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" recompile suckless programs
autocmd BufWritePost config.h,config.def.h,blocks.h !sudo make install
" autocmd BufWritePost *.c :!com %:p 2
" autocmd BufWritePost *.h :!gcc %:p
" autocmd BufWritePost *.cpp :!com %:p 2
" reload key bindings 
autocmd BufWritePost *sxhkdrc !killall sxhkd; nohup sxhkd & rm nohup.out;

" transparent vim with st
if has('nvim')
  " Enable true colors in Neovim
  set termguicolors
endif

if has('termguicolors')
  " Set transparent background for non-text elements
  hi NormalFloat guibg=none
  hi VertSplit guibg=none
  hi FoldColumn guibg=none
  hi SignColumn guibg=none
  hi LineNr guibg=none
  hi CursorLineNr guibg=none
endif

hi Normal ctermbg=none guibg=none

" hi Normal ctermbg=none guibg=none
" hi NonText ctermbg=none guibg=none
" hi LineNr ctermbg=none guibg=none
set number relativenumber
set mouse=a
filetype plugin indent on
set modifiable

" tab spacing
" set autoindent expandtab tabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.dart set autoindent expandtab tabstop=4 shiftwidth=4

" disable autocomment
autocmd BufNewFile,BufRead * setlocal formatoptions-=ro

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config

inoremap <silent><expr> <CR>
			\ coc#pum#visible() ? coc#pum#next(1) :
			\ CheckBackspace() ? "\<Tab>" :
			\ coc#refresh()
inoremap <expr><c-h> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
	\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]	=~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
	inoremap <silent><expr> <c-space> coc#refresh()
else
	inoremap <silent><expr> <c-@> coc#refresh()
endif

function! ShowDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
autocmd!
" Setup formatexpr specified filetype(s)
autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
" Update signature help on jump placeholder
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a	<Plug>(coc-codeaction-selected)
nmap <leader>a	<Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac	<Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as	<Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf	<Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r	<Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r	<Plug>(coc-codeaction-refactor-selected)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> <tab>k <Plug>(coc-diagnostic-prev)
nmap <silent> <tab>j <Plug>(coc-diagnostic-next)

" Run the Code Lens action on the current line
nmap <leader>cl	<Plug>(coc-codelens-action)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call		 CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR	 :call		 CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" inoremap <silent><expr> <M-k>
inoremap <silent><expr> <C-j>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ CheckBackspace() ? "\<Tab>" :
  \ coc#refresh()

" inoremap <expr><M-h>
inoremap <expr><C-k>
  \ coc#pum#visible() ? coc#pum#prev(1) :
  \ "\<C-h>"

" function! HighlightMacro()
"   let name = system('~/c/cmacro/cmacro ' . expand('%'))
"   silent! call matchadd('Function', name, 0, -1, {'id': 'highlight_words'})
"   " let param = system('~/c/cmacro/cparam ' . expand('%'))
"   " exec "4match DiagnosticSignHint " . param
" endfunction

silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! hi PreProc ctermfg=35 guifg=#8ed5e5
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! match Operator /[\<\>\?\{\}\:\+\=\|\.\-\&\*,;!]/
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! 2match Special /[(){}]/

" Change the color of completion menu
" hi PmenuSel ctermfg=Black ctermbg=none gui=reverse
hi CursorLine ctermbg=none guibg=#3c3836
hi CursorColumn ctermbg=none guibg=#3c3836
hi Pmenu ctermbg=none ctermfg=15 guibg=none guifg=#ffffff

hi MatchParen guifg=white guibg=none

hi link Function Function

" function! Complete__()
" 	let output = system("/home/james/c/cnlp/correct " . expand('<cword>'))
" 	let completions = split(output, "\n")
" 	return completions
" endfunction

" set omnifunc=Complete__

"Plug 'tpope/vim-surround'
" Plug 'bfrg/vim-cpp-modern'
" Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }
" Plug 'williamboman/mason.nvim'
" Plug 'williamboman/mason-lspconfig.nvim'
" Plug 'bscan/PerlNavigator'
" Plug 'neovim/nvim-lspconfig'

" let g:ale_linters = { 'perl': [] }

" function! RipgrepFzf(query, fullscreen)
"   let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
"   let initial_command = printf(command_fmt, shellescape(a:query))
"   let reload_command = printf(command_fmt, '{q}')
"   let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
"   let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
"   call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
" endfunction
