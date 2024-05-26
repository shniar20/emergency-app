import 'package:cloud_firestore/cloud_firestore.dart';

class Emergency {
  String? id;
  int department;
  Location location;
  bool needsAmbulance;
  int numberOfAmbulances;
  String userID;
  bool answered = false;
  bool? ambulanceAnswered;
  DateTime createdAt = DateTime.now();

  Emergency({
    this.id,
    required this.department,
    required this.location,
    required this.numberOfAmbulances,
    required this.userID,
    this.needsAmbulance = false,
    this.answered = false,
    this.ambulanceAnswered,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Emergency.fromMap(Map<String, dynamic> data) {
    return Emergency(
      department: data["department"],
      location: Location.fromMap(data["location"]),
      needsAmbulance: data["needsAmbulance"],
      numberOfAmbulances: data["numberOfAmbulances"],
      userID: data["userID"],
      answered: data["answered"],
      ambulanceAnswered: data["ambulanceAnswered"],
      createdAt: (data["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "department": department,
      "location": location.toMap(),
      "needsAmbulance": needsAmbulance,
      "numberOfAmbulances": numberOfAmbulances,
      "userID": userID,
      "answered": answered,
      "ambulanceAnswered": ambulanceAnswered,
      "createdAt": createdAt,
    };
  }
}

class Location {
  String longitude;
  String latitude;

  Location({
    required this.longitude,
    required this.latitude,
  });

  factory Location.fromMap(Map<String, dynamic> data) {
    return Location(
      longitude: data["longitude"],
      latitude: data["latitude"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "longitude": longitude,
      "latitude": latitude,
    };
  }
}
