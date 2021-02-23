class Expense {
  int id;
  String name;
  String amount;
  String date;
  int isExpense;

  Expense.withID(this.id, this.name, this.amount, this.date, this.isExpense);

  Expense();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'amount': amount,
      'date': date,
      'isExpense': isExpense,
    };
  }

  Expense.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.amount = map['amount'];
    this.date = map['date'];
    this.isExpense = map['isExpense'];
  }
}
