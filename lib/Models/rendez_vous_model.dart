class Appointment {
  String id;
  String firstName;
  String lastName;
  DateTime date;
  String reason;
  bool isDone;
  bool isNoShow;

  Appointment({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.date,
    required this.reason,
    this.isDone = false,
    this.isNoShow = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'date': date.toIso8601String(),
      'reason': reason,
      'isDone': isDone,
      'isNoShow': isNoShow,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      date: DateTime.parse(json['date']),
      reason: json['reason'],
      isDone: json['isDone'] ?? false,
      isNoShow: json['isNoShow'] ?? false,
    );
  }
}
