#!/usr/bin/env coffee

> fs > readdirSync mkdirSync copyFileSync
  path > join dirname
  !/ROOT
  @u7/walk > walkRel

COPY = new Set [
  'js'
  'yml'
  'json'
  'sql'
  'mjs'
  'lua'
  'md'
]

_ROOT = dirname ROOT
LIB = join _ROOT, 'lib'
SRC = join _ROOT, 'src'

< default main = =>
  for await i from walkRel(
    SRC
    (i) =>
      i.endsWith '/node_modules'
  )
    pos = i.lastIndexOf '.'
    if ~ pos
      ext = i[pos+1..]
      if COPY.has ext
        f = join SRC, i
        t = join LIB, i
        mkdirSync(
          dirname t
          { recursive: true, force: true }
        )
        copyFileSync(f,t)
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

