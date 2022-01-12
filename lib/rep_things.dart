import 'package:flutter/material.dart';
import 'package:test/rep_things_details.dart';
import 'add_money.dart';
import 'globals.dart';
import 'purchase.dart';
import 'sell.dart';

class RepThings extends StatefulWidget {
  const RepThings({Key? key}) : super(key: key);

  @override
  _RepThingsState createState() => _RepThingsState();
}

class _RepThingsState extends State<RepThings> {
  late DateTime fromDate, toDate;
  List <Map <String, dynamic>> repThings = [];
  List <Map <String, dynamic>> repHistory = [];

  @override
  void initState() {
    super.initState();
    fromDate = DateTime.now();
    toDate = fromDate;
    _formReport();
  }

  _formReport(){
    fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day);
    toDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime(toDate.year, toDate.month, toDate.day)
            .add(const Duration(days: 1))
            .millisecondsSinceEpoch-1
    );
    print('dates -$fromDate - $toDate');

    repThings = [];
    regThings.forEach((thingName, dataObj) {
      int qNow = dataObj['q'];
      int sNow = dataObj['s'];
      var h = dataObj['h'];
      print('thingName $thingName h $h');
      repHistory = [];
      int sPlusFrom=0, sMinusFrom=0, qPlusFrom=0, qMinusFrom=0;
      int sPlusTo=0, sMinusTo=0, qPlusTo=0, qMinusTo=0;
      h.forEach((k, ev){
        var dt = DateTime.fromMillisecondsSinceEpoch(ev['dt']+1);
        int s = ev['s'];
        int q = ev['q'];
        print('$k dt $dt s $s q $q');
        if (dt.isAfter(fromDate)) {
          if (q > 0) {
            sPlusFrom += s;
            qPlusFrom += q;
          } else {
            sMinusFrom -= s;
            qMinusFrom -= q;
          }
        }
        if (dt.isAfter(toDate)) {
          if (q > 0) {
            sPlusTo += s;
            qPlusTo += q;
          } else {
            sMinusTo -= s;
            qMinusTo -= q;
          }
        }
      });
      int qFrom = qNow - qPlusFrom + qMinusFrom;
      int sFrom = sNow - sPlusFrom + sMinusFrom;
      int qTo = qNow - qPlusTo + qMinusTo;
      int sTo = sNow - sPlusTo + sMinusTo;
      var repObj = {
        'name': thingName,
        'qFrom': qFrom,
        'sFrom': sFrom,
        'qTo': qTo,
        'sTo': sTo,
        'qPlus': qPlusFrom - qPlusTo,
        'qMinus': qMinusFrom - qMinusTo,
        'sPlus': sPlusFrom - sPlusTo,
        'sMinus': sMinusFrom - sMinusTo,
      };
      repThings.add(repObj);
    });
    setState(() {});
    print('repThings $repThings');
  }

  _showDoc(el){
    print('el $el');
    Navigator.push(context, MaterialPageRoute(builder:
        (context) => RepThingsDetails(thing: el['name'], fromDate: fromDate, toDate: toDate,)),
    );
  }

  List<TableRow> otherTableRows(){
    List<TableRow> result = [];
    for (var el in repThings) {
      result.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: (){
                  _showDoc(el);
                },
                child: Text(el['name']),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: (){
                    _showDoc(el);
                  },
                  child: Column(
                    children: [
                      Text(el['sFrom'].toString()),
                      Text(el['qFrom'].toString()),
                    ],
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: (){
                    _showDoc(el);
                  },
                  child: Column(
                    children: [
                      Text(el['sPlus'].toString()),
                      Text(el['qPlus'].toString()),
                    ],
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: (){
                    _showDoc(el);
                  },
                  child: Column(
                    children: [
                      Text(el['sMinus'].toString()),
                      Text(el['qMinus'].toString()),
                    ],
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: (){
                    _showDoc(el);
                  },
                  child: Column(
                    children: [
                      Text(el['sTo'].toString()),
                      Text(el['qTo'].toString()),
                    ],
                  )
              ),
            ),
          ],
        )
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Товар'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Оборотка по товару', textScaleFactor: 1.4,),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('за период с'),
                TextButton(
                  child: Text('${fromDate.day}/${fromDate.month}/${fromDate.year-2000}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    var newDT = await selectDate(context, fromDate);
                    if (newDT == null) {
                      return;
                    }
                    setState(() {
                      fromDate = newDT;
                    });
                  },
                ),
                const Text('по'),
                TextButton(
                  child: Text('${toDate.day}/${toDate.month}/${toDate.year-2000}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    var newDT = await selectDate(context, toDate);
                    if (newDT == null) {
                      return;
                    }
                    setState(() {
                      toDate = newDT;
                    });
                  },
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        shadowColor: Colors.red,
                        elevation: 10,
                      ),
                      icon: const Icon(Icons.login),
                      label: const Text('Сформировать'),
                      onPressed: _formReport,
                    ),
                  ),
                ]
            ),
            Expanded(child:
              ListView(
                children: [
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
                              child: Text('Нач.', textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('+', textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('-', textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Кон.', textAlign: TextAlign.center),
                            ),
                          ]
                      ),
                      ...otherTableRows(),
                    ],
                    columnWidths: const <int, TableColumnWidth> {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(2),
                    },
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
