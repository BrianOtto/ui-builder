lib-js: to text! read %libr3.js
lib-js-mem: read %libr3.js.mem
lib-wasm: read %libr3.wasm

uri-base64: "data:application/octet-stream;base64,"
replace lib-js "libr3.js.mem" rejoin [uri-base64 enbase lib-js-mem]
replace lib-js "libr3.wasm" rejoin [uri-base64 enbase lib-wasm]

replace lib-js "libr3.worker.js" "libr3-emscripten.worker.js"

write %libr3.js lib-js

delete %libr3.js.mem
delete %libr3.wasm
