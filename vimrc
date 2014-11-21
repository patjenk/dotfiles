set nocompatible                 " beiMproved, required
filetype off                     " required for vundle
syntax enable
set background=dark
colorscheme default
let g:vim_home_path = "~/.vim"

" ----------------------------------------------------------------------------
" Vundle, to install new bundles run `:PluginInstall`
" ----------------------------------------------------------------------------
set rtp+=~/.vim/bundle/Vundle.vim   " set the runtime path to include Vundle and initialize
let g:vundle_default_git_proto = 'https'
call vundle#begin()

Bundle 'gmarik/vundle'

" Easily move around quotes and surrounding tags 2014.03.24
Bundle 'tpope/vim-surround'

" Makes things clicable
Bundle "Rykka/clickable.vim"

" Restructred Text 2014.03.24
Bundle 'Rykka/riv.vim'

" Stolen from Tim Messier 2014.03.24
Bundle 'saltstack/salt-vim'

" Git functionality 2014.04.16
Bundle 'tpope/vim-fugitive'

" a plugin for visually displaying indent levels 2014.04.16
Bundle 'nathanaelkane/vim-indent-guides'

" plugin that defines a new text object representing lines of code at the same
" indent level 2014.04.16
Bundle 'michaeljsmith/vim-indent-object'

" plugin to visualize your undo tree
Bundle 'sjl/gundo.vim'

" An automatic table creator & formatter allowing one to create neat tables as
" you type.
Bundle "dhruvasagar/vim-table-mode"

" Hybrid relative and absolute line numbers
Bundle "jeffkreeftmeijer/vim-numbertoggle"

" Bundle for vim to highlight adjectives, passive language and weasel words.
Bundle "jamestomasino/vim-writingsyntax"

" Syntastic is a syntax checking plugin for Vim that runs files through
" external syntax checkers and displays any resulting errors to the user. 
Bundle "scrooloose/syntastic"

call vundle#end()        " All Bundle commands need to come before this
" ----------------------------------------------------------------------------
" Let's make sure that visual indents work. 
" ----------------------------------------------------------------------------
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=3
hi IndentGuidesEven ctermbg=4
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_color_change_percent = 30
let g:syntastic_aggregate_errors = 1

" ----------------------------------------------------------------------------
" Syntax highlighting helps get things done
" ----------------------------------------------------------------------------
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = '✗'           " Better :sign interface symbols
let g:syntastic_warning_symbol = '!'         " Better :sign interface symbols

" ----------------------------------------------------------------------------
" Let's do stuff with python
" ----------------------------------------------------------------------------
if has('python')
py <<EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif

" ----------------------------------------------------------------------------
" UI
" ----------------------------------------------------------------------------
set ruler                        " show me the line,column my cursor is on
set noshowcmd                    " Don't display incomplete commands
set nolazyredraw                 " If we're going to redraw, lets not be lazy about it.
syntax sync minlines=1000        " Look for synchronization points 1000 lines before the current position in the file.
set number                       " show line numbers
set wildmenu                     " Turn on wild menu. Sounds fun.
set wildmode=longest:list,full   " make tab completion act like bash, but even better!
set ch=2                         " Command line height
set backspace=indent,eol,start   " Fixes a problem where I cannot delete text that is existing in the file
set whichwrap=b,s,h,l,<,>,[,]    " Wrap on other things
set report=0                     " Tell us about changes
set nostartofline                " don't jump to the start of a line when scrolling
" I'm in a goddamn hurry. I want anything up near esc to be esc so I can just mash the keyboard.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" ----------------------------------------------------------------------------
" Visual stoof
" ----------------------------------------------------------------------------
set mat=5                        " show matching brackets for 1/10 of a second
set laststatus=2                 " always have a file status line at the bottom, even when theres only one file
set novisualbell                 " Stop flashing at me and trying to give me seizures.
set virtualedit=block            " Allow virtual edit in just block mode.
highlight OverLength ctermbg = red " Highlight extra whistepace
highlight ColorColumn ctermbg = darkgray " Highlight extra whistepace
highlight ExtraWhitespace ctermbg = red guibg=red " Highlight extra whistepace

filetype plugin indent on

nnoremap o :GundoToggle<CR>

" ----------------------------------------------------------------------------
" Searching and replacing
" ---------------------------------------------------------------------------
set showmatch                    " brackets/brace matching
set incsearch                    " show me whats matching as I type my search
set hlsearch                     " Highlight search results
set ignorecase                   " Ignore case while searching
set smartcase                    " psych on that whole ignore case while searching thing! This will match case if you use any uppercase characters.
set gdefault                     " Always do search and replace globally
" prepend all searches with \v to get rid of vim's 'crazy default regex characters'
nnoremap / /\v
" make tab % in normal mode. This allows us to jump between brackets.
nnoremap <tab> %
" make tab % in visual mode. this allows us to jump between brackets.
vnoremap <tab> %
" I got this foo from Gary Bernhart. It makes %% the directory of the current file.
cnoremap %% <C-R>=expand('%:h').'/'<CR> 

" ----------------------------------------------------------------------------
" Moving around
" ---------------------------------------------------------------------------
" disabling the up key in normal mode. LEARN TO USE k
nnoremap <up> <nop>
" disabling the down key in normal mode. LEARN TO USE j
nnoremap <down> <nop>
" disabling the left key in normal mode. LEARN TO USE h
nnoremap <left> <nop>
" disabling the right key in normal mode. LEARN TO USE l
nnoremap <right> <nop>
" disabling the up key in normal mode. LEARN TO USE k
inoremap <up> <nop>
" disabling the down key in normal mode. LEARN TO USE j
inoremap <down> <nop>
" disabling the left key in normal mode. LEARN TO USE h
inoremap <left> <nop>
" disabling the right key in normal mode. LEARN TO USE l!!!
inoremap <right> <nop>

" ---------------------------------------------------------------------------
" Strip all trailing whitespace in file
" ---------------------------------------------------------------------------
function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction
map ,s :call StripWhitespace ()<CR>

" ----------------------------------------------------------------------------
" autoreload .vimrc
" ----------------------------------------------------------------------------
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup ENu

" ----------------------------------------------------------------------------
" Settings for working with python files
" ----------------------------------------------------------------------------
set colorcolumn=73,80,160
autocmd BufWinLeave *.py mkview
autocmd BufWinEnter *.py silent loadview
let g:syntastic_python_checkers=['pylint','flake8']
let g:syntastic_python_flake8_args='--config ~/.flake8'
let g:syntastic_python_pylint_args='--rcfile .pylintrc --msg-template="{path}:{line}: [{msg_id}] {msg}" -r n'
