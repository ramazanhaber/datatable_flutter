import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DatatableContent extends StatefulWidget {
  DatatableContent();

  @override
  State<DatatableContent> createState() => _DatatableContentState();
}

class _DatatableContentState extends State<DatatableContent> {
  List<bool> _selected = [];

  List<Map> _books = [
    {'id': 100, 'title': 'Flutter Basics', 'author': 'David John'},
    {'id': 102, 'title': 'Git and GitHub', 'author': 'Merlin Nick'},
    {'id': 101, 'title': 'Flutter Basics', 'author': 'David John'},
  ];

  // Callback when mouse clicked on `Listener` wrapped widget.
  Future<void> onPointerDown(PointerDownEvent event) async {
    // Check if right mouse button clicked
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
      Overlay.of(context)!.context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          context: context,

          items: [
            PopupMenuItem(child: Text('     [SEÇİLENLERİ]     ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),), value: 0),
            PopupMenuItem(child: Text('Copy'), value: 1),
            PopupMenuItem(child: Text('Cut'), value: 2),
          ],
          position: RelativeRect.fromSize(
              event.position & Size(48.0, 48.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
          mesajYaz("kopyalandi copy ");
          break;
        case 2:
          mesajYaz("kesildi cut ");
          break;
        default:
      }
    }}

  void mesajYaz(String text){
    _selected.asMap().forEach((key, value) {
      if(value){
        print(text+"->"+key.toString()+"-> "+value.toString());
      }
    });
  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    document.onContextMenu.listen((event) => event.preventDefault());

    _books.forEach((element) {
      _selected.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Listener(
        onPointerDown: (PointerDownEvent details) {
          onPointerDown(details);
        },

        child: Container(
          child: ListView(
            children: [_createDataTable()],
          ),
        ),
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Book')),
      DataColumn(label: Text('Author')),
      DataColumn(label: Text('Category'))
    ];
  }

  List<DataRow> _createRows() {
    List<DataRow> listem = [];

    _books.asMap().forEach((index, book) {
      var row = DataRow(
          cells: [
            DataCell(Text('#' + book['id'].toString())),
            DataCell(Text(book['title'])),
            DataCell(Text(book['author'])),
            DataCell(FlutterLogo())
          ],
          selected: _selected[index],

          onSelectChanged: (bool? selected) {
            setState(() {
              _selected[index] = selected!;
            });
          }

          );

      listem.add(row);
    });

    return listem;
  }

}
