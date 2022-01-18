import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map <String, dynamic> regCash = {
  's': 0,
  'h': {}
};

moveRegCash(Doc doc, int sum){
  String docKey = doc.typeDoc+doc.numDoc;
  int dt = doc.date.millisecondsSinceEpoch;
  var newRec = {
    's': sum,
    'dt': dt
  };
  var h = regCash['h'];
  var curRec = h[docKey];
  if (curRec == null) {
    h[docKey] = {'s':sum, 'dt':dt};
    regCash['s'] += sum;
  } else {
    int cs = curRec['s'];
    int ds = sum - cs;
    h[docKey] = newRec;
    regCash['s'] += ds;
  }
  saveLocally('regCash', jsonEncode(regCash));
}

Map <String, dynamic> regProfit = {
  's': 0,
  'h': {}
};

moveRegProfit(Doc doc, int sum){
  String docKey = doc.typeDoc+doc.numDoc;
  int dt = doc.date.millisecondsSinceEpoch;
  var newRec = {
    's': sum,
    'dt': dt
  };
  var h = regProfit['h'];
  var curRec = h[docKey];
  if (curRec == null) {
    h[docKey] = {'s':sum, 'dt':dt};
    regProfit['s'] += sum;
  } else {
    int cs = curRec['s'];
    int ds = sum - cs;
    h[docKey] = newRec;
    regProfit['s'] += ds;
  }
  saveLocally('regProfit', jsonEncode(regProfit));
}

Map <String, dynamic> regThings = {};

double defineCost(thingName, docKey) {
  double result = 0;
  var tr = regThings[thingName];
  if (tr == null) {
    print('no regThings for $thingName');
    return 0;
  }
  var h = tr['h'];
  var docMoves = h[docKey];
  print('docMoves $docMoves');
  int docQ = 0;
  int docS = 0;
  if (docMoves != null) {
    docQ = docMoves['q'];
    docS = docMoves['s'];
  }
  int rs = tr['s'];
  int rq = tr['q'];
  result = (rs+docS) / (rq+docQ);
  print('found sebEd $result for $thingName rs $rs rq $rq docS $docS docQ $docQ');
  return result;
}

moveRegs(Doc doc) {
  String docKey = doc.typeDoc+doc.numDoc;
  int dt = doc.date.millisecondsSinceEpoch;
  int sum = doc.sum;
  if (doc.typeDoc == 'p') {
    moveRegCash(doc, sum);
  } else if (doc.typeDoc == 'z') {
    moveRegCash(doc, -sum);
  } else if (doc.typeDoc == 'a') {
    moveRegCash(doc, sum);
    return;
  } else if (doc.typeDoc == 'b') {
    moveRegCash(doc, -sum);
    return;
  }
  int costSum = 0;
  var td = jsonDecode(doc.td);
  print('doc $doc');
  for (int idx=0; idx<td.length; idx++){
    var row = td[idx];
    String thingName = row['thing'];
    int s = row['sum'];
    int q = row['quantity'];
    print('thingName $thingName q $q s $s');
    if (doc.typeDoc == 'p') {
      s = -(defineCost(thingName, docKey)*q).toInt();
      q = -q;
      costSum += s;
    }
    var newRec = {
      's': s,
      'q': q,
      'dt': dt
    };
    var rt = regThings[thingName];
    if (rt == null) {
      regThings[thingName] = {
        'q': q,
        's': s,
        'h': {
          docKey: newRec
        }
      };
    } else {
      var h = rt['h'];
      var curRec = h[docKey];
      if (curRec == null) {
        h[docKey] = {'s':s, 'q':q, 'dt':dt};
        rt['q'] += q;
        rt['s'] += s;
      } else {
        int cq = curRec['q'];
        int cs = curRec['s'];
        int dq = q - cq;
        int ds = s - cs;
        h[docKey] = newRec;
        rt['q'] += dq;
        rt['s'] += ds;
      }
    }
  }
  if (doc.typeDoc == 'p') {
    print('costSum $costSum');
    int profit = doc.sum + costSum;
    moveRegProfit(doc, profit);
  }
  saveLocally('regThings', jsonEncode(regThings));
}

