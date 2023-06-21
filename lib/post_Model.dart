import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://10.0.2.2:8090');

class RegisterNewUser {
  Future register(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };
    final record = await pb.collection('posts').create(body: data);
    return record;
  }

  // Future delete(String id) async {
  //   final del = await pb.collection('posts').delete('$id');
  //   return del;
  // }

  // Future login(String email, String password) async {
  //   final login =
  //       await pb.collection('posts').authWithPassword(email, password);
  //   return login;
  // }
}
