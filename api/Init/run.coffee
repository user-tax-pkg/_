> chalk

{greenBright} = chalk

< (li)=>
  for i from li
    console.log greenBright i
    try
      {default:m} = await import('./'+i)
      await m()
    catch err
      console.trace err
  return
