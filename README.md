Ripped straight from an email I wrote to some friends, it's

# Parentheses Crosshairs

Showing crosshairs on the cursor when it's on top of parentheses (or other
elements of 'matchpairs').

## Install

Use pathogen or vundle, or copy plugin/paren_crosshairs.vim to ~.vim/plugin.


## Why?

The matchparen plugin tries to do a good thing; namely, highlight the paren that
matches the one under the cursor. However, my friends and I found that having
two parentheses highlighted always confounds our intuition about *where the
cursor actually is*.

This plugin deals with this problem by setting cursorline and cursorcolumn when
the cursor is on a paren.

Screenshot time!

### Before
![Demo of two highlighted parens](http://i.imgur.com/5iZPJ.png "Before")

Where's the cursor?

### After
![Demo of paren crosshairs](http://i.imgur.com/i8uld.png?1 "After")

There it is!

## Historie

Here's the original text of the email. The current plugin just has a few
niceties added:

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
