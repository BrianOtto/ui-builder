lib-js: to text! read %libr3.js
lib-js-mem: read %libr3.js.mem
lib-wasm: read %libr3.wasm
lib-worker-js: to text! read %libr3.worker.js
ui-db-js: to text! read %../../ui-db.js

uri-base64: "data:application/octet-stream;base64,"
replace lib-js "libr3.js.mem" rejoin [uri-base64 enbase lib-js-mem]
replace lib-js "libr3.wasm" rejoin [uri-base64 enbase lib-wasm]
replace lib-js "libr3.worker.js" "libr3-emscripten.worker.js"

write %libr3-emscripten.js lib-js
write %libr3-emscripten.worker.js lib-worker-js

; Export for lib.js

lib-js: rejoin [ui-db-js "^/^/" lib-js]

script-find: "pthreadMainJs = locateFile(pthreadMainJs);"
script-replace: "new uiDB().getScript('worker.js', function(pthreadMainJs) { "
replace lib-js script-find script-replace

script-find: "getNewWorker: function() {"
script-replace: "true, true) }, "
replace lib-js script-find rejoin [script-replace script-find]

write %libr3-emscripten.js.base64 enbase lib-js

; Export for worker.js

lib-worker-js: rejoin [ui-db-js "^/^/" lib-worker-js]

replace/all lib-worker-js "importScripts" "// importScripts"

script-find: "if (typeof FS !== 'undefined'"
script-replace: "new uiDB().getScript('lib.js', function(result) { importScripts(result); "
replace lib-worker-js script-find rejoin [script-replace script-find]

script-find: "} else if (e.data.cmd === 'objectTransfer') {"
script-replace: "}, true, true) "
replace lib-worker-js script-find rejoin [script-replace script-find]

write %libr3-emscripten.worker.js.base64 enbase lib-worker-js

; Clean up

delete %libr3.js
delete %libr3.js.mem
delete %libr3.wasm
delete %libr3.worker.js
