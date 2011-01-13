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

" ----------------------------------------------------------------------------
" Visual stoof
" ----------------------------------------------------------------------------
set background=dark              " We use a dark terminal so we can play nethack
set showmatch                    " brackets/brace matching
set mat=5                        " show matching brackets for 1/10 of a second
set incsearch                    " show me whats matching as I type my search
set laststatus=2                 " always have a file status line at the bottom, even when theres only one file
set hlsearch                     " Highlight search results
"set ignorecase                   " Ignore case while searching
set novisualbell                 " Stop flashing at me and trying to give me seizures.
set virtualedit=block            " Allow virtual edit in just block mode.

" ---------------------------------------------------------------------------
"  Strip all trailing whitespace in file
" ---------------------------------------------------------------------------

function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction
map ,s :call StripWhitespace ()<CR>
