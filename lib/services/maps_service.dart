class MapLocation {
  final double latitude;
  final double longitude;
  final String addressName;

  const MapLocation({
    required this.latitude,
    required this.longitude,
    required this.addressName,
  });
}

abstract class MapsService {
  Future<MapLocation> getCurrentLocation();
  Future<List<MapLocation>> getRoutePolyline(MapLocation origin, MapLocation destination);
  Future<String> getEstimatedTimeArrival(MapLocation origin, MapLocation destination);
}

class MockMapsService implements MapsService {
  @override
  Future<MapLocation> getCurrentLocation() async {
    return const MapLocation(
      latitude: 28.6139,
      longitude: 77.2090,
      addressName: 'Sector 62, Noida, UP - 201301',
    );
  }

  @override
  Future<List<MapLocation>> getRoutePolyline(MapLocation origin, MapLocation destination) async {
    return [
      origin,
      const MapLocation(latitude: 28.6150, longitude: 77.2100, addressName: 'Waypoint 1'),
      const MapLocation(latitude: 28.6170, longitude: 77.2120, addressName: 'Waypoint 2'),
      destination,
    ];
  }

  @override
  Future<String> getEstimatedTimeArrival(MapLocation origin, MapLocation destination) async {
    return '6 mins (1.2 km away)';
  }
}
