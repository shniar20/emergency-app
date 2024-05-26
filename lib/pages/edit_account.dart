import 'package:emergency/models/user_model.dart';
import 'package:emergency/store/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  final String name;
  final String phone;
  const EditAccount({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  State<EditAccount> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccount> {
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late UserProvider userProvider;
  late Size screenSize;

  // ignore: unused_element
  Future<void> _getImage() async {}

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
    userProvider = Provider.of<UserProvider>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const Icon(
          Icons.person,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 33, 67, 127),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenSize.width / 4,
                  backgroundImage: const AssetImage('assets/images/men.png'),
                ),
                const SizedBox(height: 30),
                isEditing
                    ? Column(
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "تکایە ئەم بۆشاییە پڕبکەرەوە";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              controller: nameController,
                              textDirection: TextDirection.rtl,
                              decoration: const InputDecoration(
                                hintText: 'ناوی نوێ داخل بکە',
                                hintTextDirection: TextDirection.rtl,
                                hintStyle: TextStyle(
                                  fontFamily: 'rabar',
                                  color: Colors.grey,
                                ),
                                errorStyle: TextStyle(
                                  fontFamily: 'rabar',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            textAlign: TextAlign.end,
                            enabled: false,
                            decoration: const InputDecoration(
                              hintText: "ژمارەی تەلەفۆنی نوێ داخل بکە",
                              // hintTextDirection: TextDirection.rtl,
                              hintStyle: TextStyle(
                                fontFamily: 'rabar',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            userProvider.name ?? "",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(width: 5),
                              Text(
                                userProvider.phoneNumber ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 50),
                isEditing
                    ? ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Save changes logic goes here
                            userProvider.updateUser(
                              context: context,
                              user: User(
                                id: userProvider.id,
                                name: nameController.text.trim(),
                                phoneNumber: phoneController.text.trim(),
                              ),
                              onSuccess: () {
                                Navigator.pop(context);
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color.fromARGB(255, 33, 67, 127),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60.0,
                            vertical: 10.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: userProvider.isLoading
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'تۆمارکردنی گۆرانکاری',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color.fromARGB(255, 33, 67, 127),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60.0,
                            vertical: 10.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: const Text(
                          'گۆرین',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
