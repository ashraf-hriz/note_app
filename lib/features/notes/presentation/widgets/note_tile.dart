import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/helper.dart';
import '../../domain/entities/note_entity.dart';
import '../screens/note_detailed_screen.dart';

enum TileType {
  square,
  verRect,
  horRect,
}

class NoteTile extends StatelessWidget {
  final Note note;
  final TileType tileType;
  final int index;
  const NoteTile({
    super.key,
    required this.note,
    required this.tileType,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       
        push(context,NoteDetailScreen(note: note,));
      },
      child: Container(
        // margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThemeHelper.tileColors[index % 7],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: tileType == TileType.horRect
                  ? const EdgeInsets.only(right: 100)
                  : null,
              child: Text(
                note.title,
                maxLines: _getMaxLines(tileType),
                style: ThemeHelper.noteTitleTextStyle.copyWith(
                  fontSize: _getTxtSize(tileType),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(note.date,
                    style: ThemeHelper.dateTextStyle.copyWith(
                        color: Colors.black.withOpacity(0.7))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getTxtSize(TileType tileType) {
    switch (tileType) {
      case TileType.square:
        return 21.0;
      case TileType.verRect:
        return 24.0;
      case TileType.horRect:
        return 29.0;
    }
  }

  _getMaxLines(TileType tileType) {
    switch (tileType) {
      case TileType.square:
        return 4;
      case TileType.verRect:
        return 8;
      case TileType.horRect:
        return 3;
    }
  }
}
