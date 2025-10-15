set clipboard=unnamed
set number
set relativenumber

call plug#begin()
Plug 'rust-lang/rust.vim'
Plug 'dense-analysis/ale'
call plug#end()

let g:popupwin_enable_at_startup = 1

let g:rustfmt_autosave = 1

" To have rust-analyzer install it using rustup with the following command:
" rustup component add rust-analyzer
" Then, to know the location of the binary with rustup use the following command:
" rustup which --toolchain stable rust-analyzer
" Lastly, set the executable path of the rust-analyzer in ale
let g:ale_rust_analyzer_executable = '/Users/adrianvincentaguilar/.rustup/toolchains/stable-aarch64-apple-darwin/bin/rust-analyzer'
let g:ale_linters = {'rust': ['analyzer']}
let g:ale_completion_enabled = 1
let g:ale_floating_preview = 1
set completeopt=menu,menuone,preview,noselect,noinsert

augroup ale_hover_cursor
  autocmd!
  autocmd CursorHold * ALEHover
augroup END

let g:netrw_bufsettings="noma nomod nu nobl nowrap ro nornu"

