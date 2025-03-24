part of obsivision.apis.mail;

class SubscribeEarlyAccess {
  static const String projectId = 'projectId';
  static const String emailAddress = 'emailAddress';
  static const String accessType = 'accessType';
  static Future<int> handle({
    required T? Function<T>(String paramName) getParam,
    required void Function(int, String) raise,
  }) async {
    final ref = firestore
        .collection('mail')
        .document('subscriptions')
        .collection('early-access')
        .document(projectId)
        .collection(getParam(accessType));
    await ref.document(getParam(emailAddress)).set({});
    return HttpStatus.ok;
  }
}
