import 'package:flutter/material.dart';

import 'globals.dart';
import 'purchase.dart';
import 'sell.dart';

class RepThingsDetails extends StatefulWidget {
  final String thing;
  final DateTime fromDate, toDate;

  const RepThingsDetails({Key? key, required this.thing, required this.fromDate, required this.toDate}) : super(key: key);

  @override
  _RepThingsDetailsState createState() => _RepThingsDetailsState();
}

class _RepThingsDetailsState extends State<RepThingsDetails> {
  late DateTime fromDate, toDate;
  List <Map <String, dynamic>> repHistory = [];
  int sFrom=0, sTo=0, qFrom=0, qTo=0;

  @override
  void initState() {
    super.initState();
    fromDate = widget.fromDate;
    toDate = widget.toDate;
    _formReport();
  }

  _formReport(){
    fromDate = DateTime(fromDate.year, fromDate.month, fromDate.day);
    toDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime(toDate.year, toDate.month, toDate.day)
            .add(const Duration(days: 1))
            .millisecondsSinceEpoch-1
    );
    print('_formReport $fromDate - $toDate');
    var th = regThings[widget.thing];
    print('th $th');
    int sNow = th['s'];
    int qNow = th['q'];
    var h = th['h'];
    print('h $h');
    repHistory = [];
    int sPlusFrom=0, sMinusFrom=0;
    int sPlusTo=0, sMinusTo=0;
    int qPlusFrom=0, qMinusFrom=0;
    int qPlusTo=0, qMinusTo=0;
    h.forEach((k, ev){
      var dt = DateTime.fromMillisecondsSinceEpoch(ev['dt']+1);
      if (dt.isAfter(fromDate) && dt.isBefore(toDate)) {
        var record = {
          'docKey': k,
          'q': ev['q'],
          's': ev['s'],
          'dt': ev['dt']
        };
        repHistory.add(record);
      }
      int s = ev['s'];
      int q = ev['q'];
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
    setState(() {
      sFrom = sNow - sPlusFrom + sMinusFrom;
      sTo = sNow - sPlusTo + sMinusTo;
      qFrom = qNow - qPlusFrom + qMinusFrom;
      qTo = qNow - qPlusTo + qMinusTo;
    });
    print('repHistory $repHistory');
  }

  _showDoc(el){
    String docKey = el['docKey'];
    print('show doc $el docKey $docKey');
    String numDoc = docKey.substring(1);
    String typeDoc = docKey.substring(0,1);
    Doc? doc = findDocByNumberAndType(numDoc, typeDoc);
    if (doc == null) {
      print('err. doc not found');
      return;
    }
    print('found doc $doc');
    _editDoc(doc);
  }

  _editDoc(_doc){
    print('edit $_doc');
    if (_doc.typeDoc == 'z') {
      Navigator.push(context, MaterialPageRoute(builder:
          (context) => Purchase(doc: _doc)),
      );
    } else if (_doc.typeDoc == 'p') {
      Navigator.push(context, MaterialPageRoute(builder:
          (context) => Sell(doc: _doc)),
      );
    }
  }

  List<TableRow> otherTableRows(){
    List<TableRow> result = [];
    for (var el in repHistory) {
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(el['dt']);
      String dts = '${dt.day}/${dt.month}/${dt.year-2000}';
      String docs = el['docKey'];
      String docLetter = docs.substring(0,1);
      String docNumber = docs.substring(1);
      String typeDoc = rusTypeDoc(docLetter);
      docs = typeDoc+' №'+docNumber;
      result.add(
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: (){
                  _showDoc(el);
                },
                child: Text(dts),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: (){
                    _showDoc(el);
                  },
                  child: Text(el['s'].toString())
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: (){
                    _showDoc(el);
                  },
                  child: Text(el['q'].toString())
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: (){
                    _showDoc(el);
                  },
                  child: Text(docs)
              ),
            ),
          ],)
      );
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.thing),),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('отчёт с'),
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
                Row(
                  children: [
                    Text('Остаток на начало: $sFrom / $qFrom'),
                  ],
                ),
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
                            child: Text('Дата', textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Сумма', textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Количество', textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Документ', textAlign: TextAlign.center,),
                          ),
                        ]
                    ),
                    ...otherTableRows(),
                  ],
                  columnWidths: const <int, TableColumnWidth> {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(4),
                  },
                ),
                Row(
                  children: [
                    Text('Остаток на конец: $sTo / $qTo'),
                  ],
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}
