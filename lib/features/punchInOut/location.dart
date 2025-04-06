class Location {
  final double longitude;
  final double latitude;
  final String branch_id;

  Location({required this.longitude, required this.latitude,required this.branch_id});

  factory Location.fromJson(Map<String, dynamic> json) {
    print(json["naiem"]);
    return Location(
      longitude: double.parse("${json['longitude']?? 0.0}"),
      latitude: double.parse("${json['latitude'] ?? 0.0}"),
      branch_id: json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'id': branch_id,
    };
  }
}
