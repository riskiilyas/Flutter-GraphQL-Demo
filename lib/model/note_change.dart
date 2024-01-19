import 'note.dart';

class NoteChange {
  NoteChange({
    required this.status,
    required this.note,
  });

  NoteChange.fromJson(dynamic json) {
    status = json['status'];
    note = (json['note'] != null ? Note.fromJson(json['note']) : null)!;
  }

  late String status;
  late Note note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['note'] = note.toJson();
    return map;
  }
}
