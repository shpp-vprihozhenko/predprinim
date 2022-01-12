import 'dart:convert';

import 'package:flutter/material.dart';

import 'globals.dart';

class AddMoney extends StatefulWidget {
  final Doc doc;

  const AddMoney({Key? key, required this.doc}) : super(key: key);

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  late TextEditingController _controller;
  late int docNumber;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.doc.sum.toString();
    docNumber = int.parse(widget.doc.numDoc);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.doc.typeDoc=='a'?'Внесение':'Изьятие'} денег'),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Text('№ документа $docNumber'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                const Text('Сумма: '),
                Expanded(
                  child: TextField(
                    controller: _controller,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'ok',
        child: const Text('OK'),
        onPressed: () async {
          Doc doc = Doc(date: DateTime.now(), numDoc: docNumber.toString(),
              typeDoc: widget.doc.typeDoc,
              sum: int.parse(_controller.value.text),
              ka: '', inf: '', td: ''
          );
          if (docNumerator < docNumber) {
            journal.add(doc);
            docNumerator = docNumber;
            saveLocally('docNumerator', docNumber.toString());
          } else {
            updateJ(doc);
          }
          saveLocally('journal', jsonEncode(journal));
          moveRegs(doc);
          await showAlertPage(context, 'Документ сохранён');
          Navigator.pop(context);
        },
      ),

    );
  }
}
