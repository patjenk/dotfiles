syntax enable                    " Turn on Syntax highlighting

" auto indenting
set et
set sw=2                         " shift width is two, yes two
set softtabstop=2                " two!
set nosmarttab                   " fuck tabs!
"set autoindent                   " It's easier than doing it myself.
"set smartindent                  " Don't be stupid about it.
set expandtab                    " all tabs are actually spaces

" ----------------------------------------------------------------------------
" UI
" ----------------------------------------------------------------------------
set ruler                        " show me the line,column my cursor is on
set noshowcmd                    " Don't display incomplete commands
set nolazyredraw                 " If we're going to redraw, lets not be lazy about it.
syntax sync minlines=1000         " Look for synchronization points 1000 lines before the current position in the file.
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
set background=dark              " We use a dark terminal so we can play nethack
set mat=5                        " show matching brackets for 1/10 of a second
set laststatus=2                 " always have a file status line at the bottom, even when theres only one file
set novisualbell                 " Stop flashing at me and trying to give me seizures.
set virtualedit=block            " Allow virtual edit in just block mode.

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
"  Strip all trailing whitespace in file
" ---------------------------------------------------------------------------
function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction
map ,s :call StripWhitespace ()<CR>
