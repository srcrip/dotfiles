let s:ranger_command = 'ranger'
let s:choice_file_path = '/tmp/chosenfile'
let s:default_edit_cmd='edit '

function! OpenRangerIn(path, edit_cmd)
  let currentPath = expand(a:path)
  let rangerCallback = { 'name': 'ranger', 'edit_cmd': a:edit_cmd }

  function! rangerCallback.on_exit(job_id, code, event)
    if a:code == 0
      silent! BufDel!
    endif
    try
      if filereadable(s:choice_file_path)
        for f in readfile(s:choice_file_path)
          exec self.edit_cmd . f
        endfor
        call delete(s:choice_file_path)
      endif
    endtry
  endfunction

  enew
  setl ft=ranger

  if isdirectory(currentPath)
    call termopen(s:ranger_command . ' --choosefiles=' . s:choice_file_path . ' "' . currentPath . '"', rangerCallback)
  else
    call termopen(s:ranger_command . ' --choosefiles=' . s:choice_file_path . ' --selectfile="' . currentPath . '"', rangerCallback)
  endif
  startinsert
endfunction

command! RangerCurrentFile call OpenRangerIn("%", s:default_edit_cmd)
command! RangerCurrentDirectory call OpenRangerIn("%:p:h", s:default_edit_cmd)
command! RangerWorkingDirectory call OpenRangerIn(".", s:default_edit_cmd)
command! Ranger RangerCurrentFile

" To open the selected file in a new tab
command! RangerCurrentFileNewTab call OpenRangerIn("%", 'tabedit ')
command! RangerCurrentFileExistingOrNewTab call OpenRangerIn("%", 'tab drop ')
command! RangerCurrentDirectoryNewTab call OpenRangerIn("%:p:h", 'tabedit ')
command! RangerCurrentDirectoryExistingOrNewTab call OpenRangerIn("%:p:h", 'tab drop ')
command! RangerWorkingDirectoryNewTab call OpenRangerIn(".", 'tabedit ')
command! RangerWorkingDirectoryExistingOrNewTab call OpenRangerIn(".", 'tab drop ')
command! RangerNewTab RangerCurrentDirectoryNewTab

" Open Ranger in the directory passed by argument
function! OpenRangerOnVimLoadDir(argv_path)
  let path = expand(a:argv_path)

  " Delete empty buffer created by vim
  BufDel!

  " Open Ranger
  call OpenRangerIn(path, 'edit')
endfunction

" To open ranger when vim load a directory
augroup ReplaceNetrwByRangerVim
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter * if isdirectory(expand("%")) | call OpenRangerOnVimLoadDir("%") | endif
augroup END
