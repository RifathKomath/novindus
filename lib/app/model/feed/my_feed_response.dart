class MyFeedResponse {
    int? count;
    String? next;
    dynamic previous;
    List<MyFeedResult>? results;

    MyFeedResponse({
        this.count,
        this.next,
        this.previous,
        this.results,
    });

    factory MyFeedResponse.fromJson(Map<String, dynamic> json) => MyFeedResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<MyFeedResult>.from(json["results"]!.map((x) => MyFeedResult.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class MyFeedResult {
    int? id;
    String? description;
    String? image;
    String? video;
    List<dynamic>? likes;
    List<dynamic>? dislikes;
    List<dynamic>? bookmarks;
    List<dynamic>? hide;
    DateTime? createdAt;
    bool? follow;
    User? user;

    MyFeedResult({
        this.id,
        this.description,
        this.image,
        this.video,
        this.likes,
        this.dislikes,
        this.bookmarks,
        this.hide,
        this.createdAt,
        this.follow,
        this.user,
    });

    factory MyFeedResult.fromJson(Map<String, dynamic> json) => MyFeedResult(
        id: json["id"],
        description: json["description"],
        image: json["image"],
        video: json["video"],
        likes: json["likes"] == null ? [] : List<dynamic>.from(json["likes"]!.map((x) => x)),
        dislikes: json["dislikes"] == null ? [] : List<dynamic>.from(json["dislikes"]!.map((x) => x)),
        bookmarks: json["bookmarks"] == null ? [] : List<dynamic>.from(json["bookmarks"]!.map((x) => x)),
        hide: json["hide"] == null ? [] : List<dynamic>.from(json["hide"]!.map((x) => x)),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        follow: json["follow"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "image": image,
        "video": video,
        "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x)),
        "dislikes": dislikes == null ? [] : List<dynamic>.from(dislikes!.map((x) => x)),
        "bookmarks": bookmarks == null ? [] : List<dynamic>.from(bookmarks!.map((x) => x)),
        "hide": hide == null ? [] : List<dynamic>.from(hide!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "follow": follow,
        "user": user?.toJson(),
    };
}

class User {
    int? id;
    dynamic name;
    dynamic image;

    User({
        this.id,
        this.name,
        this.image,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
    };
}
