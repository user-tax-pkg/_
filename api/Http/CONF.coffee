> _/ENV
  os > cpus

{HTTP:CONF} = ENV

< DEBUG = true

< CPU_NUM = Math.max(
  (+CONF.CPU_NUM) or cpus().length
  1
)

< HOST = new Set(
  CONF.HOST.split ' '
)

< PORT = (+CONF.PORT) or 80
