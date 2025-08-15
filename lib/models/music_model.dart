class MusicModel {
  final String id;
  final String title;
  final String artist;
  final String filePath;
  final Duration duration;
  final String? coverPath;

  MusicModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.filePath,
    required this.duration,
    this.coverPath,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      filePath: json['filePath'],
      duration: Duration(milliseconds: json['duration'] ?? 0),
      coverPath: json['coverPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'filePath': filePath,
      'duration': duration.inMilliseconds,
      'coverPath': coverPath,
    };
  }
}
