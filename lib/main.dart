import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test/balance.dart';
import 'YT.dart';
import 'add_money.dart';
import 'journal.dart';
import 'purchase.dart';
import 'rep_money.dart';
import 'rep_profit.dart';
import 'rep_things.dart';
import 'sell.dart';
import 'globals.dart';
import 'service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Предприниматель',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('ru'),
        Locale('ua'),
      ],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    restoreSavedData();
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  restoreSavedData() async {
    String rc = await restoreLocally('regCash');
    if (rc != '') {
      try {
        regCash = jsonDecode(rc);
        print('got rc $rc');
      } catch (e) {
        print('err on regCash restore $e');
      }
    }

    String rp = await restoreLocally('regProfit');
    if (rp != '') {
      try {
        regProfit = jsonDecode(rp);
        print('got rp $rp');
      } catch (e) {
        print('err on regProfit restore $e');
      }
    }

    String rt = await restoreLocally('regThings');
    if (rt != '') {
      try {
        regThings = jsonDecode(rt);
        print('got rt $regThings');
      } catch (e) {
        print('err on regThings restore $e');
      }
    }

    String dn = await restoreLocally('docNumerator');
    if (dn != '') {
      docNumerator = int.parse(dn);
    }

    String j = await restoreLocally('journal');
    if (j == '') {
      print('no saved data');
      return;
    }
    print('restored j1 $j');
    try {
      var jl = jsonDecode(j);
      journal = [];
      for (var el in jl) {
        Doc d = Doc.fromJson(el);
        journal.add(d);
      }
    } catch(e) {
      print('some err on restore journal $e');
    }
  }

  _serv(){
    Navigator.push(context, MaterialPageRoute(builder:
        (context) => const Service()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Предприниматель'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/olegBG.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Приходы товара'),
                  onPressed: (){
                    Doc doc = Doc(date: DateTime.now(),
                      numDoc: (docNumerator+1).toString(), typeDoc: 'z'
                    );
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => Purchase(doc: doc)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Продажа товара'),
                  onPressed: (){
                    Doc doc = Doc(date: DateTime.now(),
                        numDoc: (docNumerator+1).toString(), typeDoc: 'z'
                    );
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => Sell(doc: doc)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Внесение денег'),
                  onPressed: (){
                    Doc doc = Doc(date: DateTime.now(), numDoc: (docNumerator+1).toString(),
                        typeDoc: 'a', sum: 0, ka: '', inf: '', td: ''
                    );
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => AddMoney(doc: doc,)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Изьятие денег'),
                  onPressed: (){
                    Doc doc = Doc(date: DateTime.now(), numDoc: (docNumerator+1).toString(),
                        typeDoc: 'b', sum: 0, ka: '', inf: '', td: ''
                    );
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => AddMoney(doc: doc,)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Журнал'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => const Journal()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Отчёты'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => const Reports()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Сервис'),
                  onPressed: _serv,
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );  }

}

class Reports extends StatelessWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Отчёты'),),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/olegBG.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Движение денег'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => const RepMoney()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Движение товара'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => const RepThings()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Прибыль'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => const RepProfit()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: bStyle,
                  child: const Text('Баланс'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => const RepBalance()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
отч.
движение денег
движение товара
прибыль
баланс
 */