> !/LANG_NAME.js
  utax/pair.js

export LANG = pair LANG_NAME.split('|')

map = new Map(LANG)

exist = (l)=>
  if l
    has = map.has(l)
    if not has
      [l] = l.split('-')
      has = map.has(l)
    if has
      return l
  return

+ NOW, DEFAULT_LANG

L = localStorage

bodyCls = (l)=>
  {classList} = document.body
  i18N = 'i18N'
  for i from classList
    if i.startsWith i18N
      classList.remove i
  classList.add( i18N + l )
  return

do =>
  for i in navigator.languages
    value = exist(i)
    if value
      DEFAULT_LANG = value
      break

  bodyCls NOW = exist(L.lang) or DEFAULT_LANG or LANG[0][0]
  return

< HOOK = new Set()

< set = (l)=>
  if exist(l) and l!=NOW
    if l == DEFAULT_LANG
      delete L.lang
    else
      L.lang = l
    NOW = l
    bodyCls l
    for hook from HOOK
      hook NOW

  return

< =>
  NOW

