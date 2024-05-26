import 'package:emergency/models/emergency_model.dart';
import 'package:emergency/store/emergency_provider.dart';
import 'package:emergency/store/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Police extends StatefulWidget {
  const Police({super.key});

  @override
  State<Police> createState() => _PoliceState();
}

class _PoliceState extends State<Police> {
  late EmergencyProvider emergencyProvider;
  late UserProvider userProvider;
  late GoogleMapController _controller;
  final Map<String, Marker> _markers = {};
  Position? currentPosition;

  bool needAmbulance = false;

  @override
  void didChangeDependencies() {
    emergencyProvider = Provider.of<EmergencyProvider>(context, listen: true);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _showAmbulanceDialog(BuildContext context) async {
    // print("First Dialog");
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return _buildAmbulanceDialog();
      },
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    // print("Second Dialog");
    int numberOfAmbulances = 1; // Default value

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return _buildConfirmationDialog(numberOfAmbulances);
      },
    );
  }

  Future<void> _showSuccessAlert(
      BuildContext context, int numberOfAmbulances) async {
    // print("Third Dialog");
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return _buildSuccessAlert(numberOfAmbulances);
      },
    ).then((value) {
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }

  Widget _buildAmbulanceDialog() {
    return AlertDialog(
      title: const Text(
        'پێويستت بە ئەمبوڵانس هەيە ؟',
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: 'rabar',
          color: Colors.black,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                emergencyProvider.needsAmbulance = true;
                // Handle 'Yes' button click
                Navigator.of(context).pop();
                setState(() {
                  needAmbulance = true;
                });
                _showConfirmationDialog(context);
                // TODOs: Add code to send location and request ambulance
              },
              child: const Text(
                'بەلێ',
                style: TextStyle(
                  color: Color.fromARGB(255, 33, 67, 127),
                  fontSize: 16,
                  fontFamily: 'rabar',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle 'No' button click
                if (emergencyProvider.isLoading) return;

                emergencyProvider.needsAmbulance = false;
                emergencyProvider.numberOfAmbulances = 0;
                emergencyProvider.department = 2;

                Emergency emergency = Emergency(
                  department: emergencyProvider.department!,
                  location: Location(
                    longitude: emergencyProvider.longitude!,
                    latitude: emergencyProvider.latitude!,
                  ),
                  needsAmbulance: emergencyProvider.needsAmbulance!,
                  numberOfAmbulances: emergencyProvider.numberOfAmbulances!,
                  userID: userProvider.id!,
                  ambulanceAnswered: null,
                );

                emergencyProvider.sendEmergency(
                  context: context,
                  emergencyModel: emergency,
                  onSuccess: () {
                    emergencyProvider.clearValues();
                    Navigator.of(context).pop();
                    _showSuccessAlert(context, 0);
                  },
                );
              },
              child: const Text(
                'نەخێر',
                style: TextStyle(
                  color: Color.fromARGB(227, 103, 8, 1),
                  fontSize: 16,
                  fontFamily: 'rabar',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmationDialog(int numberOfAmbulances) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
        'ژمارەی ئەمبوڵانس',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'rabar',
          color: Colors.black,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text('Ambulance requested successfully!'),
          const SizedBox(height: 10),
          const Text(
            'چەند ئەمبوڵانس پێويستە ؟',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'rabar',
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 50,
            child: TextFormField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              initialValue: '1',
              onChanged: (value) {
                // Update the number of ambulances
                numberOfAmbulances = int.tryParse(value) ?? 1;
              },
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(16.0),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (emergencyProvider.isLoading) return;

            emergencyProvider.isLoading = true;
            emergencyProvider.department = 20;
            emergencyProvider.needsAmbulance = true;
            emergencyProvider.numberOfAmbulances = numberOfAmbulances;

            Emergency emergency = Emergency(
              department: emergencyProvider.department!,
              location: Location(
                longitude: emergencyProvider.longitude!,
                latitude: emergencyProvider.latitude!,
              ),
              needsAmbulance: emergencyProvider.needsAmbulance!,
              numberOfAmbulances: emergencyProvider.numberOfAmbulances!,
              userID: userProvider.id!,
              ambulanceAnswered: false,
            );

            emergencyProvider.sendEmergency(
              context: context,
              emergencyModel: emergency,
              onSuccess: () {
                emergencyProvider.clearValues();
                Navigator.of(context).pop();
                _showSuccessAlert(context, numberOfAmbulances);
              },
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 100.0),
            child: Text(
              'ناردن',
              style: TextStyle(
                color: Color.fromARGB(255, 33, 67, 127),
                fontSize: 16,
                fontFamily: 'rabar',
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSuccessAlert(int numberOfAmbulances) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'بە سەرکەوتوی ناونيشانەکەت نێردرا',
            style: TextStyle(
              fontFamily: 'rabar',
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          numberOfAmbulances == 0
              ? const SizedBox()
              : Text(
                  ' ژمارەی ئەمبولانسی داواکراو  $numberOfAmbulances',
                  style: const TextStyle(
                    fontFamily: 'rabar',
                    color: Colors.grey,
                  ),
                ),
        ],
      ),
      contentPadding: const EdgeInsets.all(16.0), // Set padding for content
      actions: [
        TextButton(
          onPressed: () {
            // Close the success alert
            Navigator.of(context).pop();
            setState(() {
              needAmbulance = false; // Reset the state variable
            });
          },
          child: const Center(
            child: Text(
              'باشە',
              style: TextStyle(
                color: Color.fromARGB(255, 33, 67, 127),
                fontSize: 16,
                fontFamily: 'rabar',
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            _determinePosition().then((value) {
              currentPosition = value;
            }).whenComplete(() {
              if (currentPosition != null) {
                Marker location = Marker(
                  markerId: const MarkerId("marker"),
                  position: LatLng(
                    currentPosition!.latitude,
                    currentPosition!.longitude,
                  ),
                  visible: false,
                );
                _markers["marker"] = location;
              }
              setState(() {});
            });
          },
          child: Image.asset(
            'assets/images/location.png',
            height: 10.0,
            width: 10.0,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 33, 67, 127),
        title: const Text(
          'هاتوچۆ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'rabar',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Disable back arrow
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              myLocationEnabled: currentPosition != null ? true : false,
              initialCameraPosition: const CameraPosition(
                target: LatLng(36.18568689371844,
                    44.36993535608053), // Coordinates for a location in Iraq
                zoom: 7,
              ),
              cameraTargetBounds: CameraTargetBounds(
                LatLngBounds(
                  southwest: const LatLng(35.20873765977967, 42.33197249772141),
                  northeast: const LatLng(37.09366008380238, 46.15521300554078),
                ),
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(7, 18),
              mapToolbarEnabled: false,
              // layoutDirection: TextDirection.rtl,
              onMapCreated: (controller) {
                _controller = controller;
              },
              onTap: (LatLng latLng) {
                currentPosition = null;
                Marker marker = Marker(
                  markerId: const MarkerId("marker"),
                  position: LatLng(latLng.latitude, latLng.longitude),
                );
                setState(() {
                  _markers["marker"] = marker;
                });
              },
              onLongPress: (argument) {
                setState(() {
                  _markers.remove("marker");
                });
              },
              markers: _markers.values.toSet(),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              children: [
                const Text(
                  'بۆ داواکردنی یارمەتی خێرا ناونیشانەکەت بنێرە',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'rabar',
                    color: Color.fromARGB(255, 33, 67, 127),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: _markers.isNotEmpty
                        ? () {
                            LatLng location = _markers["marker"]!.position;
                            emergencyProvider.longitude =
                                location.longitude.toString();
                            emergencyProvider.latitude =
                                location.latitude.toString();
                            if (needAmbulance) {
                              _showConfirmationDialog(context);
                            } else {
                              _showAmbulanceDialog(context);
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 33, 67, 127),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Text(
                        "ناردنی ناونیشان ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'rabar'),
                      ),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {},
                //       style: ElevatedButton.styleFrom(
                //           shape: const CircleBorder(),
                //           padding: const EdgeInsets.all(10),
                //           backgroundColor:
                //               const Color.fromARGB(255, 151, 13, 3)),
                //       child: const Icon(
                //         Icons.mic,
                //         color: Colors.white,
                //         size: 30,
                //       ),
                //     ),

                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
