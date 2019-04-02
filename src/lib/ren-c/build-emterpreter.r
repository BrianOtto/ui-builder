lib-js: to text! read %libr3.js
lib-bytecode: read %libr3.bytecode
lib-wasm: read %libr3.wasm

uri-base64: "data:application/octet-stream;base64,"
replace lib-js "libr3.wasm" rejoin [uri-base64 enbase lib-wasm]

module: rejoin [
    "var Module = {}; Module[^"emterpreterFile^"] = Uint8Array.from(atob('"
    enbase lib-bytecode
    "'), c => c.charCodeAt(0)).buffer;"
]

lib-js: rejoin [module "^/^/" lib-js]

write %libr3.js lib-js

delete %libr3.wasm
delete %libr3.bytecode
delete %libr3.js.orig.js
