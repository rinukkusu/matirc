import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:angular2/core.dart';

@Injectable()
class IrcService {
  StreamController<dynamic> _onMessageController =
      new StreamController.broadcast();
  Stream<dynamic> onMessage;
  WebSocket socket;

  IrcService(@Inject("IRC_HOST") String host, @Inject("IRC_PORT") int port) {
    onMessage = _onMessageController.stream;
  }

  void connect(String nickname) {
    socket = new WebSocket("ws://localhost:8080");

    socket.onError.listen((event) {
      window.console.log(event);
    });

    socket.onOpen.listen((event) {
      window.console.log(event);
      socket.sendString("rinutest");

      new Timer.periodic(
          new Duration(seconds: 1), (t) => socket.sendString("rinutest"));
    });

    socket.onMessage.listen((MessageEvent event) {
      window.console.log(event);
      _onMessageController.add(JSON.decode(event.data));
    });

    socket.onClose.listen((CloseEvent event) {
      window.console.log(event);
    });
  }

  void sendMessage(String target, String message) {
    socket.sendString(message);
  }
}
