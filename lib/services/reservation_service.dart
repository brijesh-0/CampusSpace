import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_space/models/reservationmodel.dart';

class ReservationsApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ReservationModel>> fetchReservations({required String email}) async {
    var querySnapshot1 = await _db
        .collection('bookings')
        .where('faculty.email', isEqualTo: email)
        .get();
    
    var querySnapshot2 = await _db
        .collection('bookings')
        .where('clubEmail', isEqualTo: email)
        .get();
    
    var allDocs = querySnapshot1.docs + querySnapshot2.docs;
    var uniqueDocs = allDocs.toSet().toList();

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

        var reservation = ReservationModel.fromJson(querySnapshot.docs.first.data() as Map<String, dynamic>);
        await sendNotification(reservation.clubEmail, "Your reservation has been accepted.");

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

        var reservation = ReservationModel.fromJson(querySnapshot.docs.first.data() as Map<String, dynamic>);
        await sendNotification(reservation.clubEmail, "Your reservation has been rejected.");

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
      print('Notification sent to $recipientEmail');
    } catch (e) {
      print('Failed to send notification: $e');
    }
  }
}

