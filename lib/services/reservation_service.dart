import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_space/models/reservationmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReservationsApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ReservationModel>> fetchReservations(
      {required String email}) async {
    // First query for 'faculty.email'
    var querySnapshot1 = await _db
        .collection('bookings')
        .where('faculty.email', isEqualTo: email)
        .get();

    // Second query for 'clubEmail'
    var querySnapshot2 = await _db
        .collection('bookings')
        .where('clubEmail', isEqualTo: email)
        .get();

    // Combine the results of both queries
    var allDocs = querySnapshot1.docs + querySnapshot2.docs;

    // Remove duplicates
    var uniqueDocs = {for (var doc in allDocs) doc.id: doc}.values.toList();

    var data = uniqueDocs.map((DocumentSnapshot doc) {
      return ReservationModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    print(data);
    return data;
  }

  Future<void> acceptReservation(String reservationId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('bookings')
          .where('id', isEqualTo: reservationId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference docRef = querySnapshot.docs.first.reference;
        await docRef.update({'status': 'accepted', 'isConfirmed': true});

        var reservation = ReservationModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        await sendNotification(reservation.clubEmail,
            "Your reservation for ${reservation.venueName} has been accepted.");
        print('Reservation $reservationId accepted successfully.');
      } else {
        print('No reservation found with ID: $reservationId');
      }
    } catch (e) {
      print('Failed to accept reservation: $e');
    }
  }

  Future<void> deleteReservation(String reservationId) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('bookings')
          .where('id', isEqualTo: reservationId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference docRef = querySnapshot.docs.first.reference;
        await docRef.delete();

        var reservation = ReservationModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        await sendNotification(reservation.clubEmail,
            "Your reservation for ${reservation.venueName} has been rejected.");

        print('Reservation $reservationId deleted successfully.');
      } else {
        print('No reservation found with ID: $reservationId');
      }
    } catch (e) {
      print('Failed to delete reservation: $e');
    }
  }

  Future<void> sendNotification(String recipientEmail, String message) async {
    try {
      await _db.collection('notifications').add({
        'email': recipientEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      /*QuerySnapshot querySnapshot = await _db
          .collection('clubs')
          .where('Email', isEqualTo: recipientEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String? fcmToken = querySnapshot.docs.first.get('fcmToken');

        if (fcmToken != null) {
          await sendPushNotification(fcmToken, message);
        } else {
          print('No FCM token found for $recipientEmail');
        }
        print('Notification sent to $recipientEmail');
      }*/
    } catch (e) {
      print('Failed to send notification: $e');
    }
  }

  /*Future<void> sendPushNotification(String token, String message) async {
    try {
      // Set up the notification payload
      const String serverKey =
          'f1c5f20c953db9ea94a78b6f86025c9db577897b'; // Replace with your FCM server key
      final uri = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/campusspace-44c0/messages:send');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      };

      final body = jsonEncode({
        'to': token,
        'notification': {
          'title': 'Reservation Status',
          'body': message,
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'message': message,
        },
      });

      // Send the POST request
      final response = await http.post(uri, headers: headers, body: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Push notification sent successfully.');
      } else {
        print(
            'Failed to send push notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }*/
}
