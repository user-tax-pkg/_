> ./worker
  ./CONF > DEBUG

if DEBUG
  await import('@u7/console/global.js')

exit = =>
  process.kill(process.pid, "SIGINT")
  return

MAX_MEM_LEAK = 256
{memoryUsage} = process
{ rss } = memoryUsage()

gcpoint = 32

+ WORKER_ID
TIMEOUT_COUNT = 0
ING = 0

# 定时任务: 没请求就退出，防止孤儿进程
INTERVAL = setInterval(
  =>
    if TIMEOUT_COUNT == 0
      exit()
    else
      TIMEOUT_COUNT = 0
      used = memoryUsage().rss
      diff = (used - rss)/1048576
      if gcpoint > MAX_MEM_LEAK and diff > MAX_MEM_LEAK
        clearInterval INTERVAL
        process.send WORKER_ID
        setInterval(
          =>
            if ING == 0
              exit()
            else
              console.warn 'memoryUsage', used, 'leak', diff, 'ING', ING, 'wait auto exit'
            return
          3e3
        )
        return
      else if diff > gcpoint
        gc()
        gcpoint += 32
    return
  4e4
)

next = (msg)=>
  if DEBUG
    console.warn 'recv TIMEOUT_COUNT='+TIMEOUT_COUNT,'ING='+ING,msg
  if Array.isArray msg
    ++TIMEOUT_COUNT
    ++ING
    rid = msg.pop()
    try
      process.send [
        rid
        await worker msg
      ]
    catch err
      console.trace err
    finally
      --ING
  else
    switch msg
      when -1
        exit()
  return

process.on 'message',(msg)=>
  next(msg)
  return
