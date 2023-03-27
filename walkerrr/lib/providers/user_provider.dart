var userObject = {};

class UserContext {
  Future<void> updateUserObject(userFromDB) async {
    userObject = userFromDB;
    // print('---- userObject on user_provider:\n$userObject');
  }
}
