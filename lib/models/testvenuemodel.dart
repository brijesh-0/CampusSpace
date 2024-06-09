class Venue {
  final String name;
  final String capacity;
  final List<String> images;
  final String venueType;
  final String details;

  Venue(
      {required this.name,
      required this.capacity,
      required this.images,
      required this.venueType,
      required this.details});

  factory Venue.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('Map cannot be null');
    }

    return Venue(
      name: map['name'] as String? ?? '',
      capacity: map['capacity'] as String? ?? '',
      details: map['details'] as String? ?? '',
      images: List<String>.from(map['images'] as List<dynamic>? ?? []),
      venueType: map['venueType'] as String? ?? '',
    );
  }
}
