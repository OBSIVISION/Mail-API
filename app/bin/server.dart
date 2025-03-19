library obsivision.apis.mail;

import 'dart:io';

void main(List<String> args) async {
  final server = await HttpServer.bind('0.0.0.0', 8069);
  server.listen((req) async {
    req.response
      ..statusCode = 200
      ..write({
        'payload': req.uri.pathSegments,
      });
    await req.response.close();
  });
}
