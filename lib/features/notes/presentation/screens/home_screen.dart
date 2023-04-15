import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/core/helper.dart';
import 'package:note_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:note_app/features/notes/presentation/screens/add_note_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/note_entity.dart';
import '../provider/note_provider.dart';
import '../widgets/icon_button.dart';
import '../widgets/note_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tileCounts = [
    [2, 2],
    [2, 2],
    [4, 2],
    [2, 3],
    [2, 2],
    [2, 3],
    [2, 2],
  ];

  final _tileTypes = [
    TileType.square,
    TileType.square,
    TileType.horRect,
    TileType.verRect,
    TileType.square,
    TileType.verRect,
    TileType.square,
  ];

  @override
  void initState() {
    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
       Provider.of<NoteProvider>(context,listen: false).getAllNotes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            push(context, const AddNoteScreen(note: null));
          },
          child: const Icon(Icons.add),
        ),
      ),
      backgroundColor: ThemeHelper.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            const SizedBox(
              height: 16,
            ),
            _body(),
          ],
        ),
      ),
    );
  }

  _appBar() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Notes",
            style: ThemeHelper.titleTextStyle.copyWith(fontSize: 32),
          ),
          MyIconButton(
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logOut();
            },
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }

  _body() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer<NoteProvider>(builder: (context, noteProvider, _) {
          return noteProvider.loading
              ? const LoadingWidget()
              : noteProvider.notesList.isNotEmpty
                  ? StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      axisDirection: AxisDirection.down,
                      children: [
                        for (int i = 0; i < noteProvider.notesList.length; i++)
                          StaggeredGridTile.count(
                            crossAxisCellCount: _tileCounts[i % 7][0],
                            mainAxisCellCount: _tileCounts[i % 7][1],
                            child: NoteTile(
                              index: i,
                              note: noteProvider.notesList[i],
                              tileType: _tileTypes[i % 7],
                            ),
                          ),
                      ],
                    )
                  : Center(
                      child: Text("Empty", style: ThemeHelper.titleTextStyle),
                    );
        }),
      ),
    );
  }
}
