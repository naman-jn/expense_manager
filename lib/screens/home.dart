import 'package:expense_manager/models/expense.dart';
import 'package:expense_manager/screens/add_expense.dart';
import 'package:expense_manager/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Expense> expenseList;
  double income;
  double expense;

  double screenWidth;
  double screenHeight;
  @override
  void initState() {
    super.initState();
    expenseList = List<Expense>();
    getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    if (expenseList == null) {
      expenseList = List<Expense>();
      getExpenses();
    }
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add),
        onPressed: () async {
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddExpense(
                        expense: Expense(),
                      )));
          if (result == true) {
            getExpenses();
          }
        },
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    "Expense Manager",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.blueGrey[700]),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "\u{20B9}${(income - expense).toStringAsFixed(2)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 1.2,
                      color: Colors.blueGrey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                child: Center(
                  child: Text(
                    "Total Balance",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black45),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  statCard(
                    color: Colors.tealAccent[400],
                    image: "assets/images/increment.png",
                    text: "Income",
                    value: income,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  statCard(
                    color: Colors.redAccent[100],
                    image: "assets/images/decrement.png",
                    text: "Expense",
                    value: expense,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 5.0, left: 15),
                child: Text(
                  "Recent Transactions",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      color: Colors.black54),
                ),
              ),
              expenseList.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.1,
                          ),
                          Image.asset("assets/images/emptyExpenses.png"),
                          Text(
                            "No Transactions",
                            textScaleFactor: 1.5,
                          ),
                          Text("Tap + to add one"),
                        ],
                      ),
                    )
                  : Flexible(
                      child: ListView.separated(
                        itemCount: expenseList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () async {
                                bool result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddExpense(
                                              expense: expenseList[index],
                                            )));
                                if (result == true) {
                                  getExpenses();
                                }
                              },
                              child: expenseCard(index));
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.09),
                            color: Colors.grey[200],
                            height: 1,
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

  Widget expenseCard(int index) {
    Expense expense = expenseList[index];
    bool isExpense;
    if (expense.isExpense == 1)
      isExpense = true;
    else
      isExpense = false;
    String sign;
    isExpense ? sign = '-' : sign = '+';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 9),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: isExpense ? Colors.redAccent[100] : Colors.tealAccent[400],
            ),
            child: Image.asset(
              isExpense
                  ? "assets/images/decrement.png"
                  : "assets/images/increment.png",
            ),
          ),
          SizedBox(
            width: 18,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.name,
                  style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  expense.date,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '$sign \u{20B9}${expense.amount}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color:
                    isExpense ? Colors.redAccent[100] : Colors.tealAccent[400]),
          ),
        ],
      ),
    );
  }

  Widget statCard({Color color, String image, String text, double value}) {
    return Container(
      height: screenHeight * 0.09,
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
              offset: Offset(3, 5),
              spreadRadius: 1,
              blurRadius: 5,
              color: color.withOpacity(0.3)),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                ('\u{20B9}${value.toStringAsFixed(2)}'),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )
            ],
          ),
          SizedBox(
            width: screenWidth * 0.03,
          ),
          Container(
            width: 30,
            child: Image.asset(
              image,
            ),
          ),
        ],
      ),
    );
  }

  void getExpenses() {
    income = 0;
    expense = 0;
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Expense>> noteListFuture = databaseHelper.getExpenseList();
      noteListFuture.then((expenseList) {
        setState(() {
          expenseList.forEach((element) {
            if (element.isExpense == 1)
              expense += double.parse(element.amount);
            else
              income += double.parse(element.amount);
          });
          this.expenseList = expenseList.reversed.toList();
        });
      });
    });
  }
}
