import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:campus_space/models/bookingsmodel.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  final String venue;

  CalendarScreen({required this.venue});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    bookings = await fetchBookingsForVenue(widget.venue);
    print(bookings);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.venue,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: CalendarControllerProvider(
        controller: EventController()
          ..addAll(
            bookings.expand((booking) {
              return booking.dateTimeRanges.map((dateTimeRange) {
                return CalendarEventData(
                  title: booking.eventName,
                  date: dateTimeRange.start,
                  startTime: dateTimeRange.start,
                  endTime: dateTimeRange.end,
                  //description: 'Venue: ${booking.venueName}',
                );
              }).toList();
            }).toList(),
          ),
        child: MonthView(
          minMonth: DateTime.now(),
          onCellTap: (events, date) {
            print(date);
            //print(bookings);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DayViewScreen(date: date, bookings: bookings),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<Booking>> fetchBookingsForVenue(String venueName) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('venuename', isEqualTo: venueName)
        .get();
    print(snapshot.docs); // Print the fetched documents
    return snapshot.docs
        .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

class DayViewScreen extends StatelessWidget {
  final DateTime date;
  final List<Booking> bookings;

  DayViewScreen({required this.date, required this.bookings});

  @override
  Widget build(BuildContext context) {
    List<Booking> dayBookings = bookings.where((booking) {
      return booking.dateTimeRanges.any((dateTimeRange) {
        return true;
      });
    }).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            bookings[0].venueName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: CalendarControllerProvider(
            controller: EventController()
              ..addAll(
                dayBookings.expand((booking) {
                  return booking.dateTimeRanges.map((dateTimeRange) {
                    return CalendarEventData(
                      title: booking.eventName,
                      date: dateTimeRange.start,
                      startTime: dateTimeRange.start,
                      endTime: dateTimeRange.end,
                      description: 'Held By: ${booking.clubname}',
                    );
                  }).toList();
                }).toList(),
              ),
            child: DayView(
              initialDay: date,
            ))
        /*ListView.builder(
        itemCount: dayBookings.length,
        itemBuilder: (context, index) {
          Booking booking = dayBookings[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: booking.dateTimeRanges.where((dateTimeRange) {
              return isSameDay(dateTimeRange.start, date);
            }).map((dateTimeRange) {
              return ListTile(
                title: Text(booking.eventName),
                subtitle: Text(
                  '${DateFormat.jm().format(dateTimeRange.start)} - ${DateFormat.jm().format(dateTimeRange.end)}\nVenue: ${booking.venueName}',
                ),
              );
            }).toList(),
          );
        },
      ),*/
        );
  }

  /*bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }*/
}
