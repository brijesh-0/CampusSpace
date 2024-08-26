import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_space/services/reservation_service.dart';
import 'package:intl/intl.dart';

class MyEvent extends StatefulWidget {
  final String eventName;
  final String clubName;
  final String venue;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final String posterUrl;
  final String reservationId;
  final String facultyEmail;
  final String userEmail;

  const MyEvent(
      {super.key,
      required this.eventName,
      required this.clubName,
      required this.venue,
      required this.status,
      required this.startTime,
      required this.endTime,
      required this.posterUrl,
      required this.reservationId,
      required this.facultyEmail,
      required this.userEmail});

  @override
  State<MyEvent> createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  bool isAdmin = false;
  final dateFormat = DateFormat('dd/MMM/yy,').add_jm();

  @override
  void initState() {
    super.initState();
    _initial();
  }

  Future<void> _initial() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getBool('isAdmin') ?? false
        ? setState(() => isAdmin = true)
        : setState(() => isAdmin = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Card(
              clipBehavior: Clip.hardEdge, // Clip content at card edges
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.network(
                widget.posterUrl,
                height: 156,
                width: 114.0,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.venue.toString(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    const Text("Event: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.eventName),
                  ]),
                  isAdmin
                      ? Row(
                          children: [
                            const Text(
                              "Held By: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(widget.clubName),
                          ],
                        )
                      : Container(),
                  Row(children: [
                    const Text("Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(dateFormat
                        .format(DateTime.parse(widget.startTime.toString())))
                  ]),
                  const SizedBox(
                    height: 13.0,
                  ),
                  isAdmin &&
                          (widget.status.toLowerCase() != 'accepted') &&
                          (widget.facultyEmail == widget.userEmail)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              ElevatedButton(
                                  onPressed: () async => {
                                        await ReservationsApi()
                                            .deleteReservation(
                                                widget.reservationId)
                                      },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    fixedSize: const Size.fromWidth(100.0),
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: const Text(
                                    "Reject",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  )),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                  onPressed: () async => {
                                        await ReservationsApi()
                                            .acceptReservation(
                                                widget.reservationId)
                                      },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 00,
                                    fixedSize: const Size.fromWidth(100.0),
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: const Text(
                                    "Accept",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  )),
                            ])
                      : Container(
                          child: (widget.status.toLowerCase() != 'accepted')
                              ? const Text(
                                  'Status Pending ',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF0066FF)),
                                )
                              : isAdmin
                                  ? const SizedBox()
                                  : Container(
                                      height: 35,
                                      width: 35,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.all(0.1),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.white, size: 17.0),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                title:
                                                    const Text('Cancel Reservation'),
                                                content: const Text(
                                                    'Are you sure you want to cancel this reservation? This action cannot be undone.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF0066FF)),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF0066FF)),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      ReservationsApi()
                                                          .deleteReservation(
                                                              widget
                                                                  .reservationId);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                        ),
                  //Text(isAdmin.toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
