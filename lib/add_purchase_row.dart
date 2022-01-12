import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart';

class AddPurchaseRow extends StatefulWidget {
  final String name;
  final int q, p;

  const AddPurchaseRow({Key? key, this.name='', this.q=0, this.p=0}) : super(key: key);

  @override
  _AddPurchaseRowState createState() => _AddPurchaseRowState();
}

class _AddPurchaseRowState extends State<AddPurchaseRow> {
  late TextEditingController _tec1, _tec2, _tec3;

  @override
  void initState() {
    super.initState();
    _tec1 = TextEditingController();
    _tec2 = TextEditingController();
    _tec3 = TextEditingController();
    _tec1.text = widget.name;
    _tec2.text = widget.q.toString();
    _tec3.text = widget.p.toString();
    _tec2.addListener(() {setState(() {});});
    _tec3.addListener(() {setState(() {});});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text((widget.name == ''? 'Добавить':'Изменить'))),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text('Товар:  '),
              Expanded(
                child: TextField(
                  controller: _tec1,
                ),
              ),
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
          /*
          OutlinedButton(
            child: const Text('OK'),
            onPressed: () async {
              if (_tec1.value.text == '') {
                await showAlertPage(context, 'Нет названия товара');
                return;
              }
              if (_tec2.value.text == '') {
                await showAlertPage(context, 'Нет количества');
                return;
              }
              if (_tec3.value.text == '') {
                await showAlertPage(context, 'Нет цены');
                return;
              }
              var res={};
              res['t']=_tec1.value.text;
              res['q']=double.parse(_tec2.value.text);
              res['p']=double.parse(_tec3.value.text);
              Navigator.pop(context, res);
            },
          ),

           */
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text('OK'),
        onPressed: () async {
          if (_tec1.value.text == '') {
            await showAlertPage(context, 'Нет названия товара');
            return;
          }
          if (_tec2.value.text == '') {
            await showAlertPage(context, 'Нет количества');
            return;
          }
          if (_tec3.value.text == '') {
            await showAlertPage(context, 'Нет цены');
            return;
          }
          var res={};
          res['t']=_tec1.value.text;
          res['q']=int.parse(_tec2.value.text);
          res['p']=int.parse(_tec3.value.text);
          Navigator.pop(context, res);
        },
      ),
    );
  }
}
