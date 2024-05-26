import 'package:emergency/store/user_provider.dart';
import 'package:emergency/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class Verify extends StatefulWidget {
  final String verificationId;
  const Verify({super.key, required this.verificationId});

  @override
  State<Verify> createState() {
    return _VerificationPageState();
  }
}

class _VerificationPageState extends State<Verify> {
  // final List<TextEditingController> _controllers =
  //     List.generate(4, (index) => TextEditingController());
  // final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // @override
  // void dispose() {
  //   for (var controller in _controllers) {
  //     controller.dispose();
  //   }
  //   for (var focusNode in _focusNodes) {
  //     focusNode.dispose();
  //   }
  //   super.dispose();
  // }
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final bool isLoading =
        Provider.of<UserProvider>(context, listen: true).isLoading;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Icon(
          Icons.verified_user,
          size: 25,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 33, 67, 127),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(
        //       Icons.arrow_forward,
        //       size: 25,
        //     ),
        //   ),
        // ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 33, 67, 127),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 60.0),
                    child: Text(
                      "کۆدی دڵنیایی ",
                      style: TextStyle(
                        fontFamily: 'rabar',
                        fontSize: 30,
                        color: Color.fromARGB(255, 33, 67, 127),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 60, 140, 231),
                        ),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 21.0,
                      ),
                    ),
                    onCompleted: (value) {
                      setState(() {
                        otpCode = value;
                      });
                    },
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: List.generate(
                  //     4,
                  //     (index) => SizedBox(
                  //       width: 50,
                  //       height: 40,
                  //       child: TextField(
                  //         controller: _controllers[index],
                  //         focusNode: _focusNodes[index],
                  //         keyboardType: TextInputType.number,
                  //         maxLength: 1,
                  //         textAlign: TextAlign.center,
                  //         style: const TextStyle(fontFamily: 'rabar', fontSize: 24),
                  //         decoration: const InputDecoration(
                  //           counterText: "", // Hide the character count
                  //           focusedBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //                 color: Color.fromARGB(255, 33, 67, 127),
                  //                 width: 2.0),
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  //           ),
                  //         ),
                  //         onChanged: (value) {
                  //           if (value.isNotEmpty) {
                  //             // Move focus to the next TextField
                  //             if (index < 3) {
                  //               _focusNodes[index + 1].requestFocus();
                  //             }
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 70),
                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (otpCode != null) {
                          verifyOtp(context, otpCode!);
                        } else {
                          showSnackBar(context, "تکایە کۆدەکەت تۆمار بکە");
                        }
                        // Navigator.pushNamed(context, '/navigation');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        backgroundColor: const Color.fromARGB(255, 33, 67, 127),
                      ),
                      child: const Text(
                        "دڵنیابوونەوە",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'rabar'),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 40.0),
                  // const Text(
                  //   "هیچ کۆدێکت بەدەست نەگەشت؟",
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontFamily: 'rabar',
                  //     color: Colors.black38,
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // const Text(
                  //   "دووبارە ناردنەوەی کۆد",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontFamily: 'rabar',
                  //     color: Color.fromARGB(255, 33, 67, 127),
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }

  // Verify OTP
  void verifyOtp(BuildContext context, String userOtp) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        userProvider.checkExistingUser().then((value) async {
          if (value) {
            // user exists in our app
            userProvider.loadUser(
              context: context,
              onSuccess: () {},
            );
          } else {
            // new user
            Navigator.pushReplacementNamed(context, '/registration_info');
            // User newUser = User(
            //   id: userProvider.id,
            //   name: userProvider.name!,
            //   phoneNumber: userProvider.phoneNumber!,
            // );

            // userProvider.saveUser(
            //   context: context,
            //   userModel: newUser,
            //   onSuccess: () {},
            // );
          }
        });
      },
    );
  }
}
