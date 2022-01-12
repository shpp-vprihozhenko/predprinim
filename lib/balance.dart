import 'package:flutter/material.dart';

import 'globals.dart';

class RepBalance extends StatefulWidget {
  const RepBalance({Key? key}) : super(key: key);

  @override
  _RepBalanceState createState() => _RepBalanceState();
}

class _RepBalanceState extends State<RepBalance> {
  int tSum=0, cSum=0, pSum=0;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();
    pSum = regProfit['s'];
    cSum = regCash['s'];
    tSum = countTSum();
    toDate = DateTime.now();
  }

  countTSum(){
    int sum=0;
    regThings.forEach((key, value) {
      int s = value['s'];
      sum += s;
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Баланс'),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Сумма в кассе $cSum грн.', textScaleFactor: 1.4,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Сумма в товаре $tSum грн.', textScaleFactor: 1.4,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Итого активы ${cSum+tSum} грн.', textScaleFactor: 1.4,),
                ],
              ),
            ),
            const Divider(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Текущая прибыль $pSum грн.', textScaleFactor: 1.4,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
