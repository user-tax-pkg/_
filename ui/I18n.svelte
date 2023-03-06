<template lang="pug">
select.ico(&val @change)
  +each LANG as i
    option(value="{ i[0] }") {i[1]}
</template>

<script lang="coffee">
> svelte/internal > noop
  ./lang.js:@ > set LANG
  utax/pair.js

val = lang()

change = =>
  set val
  return
</script>

