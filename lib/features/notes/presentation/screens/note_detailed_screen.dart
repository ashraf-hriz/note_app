import 'package:flutter/material.dart';
import 'package:note_app/core/helper.dart';
import 'package:note_app/features/notes/presentation/screens/add_note_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_theme.dart';
import '../../domain/entities/note_entity.dart';
import '../provider/note_provider.dart';
import '../widgets/icon_button.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;
  //final _noteController = Get.find<NoteController>();
  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.bgColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            push(context, AddNoteScreen(isUpdate: true, note: note));
          },
          child: const Icon(Icons.edit),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _appBar(context),
            _body(),
          ],
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyIconButton(
            onTap: () {
              Navigator.of(context).pop();
            },
            icon: Icons.keyboard_arrow_left,
          ),
          MyIconButton(
            onTap: () {
              _deleteNote();
              
            },
            icon: Icons.delete,
          ),
        ],
      ),
    );
  }

  _body() {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: ThemeHelper.titleTextStyle,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(note.date, style: ThemeHelper.dateTextStyle.copyWith(fontSize: 18,)),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      note.text,
                      style: ThemeHelper.bodyTextStyle,
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _deleteNote() async {
    Provider.of<NoteProvider>(navigatorKey.currentState!.context,listen: false).deleteNote(note.id);
  }
}
