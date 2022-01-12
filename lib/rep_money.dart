import 'package:flutter/material.dart';
import 'add_money.dart';
import 'globals.dart';
import 'purchase.dart';
import 'sell.dart';

class RepMoney extends StatefulWidget {
  const RepMoney({Key? key}) : super(key: key);

  @override
  _RepMoneyState createState() => _RepMoneyState();
}

class _RepMoneyState extends State<RepMoney> {
  int sumOnHand = 0;
  late DateTime fromDate, toDate;
  int sumFrom=0, sumTo=0;
  List <Map <String, dynamic>> repHistory = [];

  @override
  void initState() {
    super.initState();
    sumOnHand = regCash['s'];
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
    print('_formReport $fromDate - $toDate');
    var h = regCash['h'];
    print(h);
    repHistory = [];
    int sPlusFrom=0, sMinusFrom=0;
    int sPlusTo=0, sMinusTo=0;
    h.forEach((k, ev){
      var dt = DateTime.fromMillisecondsSinceEpoch(ev['dt']+1);
      if (dt.isAfter(fromDate) && dt.isBefore(toDate)) {
        var record = {
          'docKey': k,
          's': ev['s'],
          'dt': ev['dt']
        };
        repHistory.add(record);
      }
      if (dt.isAfter(fromDate)) {
        int s = ev['s'];
        if (s > 0) {
          sPlusFrom += s;
        } else {
          sMinusFrom += s;
        }
      }
      if (dt.isAfter(toDate)) {
        int s = ev['s'];
        if (s > 0) {
          sPlusTo += s;
        } else {
          sMinusTo += s;
        }
      }
    });
    setState(() {
      sumFrom = sumOnHand - sPlusFrom + sMinusFrom;
      sumTo = sumOnHand - sPlusTo + sMinusTo;
    });
    print('sumFrom $sumFrom sumTo $sumTo');
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
      appBar: AppBar(title: const Text('Деньги'),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Сейчас в кассе $sumOnHand грн.', textScaleFactor: 1.4,),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Отчёт с'),
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
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: ListView(
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
                              child: Text('Дата', textAlign: TextAlign.center,),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Сумма'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Документ'),
                            ),
                          ]
                      ),
                      ...otherTableRows(),
                    ],
                    columnWidths: const <int, TableColumnWidth> {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(4),
                    },
                  )

                ],

              ),
            )
          )
        ],
      ),
    );
  }
}

