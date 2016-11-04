/*import '../lib/services/irc.service.dart';
import 'package:angular2/core.dart';
import 'package:angular2/platform/browser.dart';
import 'package:matirc/app.component.dart';

void main() {
  bootstrap(AppComponent, [
    provide("IRC_HOST", useValue: "irc.sub-r.de"),
    provide("IRC_PORT", useValue: 6669),
    
    IrcService,
  ]);
}*/

import 'dart:async';
import 'dart:html';

main() async {
  var socket = new WebSocket('ws://localhost:8080/ws');

  window.console.log(socket.protocol);

  socket.onError.listen((event) {
    window.console.log(event);
  });

  socket.onOpen.listen((event) {
    window.console.log(event);

    new Timer.periodic(
        new Duration(seconds: 1), (t) => socket.sendString("test22"));
  });

  socket.onMessage.listen((MessageEvent event) {
    window.console.log(event);
  });

  socket.onClose.listen((CloseEvent event) {
    window.console.log(event);
  });
}
