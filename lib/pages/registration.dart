import 'package:emergency/store/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    // nameController.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 60.0),
                      child: Text(
                        "فریاگوزاری ",
                        style: TextStyle(
                          fontFamily: 'rabar',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 33, 67, 127),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(15.0),
                    //   child: Directionality(
                    //     textDirection: TextDirection.rtl,
                    //     child: TextField(
                    //       controller: nameController,
                    //       style: const TextStyle(
                    //           fontFamily: 'rabar', color: Colors.black),
                    //       keyboardType: TextInputType.name,
                    //       decoration: const InputDecoration(
                    //         contentPadding:
                    //             EdgeInsets.symmetric(horizontal: 20.0),
                    //         prefixIcon: Icon(
                    //           Icons.text_increase,
                    //           color: Color.fromARGB(255, 33, 67, 127),
                    //         ),
                    //         prefixIconConstraints: BoxConstraints(
                    //           minWidth: 40,
                    //         ),
                    //         labelText: "ناو",
                    //         hintText: "ناو داخل بکە",
                    //         labelStyle: TextStyle(),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: phoneNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "تکایە ئەم بۆشاییە پڕبکەرەوە";
                              } else if (value.length < 10 ||
                                  value.length > 11) {
                                return "تکایە ژمارەیەکی ڕاست بنووسە";
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontFamily: 'rabar', color: Colors.black),
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Color.fromARGB(255, 33, 67, 127),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 40,
                              ),
                              labelText: "ژمارەی تەلەفۆن",
                              hintText: "ژمارەی تەلەفۆن داخل بکە",
                              labelStyle: TextStyle(
                                fontFamily: 'rabar',
                                color: Colors.grey,
                              ),
                              errorStyle: TextStyle(
                                fontFamily: 'rabar',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    SizedBox(
                      width: 150,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            userProvider.isLoading = true;
                            sendPhoneNumber();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 33, 67, 127),
                        ),
                        child: userProvider.isLoading
                            ? const SizedBox(
                                width: 25.0,
                                height: 25.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "تۆمار کردن",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'rabar'),
                              ),
                      ),
                    ),
                    const SizedBox(height: 180),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_hospital,
                            size: 30, color: Color.fromARGB(255, 33, 67, 127)),
                        SizedBox(width: 20),
                        Icon(Icons.local_fire_department,
                            size: 30, color: Color.fromARGB(255, 33, 67, 127)),
                        SizedBox(width: 20),
                        Icon(Icons.local_police,
                            size: 30, color: Color.fromARGB(255, 33, 67, 127)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneNumberController.text.trim();
    if (phoneNumber.startsWith("0")) {
      phoneNumber = phoneNumber.substring(1);
    }

    // userProvider.name = nameController.text.trim();
    userProvider.phoneNumber = '+964$phoneNumber';

    userProvider.signInWithPhone(context, userProvider.phoneNumber!);
  }
}
