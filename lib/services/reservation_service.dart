import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_space/models/reservationmodel.dart'; // Import the ReservationModel class

class ReservationsApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ReservationModel>> fetchReservations({String? email}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;

    if (email != null) {
      snapshots = _db
          .collection('reservations')
          .where('contactEmail', isEqualTo: email)
          .snapshots();
    } else {
      snapshots = _db.collection('bookings').snapshots();
    }

    return snapshots.map((snapshot) => snapshot.docs
        .map((doc) => ReservationModel.fromJson(doc.data()))
        .toList());
  }

  // Future<void> addReservation(ReservationModel reservation) {
  //   return _db.collection('reservations').add(reservation.toJson());
  // }

  // Future<void> updateReservation(String reservationId, ReservationModel reservation) {
  //   return _db.collection('reservations').doc(reservationId).update(reservation.toJson());
  // }

  // Future<void> deleteReservation(String reservationId) {
  //   return _db.collection('reservations').doc(reservationId).delete();
  // }
}
