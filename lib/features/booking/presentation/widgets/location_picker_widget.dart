import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationPickerWidget extends StatefulWidget {
  final void Function(String locationString) onLocationPicked;

  const LocationPickerWidget({super.key, required this.onLocationPicked});

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  LatLng? _pickedLocation;
  String? _locationString;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pick Location",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(27.7172, 85.3240),
                initialZoom: 13,
                onTap: (tapPosition, latlng) async {
                  if (!mounted) return;
                  setState(() {
                    _pickedLocation = latlng;
                  });

                  try {
                    final url = Uri.parse(
                      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${latlng.latitude}&lon=${latlng.longitude}',
                    );
                    final response = await http.get(
                      url,
                      headers: {'User-Agent': 'ghar_care_app'},
                    );

                    if (!mounted) return;

                    if (response.statusCode == 200) {
                      final data = json.decode(response.body);
                      final location = data['display_name'] as String;
                      setState(() => _locationString = location);
                      widget.onLocationPicked(location);
                    } else {
                      final fallback =
                          "${latlng.latitude}, ${latlng.longitude}";
                      setState(() => _locationString = fallback);
                      widget.onLocationPicked(fallback);
                    }
                  } catch (_) {
                    if (!mounted) return;
                    final fallback = "${latlng.latitude}, ${latlng.longitude}";
                    setState(() => _locationString = fallback);
                    widget.onLocationPicked(fallback);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.ghar_care',
                ),
                if (_pickedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _pickedLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _locationString ?? "Tap on the map to select location",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
