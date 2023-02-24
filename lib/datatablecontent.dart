import 'dart:html' as html;
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
  List<Map> _booksFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  List<Map> _books = [
    {'id': 100, 'title': 'Ramazan HABER', 'author': 'Kimlik'},
    {'id': 102, 'title': 'Fatih Çoban', 'author': 'Pasaport'},
    {'id': 101, 'title': 'Emre Tek', 'author': 'Dekont'},
    {'id': 103, 'title': 'Flutter Basics3', 'author': 'Mahsup Fiş'},
    {'id': 104, 'title': 'Flutter Basics4', 'author': 'Register Card'},
    {'id': 105, 'title': 'Flutter Basics5', 'author': 'Rezervasyon Formu'},
    {'id': 106, 'title': 'Flutter Basics6', 'author': 'Folio'},
    {'id': 107, 'title': 'Flutter Basics7', 'author': 'Voucher'},
    {'id': 108, 'title': 'Flutter Basics8', 'author': 'Fatura'},
    {'id': 109, 'title': 'Flutter Basics9', 'author': 'Tesellüm'},
    {'id': 110, 'title': 'Flutter Basics10', 'author': 'Teklif Formu'},
    {'id': 120, 'title': 'Flutter Basics11', 'author': 'Sipariş Formu'},
    {'id': 121, 'title': 'Flutter Basics12', 'author': 'Diğer'},
    {'id': 122, 'title': 'Flutter Basics13', 'author': 'Özel'},
    {'id': 123, 'title': 'Flutter Basics14', 'author': 'İkametgah'},
    {'id': 124, 'title': 'Flutter Basics15', 'author': 'Vesikalık Fotoğraf'},
    {'id': 125, 'title': 'Flutter Basics16', 'author': 'Aile Durum Bildirim Formu'},
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
            PopupMenuItem(
                child: Text(
                  '     [SEÇİLENLERİ]     ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                value: 0),
            PopupMenuItem(child: Text('Arşivle'), value: 1),
            PopupMenuItem(child: Text('Taslakla'), value: 2),
            PopupMenuItem(child: Text('Sil'), value: 3),
            PopupMenuItem(child: Text('Mail Gönder'), value: 4),
          ],
          position: RelativeRect.fromSize(
              event.position & Size(48.0, 48.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
          mesajYaz("Arşivle");
          break;
        case 2:
          mesajYaz("Taslakla");
          break;
        case 3:
          mesajYaz("Sil");
          break;
        case 4:
          mesajYaz("Mail Gönder");
          break;
        default:
      }
    }
  }

  void mesajYaz(String text) {
    _selected.asMap().forEach((key, value) {
      if (value) {
        print(text + "->" + key.toString() + "-> " + value.toString()+"-> "+_booksFiltered[key]["title"].toString());
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

    _booksFiltered = _books;
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
              children: [searchWidget(), _createDataTable()],
            ),
          ),
        ),
      ),
    );
  }

  String getTurkish(String text) {
    text = text.toLowerCase().replaceAll("i̇", "i"); // buradaki iki i farklıdır
    text = text.replaceAll("ç", "c");
    text = text.replaceAll("ğ", "g");
    text = text.replaceAll("ı", "i");
    text = text.replaceAll("ö", "o");
    text = text.replaceAll("ş", "s");
    text = text.replaceAll("ü", "u");
    return text;
  }

  Widget searchWidget() {
    return Card(
      child: new ListTile(
        leading: new Icon(Icons.search),
        title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'Search', border: InputBorder.none),
            onChanged: (value) {
              setState(() {
                _searchResult = getTurkish(value);

                _booksFiltered = _books
                    .where((user) =>
                getTurkish(user["title"].toString())
                    .contains(_searchResult) ||
                    getTurkish(user["author"].toString())
                        .contains(_searchResult))
                    .toList();

              });
            }),
        trailing: new IconButton(
          icon: new Icon(Icons.cancel),
          onPressed: () {
            setState(() {
              controller.clear();
              _searchResult = '';
              _booksFiltered = _books;
            });
          },
        ),
      ),
    );
  }

  int _currentSortColumn = 0;
  bool _isAscending = true;

  Widget _createDataTable() {
    return DataTable(
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isAscending,
        columns: _createColumns(),
        rows: _createRows());
  }


  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: Text('ID'),

        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isAscending == true) {
              _isAscending = false;
              // sort the product list in Ascending, order by Price
              _booksFiltered.sort((productA, productB) =>
                  productB['id'].compareTo(productA['id']));
            } else {
              _isAscending = true;
              // sort the product list in Descending, order by Price
              _booksFiltered.sort((productA, productB) =>
                  productA['id'].compareTo(productB['id']));
            }
          });
        },
      ),
      DataColumn(label: Expanded(child: Text('Dosya Adı'))),
      DataColumn(label: Expanded(child: Text('Belge Tipi'))),
      DataColumn(label: Expanded(child: Text('Oluşturma Tarihi'))),
      DataColumn(label: Expanded(child: Text('Dosya Uzantisi'))),
      DataColumn(label: Expanded(child: Text(''))),
      DataColumn(label: Expanded(child: Text(''))),
    ];
  }



  List<DataRow> _createRows() {
    List<DataRow> listem = [];

    _booksFiltered.asMap().forEach((index, book) {
      var row = DataRow(
          cells: [
            DataCell(Text('#' + book['id'].toString())),
            DataCell(Text(book['title'])),
            DataCell(Text(book['author'])),
            DataCell(Text("2023-05-05")),
            DataCell(Text(".pdf")),
            DataCell(
                Tooltip(
                  message: "İndir",
                  child: ElevatedButton(
                    onPressed: () {
                      mesajYaz(book['title'].toString()+" indirildi");

                    },
                    child:  Icon(Icons.download_rounded),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                )
            ),
            DataCell(
                Tooltip(
                  message: "Görüntüle",
                  child: ElevatedButton(
                    onPressed: () {
                      mesajYaz(book['title'].toString()+" görüntülendi");
                    },
                    child:  Icon(Icons.remove_red_eye_sharp),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                )

            ),
          ],
          selected: _selected[index],
          onSelectChanged: (bool? selected) {
            setState(() {
              _selected[index] = selected!;
            });
          });

      listem.add(row);
    });

    return listem;
  }
}
