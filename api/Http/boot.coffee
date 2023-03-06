> child_process > fork
  http
  path > join
  ua-parser-js:UaParse
  utax/cookie2dict
  utax/streamBuffer
  ulb/headerLi
  ./CONF > DEBUG CPU_NUM PORT
  ./HEADER
  ulb/Ip

if DEBUG
  chalk = (await import('chalk')).default
  {blue} = chalk

  pprint = (prefix, o)=>
    for [k,v] from o.entries o
      if Array.isArray v
        if k == 'default'
          p = prefix[..-2]
        else
          p = prefix + k
        console.log blue p
      else
        pprint(prefix+k+'.',v)
    return

  pprint '',(await import('./MAP.js')).default

  await import('@u7/console/global.js')

WORKER = []
EVENT_EXP = ['error','exit']
WORKER_ING = []
EXIT_COUNT = 0
EXIT_MAX = 3+CPU_NUM

setInterval(
  =>
    EXIT_COUNT = 0
    return
  1e4
)

process.on 'exit',=>
  for i in WORKER
    if i
      i.send -1
  return

workerNew = (fp, id)=>
  ing = WORKER_ING[id]
  if not ing
    ing = new Map
    WORKER_ING[id] = ing

  w = fork(
    fp
    ['fork']
    {
      serialization: 'advanced'
    }
  )

  w.on 'message', (msg)=>
    if Array.isArray msg
      [rid, r] = msg
      ing.get(rid)[1](r)
      ing.delete rid
    else
      for i from EVENT_EXP
        w.removeAllListeners(i)
      WORKER[id] = undefined
      WORKER_ING[id] = ing = new Map
    return

  WORKER[id] = w

  for i from EVENT_EXP
    w.on i, (code, signal)=>
      if EXIT_COUNT++ > EXIT_MAX
        process.exit()
        return

      if ing.size
        workerNew(fp, id)
      else
        WORKER[id] = undefined
      return

  for [n, [li]] from ing.entries()
    w.send(
      li.concat([n])
    )

  w

u32_ver = (v)=>
  if v
    [a,b] = v.split('.',2)
    base = 10000
    return a*base+b%base
  0

< (fp)=>
  N = 0
  server = http.createServer(
    (req, res) =>
      {url,method} = req
      url = url[1..]
      console.log method, url
      + body, code

      req_headers = req.headers
      {origin} = req_headers
      if origin
        origin = new URL origin
        switch method
          when 'OPTIONS'
            headers = {
              ...HEADER
              'Access-Control-Max-Age':9999
            }
            code = 200
          when 'POST'
            if N >= Number.MAX_SAFE_INTEGER
              N = 0

            bin = (await streamBuffer req).toString()
            worker_id = (N++)%CPU_NUM
            cookie = cookie2dict(req_headers['cookie'])

            {browser,os,device} = UaParse req_headers['user-agent']
            t = [
              url
              bin
              Ip(req_headers, res.socket.remoteAddress)
              origin.hostname
              req_headers.host
              req_headers['accept-language']
              cookie.I
              [
                browser.name or ''
                u32_ver browser.version
                os.name or ''
                u32_ver os.version # https://chromestatus.com/feature/5452592194781184
                device.vendor or ''
                device.model or ''
              ]
              req_headers['content-type']
              headerLi(req_headers['accept-encoding']).includes 'br'
            ]

            w = WORKER[worker_id]
            if not w
              w = workerNew(fp, worker_id)

            p = new Promise (resolve)=>
              WORKER_ING[worker_id].set(
                N
                [
                  t
                  resolve
                ]
              )
              return

            if DEBUG
              console.warn 'send N =',N,'t =',t

            w.send(
              t.concat([N])
            )

            [code, headers, body] = await p
        if headers
          headers['Access-Control-Allow-Origin'] = origin.origin
      else
        code = 403
        body = 'headers miss Origin'

      headers = headers or {}
      body = body or ''
      headers['Content-Length'] = body.length

      res.writeHead(code or 404, headers)
      res.end(body)
      return
  )
  port = PORT or 80
  console.log 'LISTEN ON '+port
  server.listen(port)
  return
