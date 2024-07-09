import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isAdminGet(String email) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection("admins")
      .where('Email', isEqualTo: email)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<bool> isClubGet(String email) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection("clubs")
      .where('Email', isEqualTo: email)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<bool> checkEmail(String email, String name) async {
  final prefs = await SharedPreferences.getInstance();

  bool isAdmin = await isAdminGet(email);
  bool isClub = await isClubGet(email);

  if (isAdmin) {
    print('$email is an admin.');
    await prefs.setBool('isAdmin', true);
    await prefs.setBool('isClub', false);
  }

  if (isClub) {
    print('$email is a club member.');
    await prefs.setBool('isAdmin', false);
    await prefs.setBool('isClub', true);
    await prefs.setString('clubName', name);
  }

  return (isAdmin || isClub ? true : false);
}
