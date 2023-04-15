import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:note_app/core/utils/snackbar_message.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/helper.dart';
import '../../domain/entities/note_entity.dart';
import '../provider/note_provider.dart';
import '../widgets/icon_button.dart';

class AddNoteScreen extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  const AddNoteScreen({super.key, this.isUpdate = false, this.note});

  @override
  AddNoteScreenState createState() => AddNoteScreenState();
}

class AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _noteTextController = TextEditingController();
  //final NoteController _noteController = Get.find<NoteController>();
  final DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    if (widget.isUpdate) {
      _titleTextController.text = widget.note!.title;
      _noteTextController.text = widget.note!.text;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            _body(),
          ],
        ),
      ),
    );
  }

  _appBar() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
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
              _validateInput();
            },
            txt: widget.isUpdate ? "Update" : "Save",
          ),
        ],
      ),
    );
  }

  _body() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleTextController,
            style: ThemeHelper.titleTextStyle,
            cursorColor: Colors.black,
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              hintText: "Title",
              hintStyle:
                  ThemeHelper.titleTextStyle.copyWith(color: Colors.grey),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ThemeHelper.bgColor),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ThemeHelper.bgColor),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: _noteTextController,
            style: ThemeHelper.bodyTextStyle,
            cursorColor: Colors.black,
            minLines: 3,
            maxLines: 12,
            decoration: InputDecoration(
              hintText: "Type something...",
              hintStyle: ThemeHelper.bodyTextStyle,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ThemeHelper.bgColor),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ThemeHelper.bgColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _validateInput() async {
    bool isNotEmpty = _titleTextController.text.isNotEmpty &&
        _noteTextController.text.isNotEmpty;
    if (isNotEmpty && !widget.isUpdate) {
      _addNoteToDB();
      //Get.back();
    } else if (widget.isUpdate &&
            _titleTextController.text != widget.note!.title ||
        _noteTextController.text != widget.note!.text) {
      _updateNote();
      
    } else {
      SnackBarMessage().showErrorSnackBar(
          message: widget.isUpdate
              ? "Fields are not updated yet."
              : "All fields are required.",
          context: context);
    }
  }

  _addNoteToDB() async {
    var uuid = Uuid();

  // Generate a v1 (time-based) id
  var randomId = uuid.v1();
    Provider.of<NoteProvider>(navigatorKey.currentState!.context, listen: false)
        .addNote(
      Note(
        id: randomId,
        text: _noteTextController.text,
        title: _titleTextController.text,
        date: DateFormat('yyyy-MM-dd hh:mm').format(_currentDate).toString(),
      ),
    );
   
  }

  _updateNote() async {

    Provider.of<NoteProvider>(navigatorKey.currentState!.context, listen: false)
        .updateNote(
      Note(
         id: widget.note!.id,
        text: _noteTextController.text,
        title: _titleTextController.text,
        date: DateFormat('yyyy-MM-dd hh:mm').format(_currentDate).toString(),
      ),
    );
  }
}
