import 'package:emergency/pages/component/answered_dialog.dart';
import 'package:emergency/pages/component/drawer_content.dart';
import 'package:emergency/pages/component/pending_dialog.dart';
import 'package:emergency/store/user_provider.dart';
import 'package:emergency/utils/app_lifecycle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late UserProvider userProvider;
  late bool? approved;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: true);

    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (message == AppLifecycleState.resumed.toString()) {
        userProvider.checkSignIn().then((value) async {
          approved = userProvider.emergencyPending?.approved;
          if (approved != null && context.mounted) {
            await showDialog(
              context: context,
              builder: (context) => AnsweredDialog(
                userProvider: userProvider,
                approved: approved!,
              ),
            );
          }
        });
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "بەشەکانی فریاکەوتن",
          style: TextStyle(
            fontFamily: 'rabar',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 67, 127),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      endDrawer: const DrawerContent(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 60.0),
              //   child: Text(
              //     'بەشەکانی فریاکەوتن',
              //     style: TextStyle(
              //       fontSize: 22.0,
              //       fontWeight: FontWeight.bold,
              //       fontFamily: 'rabar',
              //       color: Color.fromARGB(255, 33, 67, 127),
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // const SizedBox(height: 16.0),
              Expanded(
                child: _buildCategoryButton(
                  'ئەمبولانس ',
                  Icons.local_hospital,
                  Colors.white,
                  () {
                    userProvider.emergencyPending != null
                        ? showDialog(
                            context: context,
                            builder: (context) => const PendingDialog(),
                          )
                        : Navigator.pushNamed(context, '/ambulance');
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: _buildCategoryButton(
                  ' ئاگرکوژێنەوە',
                  Icons.local_fire_department,
                  Colors.white,
                  () {
                    userProvider.emergencyPending != null
                        ? showDialog(
                            context: context,
                            builder: (context) => const PendingDialog(),
                          )
                        : Navigator.pushNamed(context, '/fire');
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: _buildCategoryButton(
                  ' هاتوچۆ',
                  Icons.local_police,
                  Colors.white,
                  () {
                    userProvider.emergencyPending != null
                        ? showDialog(
                            context: context,
                            builder: (context) => const PendingDialog(),
                          )
                        : Navigator.pushNamed(context, '/police');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      String title, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.maxFinite,
      height: 150,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 151, 13, 3),
              size: 40.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'rabar',
                  color: Color.fromARGB(255, 151, 13, 3)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
