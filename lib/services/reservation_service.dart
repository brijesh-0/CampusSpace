import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_space/models/reservationmodel.dart'; // Import the ReservationModel class

class ReservationsApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ReservationModel>> fetchReservations({required String email}) async {
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
    var uniqueDocs = allDocs.toSet().toList();

    // Map the documents to ReservationModel
    var data = uniqueDocs.map((DocumentSnapshot doc) {
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
        await docRef.update({'status': 'accepted', 'isConfirmed': true});

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
      // Query the 'bookings' collection where 'id' field matches reservationId
      QuerySnapshot querySnapshot = await _db
          .collection('bookings')
          .where('id', isEqualTo: reservationId)
          .get();

      // Check if any documents are returned
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first matching document reference
        DocumentReference docRef = querySnapshot.docs.first.reference;

        // Delete the document
        await docRef.delete();
        print(docRef.toString());

        print('Reservation $reservationId deleted successfully.');
      } else {
        print('No reservation found with ID: $reservationId');
      }
    } catch (e) {
      print('Failed to delete reservation: $e');
    }
  }
}
