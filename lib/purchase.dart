import 'dart:convert';
import 'package:flutter/material.dart';
import 'add_purchase_row.dart';
import 'globals.dart';

class Purchase extends StatefulWidget {
final Doc doc;

  const Purchase({Key? key, required this.doc}) : super(key: key);

  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  List <TabRow> tabRows = [];
  late TextEditingController _controller;
  int docNumber = 0;
  DateTime docDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    docNumber = int.parse(widget.doc.numDoc);
    if (widget.doc.td != '') {
      var td = jsonDecode(widget.doc.td);
      td.forEach((row){
        tabRows.add(TabRow(row['thing'], row['quantity'], row['price'], row['sum']));
      });
    }
    _controller.text = widget.doc.ka;
    docDate = widget.doc.date;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _addThingRow() async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 400, height: 300,
            child: const AddPurchaseRow(),
          ),
        );
      }
    );
    if (result == null) {
      return;
    }
    int _sum = result['p'] * result['q'];
    TabRow tr = TabRow(result['t'], result['q'], result['p'], _sum);
    setState(() {
      tabRows.add(tr);
    });
  }

  _editThingRow(TabRow element) async {
    print('_editThingName $element');
    var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: 400, height: 300,
            child: AddPurchaseRow(name: element.thing, q: element.quantity, p: element.price),
          ),
        );
      }
    );
    if (result == null) {
      return;
    }
    setState(() {
      element.thing = result['t'];
      element.quantity = result['q'];
      element.price = result['p'];
      element.sum = element.quantity * element.price;
    });
  }

  _delRow(TabRow element) async {
    print('_delRow $element');
    for (int idx=0; idx<tabRows.length; idx++) {
      TabRow tr=tabRows[idx];
      if (tr.thing == element.thing && tr.quantity == element.quantity) {
        setState(() {
          tabRows.removeAt(idx);
        });
        break;
      }
    }
  }

  List <TableRow> otherTableRows(){
    List <TableRow> result = [];
    for (var element in tabRows) {
      result.add(
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: (){
                _editThingRow(element);
              },
              child: Text(element.thing)
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(element.quantity.toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(element.price.toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(element.sum.toString()),
          ),
          IconButton(
            icon: const Icon(Icons.highlight_remove),
            onPressed: (){
              _delRow(element);
            },
          )
        ],)
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Закупка'),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text('док. № $docNumber'),
                const SizedBox(width: 16,),
                TextButton(
                  child: Text(' от ${docDate.day}/${docDate.month}/${docDate.year}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    var newDT = await selectDate(context, docDate);
                    if (newDT == null) {
                      return;
                    }
                    setState(() {
                      docDate = newDT;
                    });
                  },
                )
              ],
            ),
            Row(
              children: [
                const Text('Продавец: '),
                Expanded(
                  child: TextField(
                    controller: _controller,
                  ),
                ),
              ],
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                    shadowColor: Colors.red,
                    elevation: 10,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Новая строка'),
                  onPressed: () async {
                    _addThingRow();
                    /*
                    var res = await Navigator.push(context, MaterialPageRoute(builder:
                        (context) => const AddPurchaseRow()),
                    );
                    if (res == null) {
                      return;
                    }
                    setState(() {
                      tabRows.add(TabRow(res['t'], res['q'], res['p'], res['q']*res['p']));
                    });

                     */
                  },
                ),
              ),
            ]),
            Table(
              border: TableBorder.all(color: Colors.blueAccent, width: 2),
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Товар', textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('К-во'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Цена'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Сумма'),
                    ),
                    Icon(Icons.highlight_remove),
                  ]
                ),
                ...otherTableRows(),
              ],
              columnWidths: const <int, TableColumnWidth> {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(1),
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'ok',
        child: const Text('OK'),
        onPressed: () async {
          if (tabRows.isEmpty) {
            await showAlertPage(context, 'Нет данных');
            return;
          }

          int total = 0;
          for (var element in tabRows) {
            total+=element.sum;
          }
          Doc doc = Doc(date: docDate, numDoc: docNumber.toString(),
              typeDoc: 'z', sum: total, ka: _controller.value.text,
              inf: _controller.value.text,
              td: jsonEncode(tabRows)
          );
          if (docNumerator < docNumber) {
            journal.add(doc);
            docNumerator = docNumber;
            saveLocally('docNumerator', docNumber.toString());
          } else {
            updateJ(doc);
          }
          saveLocally('journal', jsonEncode(journal));
          moveRegs(doc);
          await showAlertPage(context, 'Документ сохранён');
          Navigator.pop(context);
        },
      ),
    );
  }
}
