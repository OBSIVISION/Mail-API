part of obsivision.apis.mail;

class SubscribeEarlyAccess {
  static const String productId = 'productId';
  static Future<int> handle({
    required T? Function<T>(String paramName) getParam,
    required void Function(int, String) raise,
  }) async {
    if ((await firestore
            .collection('mail')
            .doc('subscriptions')
            .collection('early-access')
            .doc(getParam(productId))
            .get())
        .exists) {
      await firestore
          .collection('users')
          .doc(getParam(HellcatHeaders.uid.header))
          .update({
        'emailSubscriptions': FieldValue.arrayUnion([getParam(productId)]),
      });
    }

    return HttpStatus.ok;
  }
}
