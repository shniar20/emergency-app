import 'package:emergency/models/user_model.dart';
import 'package:emergency/store/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationInfo extends StatefulWidget {
  const RegistrationInfo({super.key});

  @override
  State<RegistrationInfo> createState() => _RegistrationInfoState();
}

class _RegistrationInfoState extends State<RegistrationInfo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
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
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "بەخێربێیت",
                style: TextStyle(
                  fontFamily: 'rabar',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 33, 67, 127),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "تکایە هەندێک زانیاری دەربارەی خۆت تۆمار بکە بۆ دروستکردنی هەژمارەکەت.",
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'rabar',
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "تکایە ئەم بۆشاییە پڕبکەرەوە";
                      }
                      return null;
                    },
                    style: const TextStyle(
                        fontFamily: 'rabar', color: Colors.black),
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      prefixIcon: Icon(
                        Icons.text_increase,
                        color: Color.fromARGB(255, 33, 67, 127),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 40,
                      ),
                      labelText: "ناو",
                      hintText: "ناو داخل بکە",
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
              const SizedBox(height: 60.0),
              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      userProvider.name = nameController.text.trim();
                      userProvider.isLoading = true;

                      User newUser = User(
                        id: userProvider.id,
                        name: userProvider.name!,
                        phoneNumber: userProvider.phoneNumber!,
                      );

                      userProvider.saveUser(
                        context: context,
                        userModel: newUser,
                        onSuccess: () {},
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    backgroundColor: const Color.fromARGB(255, 33, 67, 127),
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
            ],
          ),
        ),
      ),
    );
  }
}
