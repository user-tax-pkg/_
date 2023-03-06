< ENV = process.env

< new Proxy(
  {}
  get:(_,name)=>
    new Proxy(
      {}
      get:(_, attr)=>
        ENV[name+'_'+attr] or ''
    )
)
