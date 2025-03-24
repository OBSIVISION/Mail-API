library obsivision.apis.mail;

import 'package:http_apis/http_apis.dart';
import 'package:firedart/firedart.dart';
import 'dart:io';

part './endpoints/subscribe_post.dart';
part './endpoints/subscribe_early_access.dart';

final firestore = Firestore.instance;
void main(List<String> args) async {
  Firestore.initialize('obsivision-site');
  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    int.fromEnvironment('PORT', defaultValue: 8080),
  );
  server.listen((req) async {
    req.response.headers
      ..contentType = ContentType.json
      ..set(
        'Access-Control-Allow-Origin',
        req.headers.value('Origin') ?? 'http://localhost:8084',
      )
      ..set("Access-Control-Allow-Methods", "POST, GET, DELETE, PUT, OPTIONS")
      ..set("Access-Control-Allow-Headers", "Content-Type, Authorization");

    final String? userToken = req.headers.value('User-Token');
    await api.handleRequest(req);
    await req.response.close();
  });
}

final API api = API(
  apiName: 'mail_api',
  routes: [
    RouteSegment.routes(
      routeName: 'subscribe',
      routes: [
        RouteSegment.endpoint(
          routeName: 'post',
          endpoint: Endpoint(endpointTypes: [
            EndpointType.post
          ], queryParameters: [
            Param.required(SubscribePost.postId,
                desc:
                    'The Letterpress ID of the post to subscribe to notifications from.',
                cast: (obj) => obj as String),
          ], bodyParameters: [
            Param.required(SubscribePost.emailAddress,
                desc: 'The email address that notifications will be sent to.',
                cast: (obj) => obj as String),
          ], handleRequest: SubscribePost.handle),
        ),
        RouteSegment.endpoint(
          routeName: 'early-access',
          endpoint: Endpoint(endpointTypes: [
            EndpointType.post
          ], queryParameters: [
            Param.required(SubscribeEarlyAccess.projectId,
                desc: 'The project ID of the project to join the waitlist for.',
                cast: (obj) => obj as String),
            Param.required(SubscribeEarlyAccess.accessType,
                desc:
                    'The type of early-access being requested, and is specific to each project.',
                cast: (obj) => obj as String),
          ], bodyParameters: [
            Param.required(SubscribeEarlyAccess.emailAddress,
                desc:
                    'The email address that access and communications will be sent to.',
                cast: (obj) => obj as String),
          ], handleRequest: SubscribeEarlyAccess.handle),
        ),
      ],
    ),
  ],
);
