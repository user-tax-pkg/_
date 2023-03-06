> ./On.js

RUN = 'run'
B = 'B'

keyupRemove = (input,b)=>
  val = input.value
  unbind = On input,{
    keyup:=>
      if input.value != val
        unbind()
        b.remove()
      return
  }
  return

< (i18n, submit)=>
  (e)=>
    {target} = e
    target.classList.add RUN
    try
      r = await submit(e)
    catch err
      is406 = err.status == 406

      if not is406
        isobj = err?.constructor == Object

      if is406 or isobj
        if is406
          err = await err.json()
        for [k,v] from Object.entries err
          input = target.querySelector('#'+k)
          p = input.parentNode
          b = p.nextSibling
          if b.tagName != B
            b = document.createElement(B)
          if Number.isInteger v
            b.innerText = i18n()[v]
          else
            v b
          p.after b
          keyupRemove input,b
          input.focus()
      else
        throw err
    finally
      target.classList.remove RUN
    r
