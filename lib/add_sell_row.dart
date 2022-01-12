import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart';

class AddSellRow extends StatefulWidget {
  final List <Map <String, dynamic>> thingsToSell;
  final String name;
  final int q, p;

  const AddSellRow({Key? key, required this.thingsToSell, this.name='', this.q=0, this.p=0}) : super(key: key);

  @override
  _AddSellRowState createState() => _AddSellRowState();
}

class _AddSellRowState extends State<AddSellRow> {
  late TextEditingController _tec1, _tec2, _tec3;
  List <String> things = [];
  String selectedThing = '';

  @override
  void initState() {
    super.initState();
    _tec1 = TextEditingController();
    _tec2 = TextEditingController();
    _tec3 = TextEditingController();
    _tec2.text = widget.q.toString();
    _tec3.text = widget.p.toString();
    _tec2.addListener(() {setState(() {});});
    _tec3.addListener(() {setState(() {});});
    for (var element in widget.thingsToSell) {
      things.add(element['thing']);
    }
    things.sort();
    print('lt $things');
    selectedThing = things[0];
    if (widget.name != '') {
      selectedThing = widget.name;
    }
  }

  @override
  void dispose() {
    _tec1.dispose();
    _tec2.dispose();
    _tec3.dispose();
    super.dispose();
  }

  String _countSum(){
    double _sum=0;
    try {
      _sum = double.parse(_tec2.value.text)*double.parse(_tec3.value.text);
    } catch(e) {}
    return _sum==0? '':_sum.toString();
  }

  _restOfSelected() {
    for (var el in widget.thingsToSell) {
      if (el['thing'] == selectedThing) {
        return el['q'];
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text((widget.name==''?'Добавить':'Изменить'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Товар:  '),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedThing,
                    items: things.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (choice) {
                      print('choice $choice');
                      setState(() {
                        selectedThing = choice.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Остаток ${_restOfSelected()}', textScaleFactor: 1.4,),
              ],
            ),
            Row(
              children: [
                const Text('Количество:  '),
                Expanded(
                  child: TextField(
                    controller: _tec2,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Цена:  '),
                Expanded(
                  child: TextField(
                    controller: _tec3,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Сумма: ${_countSum()}', textScaleFactor: 1.4,),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text('OK'),
        onPressed: () async {
          if (_tec2.value.text == '') {
            await showAlertPage(context, 'Нет количества');
            return;
          }
          if (_tec3.value.text == '') {
            await showAlertPage(context, 'Нет цены');
            return;
          }
          var res={};
          res['t']=selectedThing;
          res['q']=int.parse(_tec2.value.text);
          if (res['q'] > _restOfSelected()) {
            await showAlertPage(context, 'Количество превышает остаток');
            return;
          }
          res['p']=int.parse(_tec3.value.text);
          Navigator.pop(context, res);
        },
      ),
    );
  }
}
