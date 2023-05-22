import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate=DateTime.now();

  void _submitData() {
    if(_amountController.text.isEmpty) return;
    final enteredTitle = _titleController.text;
    final enteredamount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredamount <= 0 || _selectedDate==null) return;

    widget.addTx(
      enteredTitle,
      enteredamount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15),),
        ),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            //this will uplift the adding part when keyboard appear
            bottom: MediaQuery.of(context).viewInsets.bottom+10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                //onChanged: (val){
                //  titleInput=val;
                //},
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                //in ios,below code is not allowed,so use TextInputType.numberWithOptions(decimal:true)
                keyboardType: TextInputType.number,
                //we are not giving below function any parentheses because
                //because we want that when we press the button then only
                //it will get executed.

                //we are using an underscore because we will not use that
                //that value.
                onSubmitted: (_) => _submitData(),
                //onChanged: (val)=>amountInput=val,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed:_presentDatePicker,
                      child: Text(
                        'Choose Date',
                        selectionColor: Theme.of(context).primaryColor,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: Text('Add Transaction'),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
