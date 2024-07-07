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
