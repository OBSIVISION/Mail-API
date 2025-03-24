part of obsivision.apis.mail;

class SubscribePost {
  static const String postId = 'postId';
  static const String emailAddress = 'emailAddress';
  static Future<int> handle({
    required T? Function<T>(String paramName) getParam,
    required void Function(int, String) raise,
  }) async {
    return 10;
  }
}
