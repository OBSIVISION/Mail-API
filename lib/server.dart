library obsivision.apis.mail;

import 'package:firedart/firedart.dart';
import 'dart:convert';
import 'dart:io';

final firestore = Firestore.instance;
void main(List<String> args) async {
  Firestore.initialize('obsivision-site');
  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    int.fromEnvironment('PORT', defaultValue: 8080),
  );
  server.listen((req) async {
    print(req.headers);
    print(req.uri.queryParameters);
    req.response.headers
      ..contentType = ContentType.json
      ..set(
        'Access-Control-Allow-Origin',
        req.headers.value('Origin') ?? 'http://localhost:8084',
      )
      ..set("Access-Control-Allow-Methods", "POST, GET, DELETE, PUT, OPTIONS")
      ..set("Access-Control-Allow-Headers", "Content-Type, Authorization");

    final Map<String, Object?> payload = {};
    final String? userToken = req.headers.value('User-Token');

    if (req.uri.pathSegments[0] == 'subscribe') {
      final Map<String, Object?> body =
          jsonDecode(await utf8.decodeStream(req));
      print(body);
      if (req.uri.pathSegments[1] == 'post') {
        if (req.uri.queryParameters.containsKey('postId')) {
          if (body.containsKey('emailAddress')) {
            req.response.statusCode = HttpStatus.ok;
          } else {
            req.response.statusCode = HttpStatus.badRequest;
          }
        } else {
          req.response.statusCode = HttpStatus.badRequest;
        }
      } else if (req.uri.pathSegments[1] == 'early-access') {
        if (req.uri.queryParameters.containsKey('project') &&
            req.uri.queryParameters.containsKey('accessType') &&
            body.containsKey('emailAddress')) {
          final ref = firestore
              .collection('mail')
              .document('subscriptions')
              .collection('early-access')
              .document(req.uri.queryParameters['project'] as String)
              .collection(req.uri.queryParameters['accessType']!);
          await ref.document(body['emailAddress'] as String).set({});
          req.response.statusCode = HttpStatus.ok;
        } else {
          req.response.statusCode = HttpStatus.badRequest;
        }
      }
    } else {
      req.response.statusCode = HttpStatus.forbidden;
    }

    req.response.write(payload);
    await req.response.close();
  });
}
