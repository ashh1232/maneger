class Bunner {
  final String id;
  final String name;
  final String image;

  factory Bunner.fromJson(Map<String, dynamic> json) {
    return Bunner(
      id: (json['id'] ?? json['banner_id'] ?? "1").toString(),
      name: (json['name'] ?? json['banner_name'] ?? "بدون عنوان").toString(),
      image:
          (json['image'] ??
                  json['banner_image'] ??
                  "https://www.talabat.com/assets/images/Tlogo-500.png")
              .toString(),
    );
  }
  Bunner({required this.id, required this.name, required this.image});
}
