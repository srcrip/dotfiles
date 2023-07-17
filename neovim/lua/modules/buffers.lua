vim.cmd [[
function! ToggleWindowHorizontalVerticalSplit()
  if !exists('t:splitType')
    let t:splitType = 'vertical'
  endif

  if t:splitType == 'vertical' " is vertical switch to horizontal
    windo wincmd K
    let t:splitType = 'horizontal'

  else " is horizontal switch to vertical
    windo wincmd H
    let t:splitType = 'vertical'
  endif
endfunction

com! Rotate :call ToggleWindowHorizontalVerticalSplit()<cr>

nnoremap <silent> <c-x><c-k> :BufDel!<CR>
nnoremap <silent> <leader><q> :BufDel!<CR>
nmap <silent> <c-h> :BufferLineCyclePrev<CR>
nmap <silent> <c-l> :BufferLineCycleNext<CR>
nmap <silent> <c-x><c-s> :w<CR>
nmap <silent> <c-x><c-b> :FzfLua buffers<CR>

function! CloseAllOtherBuffers()
  let curr = bufnr("%")
  let last = bufnr("$")

  if curr > 1    | silent! execute "1,".(curr-1)."bd"     | endif
  if curr < last | silent! execute (curr+1).",".last."bd" | endif
endfunction

com! BufOnly execute 'call CloseAllOtherBuffers()'
nmap <silent> <space>bo :BufOnly<CR>
]]
