import 'dart:async';
import 'dart:convert';
import 'dart:html' hide Client;
import 'package:angular2/core.dart';
import "package:irc/client.dart" hide MessageEvent;

@Injectable()
class IrcService {
  Configuration _config;
  Client _client;

  StreamController<dynamic> _onMessageController = new StreamController.broadcast();
  Stream<dynamic> onMessage;

  IrcService(@Inject("IRC_HOST") String host, @Inject("IRC_PORT") int port) {
    _config = new Configuration(host: host, port: port);
    onMessage = _onMessageController.stream;
  }

  void connect(String nickname, List<String> channels, [String password = null]) {
    _config..username = nickname
           ..nickname = nickname
           ..password = password; 

    WebSocket socket = new WebSocket("ws://localhost:8080");
   
    socket.onOpen.listen((event) {
      window.console.log(event);
      socket.sendString("rinutest");
    });

    socket.onMessage.listen((MessageEvent event) {
      window.console.log(event);
      _onMessageController.add(JSON.decode(event.data));
    });

    

    /*_client = new Client(_config);

    _client.onReady.listen((ReadyEvent event) {
      channels.forEach((channel) {
        event.join(channel);
      });
    });

    _client.onMessage.listen((MessageEvent event) {
      _onMessageController.add(event);
    });

    _client.connect();*/

  }

  void sendMessage(String target, String message) {
    _client.sendMessage(target, message);
  }


}