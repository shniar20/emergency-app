import 'package:emergency/pages/activity.dart';
import 'package:emergency/pages/edit_account.dart';
import 'package:emergency/store/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({super.key});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  List<String> cities = ['سلێمانی', 'هەولێر', 'دهۆک', 'کەرکوک'];
  String selectedCity = 'هەلبژاردن';
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 33, 67, 127),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/ava.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userProvider.name ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.person),
              title: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAccount(
                        name: userProvider.name ?? "",
                        phone: userProvider.phoneNumber ?? "",
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 10.0), // Reduced padding
                  child: Text(
                    'گۆڕینی هه‌ژماری بەکارهێنەر',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(CupertinoIcons.time),
              title: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserActivityPage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 80.0),
                  child: Text(
                    'چالاکیەکان',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(CupertinoIcons.location),
              title: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 90.0),
                    child: Text(
                      'شارەکان',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const ListTile(
                                  title: Center(
                                    child: Text('شارێک هەلبژێرە'),
                                  ),
                                ),
                                const Divider(),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: cities.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Center(
                                        child: Text(cities[index]),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          selectedCity = cities[index];
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 90.0),
                      child: Text(
                        selectedCity,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: TextButton(
                onPressed: () {
                  show(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 90.0),
                  child: Text(
                    'چونەدەرەوە',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 154, 12, 2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "چونەدەرەوە",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 33, 67, 127)),
            textAlign: TextAlign.right,
          ),
          content: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey[200],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ئایا تۆ دلنیایی ؟",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black, // Set text color
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    userProvider.signOut(context: context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 16, 113, 19),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "بەلێ",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 154, 12, 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "نەخێر",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
