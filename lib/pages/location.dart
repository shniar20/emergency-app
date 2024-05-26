import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _FireState();
}

class _FireState extends State<Location> {
  late GoogleMapController _controller;
  // final Map<String, Marker> _markers = {};
  Position? currentPosition;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(36.18568689371844,
                44.36993535608053), // Coordinates for a location in Iraq
            zoom: 7,
          ),
          cameraTargetBounds: CameraTargetBounds(LatLngBounds(
              southwest: const LatLng(35.20873765977967, 42.33197249772141),
              northeast: const LatLng(37.09366008380238, 46.15521300554078))),
          minMaxZoomPreference: const MinMaxZoomPreference(7, 18),
          mapToolbarEnabled: false,
          layoutDirection: TextDirection.rtl,
          onMapCreated: (controller) {
            _controller = controller;
          },
          // onTap: (LatLng latLng) {
          //   Marker marker = Marker(
          //     markerId: const MarkerId("marker"),
          //     position: LatLng(latLng.latitude, latLng.longitude),
          //   );
          //   setState(() {
          //     _markers["marker"] = marker;
          //   });
          // },
          // onLongPress: (argument) {
          //   setState(() {
          //     _markers.remove("marker");
          //   });
          // },
          // markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
