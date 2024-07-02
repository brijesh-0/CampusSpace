import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Booking {
  final String venueName;
  final String eventName;
  final String clubname;
  final List<DateTimeRange> dateTimeRanges;

  Booking(
      {required this.venueName,
      required this.eventName,
      required this.clubname,
      required this.dateTimeRanges});

  factory Booking.fromMap(Map<String, dynamic> data) {
    String venueName = data['venuename'];
    String eventName = data['eventName'];
    String clubname = data['clubName'];
    List<DateTimeRange> dateTimeRanges = (data['dateTimeList'] as List)
        .map((dateTime) => DateTimeRange(
              start: _parseDateTime(dateTime['date'], dateTime['start-time']),
              end: _parseDateTime(dateTime['date'], dateTime['end-time']),
            ))
        .toList();
    return Booking(
        venueName: venueName,
        eventName: eventName,
        clubname: clubname,
        dateTimeRanges: dateTimeRanges);
  }

  static DateTime _parseDateTime(String date, String time) {
    final dateFormat = DateFormat('dd-MM-yyyy');
    final timeFormat = DateFormat.jm();
    final dateTimeString = '$date $time';
    final dateTimeFormat = DateFormat('dd-MM-yyyy hh:mm a');
    return dateTimeFormat.parse(dateTimeString);
  }
}
