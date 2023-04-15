class Note {
  String title;
  String text;
  String date;
  String id;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.date,
  });

  static List<Note> noteList = [
    Note(id: '1', title: 'note 1', text: 'note text', date: '2/1/2022'),
    Note(id: '2', title: 'note 2', text: 'note text', date: '2/1/2022'),
    Note(id: '3', title: 'note 3', text: 'note text', date: '2/1/2022'),
    Note(id: '4', title: 'note 4', text: 'note text', date: '2/1/2022'),
  ];

  
}