let s:dir = expand("<sfile>:p:h:h") . '/emoji'
let s:emoji = []
if has('win32') || has('win64')
  let s:ext = '.bmp'
else
  let s:ext = '.png'
endif

function! s:setup()
  let org_wildignore = &l:wildignore
  if has('win32') || has('win64')
    set wildignore-=*.bmp
  else
    set wildignore-=*.png
  endif
  let files = split(glob(s:dir . '/*' . s:ext), "\n")
  let &l:wildignore = org_wildignore
  if len(files) == 0
    if has('win32') || has('win64')
      call system(s:dir . '\download.bat')
    else
      call system("sh " . s:dir . '/download.sh')
    endif
    let files = split(glob(s:dir . '/*' . s:ext), "\n")
  endif
  for file in files
    let name = fnamemodify(file, ':p:t:r')
    exec ":sign define ".name." icon=".file." text=X"
    call add(s:emoji, name)
  endfor
endfunction

function! s:enter(mode)
  let line = ':' . getline('.') . ':'
  bw!
  if a:mode == 'i'
    call feedkeys((col('.') == col('$') - 1 ? "a" : "i") . line)
  elseif a:mode == 'n'
    call feedkeys((col('.') == col('$') - 1 ? "a" : "i") . line . "\<esc>")
  else
    let @+ = line
  endif
endfunction

function! s:emoji(mode)
  silent new __EMOJI__
  setlocal buftype=nofile bufhidden=wipe noswapfile nonumber buflisted cursorline
  redraw
  if len(s:emoji) == 0
    call s:setup()
  endif
  call setline(1, s:emoji)
  for n in range(len(s:emoji))
    execute ":sign place ".(n+1)." line=".(n+1)." name=".s:emoji[n]." buffer=" . bufnr("%")
  endfor
  setlocal nomodifiable
  exec "nnoremap <silent> <buffer> <cr> :call <sid>enter('".a:mode."')<cr>"
  nnoremap <silent> <buffer> q :bw!<cr>
  if a:mode == 'i'
    stopinsert
  endif
  return ''
endfunction

nnoremap <plug>(emoji-selector-clipboard) :<c-u>call <sid>emoji('')<cr>
inoremap <plug>(emoji-selector-clipboard) <c-r>=<sid>emoji('')<cr>
nnoremap <plug>(emoji-selector-insert) :<c-u>call <sid>emoji('n')<cr>
inoremap <plug>(emoji-selector-insert) <c-r>=<sid>emoji('i')<cr>

command! Emoji call s:emoji('')
