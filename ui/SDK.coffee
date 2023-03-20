> @w5/sdk
  ./gen/sdkThrow.js
  ./CDN.js > set:cdnSet
  ./lang.js:@ > HOOK

[proxy, sdkInit, setLang] = sdk(
  (r, next, url, req_option)=>
    if r instanceof Error
      throw r

    for t from sdkThrow
      r = await t(r, next, url, req_option)
      if not ( r instanceof Response )
        return r
    throw r
    return
)

< init = (api_url, cdn)=>
  cdnSet cdn
  sdkInit(api_url, lang())
  HOOK.add setLang
  return

< default proxy

