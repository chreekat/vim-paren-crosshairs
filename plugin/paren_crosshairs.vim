" Vim plugin for putting crosshairs on cursor when on a paren
" Maintainer:   Bryan Richter <at the googles>
" Last Change:  2012
" License:      WTFPL

if exists("g:loaded_paren_crosshairs") || &cp || !exists("##CursorMoved")
    finish
endif
let g:loaded_paren_crosshairs = 1

augroup TargetMatchpairs
    au!
    au WinEnter,CmdwinEnter,CursorMoved,CursorMovedI * call s:targetMatchpairs()
    au BufLeave,WinLeave * call s:suspendTargeting()
augroup END

func! s:targetMatchpairs()
    if !exists('w:targetAcquired')
        let w:targetAcquired = 0
    endif
    " Global to buffer:
    if !exists('b:matchPairs')
        " '[:],{,},(,)' --> '[]{}()'
        let b:matchPairs = substitute(&matchpairs, "[,:]", "", "g")
    endif

    let curChar = getline('.')[col('.') - 1]
    let targetInReticule =
                \len(curChar) > 0 && stridx(b:matchPairs, curChar) >= 0

    if targetInReticule && !w:targetAcquired
        let w:disengage = "set " . (&cuc ? "cuc" : "nocuc")
                    \. ' ' . (&cul ? "cul" : "nocul")
        set cuc cul
        let w:targetAcquired = 1
    elseif !targetInReticule && w:targetAcquired
        exec w:disengage
        let w:targetAcquired = 0
    endif
endfu

func! s:suspendTargeting()
    if exists('w:targetAcquired') && w:targetAcquired
        exec w:disengage
        let w:targetAcquired = 0
    endif
endfu
