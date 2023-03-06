> _/ENV

{MAIL:CONF} = ENV

< SMTP_FROM = CONF.FROM
< SMTP = {
  host: CONF.HOST
  port: +CONF.PORT or 465
  auth:{
    user: CONF.USER or SMTP_FROM
    pass: CONF.PASSWORD
  }
  secure: !!CONF.SECURE
  debug: !!CONF.DEBUG
  logger: !!CONF.LOGGER
}
