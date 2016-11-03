import 'dart:async';
import 'package:angular2/core.dart';
import "package:irc/client.dart";

@Injectable()
class IrcService {
  Configuration _config;
  Client _client;

  StreamController<MessageEvent> _onMessageController = new StreamController.broadcast();
  Stream<MessageEvent> onMessage;

  IrcService(@Inject("IRC_HOST") String host, @Inject("IRC_PORT") int port) {
    _config = new Configuration(host: host, port: port);
    onMessage = _onMessageController.stream;
  }

  void connect(String nickname, List<String> channels, [String password = null]) {
    _config..username = nickname
           ..nickname = nickname
           ..password = password; 

    _client = new Client(_config);

    _client.onReady.listen((ReadyEvent event) {
      channels.forEach((channel) {
        event.join(channel);
      });
    });

    _client.onMessage.listen((MessageEvent event) {
      _onMessageController.add(event);
    });

    _client.connect();
  }

  void sendMessage(String target, String message) {
    _client.sendMessage(target, message);
  }


}