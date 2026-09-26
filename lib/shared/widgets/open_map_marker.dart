import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class OpenMapMarker extends StatefulWidget {
  const OpenMapMarker({
    super.key,
    required this.onTapMap,
    required this.width,
    this.currentPosition,
    this.initialPoint,
  });

  final void Function(LatLng point) onTapMap;
  final double width;
  final Position? currentPosition;
  final LatLng? initialPoint;

  @override
  State<OpenMapMarker> createState() => _OpenMapMarkerState();
}

class _OpenMapMarkerState extends State<OpenMapMarker> {
  static const LatLng _defaultCenter = LatLng(3.4516, -76.5320);
  late LatLng? _selectedPoint;
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _selectedPoint = widget.initialPoint;
    _mapController = MapController();
  }

  LatLng get _initialCenter =>
      widget.initialPoint ??
      (widget.currentPosition != null
          ? LatLng(widget.currentPosition!.latitude,
              widget.currentPosition!.longitude)
          : _defaultCenter);

  @override
  void didUpdateWidget(OpenMapMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPoint != oldWidget.initialPoint && widget.initialPoint != null) {
      setState(() {
        _selectedPoint = widget.initialPoint;
      });
      _mapController.move(widget.initialPoint!, 15);
    } else if (widget.currentPosition != oldWidget.currentPosition && widget.currentPosition != null && _selectedPoint == null) {
      _mapController.move(
        LatLng(widget.currentPosition!.latitude, widget.currentPosition!.longitude),
        15,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: 250,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _initialCenter,
          initialZoom: 15,
          onTap: (_, point) {
            setState(() => _selectedPoint = point);
            widget.onTapMap(point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.ponteglam.app',
          ),
          MarkerLayer(
            markers: [
              if (widget.currentPosition != null)
                Marker(
                  point: LatLng(widget.currentPosition!.latitude,
                      widget.currentPosition!.longitude),
                  width: 20,
                  height: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              if (_selectedPoint != null)
                Marker(
                  point: _selectedPoint!,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
            ],
          ),
          RichAttributionWidget(
            alignment: AttributionAlignment.bottomRight,
            attributions: [
              TextSourceAttribution('© OpenStreetMap contributors'),
            ],
          ),
        ],
      ),
    );
  }
}
