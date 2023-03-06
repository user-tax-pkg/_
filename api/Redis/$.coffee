> utax/u8 > U8
  utax/utf8e
  _/Http/CONF > DEBUG

if DEBUG
  {default:assert} = await import('assert/strict')
  {BinSet} = await import('@u7/wasm-set')
  SET = new BinSet()

wrap = (...args)=>
  r = args[0]
  if Array.isArray r
    r = U8 r
  else
    r = utf8e r

  if DEBUG
    assert not SET.has(r)
    SET.add(r)

  if args[1]
    r.bind = args[1]
  r

< new Proxy(
  wrap
  get:(_,name)=>
    wrap name[2..].toLowerCase().replace(
      /_./g
      (x)=>
        x[1..].toUpperCase()
    )
)
