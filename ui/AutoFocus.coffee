> ./On.js
  ./Focus.js

< (form)=>
  focus = Focus form
  _focus = =>
    setTimeout focus
    return
  _focus()
  On form,{
    submit:_focus
  }
  On document, {
    visibilitychange: =>
      (document.visibilityState == 'visible') and _focus()
      return
  }
