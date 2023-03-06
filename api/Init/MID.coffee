#!/usr/bin/env coffee

> path > join dirname basename
  fs > readdirSync existsSync
  utax/camel
  @u7/write
  @u7/read
  json5
  !/PKG
  !/ROOT

EXPORT = 'const EXPORT = [];\nexport default EXPORT;'

genMid = =>
  li = [EXPORT]
  for pkg from PKG
    fp = join(ROOT,pkg,'mid')
    if existsSync fp
      for i from readdirSync fp
        if i.endsWith '.js'
          li.push "EXPORT.push((await import('./#{pkg}/mid/#{i}')).default)"
  write(
    join ROOT,'MID.js'
    li.join('\n')
  )
  return

< default main = =>
  genMid()
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()
