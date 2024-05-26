import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergency/pages/verfication.dart';
import 'package:emergency/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emergency/models/user_model.dart' as user_model;

class UserProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool _isLoading = false;
  String? _id;
  String? _name;
  String? _phoneNumber;
  user_model.EmergencyPending? _emergencyPending;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserProvider() {
    checkSignIn();
  }

  bool get isSignedIn => _isSignedIn;
  bool get isLoading => _isLoading;
  String? get id => _id;
  String? get name => _name;
  String? get phoneNumber => _phoneNumber;
  user_model.EmergencyPending? get emergencyPending => _emergencyPending;

  set isSignedIn(bool isSignedIn) {
    _isSignedIn = isSignedIn;
    notifyListeners();
  }

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  set id(String? id) {
    _id = id;
    notifyListeners();
  }

  set name(String? name) {
    _name = name;
    notifyListeners();
  }

  set phoneNumber(String? phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  set emergencyPending(user_model.EmergencyPending? emergencyPending) {
    _emergencyPending = emergencyPending;
    notifyListeners();
  }

  Future<void> checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signed_in") ?? false;
    notifyListeners();

    if (!_isSignedIn) {
      return;
    }

    Map<String, dynamic> decodedJson =
        jsonDecode(s.getString("user_model") ?? "{}");

    user_model.User loggedInUser = user_model.User.fromMap(decodedJson);

    DocumentSnapshot fetchedUserData =
        await _firebaseFirestore.collection("users").doc(loggedInUser.id).get();

    if (!fetchedUserData.exists) {
      return;
    }

    id = fetchedUserData.id;
    name = fetchedUserData.get("name");
    phoneNumber = fetchedUserData.get("phoneNumber");
    if (fetchedUserData.get("emergencyPending") != null) {
      emergencyPending = user_model.EmergencyPending.fromMap(
          fetchedUserData.get("emergencyPending"));
    }
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setBool("is_signed_in", true);
    isSignedIn = true;
  }

  void signOut({required BuildContext context}) async {
    isSignedIn = false;
    id = null;
    name = null;
    phoneNumber = null;
    emergencyPending = null;

    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.clear();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/registration",
        (route) => false,
      );
    }
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            isLoading = false;
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            isLoading = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Verify(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    isLoading = true;

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;
      if (user != null) {
        _id = user.uid;
        onSuccess();
      }
      isLoading = false;
    } on FirebaseAuthException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
      isLoading = false;
    }
  }

  // DATABASE OPERATIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_id).get();
    if (snapshot.exists) {
      return true;
    }

    return false;
  }

  void saveUser({
    required BuildContext context,
    required user_model.User userModel,
    required Function onSuccess,
  }) async {
    isLoading = true;
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(_id)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        isLoading = false;
      });
      await saveUserToSharedPreferences(userModel).then((value) {
        setSignIn().then((value) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/navigation',
            (route) => false,
          );
        });
      });
    } on FirebaseAuthException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
      isLoading = false;
    }
  }

  void loadUser({
    required BuildContext context,
    required Function onSuccess,
  }) async {
    isLoading = true;
    try {
      await _firebaseFirestore.collection("users").doc(_id).get().then((value) {
        if (!value.exists) {
          throw Exception("Account not found.");
        }

        id = value.id;
        name = value.get("name");
        phoneNumber = value.get("phoneNumber");
        if (value.get("emergencyPending") != null) {
          emergencyPending = user_model.EmergencyPending.fromMap(
              value.get("emergencyPending"));
        }

        onSuccess();
        isLoading = false;
      });
      user_model.User userModel =
          user_model.User(id: _id, name: _name!, phoneNumber: _phoneNumber!);
      await saveUserToSharedPreferences(userModel).then((value) {
        setSignIn().then((value) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/navigation',
            (route) => false,
          );
        });
      });
    } on FirebaseAuthException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
      isLoading = false;
    }
  }

  Future<bool> updateUser({
    required BuildContext context,
    required user_model.User user,
    required Function onSuccess,
  }) async {
    isLoading = true;
    try {
      await _firebaseFirestore.collection("users").doc(_id).set(user.toMap());
      isLoading = false;

      name = user.name;
      phoneNumber = user.phoneNumber;
      emergencyPending = user.emergencyPending;

      onSuccess();
      return true;
    } on FirebaseException catch (err) {
      if (context.mounted) {
        showSnackBar(context, err.message.toString());
      }
      isLoading = false;
      return false;
    }
  }

  void answeredDialogClosed({
    required BuildContext context,
  }) async {
    try {
      user_model.User user = user_model.User(
        id: id!,
        name: name!,
        phoneNumber: phoneNumber!,
        emergencyPending: null,
      );

      await _firebaseFirestore
          .collection("users")
          .doc(user.id)
          .set(user.toMap());

      emergencyPending = null;
    } on FirebaseException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
    }
  }

  Future saveUserToSharedPreferences(user_model.User userModel) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString("user_model", jsonEncode(userModel.toMap()));
  }
}
