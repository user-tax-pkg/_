byTag = (e,tag)=>
  e.getElementsByTagName(tag)

export default byTag

< byTag0 = (e,tag)=>
  byTag(e,tag)[0]

< byTagBind = (e, tag)=>
  =>
    byTag e, tag

