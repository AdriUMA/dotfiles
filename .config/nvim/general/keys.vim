" Remap escape
nnoremap <C-c> <Esc>
inoremap ii <Esc>
inoremap II <Esc>

" Use alt + hjkl to resize windows
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>

" Alternate way to save
nnoremap <C-s> :w<CR>
" Alternate way to quit and save
nnoremap <C-q> :wq!<CR>

" TAB in general mode will move to next buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go to prev buffer
nnoremap <S-TAB> :bprevious<CR>

" Better tabbing
vnoremap < <gv
vnoremap > >gv
inoremap <S-TAB> <C-d>

" Move selected line / block of text in visual mode
" shift + k to move up
" shift + j to move down
nnoremap K :m -2<CR>
nnoremap J :m +1<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

