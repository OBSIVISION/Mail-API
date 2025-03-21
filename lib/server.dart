library obsivision.apis.mail;

import 'dart:io';

void main(List<String> args) async {
  print('running main');
  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    int.fromEnvironment('PORT', defaultValue: 8080),
  );
  print('bound server, listening for requests');
  server.listen((req) async {
    print('request received');
    final idToken = req.headers.value('X-Serverless-Authorization');
    if (idToken != null) {
      print('ID token is not null');
      final tokenParts = idToken.split(' ');
      if (tokenParts[0].toLowerCase() == 'bearer') {
        print(tokenParts[1]);
        print(req.uri.pathSegments);
      }
    }
    req.response
      ..headers.contentType = ContentType.json
      ..statusCode = HttpStatus.ok
      ..write({
        'payload': req.uri.pathSegments,
      });
    print('wrote response, closing');
    await req.response.close();
  });
}
