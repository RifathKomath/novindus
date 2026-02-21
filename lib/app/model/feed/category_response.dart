class CategoryResponse {
  List<CategoryList>? categories;
  bool? status;

  CategoryResponse({this.categories, this.status});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        categories: json["categories"] == null
            ? []
            : List<CategoryList>.from(
                json["categories"]!.map((x) => CategoryList.fromJson(x)),
              ),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "status": status,
  };
}

class CategoryList {
  int? id;
  String? title;
  String? image;

  CategoryList({this.id, this.title, this.image});

  factory CategoryList.fromJson(Map<String, dynamic> json) =>
      CategoryList(id: json["id"], title: json["title"], image: json["image"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title, "image": image};
}
