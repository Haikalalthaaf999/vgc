class TambahData {
  final String? title;
  final String? description;
  final String? genre;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;
  final String? image;
  final String? imageUrl; // Tambahan

  TambahData({
    this.title,
    this.description,
    this.genre,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.image,
    this.imageUrl, // Tambahan
  });

  TambahData copyWith({String? image, String? imageUrl}) {
    return TambahData(
      title: title,
      description: description,
      genre: genre,
      updatedAt: updatedAt,
      createdAt: createdAt,
      id: id,
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl, // Tambahan
    );
  }

  factory TambahData.fromJson(Map<String, dynamic> json) => TambahData(
    title: json["title"] as String?,
    description: json["description"] as String?,
    genre: json["genre"] as String?,
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : null,
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : null,
    id: json["id"] as int?,
    image: json["image"] as String?,
    imageUrl: json["image_url"] as String?, // Tambahan
  );

  Map<String, dynamic> toJson() => {
    "title": title ?? '',
    "description": description ?? '',
    "genre": genre ?? '',
    "updated_at": updatedAt?.toIso8601String() ?? '',
    "created_at": createdAt?.toIso8601String() ?? '',
    "id": id ?? 0,
    "image": image ?? '',
    "image_url": imageUrl ?? '', // Tambahan
  };
}
