class BucketLocation {
  final int id;
  final String name;
  final double lat;
  final double lng;
  final String? address;

  BucketLocation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.address,
  });

  factory BucketLocation.fromJson(Map<String, dynamic> json) {
    return BucketLocation(
      id: json["id"],
      name: json["name"],
      lat: json["lat"].toDouble(),
      lng: json["lng"].toDouble(),
      address: json["address"],
    );
  }
}
