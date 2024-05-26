import 'package:emergency/models/emergency_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;

class ActivityDetail extends StatefulWidget {
  final Emergency emergency;
  final String department;
  const ActivityDetail({
    Key? key,
    required this.emergency,
    required this.department,
  }) : super(key: key);

  @override
  State<ActivityDetail> createState() => _ActivityDetailState();
}

class _ActivityDetailState extends State<ActivityDetail> {
  late GoogleMapController _controller;
  Marker? _marker;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();

    _marker = Marker(
      markerId: const MarkerId("marker"),
      position: LatLng(
        double.parse(widget.emergency.location.latitude),
        double.parse(widget.emergency.location.longitude),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 45.0),
            child: Text(
              'بینینەوەی چالاکیەکان',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'rabar',
                color: Color.fromARGB(255, 33, 67, 127),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 405, // Set the desired width
              height: 350, // Set the desired height
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 33, 67, 127),
                  width: 1.0,
                ),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(widget.emergency.location.latitude),
                    double.parse(widget.emergency.location.longitude),
                  ),
                  zoom: 14,
                ),
                cameraTargetBounds: CameraTargetBounds(
                  LatLngBounds(
                    southwest: const LatLng(
                      35.20873765977967,
                      42.33197249772141,
                    ),
                    northeast: const LatLng(
                      37.09366008380238,
                      46.15521300554078,
                    ),
                  ),
                ),
                minMaxZoomPreference: const MinMaxZoomPreference(7, 18),
                mapToolbarEnabled: false,
                layoutDirection: TextDirection.rtl,
                onMapCreated: (controller) {
                  _controller = controller;
                },
                markers: <Marker>{_marker!},
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.department,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontFamily: 'rabar',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            intl.DateFormat("hh:mm a - dd/MM/yyyy")
                .format(widget.emergency.createdAt)
                .toString(),
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 150,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                backgroundColor: const Color.fromARGB(255, 33, 67, 127),
              ),
              child: const Text(
                "پەسەندکردن",
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontFamily: 'rabar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
