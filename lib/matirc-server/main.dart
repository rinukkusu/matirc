import 'dart:io';
import 'dart:convert';

import 'package:irc/client.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  /*HttpServer.bind(InternetAddress.ANY_IP_V4, 8080).then((HttpServer server) {
    print("HttpServer listening...");
    server.serverHeader = "matirc_server";
    server.listen((HttpRequest request) {
      if (WebSocketTransformer.isUpgradeRequest(request)) {
        WebSocketTransformer.upgrade(request).then(handleWebSocket);
      } else {
        print("Regular ${request.method} request for: ${request.uri.path}");
        serveRequest(request);
      }
    });
  });*/

  shelf_io.serve(webSocketHandler(handleWebSocket), 'localhost', 8080).then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });
}

List<Client> clients = new List<Client>();

void handleWebSocket(WebSocketChannel channel) {
  print('Client connected!');

  clients.add(null);
  int idx = clients.length - 1;

  channel.stream.listen((String s) {
    print('Client sent: $s');

    if (clients[idx] == null) {
      /*var config = new Configuration(
          host: "irc.adventuria.eu", port: 6667, nickname: s, username: s);
      clients[idx] = new Client(config);

      clients[idx].onReady.listen((ReadyEvent event) {
        event.join("#dev");
      });

      clients[idx].onMessage.listen((MessageEvent event) {
        // Log any message events to the console
        print("<${event.target.name}><${event.from.name}> ${event.message}");

        var message = {
          "target": {"name": event.target.name},
          "from": {"name": event.from.name},
          "message": event.message
        };
        var msgString = JSON.encode(message);
        print(msgString);
        socket.add(msgString);
      });

      clients[idx].connect();*/

      channel.sink.add("test");
    } else {
      //clients[idx].sendMessage("#dev", s);
    }
  }, onDone: () {
    print('Client disconnected: ${channel.closeCode}');
    clients[idx]?.disconnect();
  }, onError: (err) {
    print(err);
  });
}

void serveRequest(HttpRequest request) {
  request.response.statusCode = HttpStatus.FORBIDDEN;
  request.response.reasonPhrase = "WebSocket connections only";
  request.response.close();
}
