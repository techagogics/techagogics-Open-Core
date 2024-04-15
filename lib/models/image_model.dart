class ImageModel {
  final int id;
  final String url;
  final bool isFake;

  ImageModel({required this.id, required this.url, required this.isFake});

  // Factory constructor to create a new ImageModel from a map structure
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['image_id'] as int,
      url: json['image_path'] as String,
      isFake: json['is_fake']
          as bool, // Stellen Sie sicher, dass das JSON-Feld 'is_fake' heißt
    );
  }

  // Method to convert the ImageModel instance to a map
  Map<String, dynamic> toJson() {
    return {
      'image_id': id,
      'image_path': url,
      'is_fake': isFake,
    };
  }
}
