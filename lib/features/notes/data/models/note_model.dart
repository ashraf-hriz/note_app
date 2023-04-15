import 'package:note_app/features/notes/domain/entities/note_entity.dart';

class NoteModel extends Note {
  NoteModel({
    required String id,
    required String title,
    required String text,
    required String date,
  }) : super(
          id: id,
          title: title,
          text: text,
          date: date,
        );

        factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      text: json['note'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> note = <String, dynamic>{};
    note['title'] = title;
    note['note'] = text;
    note['date'] = date;
    note['id'] = id;
    return note;
  }
}
