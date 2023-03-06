> ./Box.js > Box
  ./byTag.js > byTag0
  utax/On.js
  utax/assign.js

{body} = document

< (gen, next)=>
  tag = 'u-alert'
  Box(
    (box)=>
      box.innerHTML = "<#{tag}></#{tag}>"
      x = =>
        box.close()
        return
      if next
        _x = x
        x = =>
          next()
          _x()
          return

      On box,{
        close: On body,{
          keydown:({keyCode})=>
            if [13,27].includes keyCode
              x()
            return
        }
      }
      assign byTag0(box,tag),{
        x
        gen
      }
      return
  )
