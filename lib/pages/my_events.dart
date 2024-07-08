import 'package:flutter/material.dart';
import 'package:campus_space/widgets/my_event.dart';
import 'package:campus_space/services/reservation_service.dart';
import 'package:campus_space/models/reservationmodel.dart';

class MyEvents extends StatefulWidget {
  final String photoUrl;
  final String email;

  const MyEvents({Key? key, required this.photoUrl, required this.email})
      : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List<ReservationModel> reservations = [];

  Future<void> _refreshData() async {
    // Fetch reservations again
    List<ReservationModel> refreshedReservations =
        await ReservationsApi().fetchReservations(email: widget.email);
    setState(() {
      reservations = refreshedReservations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: RefreshIndicator(
        onRefresh: _refreshData,
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
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Reservations',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF),
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
                        backgroundImage: NetworkImage(widget.photoUrl),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            FutureBuilder<List<ReservationModel>>(
              future: ReservationsApi().fetchReservations(email: widget.email),
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

                reservations = snapshot.data!;
                return Column(
                  children: reservations
                      .where((reservation) =>
                          reservation.dateTimeList.isNotEmpty &&
                          reservation.dateTimeList[0].startDateTime
                              .isAfter(DateTime.now()))
                      .map((reservation) {
                    return MyEvent(
                      eventName: reservation.eventName,
                      startTime: reservation.dateTimeList[0].startDateTime,
                      endTime: reservation.dateTimeList[0].endDateTime,
                      venue: reservation.venueName,
                      status: reservation.status,
                      posterUrl: reservation.posterUrl ??
                          "https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg",
                      reservationId: reservation.id,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
