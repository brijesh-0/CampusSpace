class ReservationModel {
  int attendeeNo;
  String clubName;
  String contactEmail;
  String contactPerson;
  String contactPhone;
  List<Map<String, dynamic>> dateTimeList;

  ReservationModel({
    required this.attendeeNo,
    required this.clubName,
    required this.contactEmail,
    required this.contactPerson,
    required this.contactPhone,
    required this.dateTimeList,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      attendeeNo: json['attendee_no'] ?? 0,
      clubName: json['clubName'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      dateTimeList: List<Map<String, dynamic>>.from(json['dateTimeList'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendee_no': attendeeNo,
      'clubName': clubName,
      'contactEmail': contactEmail,
      'contactPerson': contactPerson,
      'contactPhone': contactPhone,
      'dateTimeList': dateTimeList,
    };
  }
}
