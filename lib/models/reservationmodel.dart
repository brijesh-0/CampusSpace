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

class DateTimeDetail {
    String date;
    String startTime;
    String endTime;

    DateTimeDetail({
        required this.date,
        required this.startTime,
        required this.endTime,
    });

    factory DateTimeDetail.fromJson(Map<String, dynamic> json) {
        return DateTimeDetail(
            date: json['date'] ?? '',
            startTime: json['start-time'] ?? '',
            endTime: json['end-time'] ?? '',
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'date': date,
            'start-time': startTime,
            'end-time': endTime,
        };
    }
}

class ReservationModel {
    int attendeeNo;
    String clubName;
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
            'venuename': venueName,
            'status': status,
        };
    }
}
