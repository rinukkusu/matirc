import 'dart:io';
import 'dart:convert';

import 'package:irc/client.dart';

void main() {
  HttpServer.bind(InternetAddress.ANY_IP_V4, 8080).then((HttpServer server) {
    print("HttpServer listening...");
    server.serverHeader = "matirc_server";
    server.listen((HttpRequest request) {
      if (WebSocketTransformer.isUpgradeRequest(request)){
        WebSocketTransformer.upgrade(request).then(handleWebSocket);
      }
      else {
        print("Regular ${request.method} request for: ${request.uri.path}");
        serveRequest(request);
      }
    });
  });
}

void handleWebSocket(WebSocket socket){
  print('Client connected!');

  Client client;

  socket.listen((String s) {
    print('Client sent: $s');

    if (client == null) {
      var config = new Configuration(host: "irc.adventuria.eu", port: 6667, nickname: s, username: s);
      client = new Client(config);

      client.onReady.listen((ReadyEvent event) {
        event.join("#dev");
      });

      client.onMessage.listen((MessageEvent event) {
        // Log any message events to the console
        print("<${event.target.name}><${event.from.name}> ${event.message}");

        var message = { 
          "target": { "name": event.target.name },
          "from": { "name": event.from.name },
          "message": event.message
        };
        var msgString = new JsonUtf8Encoder().convert(message);
        print(msgString);
        socket.addUtf8Text(msgString);
      });

      client.connect();
    }
    else {
      client.sendMessage("#dev", s);
    }
  },
  onDone: () {
    print('Client disconnected');  
    client?.disconnect();
  });
}

void serveRequest(HttpRequest request){
  request.response.statusCode = HttpStatus.FORBIDDEN;
  request.response.reasonPhrase = "WebSocket connections only";
  request.response.close();
}