Map <String, dynamic> getRegs(String thingName, DateTime onDT){
  var rt = regThings[thingName];
  var history = rt['h'];
  int sPlus=0, sMinus=0, qPlus=0, qMinus=0;
  history.forEach((k, ev){
    var dt = DateTime.fromMillisecondsSinceEpoch(ev['dt']+1);
    if (dt.isAfter(onDT)) {
      int q = ev['q'];
      int s = ev['s'];
      if (ev['q'] > 0) {
        sPlus += s;
        qPlus += q;
      } else {
        sMinus += s;
        qMinus += q;
      }
    }
  });
  var result = {
    'q': rt['q'] - qPlus + qMinus,
    's': rt['s'] - sPlus + sMinus
  };
  return result;
}

List<Doc> journal = [];

int docNumerator = 0;

List <String> refThings = [];


class Doc {
  DateTime date;
  String numDoc;
  String typeDoc;
  int sum;
  String ka, td, inf;

  Doc({DateTime? date, this.numDoc='', this.typeDoc='', this.sum=0,
    this.ka='', this.td='', this.inf=''}
  ) : date = date ?? DateTime.now();

  factory Doc.fromJson(Map<String, dynamic> json) {
    return Doc(
      date: DateTime.parse(json['date']),
      numDoc: json['numDoc'],
      typeDoc: json['typeDoc'],
      sum: json['sum'],
      ka: json['ka'],
      td: json['td'],
      inf: json['inf']
    );
  }


  Map<String, dynamic> toJson() => {
    'date': date.toString(),
    'numDoc': numDoc,
    'typeDoc': typeDoc,
    'sum': sum,
    'ka': ka,
    'td': td,
    'inf': inf,
  };

  @override
  String toString() {
    return 'd $date nd $numDoc t $typeDoc s $sum ka $ka td $td inf $inf';
  }
}

class TabRow {
  String thing = '';
  int quantity = 0;
  int price = 0;
  int sum = 0;

  TabRow(this.thing, this.quantity, this.price, this.sum);

  TabRow.fromJson(Map<String, dynamic> json)
      : thing = json['thing'],
        quantity = json['quantity'],
        price = json['price'],
        sum = json['sum'];

  Map<String, dynamic> toJson() => {
    'thing': thing,
    'quantity': quantity,
    'price': price,
    'sum': sum,
  };

  @override
  String toString() {
    return 'thing $thing q $quantity p $price s $sum';
  }
}

showAlertPage(context, String msg) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(msg),
        );
      }
  );
}

selectDate(BuildContext context, DateTime iniDate) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: iniDate, // Refer step 1
    firstDate: DateTime(2021),
    lastDate: DateTime(2025),
    locale : const Locale("ru","RU"),
  );
  return picked;
}

saveLocally(String key, String data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);
}

restoreLocally(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var s = prefs.getString(key);
  return s ?? '';
}

ButtonStyle bStyle = OutlinedButton.styleFrom(
  primary: Colors.white,
  backgroundColor: Colors.teal,
  shadowColor: Colors.red,
  elevation: 10,
);
ButtonStyle iStyle = OutlinedButton.styleFrom(
  //primary: Colors.white,
  //backgroundColor: Colors.white,
  shadowColor: Colors.black,
  elevation: 10,
);

updateJ(Doc doc) {
  for (int idx=0; idx<journal.length; idx++) {
    Doc el = journal[idx];
    if (doc.numDoc == el.numDoc) {
      journal[idx] = doc;
      print('journal updated');
      return;
    }
  }
  print('journal NOT updated');
}

Doc? findDocByNumberAndType(String numDoc, String typeDoc) {
  for (int idx=0; idx<journal.length; idx++) {
    Doc el = journal[idx];
    if (numDoc == el.numDoc && typeDoc == el.typeDoc) {
      return el;
    }
  }
  return null;
}

String rusTypeDoc(String docLetter) {
  String typeDoc='';
  if (docLetter == 'a') {
    typeDoc = 'Внесение денег';
  } else if (docLetter == 'b') {
    typeDoc = 'Изъятие денег';
  } else if (docLetter == 'p') {
    typeDoc = 'Продажа';
  } else if (docLetter == 'z') {
    typeDoc = 'Закупка';
  }
  return typeDoc;
}
