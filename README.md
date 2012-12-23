Ripped straight from an email I wrote to some friends, it's

= Target Parentheses

Showing crosshairs on the cursor when it's on top of parentheses (or othere
elements of 'matchpairs'.

To hell with code files, here's the code:

```vim
    func! TargetMatchpairs()
        if !exists('b:targetAcquired')
            let b:targetAcquired = 0
        endif
        if !exists('b:matchPairs')
            " '[:],{,},(,)' --> '[]{}()'
            let b:matchPairs = substitute(&matchpairs, "[,:]", "", "g")
        endif
        let curChar = getline('.')[col('.') - 1]
        let targetInReticule = stridx(b:matchPairs, curChar) >= 0
        if targetInReticule && !b:targetAcquired
            set cuc cul
            let b:targetAcquired = 1
        elseif !targetInReticule && b:targetAcquired
            set nocuc nocul
            let b:targetAcquired = 0
        endif
    endfu

    augroup TargetMatchpairs
        au!
        au CursorMoved,CursorMovedI * call TargetMatchpairs()
    augroup END
```
