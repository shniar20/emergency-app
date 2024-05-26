import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/models/emergency_model.dart';
import 'package:emergency/models/user_model.dart';
import 'package:emergency/store/user_provider.dart';
import 'package:emergency/utils/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class EmergencyProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _id;
  int? _department;
  String? _longitude;
  String? _latitude;
  bool? _needsAmbulance;
  int? _numberOfAmbulances;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  bool get isLoading => _isLoading;
  String? get id => _id;
  int? get department => _department;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  bool? get needsAmbulance => _needsAmbulance;
  int? get numberOfAmbulances => _numberOfAmbulances;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  set id(String? id) {
    _id = id;
    notifyListeners();
  }

  set department(int? department) {
    _department = department;
    notifyListeners();
  }

  set longitude(String? longitude) {
    _longitude = longitude;
    notifyListeners();
  }

  set latitude(String? latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  set needsAmbulance(bool? needsAmbulance) {
    _needsAmbulance = needsAmbulance;
    notifyListeners();
  }

  set numberOfAmbulances(int? numberOfAmbulances) {
    _numberOfAmbulances = numberOfAmbulances;
    notifyListeners();
  }

  void clearValues() {
    id = null;
    department = null;
    longitude = null;
    latitude = null;
    needsAmbulance = null;
    numberOfAmbulances = null;
  }

  Future<List<Emergency>> getEmergencies({
    required String userId,
    bool? answered,
  }) async {
    // isLoading = true;
    List<Emergency> emergencies = [];
    QuerySnapshot documents = await _firebaseFirestore
        .collection("emergencies")
        .where("answered", isEqualTo: answered)
        .where("userID", isEqualTo: userId)
        .get();

    for (var document in documents.docs) {
      Emergency emergency =
          Emergency.fromMap(document.data() as Map<String, dynamic>);
      emergency.id = document.id;
      emergencies.add(emergency);
    }

    // isLoading = false;

    return emergencies;
  }

  void sendEmergency({
    required BuildContext context,
    required Emergency emergencyModel,
    required Function onSuccess,
  }) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    isLoading = true;
    try {
      await _firebaseFirestore
          .collection("emergencies")
          .add(emergencyModel.toMap())
          .then((value) {
        User user = User(
          id: userProvider.id!,
          name: userProvider.name!,
          phoneNumber: userProvider.phoneNumber!,
          emergencyPending: EmergencyPending(
            emergencyID: value.id,
            emergency: emergencyModel,
            approved: null,
          ),
        );
        userProvider.updateUser(context: context, user: user, onSuccess: () {});
        onSuccess();
        isLoading = false;
      });
    } on FirebaseException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
      isLoading = false;
    }
  }

  void deleteOneEmergency({
    required BuildContext context,
    required Emergency emergency,
    required Function onSuccess,
  }) async {
    try {
      await _firebaseFirestore
          .collection("emergencies")
          .doc(emergency.id)
          .delete()
          .then((value) => onSuccess());
    } on FirebaseException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
    }
  }

  void deleteAllEmergencies({
    required BuildContext context,
    required List<Emergency> emergencies,
    required Function onSuccess,
  }) async {
    try {
      for (var emergency in emergencies) {
        await _firebaseFirestore
            .collection("emergencies")
            .doc(emergency.id!)
            .delete();
      }

      onSuccess();
    } on FirebaseException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
    }
  }
}
