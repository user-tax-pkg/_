export default (
  promise
  render
)=>
  try
    return await promise
  catch err
    is406 = err.status == 406
    if is406
      err = await err.json()
    if err?.constructor == Object
      render err
    throw err
  return
