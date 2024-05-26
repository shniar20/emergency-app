import 'package:emergency/models/emergency_model.dart';
import 'package:emergency/pages/activity_detail.dart';
import 'package:emergency/store/emergency_provider.dart';
import 'package:emergency/store/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class UserActivityPage extends StatefulWidget {
  const UserActivityPage({Key? key}) : super(key: key);

  @override
  State<UserActivityPage> createState() => _UserActivityPageState();
}

class _UserActivityPageState extends State<UserActivityPage> {
  late EmergencyProvider emergencyProvider;
  late UserProvider userProvider;
  List<Emergency> emergencies = [];
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    emergencyProvider = Provider.of<EmergencyProvider>(context, listen: false);

    emergencyProvider
        .getEmergencies(userId: userProvider.id!, answered: true)
        .then((value) {
      setState(() {
        emergencies = value;
        loading = false;
      });
    });
  }

  Future refresh() async {
    setState(() {
      loading = true;
    });
    emergencies = await emergencyProvider.getEmergencies(
        userId: userProvider.id!, answered: true);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 67, 127),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.chevron_right),
            color: Colors.white,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            const Text(
              ':چالاکیە تۆمارکراوەکان',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'rabar'),
            ),
            const SizedBox(height: 30),
            loading
                ? const Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : emergencies.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            String department = "";
                            switch (emergencies[index].department) {
                              case 0:
                                department = "ئەمبوڵانس";
                                break;
                              case 1:
                                department = "ئاگرکوژێنەوە";
                                break;
                              case 2:
                                department = "هاتووچۆ";
                                break;
                              case 10:
                                department = "ئەمبولانس و ئاگرکوژێنەوە";
                                break;
                              case 20:
                                department = "ئەمبوڵانس و هاتووچۆ";
                                break;
                            }

                            return Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(194, 159, 11, 0),
                                  ),
                                  onPressed: () {
                                    // Delete action
                                    emergencyProvider.deleteOneEmergency(
                                      context: context,
                                      emergency: emergencies[index],
                                      onSuccess: () => refresh(),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.info,
                                    color: Color.fromARGB(255, 22, 74,
                                        163), // Customize the color as needed
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActivityDetail(
                                          emergency: emergencies[index],
                                          department: department,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      department,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      intl.DateFormat("dd/MM/yyyy")
                                          .format(emergencies[index].createdAt)
                                          .toString(),
                                    ),
                                    Text(
                                      intl.DateFormat("hh:mm a")
                                          .format(emergencies[index].createdAt)
                                          .toString(),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(Icons.history,
                                      color: Color.fromARGB(227, 103, 8, 1)),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 5.0),
                          itemCount: emergencies.length,
                        ),
                      )
                    : Expanded( 
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            "هیچ چالاکیێکت نییە",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'rabar',
                              fontSize: 20.0,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
            const SizedBox(height: 16),
            loading
                ? const SizedBox()
                : Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: emergencies.isNotEmpty
                          ? () {
                              emergencyProvider.deleteAllEmergencies(
                                context: context,
                                emergencies: emergencies,
                                onSuccess: () => refresh(),
                              );
                            }
                          : null,
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'سڕينەوەی هەموو چالاکياکان',
                          style: TextStyle(
                              color: Color.fromARGB(194, 159, 11, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'rabar'),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
