import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        brightness: Brightness.dark,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreemState();
}

class _MainScreemState extends State<MainScreen> {
  final List<XFile> _files = [];
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void onDragDone(DropDoneDetails detail) {
    setState(() {
      _files.addAll(detail.files);
    });
  }

  void onDragEntered(details) => setState(() => isDraggedIn = true);
  void onDragExited(details) => setState(() => isDraggedIn = false);
  bool isDraggedIn = false;
  final myDelegate = const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 200,
    childAspectRatio: 0.707,
    crossAxisSpacing: 5,
    mainAxisSpacing: 5,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ReorderableGridView.builder(
          onReorder: (oldIndex, newIndex) {
            final oldWidget = _files.removeAt(oldIndex);
            _files.insert(newIndex, oldWidget);
            setState(() {});
          },
          gridDelegate: myDelegate,
          itemCount: _files.length + 1,
          itemBuilder: (context, index) {
            if (index == _files.length) {
              return DropTarget(
                key: ValueKey(index),
                onDragEntered: onDragEntered,
                onDragExited: onDragExited,
                onDragDone: onDragDone,
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: isDraggedIn
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Icon(Icons.add, size: isDraggedIn ? 60 : 40))),
              );
            }
            return Container(
              key: ValueKey(index),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(children: [
                Image.file(
                  File(_files[index].path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer),
                      child: Text((index + 1).toString()),
                    )),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton.filled(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => setState(() {
                            _files.removeAt(index);
                          }),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
                )
              ]),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.settings),
            onPressed: () {},
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            child: const Icon(Icons.output),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
