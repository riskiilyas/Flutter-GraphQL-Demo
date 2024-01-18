class Note {
  final String id;
  final String title;
  final String content;
  final String author;

  Note({required this.id, required this.title, required this.content, required this.author});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
    };
  }
}
