set tabstop=4
set shiftwidth=4
set expandtab

cmap wq!! %!sudo tee > /dev/null %

"Relative with start point or with line number or absolute number lines
function! NumberToggle()
    if(&number == 1)
        set number!
        set relativenumber!
      elseif(&relativenumber==1)
        set relativenumber
        set number
      else
        set norelativenumber
        set number                                                  
    endif
endfunction

nnoremap <C-n> :call NumberToggle()<CR>
