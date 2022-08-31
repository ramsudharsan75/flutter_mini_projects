import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  const Chart(this._recentTransactions, {Key? key}) : super(key: key);

  List<Map<String, Object>> get groupedTransactionsValues {
    var txList = List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var tx in _recentTransactions) {
        if (weekDay.day == tx.date.day &&
            tx.date.month == weekDay.month &&
            tx.date.year == weekDay.year) {
          totalSum += tx.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });

    return txList.reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0, (previousValue, data) {
      return previousValue + (data['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues.map((data) {
            return Expanded(
              child: ChartBar(
                data['day'].toString(),
                (data['amount'] as double),
                totalSpending != 0.0
                    ? ((data['amount'] as double) / totalSpending)
                    : 0.0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
