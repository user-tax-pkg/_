#!/usr/bin/env coffee

> !/ROOT
  @u7/read
  utax/camel
  @u7/write
  fs > rmSync existsSync readdirSync
  utax/extract > extractLi
  zx/globals:
  path > join dirname
  ./dump

SRC = join dirname(ROOT),'src'

dumpFunc = (pkg, schema)=>
  dir = join SRC,pkg,'Sql'
  sql = read join(dir,schema+'.sql')
  sql = extractLi(
    sql
    'CREATE OR REPLACE FUNCTION '
    '$$;'
  )


  if existsSync dir
    for i from readdirSync dir
      if i.endsWith '.js'
        rmSync(
          join dir, i
          { recursive: true, force: true }
        )

  for func from sql
    out = [
      '''// NOT EDIT : use sh/gen/sql_func.coffee gen

      import {UNSAFE} from '_/Pg'
      '''
    ]

    pos = func.indexOf('(')

    schema_name = func[..pos-1].trim()

    ++pos

    func_name = schema_name.split('.').pop()
    if func_name == 'drop_func'
      continue

    args = []
    li = []


    pos2 = func.indexOf(')',pos)
    p = 1
    for name from func[pos...pos2++].split(',')
      name = name.trim().split(' ')[0]
      li.push name
      args.push '$'+p
      ++p

    s = func[pos2...func.indexOf(' LANGUAGE')]
    pos = s.indexOf('RETURNS ')
    if pos > 0
      pos+=8
      s = s[pos..].trim()

    select = 'SELECT'
    if s.startsWith('TABLE')
      select += ' * FROM'

    unsafe = """
  UNSAFE(
      '#{select} #{schema_name}(#{args.join(',')})',
      #{li.join(',')}
    )"""
    fn = "(#{li.join(',')})"

    if s!='void'
      fn = 'async '+fn
      unsafe = "(await #{unsafe})"
      pos = func.indexOf('-- JS_RETURN ', pos2)
      if pos > 0
        pos+=13
        unsafe+=func[pos..func.indexOf('\n',pos)-1].trim()

    out.push """\nexport default #{fn}=>{
    return #{unsafe}
  }"""
    fp = join(dir,"#{camel func_name}.js")
    console.log '\n'+fp
    write(
      fp
      out.join('\n')
    )

do =>
  for await [pkg, schema] from dump()
    dumpFunc pkg, schema
  process.exit()
  return



