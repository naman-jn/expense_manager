import 'package:expense_manager/models/expense.dart';
import 'package:expense_manager/utils/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  AddExpense({Key key, @required this.expense}) : super(key: key);
  final Expense expense;

  AddExpense.withId(this.expense);

  @override
  _AddExpenseState createState() => _AddExpenseState(expense);
}

class _AddExpenseState extends State<AddExpense> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  _AddExpenseState(this.expense);
  Expense expense;
  bool isExpense;

  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  double screenHeight;
  double screenWidth;
  @override
  void initState() {
    super.initState();
    expense.isExpense == 0 ? isExpense = false : isExpense = true;
    nameController.text = expense.name;
    amountController.text = expense.amount;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          if (formKey.currentState.validate()) _save();
        },
        child: Icon(Icons.save),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/add_bg.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.grey.withOpacity(0.5), BlendMode.dstATop))),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        Text("Add transaction",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        expense.id == null
                            ? SizedBox()
                            : IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.black54,
                                ),
                                onPressed: () async {
                                  await databaseHelper
                                      .deleteExpense(expense.id);
                                  Navigator.pop(context, true);
                                }),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Type: ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        SizedBox(
                          width: screenWidth * 0.07,
                        ),
                        ButtonBar(
                          children: [
                            typeButton(
                                text: "Expense",
                                isSelected: isExpense,
                                onPressed: () {
                                  isExpense = true;
                                },
                                color: Colors.deepOrangeAccent),
                            typeButton(
                                text: "Income",
                                isSelected: !isExpense,
                                onPressed: () {
                                  isExpense = false;
                                },
                                color: Colors.blueAccent),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Amount: ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: screenWidth * 0.65,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
                            ],
                            decoration:
                                inputDecoration(hintText: "Enter Amount"),
                            controller: amountController,
                            validator: (String s) {
                              if (s.isEmpty || s.trim() == '') {
                                return "Amount can't be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Note: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.06,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: screenWidth * 0.65,
                          child: TextFormField(
                            decoration: inputDecoration(
                                hintText: "Enter transaction detail"),
                            controller: nameController,
                            validator: (String s) {
                              if (s.isEmpty || s.trim() == '') {
                                return "Note can't be empty";
                              }
                              return null;
                            },
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget typeButton(
      {String text, Function onPressed, bool isSelected, Color color}) {
    return OutlineButton(
      onPressed: () {
        setState(() {
          onPressed();
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      borderSide: BorderSide(color: isSelected ? color : Colors.grey),
      child: Text(
        text,
        style: TextStyle(color: isSelected ? color : Colors.grey),
      ),
    );
  }

  InputDecoration inputDecoration({String hintText = ""}) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      hintText: hintText,
      errorStyle: TextStyle(color: Colors.red),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(color: Colors.blue[300]),
      ),
    );
  }

  void _save() async {
    Navigator.pop(context, true);
    expense.date = DateFormat.MMMd().format(DateTime.now());
    expense.amount = amountController.text.trim();
    expense.name = nameController.text.trim();
    if (isExpense) {
      expense.isExpense = 1;
    } else {
      expense.isExpense = 0;
    }

    expense.id == null
        ? await databaseHelper.insertExpense(expense)
        : await databaseHelper.updateExpense(expense);
  }
}
