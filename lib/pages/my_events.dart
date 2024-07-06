import 'package:flutter/material.dart';
import 'package:campus_space/widgets/my_event.dart';
import 'package:campus_space/services/reservation_service.dart';
import 'package:campus_space/models/reservationmodel.dart';

class MyEvents extends StatelessWidget {
  final String photoUrl;
  const MyEvents({super.key, required this.photoUrl});

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
          const MyEvent(),
          const MyEvent(),
          // Adding some space between text and TextField
          StreamBuilder<List<ReservationModel>>(
            stream: ReservationsApi()
                .fetchReservations(email: "brijesh.cs22@bmsce.ac.in"),
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
              // Process your data here
              List<ReservationModel> reservations = snapshot.data!;
              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  ReservationModel reservation = reservations[index];
                  return const MyEvent();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
