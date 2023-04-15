import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/app_theme.dart';
import '../../domain/entities/note_entity.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            /* Get.to(
              const AddNotePage(
                note: null,
              ),
              transition: Transition.downToUp,
            ); */
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
            onTap: () {},
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
      child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          axisDirection: AxisDirection.down,
          children: [
            for (int i = 0; i < Note.noteList.length; i++)
              StaggeredGridTile.count(
                  crossAxisCellCount: _tileCounts[i % 7][0],
                  mainAxisCellCount: _tileCounts[i % 7][1],
                  child: NoteTile(
                    index: i,
                    note: Note.noteList[i],
                    tileType: _tileTypes[i % 7],
                  ))
          ]),
      // itemCount: _notesController.noteList.length,
      // itemBuilder: (context, index)
      // {
      //   return NoteTile(
      //     tileType: _tileTypes[index % 7],
      //     note: _notesController.noteList[index],
      //   );
      // },
      // StaggeredGridTileBuilder: (int index) => _tileCounts[index % 7]);

      // return StaggeredGridView.count(
      //   crossAxisCount: 4,
      //   StaggeredGridTiles: _StaggeredGridTiles,
      //   mainAxisSpacing: 12,
      //   crossAxisSpacing: 12,
      //   children: _notesController.noteList
      //       .map((n) => NoteTile(
      //             note: n,
      //           ))
      //       .toList(),
      // );

      // ListView.builder(
      //     itemCount: _notesController.noteList.length,
      //     itemBuilder: (context, index) {
      //       return NoteTile(
      //         note: _notesController.noteList[index],
      //       );
      //     });

      /* Obx(() {
        if (_notesController.noteList.isNotEmpty) {
          return 
        } else {
          return Center(
            child: Text("Empty", style: ThemeHelper.titleTextStyle),
          );
        }
      }), */
    ));
  }
}
