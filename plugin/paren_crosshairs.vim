func! s:targetMatchpairs()
    if !exists('b:targetAcquired')
        let b:targetAcquired = 0
    endif
    if !exists('b:matchPairs')
        " '[:],{,},(,)' --> '[]{}()'
        let b:matchPairs = substitute(&matchpairs, "[,:]", "", "g")
    endif

    let curChar = getline('.')[col('.') - 1]
    let targetInReticule = len(curChar) > 0 && stridx(b:matchPairs, curChar) >= 0

    if targetInReticule && !b:targetAcquired
        let b:disengage = "set " . (&cuc ? "cuc" : "nocuc")
                    \. ' ' . (&cul ? "cul" : "nocul")
        set cuc cul
        let b:targetAcquired = 1
    elseif !targetInReticule && b:targetAcquired
        exec b:disengage
        let b:targetAcquired = 0
    endif
endfu

func! s:suspendTargeting()
    if b:targetAcquired
        exec b:disengage
        let b:targetAcquired = 0
    endif
endfu

augroup TargetMatchpairs
    au!
    au WinEnter,CursorMoved,CursorMovedI * call s:targetMatchpairs()
    au WinLeave * call s:suspendTargeting()
augroup END
