> !/_/byTag.js

< (elem)=>
  =>
    li = [...byTag(elem, 'input')].filter(
      (i)=>
        ['text','password'].includes(
          i.type
        ) && !i.disabled
    )
    for i from li
      if not i.value
        i.focus()
        return li
    li[0]?.focus()
    li

