import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_space/models/reservationmodel.dart'; // Import the ReservationModel class

class ReservationsApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ReservationModel>> fetchReservations(
      {required String email}) async {
    var querySnapshot = await _db
        .collection('bookings')
        .where('Faculty.email', isEqualTo: email)
        .get();

    var data = querySnapshot.docs.map((DocumentSnapshot doc) {
      return ReservationModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    print(data);
    return data;
  }

  Future<void> acceptReservation(String reservationId) async {
    try {
      // Query the collection for the document where 'ID' matches the reservationId
      QuerySnapshot querySnapshot = await _db
          .collection('bookings')
          .where('id', isEqualTo: reservationId)
          .get();

      // Check if any documents are returned
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first matching document reference
        DocumentReference docRef = querySnapshot.docs.first.reference;

        // Update the status field for the matching document
        await docRef.update({'status': 'accepted'});

        print('Reservation $reservationId accepted successfully.');
      } else {
        print('No reservation found with ID: $reservationId');
      }
    } catch (e) {
      print('Failed to accept reservation: $e');
    }
  }

  // Future<void> deleteReservation(String reservationId) {
  //   return _db.collection('reservations').doc(reservationId).delete();
  // }
}
