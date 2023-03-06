> !/_/byTag.js

< (funcLi...)=>
  (elem)=>
    li = byTag(elem,'li')
    for f, p in funcLi
      li[p].onclick = f
    return
