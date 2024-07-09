import 'package:intl/intl.dart';

class DateTimeDetail {
  DateTime startDateTime;
  DateTime endDateTime;

  DateTimeDetail({
    required this.startDateTime,
    required this.endDateTime,
  });

  factory DateTimeDetail.fromJson(Map<String, dynamic> json) {
    return DateTimeDetail(
      startDateTime: _parseDateTime(json['date'], json['start-time']),
      endDateTime: _parseDateTime(json['date'], json['end-time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start-time': DateFormat('yyyy-MM-dd hh:mm a').format(startDateTime),
      'end-time': DateFormat('yyyy-MM-dd hh:mm a').format(endDateTime),
    };
  }

  static DateTime _parseDateTime(String date, String time) {
    final dateTimeString = '$date $time';
    final dateTimeFormat = DateFormat('yyyy-MM-dd hh:mm a');
    return dateTimeFormat.parse(dateTimeString);
  }
}

class Faculty {
  String email;
  String name;

  Faculty({
    required this.email,
    required this.name,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
    };
  }
}

class ReservationModel {
  int attendeeNo;
  String clubName;
  String clubEmail;
  String contactEmail;
  String contactPerson;
  String contactPhone;
  List<DateTimeDetail> dateTimeList;
  Faculty faculty;
  String eventDescription;
  String eventName;
  String id;
  bool isConfirmed;
  String? posterUrl;
  String venueName;
  String status;

  ReservationModel({
    required this.attendeeNo,
    required this.clubName,
    required this.clubEmail,
    required this.contactEmail,
    required this.contactPerson,
    required this.contactPhone,
    required this.dateTimeList,
    required this.faculty,
    required this.eventDescription,
    required this.eventName,
    required this.id,
    required this.isConfirmed,
    this.posterUrl,
    required this.venueName,
    required this.status,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      attendeeNo: json['attendee_no'] ?? 0,
      clubName: json['clubName'] ?? '',
      clubEmail: json['clubEmail'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      dateTimeList: (json['dateTimeList'] as List)
          .map((e) => DateTimeDetail.fromJson(e))
          .toList(),
      faculty: Faculty.fromJson(json['faculty'] ?? {}),
      eventDescription: json['eventDescription'] ?? '',
      eventName: json['eventName'] ?? '',
      id: json['id'] ?? '',
      isConfirmed: json['isConfirmed'] ?? false,
      posterUrl: json['poster_url'],
      venueName: json['venuename'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendee_no': attendeeNo,
      'clubName': clubName,
      'clubEmail': clubEmail,
      'contactEmail': contactEmail,
      'contactPerson': contactPerson,
      'contactPhone': contactPhone,
      'dateTimeList': dateTimeList.map((e) => e.toJson()).toList(),
      'faculty': faculty.toJson(),
      'eventDescription': eventDescription,
      'eventName': eventName,
      'id': id,
      'isConfirmed': isConfirmed,
      'poster_url': posterUrl,
      'venueName': venueName,
      'status': status,
    };
  }
}
