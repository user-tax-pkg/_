> _/ENV

{REDIS:CONF} = ENV

### REDIS_HOST_PORT

like REDIS_HOST_PORT = 47.92.198.111:9998

if use REDIS_CLUSTER , use :

  REDIS_HOST_PORT = redis.host1:port1 redis.host2:port2
###

host_port = (s)=>
  s = s.split(':')
  if s.length == 1
    s.push 6379
  else
    s[1] = +s[1]
  s

< REDIS_HOST_PORT = do =>
  {HOST_PORT} = CONF
  console.log HOST_PORT
  li = HOST_PORT.split(' ')

  if li.length == 1
    return host_port li[0]

  li.map host_port

< REDIS_DB = +CONF.DB or 0

< REDIS_PASSWORD = CONF.PASSWORD
< REDIS_USER = CONF.USER or 'default'
