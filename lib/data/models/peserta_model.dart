class Participant {
  final int id;
  final int bookingId;
  final String participantName;
  final bool isCheckedIn;
  final DateTime? checkinTime;
  final String? checkedInBy;

  Participant({
    required this.id,
    required this.bookingId,
    required this.participantName,
    required this.isCheckedIn,
    this.checkinTime,
    this.checkedInBy,
  });
}
//masih ragu