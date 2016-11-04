import 'dart:async';
import 'dart:html';

main() async {
  var socket = new WebSocket('ws://127.0.0.1:8081/ws');

  socket.onError.listen((event) {
    window.console.log(event);
  });

  socket.onOpen.listen((event) {
    window.console.log([1, event]);
    socket.sendString("test");

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