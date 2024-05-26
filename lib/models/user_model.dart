import 'package:emergency/models/emergency_model.dart';

class User {
  String? id;
  String name;
  String phoneNumber;
  String? imagePath;
  DateTime? createdAt = DateTime.now();
  EmergencyPending? emergencyPending;

  User({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.imagePath,
    this.emergencyPending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data["id"],
      name: data["name"],
      phoneNumber: data["phoneNumber"],
      imagePath: data["imagePath"],
      emergencyPending: data["emergencyPending"] != null
          ? EmergencyPending.fromMap(data["emergencyPending"])
          : null,
      createdAt:
          data["createdAt"] != null ? DateTime.parse(data["createdAt"]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "phoneNumber": phoneNumber,
      "emergencyPending": emergencyPending?.toMap(),
      "createdAt": createdAt?.toIso8601String(),
    };
  }
}

class EmergencyPending {
  String emergencyID;
  Emergency? emergency;
  bool? approved;

  EmergencyPending({
    required this.emergencyID,
    this.emergency,
    this.approved,
  });

  factory EmergencyPending.fromMap(Map<String, dynamic> data) {
    return EmergencyPending(
      emergencyID: data["emergencyID"],
      approved: data["approved"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "emergencyID": emergencyID,
      "approved": approved,
    };
  }
}
