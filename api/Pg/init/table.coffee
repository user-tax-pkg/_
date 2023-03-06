#!/usr/bin/env coffee

> !/_pkg > MOD
  !/ROOT
  ../index > PG
  ../PG_URI
  fs > existsSync
  path > join dirname
  @u7/read
  chalk

{yellowBright,redBright, blueBright}=chalk

exe = (sql)=>
  sql += ';'
  try
    await PG.unsafe(sql)
  catch err
    console.error yellowBright(sql) + '\n' + redBright(err.message) + '\n'
  return

sql_iter = ()->
  li = []
  for [mod,{db,dir}] from MOD.entries()
    mod_dir = mod[...mod.indexOf '/']
    if dir
      for pkg from dir.split(' ')
        fp = join mod_dir,pkg,"init/pg.sql"
        yield fp
    if db
      {schema} = db
      schema = schema.split ' '
      if schema.length
        d = mod[..mod.indexOf('/')-1]
        for s from schema
          li.push join mod_dir,'Sql',schema+".sql"
  yield from li
  return

< default main = =>
  for fp from sql_iter()
    fp = join ROOT, fp
    if not existsSync fp
      continue
    console.log blueBright fp
    sql = read fp
    for i from sql.split(';')
      i = i.trim()
      if not i
        continue
      if i.startsWith 'CREATE OR REPLACE FUNCTION'
        t = [i]
      else if t
        t.push i
        if i.endsWith '$$'
          sql = t.join(';\n')
          await exe sql
          t = undefined
      else
        await exe i
  #await UNSAFE sql
  #await $"psql #{PG_URI} < #{fp} > /dev/null"
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

