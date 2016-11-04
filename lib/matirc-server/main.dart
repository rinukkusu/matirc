import 'dart:io';
import 'dart:convert';

import 'package:irc/client.dart';

void main() {
  HttpServer
    .bind(InternetAddress.ANY_IP_V4, 8080)
    .then((HttpServer server) {
      print("HttpServer listening...");
      server.serverHeader = "matirc_server";
      server.listen((HttpRequest request) {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          WebSocketTransformer.upgrade(request).then(handleWebSocket);
        } else {
          print("Regular ${request.method} request for: ${request.uri.path}");
          serveRequest(request);
        }
      }
    );
  });
}

List<Client> clients = new List<Client>();

void handleWebSocket(WebSocket socket) {
  print('Client connected!');

  clients.add(null);
  int idx = clients.length - 1;

  socket.handleError((err) {
    print(err);
  });

  socket.listen((String s) {
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

      socket.add("test");
    } else {
      //clients[idx].sendMessage("#dev", s);
    }
  }, onDone: () {
    print('Client disconnected: ${socket.closeCode} - ${socket.closeReason}');
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
