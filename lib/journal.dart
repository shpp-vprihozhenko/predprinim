import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_money.dart';
import 'globals.dart';
import 'purchase.dart';
import 'sell.dart';

class Journal extends StatefulWidget {
  const Journal({Key? key}) : super(key: key);

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {

  @override
  void initState() {
    super.initState();
  }

  editDoc(_doc){
    print('edit $_doc');
    if (_doc.typeDoc == 'z') {
      Navigator.push(context, MaterialPageRoute(builder:
          (context) => Purchase(doc: _doc)),
      );
    } else if (_doc.typeDoc == 'p') {
      Navigator.push(context, MaterialPageRoute(builder:
          (context) => Sell(doc: _doc)),
      );
    } else if (_doc.typeDoc == 'a') {
      Navigator.push(context, MaterialPageRoute(builder:
          (context) => AddMoney(doc: _doc)),
      );
    } else if (_doc.typeDoc == 'b') {
      Navigator.push(context, MaterialPageRoute(builder:
          (context) => AddMoney(doc: _doc)),
      );
    }

  }

  otherRows(){
    List <TableRow> res = [];
    for (var element in journal) {
      DateTime date = element.date;
      String sd = '${date.day}/${date.month}/${date.year-2000}';
      String dts = rusTypeDoc(element.typeDoc);
      res.add(TableRow(
        children: [
          TextButton(
              onPressed: (){ editDoc(element); },
              child: Text(sd)
          ),
          TextButton(
            onPressed: (){ editDoc(element); },
            child: Text(dts+' №'+element.numDoc.toString())
          ),
          TextButton(
              onPressed: (){ editDoc(element); },
              child: Text(element.sum.toString())
          ),
          TextButton(
              onPressed: (){ editDoc(element); },
              child: Text(element.inf)
          ),
        ]
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Журнал'),),
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Table(
                border: TableBorder.all(color: Colors.blueAccent, width: 2),
                children: [
                  const TableRow(
                      children: [
                        Text('Дата'),
                        Text('Док №'),
                        Text('Сумма'),
                        Text('Инф.'),
                      ]
                  ),
                  ...otherRows()
                ],
              columnWidths: const <int, TableColumnWidth> {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
            )
          ],
        ),
      ),
    );
  }
}
