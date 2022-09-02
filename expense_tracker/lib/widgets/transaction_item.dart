import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function deleteTx;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text(
                '\$${transaction.amount}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat('dd MMM yyyy').format(transaction.date),
          style: const TextStyle(fontSize: 15),
        ),
        trailing: MediaQuery.of(context).size.width > 360
            ? TextButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).errorColor)),
                onPressed: () => deleteTx(transaction.id),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
                onPressed: () => deleteTx(transaction.id),
              ),
      ),
    );
  }
}
