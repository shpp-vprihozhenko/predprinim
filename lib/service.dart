import 'dart:convert';

import 'package:flutter/material.dart';

import 'globals.dart';
import 'scan_bar_code.dart';
import 't2.dart';
import 'yt.dart';

class Service extends StatelessWidget {
  const Service({Key? key}) : super(key: key);

  _test(){
    Doc doc;
    DateTime dm;
    List <TabRow> tl=[];

    /*
    dm = DateTime.now();
    doc = Doc(date: dm, numDoc: '13', typeDoc: 'p', sum: 10, ka: 'qaw',
        td: jsonEncode(tl),
        inf: 'ok'
    );
    moveRegCash(doc, 10);

    dm = DateTime.now().add(const Duration(days:-1));
    doc = Doc(date: dm, numDoc: '12', typeDoc: 'p', sum: 10, ka: 'qaw',
        td: jsonEncode(tl),
        inf: 'ok'
    );
    moveRegCash(doc, 10);

    dm = DateTime.now().add(const Duration(days:-2));
    doc = Doc(date: dm, numDoc: '11', typeDoc: 'p', sum: 10, ka: 'qaw',
        td: jsonEncode(tl),
        inf: 'ok'
    );
    moveRegCash(doc, 10);

    dm = DateTime.now().add(const Duration(days:-3));
    doc = Doc(date: dm, numDoc: '10', typeDoc: 'p', sum: 10, ka: 'qaw',
        td: jsonEncode(tl),
        inf: 'ok'
    );
    moveRegCash(doc, 10);

    dm = DateTime.now().add(const Duration(days:-4));
    doc = Doc(date: dm, numDoc: '9', typeDoc: 'p', sum: 10, ka: 'qaw',
        td: jsonEncode(tl),
        inf: 'ok'
    );
    moveRegCash(doc, 10);

    dm = DateTime.now().add(const Duration(days:-5));
    doc = Doc(date: dm, numDoc: '8', typeDoc: 'p', sum: 10, ka: 'qaw',
        td: jsonEncode(tl),
        inf: 'ok'
    );
    moveRegCash(doc, 10);

    print('regC $regCash');

     */

    // regThings['лопата'] = {
    //   's': 100,
    //   'q': 10,
    //   'h': {
    //     'z1': {'s':100, 'q':10, 'dt': 1640226959774},
    //   }
    // };
    // regThings['топор'] = {
    //   's': 220,
    //   'q': 22,
    //   'h': {
    //     'z1': {'s': 7, 'q': 1, 'dt': 1640226959774},
    //     'z2': {'s': 7, 'q': 1, 'dt': 1640326959774},
    //     'z3': {'s': 8, 'q': 1, 'dt': 1640426959774},
    //   }
    // };

    tl = [];
    tl.add(TabRow('топор', 1, 10, 10));
    DateTime now = DateTime.now().add(const Duration(days:-7));
    doc = Doc(date: now, numDoc: '1', typeDoc: 'z', sum: 10, ka: 'qaw', td: jsonEncode(tl), inf: 'ok');
    moveRegs(doc);

    tl = [];
    tl.add(TabRow('топор', 1, 10, 10));
    now = DateTime.now().add(const Duration(days:-6));
    doc = Doc(date: now, numDoc: '2', typeDoc: 'z', sum: 10, ka: 'qaw', td: jsonEncode(tl), inf: 'ok');
    moveRegs(doc);

    tl = [];
    tl.add(TabRow('топор', 1, 10, 10));
    //tl.add(TabRow('пила', 3, 30, 90));
    DateTime dm3 = DateTime.now().add(const Duration(days: -5));
    doc = Doc(date: dm3, numDoc: '3', typeDoc: 'z', sum: 10, ka: 'qaw', td: jsonEncode(tl), inf: 'ok');

    moveRegs(doc);

    tl = [];
    tl.add(TabRow('топор', 1, 10, 10));
    dm3 = DateTime.now().add(const Duration(days:-4));
    doc = Doc(date: dm3, numDoc: '4', typeDoc: 'z', sum: 10, ka: 'qaw', td: jsonEncode(tl), inf: 'ok return');
    moveRegs(doc);

    tl = [];
    tl.add(TabRow('топор', 1, 10, 10));
    dm3 = DateTime.now().add(const Duration(days:-3));
    doc = Doc(date: dm3, numDoc: '5', typeDoc: 'z', sum: 10, ka: 'qaw', td: jsonEncode(tl), inf: 'ok return');
    moveRegs(doc);

    tl.add(TabRow('топор', 1, 10, 10));
    dm3 = DateTime.now().add(const Duration(days:-2));
    doc = Doc(date: dm3, numDoc: '6', typeDoc: 'z', sum: 10, ka: 'qaw', td: jsonEncode(tl), inf: 'ok return');
    moveRegs(doc);

    tl.add(TabRow('топор', 1, 10, 10));
    dm = DateTime.now().add(const Duration(days:-1));
    doc = Doc(date: dm, numDoc: '7', typeDoc: 'z', sum: 10, ka: 'qaw', td: jsonEncode(tl), inf: 'ok return');
    moveRegs(doc);
    print('cash $regCash');

    tl = [];
    tl.add(TabRow('топор', 1, 12, 12));
    dm = DateTime.now().add(const Duration(days: 0));
    doc = Doc(date: dm, numDoc: '8', typeDoc: 'p', sum: 12, ka: 'qaw', td: jsonEncode(tl), inf: 'ok return');
    moveRegs(doc);

    print('cash $regCash');
  }

  _regs(){
    print('\nregCash $regCash');
    print('\nregProfit $regProfit');
    print('\nregThings $regThings');
  }

  _clear(){
    Map <String, dynamic> regThingsNew = {};
    regThings = regThingsNew;
    saveLocally('regThings', jsonEncode(regThings));

    Map <String, dynamic> regProfitNew = {
      's': 0,
      'h': {}
    };
    regThings = regThingsNew;
    saveLocally('regProfit', jsonEncode(regThings));

    Map <String, dynamic> regCashNew = {
      's': 0,
      'h': {}
    };
    regCash = regCashNew;
    saveLocally('regCash', jsonEncode(regCash));

    List<Doc> journalNew = [];
    journal = journalNew;
    saveLocally('journal', jsonEncode(journal));

    int docNumerator = 0;
    saveLocally('docNumerator', docNumerator.toString());

    print('\nregCash $regCash');
    print('\nregProfit $regProfit');
    print('\nregThings $regThings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сервис'),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: bStyle,
                child: const Text('регистры'),
                onPressed: _regs,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: bStyle,
                child: const Text('тест. дв. рег.'),
                onPressed: _test,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: bStyle,
                child: const Text('очистка базы'),
                onPressed: _clear,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: bStyle,
                child: const Text('YT test'),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => const YT()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: bStyle,
                child: const Text('test2'),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => const Test2()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: bStyle,
                child: const Text('Сканер ШК'),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => const ScanBarCode()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
