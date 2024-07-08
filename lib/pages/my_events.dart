import 'package:flutter/material.dart';
import 'package:campus_space/widgets/my_event.dart';
import 'package:campus_space/services/reservation_service.dart';
import 'package:campus_space/models/reservationmodel.dart';

class MyEvents extends StatelessWidget {
  final String photoUrl;
  final String email;
  const MyEvents({super.key, required this.photoUrl, required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: ListView(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 15.0),
              child: Row(
                children: [
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'My ',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.black, // Default color for 'Find Your'
                          ),
                        ),
                        TextSpan(
                          text: 'Reservations',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF), // Color for 'Venue'
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(photoUrl),
                        // Replace with your image asset
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 15.0),
          // Adding some space between text and TextField
          FutureBuilder<List<ReservationModel>>(
            future: ReservationsApi().fetchReservations(email: email),
            builder: (BuildContext context,
                AsyncSnapshot<List<ReservationModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No reservations found.'));
              }

              List<ReservationModel> reservations = snapshot.data!;
              return Column(
                children: reservations.map((reservation)  {
                  return MyEvent(
                    eventName: reservation.eventName,
                    time: reservation.dateTimeList[0].startTime,
                    date: reservation.dateTimeList[0].date,
                    venue: reservation.venueName,
                    status: reservation.status,
                    posterUrl: reservation.posterUrl ??
                        "https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg",
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
