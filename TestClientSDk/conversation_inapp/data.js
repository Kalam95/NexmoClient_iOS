node:events:504
      throw er; // Unhandled 'error' event
      ^

Error: listen EADDRINUSE: address already in use :::5001
    at Server.setupListenHandle [as _listen2] (node:net:1330:16)
    at listenInCluster (node:net:1378:12)
    at Server.listen (node:net:1465:7)
    at Function.listen (/Users/mehboobalam/Documents/projects/Xcode:ios/UniversalApp_swift/conversation_inapp/node_modules/express/lib/application.js:635:24)
    at Object.<anonymous> (/Users/mehboobalam/Documents/projects/Xcode:ios/UniversalApp_swift/conversation_inapp/index.js:129:5)
    at Module._compile (node:internal/modules/cjs/loader:1103:14)
    at Object.Module._extensions..js (node:internal/modules/cjs/loader:1157:10)
    at Module.load (node:internal/modules/cjs/loader:981:32)
    at Function.Module._load (node:internal/modules/cjs/loader:822:12)
    at Function.executeUserEntryPoint [as runMain] (node:internal/modules/run_main:77:12)
Emitted 'error' event on Server instance at:
    at emitErrorNT (node:net:1357:8)
    at processTicksAndRejections (node:internal/process/task_queues:83:21) {
  code: 'EADDRINUSE',
  errno: -48,
  syscall: 'listen',
  address: '::',
  port: 5001
}
