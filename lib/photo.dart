class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  Photo.fromJson(json)
      : this.albumId = json['albumId'],
        this.id = json['id'],
        this.title = json['title'],
        this.url = json['url'],
        this.thumbnailUrl = json['thumbnailUrl'];

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl
    };
  }
}
