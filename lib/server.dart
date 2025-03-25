library obsivision.apis.mail;

import 'package:dart_firebase_admin/auth.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:http_apis_define/http_apis.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'dart:io';

part './endpoints/subscribe_post.dart';
part './endpoints/subscribe_early_access.dart';

final admin = FirebaseAdminApp.initializeApp(
  'obsivision-site',
  Credential.fromApplicationDefaultCredentials(),
);
final firestore = Firestore(admin);
final auth = Auth(admin);
void main(List<String> args) async {
  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    int.fromEnvironment('PORT', defaultValue: 8080),
  );

  server.listen((req) async {
    req.response.headers.contentType = ContentType.json;

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
          endpoint: Endpoint(
              requiresAuth: false,
              endpointTypes: [EndpointType.post],
              queryParameters: [
                Param<String, String>.required(SubscribePost.postId,
                    desc:
                        'The Letterpress ID of the post to subscribe to notifications from.',
                    cast: (obj) => obj as String),
              ],
              bodyParameters: [
                Param<String, String>.required(SubscribePost.emailAddress,
                    desc:
                        'The email address that notifications will be sent to.',
                    cast: (obj) => obj as String),
              ],
              handleRequest: SubscribePost.handle),
        ),
        RouteSegment.endpoint(
          routeName: 'early-access',
          endpoint: Endpoint(
              requiresAuth: true,
              endpointTypes: [EndpointType.post],
              queryParameters: [
                Param<String, String>.required(SubscribeEarlyAccess.productId,
                    desc:
                        'The project ID of the project to join the waitlist for.',
                    cast: (obj) => obj as String),
              ],
              bodyParameters: null,
              handleRequest: SubscribeEarlyAccess.handle),
        ),
      ],
    ),
  ],
);
