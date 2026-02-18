class Booking {
  final String id;
  final String submissionId;
  final String userId;
  final DateTime preferredDate;
  final String? message;
  final String status;

  Booking({
    required this.id,
    required this.submissionId,
    required this.userId,
    required this.preferredDate,
    this.message,
    this.status = 'pending',
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      submissionId: json['submission_id'],
      userId: json['user_id'],
      preferredDate: DateTime.parse(json['preferred_date']),
      message: json['message'],
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'submission_id': submissionId,
      'user_id': userId,
      'preferred_date': preferredDate.toIso8601String(),
      'message': message,
      'status': status,
    };
  }
}
