let s:dir = expand("<sfile>:p:h:h") . '/emoji'
let s:emoji = []
if has('win32') || has('win64')
  let s:ext = '.bmp'
else
  let s:ext = '.png'
endif

function! s:setup()
  let files = split(glob(s:dir . '/*' . s:ext), "\n")
  if len(files) == 0
    if has('win32') || has('win64')
      call system(s:dir . '\download.bat')
    else
      call system(s:dir . '/download.sh')
    endif
    let files = split(glob(s:dir . '/*' . s:ext), "\n")
  endif
  for file in files
    let name = fnamemodify(file, ':p:t:r')
    exec ":sign define ".name." icon=".file." text=X"
    call add(s:emoji, name)
  endfor
endfunction

function! s:enter()
  let line = getline('.')
  let @+ = ':' . line . ':'
  bw!
endfunction

function! s:emoji()
  silent new __EMOJI__
  setlocal buftype=nofile bufhidden=wipe noswapfile buflisted cursorline
  redraw
  if len(s:emoji) == 0  
    call s:setup()
  endif
  call setline(1, s:emoji)
  for n in range(len(s:emoji))
    execute ":sign place ".(n+1)." line=".(n+1)." name=".s:emoji[n]." buffer=" . bufnr("%")
  endfor
  nnoremap <buffer> <cr> :call <sid>enter()<cr>
  nnoremap <buffer> q :bw!<cr>
endfunction

command! Emoji call s:emoji()
