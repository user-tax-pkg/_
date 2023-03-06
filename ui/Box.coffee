> utax/On.js
  utax/assign.js
  ./byTag.js > byTag0

{body} = doc = document

New = (tag)=>
  doc.createElement tag

< Box = (init)=>
  dialog = New 'dialog'
  dialog.className = 'uBox'
  init(dialog)
  On dialog,{
    close: =>
      body.removeChild(dialog)
      return
  }

  body.append dialog
  dialog.showModal()

  dialog

< xClose = (dialog)=>
  x = New 'a'
  x.className = 'x'
  dialog.prepend x
  On x, {
    click: =>
      dialog.close()
      return
  }
  dialog

< escClose = (dialog)=>
  On dialog,{
    close: On body,{
      keyup:(e)=>
        if 27 == e.keyCode
          dialog.close()
        return
    }
  }
  dialog

< xBox = (args...)=>
  xClose escClose Box(...args)

< default htmBox = (html)=>
  xBox (e)=>
    e.innerHTML = html
    return

< tagBox = (tag)=>
  box = htmBox("""<#{tag}></#{tag}>""")
  [box,byTag0(box,tag)]

