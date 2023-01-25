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
    {'id': 103, 'title': 'Flutter Basics3', 'author': 'David John3'},
    {'id': 104, 'title': 'Flutter Basics4', 'author': 'David John4'},
    {'id': 105, 'title': 'Flutter Basics5', 'author': 'David John5'},
    {'id': 106, 'title': 'Flutter Basics6', 'author': 'David John6'},
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

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(text),
    ));
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
    return Scaffold(
      body: Material(
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
      ),
    );
  }

  int _currentSortColumn = 0;
  bool _isAscending = true;

  DataTable _createDataTable() {
    return DataTable(
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isAscending,
        columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('ID'),
          onSort: (columnIndex, _) {
            setState(() {
              _currentSortColumn = columnIndex;
              if (_isAscending == true) {
                _isAscending = false;
                // sort the product list in Ascending, order by Price
                _books.sort((productA, productB) =>
                    productB['id'].compareTo(productA['id']));
              } else {
                _isAscending = true;
                // sort the product list in Descending, order by Price
                _books.sort((productA, productB) =>
                    productA['id'].compareTo(productB['id']));
              }
            });
          },

      ),
      DataColumn(label: Text('Book')),
      DataColumn(label: Text('Author')),
      DataColumn(label: Text('Category')),
      DataColumn(label: Text('SİL'))
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
            DataCell(FlutterLogo()),
            DataCell(ElevatedButton(onPressed: () {
              mesajYaz( book['id'].toString());
            },child: Text("SİL"),)),
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
