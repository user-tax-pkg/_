> ./req.js > Req
  utax/utf8d.js
  utax/getDefault.js:
  ./lang.js:@ > HOOK

unbin = (pos_li_id_li, word)=>
  {length} = pos_li_id_li
  length/=2
  pos_li = pos_li_id_li[...length]
  id_li = pos_li_id_li[length..]

  pos_id = new Map()
  for i,n in pos_li
    pos_id.set i,id_li[n]

  m = []
  id = 0
  for i,pos in word.map (i)=>utf8d(i)
    _id = pos_id.get(pos)
    m[_id or id]=i
    if _id != undefined
      id = _id
    id++

  m

DB = new Promise(
  (resolve, reject)=>
    db = indexedDB.open('user.tax', 1)
    Object.assign(
      db
      {
        onupgradeneeded:(e)=>
          e.target.result.createObjectStore('i18n', { keyPath: 'id' })
          return
        onsuccess: =>
          DB = db.result
          resolve()
          return
        onerror: reject
      }
    )
    return
)


RW = new Proxy(
  {}
  get:(self, name)=>
    DB.transaction(name, 'readwrite').objectStore(name)
)

get = new Proxy(
  {}
  get:(self, name)=>
    (key)=>
      r = DB.transaction(name).objectStore(name).get key
      new Promise(
        (resolve,reject)=>
          Object.assign(
            r
            onsuccess:=>resolve r.result
            onerror:reject
          )
      )
)

PKG_REQ = new Map()

export default new Proxy(
  {}
  {
    get: (_, pkg) =>
      (ver, pos_id_li, CDN)=>
        i18n_li = []
        I18N = new Proxy(
          i18n_li
          get:(_,key)=>
            i18n_li[key] or '　'
        )

        hook = new Set()

        setLang = (language)=>
          if DB instanceof Promise
            await DB

          req = PKG_REQ.getDefault(
            pkg
            =>
              Req()
          )

          pkg_ver = pkg + '/' + ver
          pkg_ver_lang = pkg_ver + '/' + language
          r = await get.i18n pkg_ver_lang
          bin = if r then r.v else await do =>
            v=await req(CDN())
            {i18n} = RW
            prefix = pkg+'/'
            prefix_len = prefix.length
            i18n.openCursor(
              IDBKeyRange.bound(prefix, prefix+'\uffff', false, true)
            ).onsuccess = (e)=>
              c = e.target.result
              if c
                {key} = c
                c_ver = key[ prefix_len..key.indexOf('/',prefix_len)-1 ]
                if c_ver != ver
                  i18n.delete(key)
                c.continue()
              else
                i18n.put {
                  id:pkg_ver_lang
                  v
                }
              return
            v

          bin = do =>
            t = []
            p = 0
            push = t.push.bind t

            loop
              n = bin.indexOf(0, p)
              if ~ n
                push bin[p..n-1]
                p = n+1
              else
                push bin[p..]
                break
            t

          i18n_li.splice(
            0
            i18n_li.length
            ...unbin(
              pos_id_li
              bin
            )
          )
          for f from hook
            f i18n_li
          return

        setTimeout =>
          setLang lang()
          return

        HOOK.add setLang
        [
          I18N
          (next)=>
            next I18N
            hook.add(next)
            =>
              =>
                hook.delete(next)
                return
        ]
  }
)

