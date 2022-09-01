import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './models/transaction.dart';
import './/widgets/new_transaction.dart';
import './/widgets/transaction_list.dart';
import './widgets/chart.dart';

void main(List<String> args) {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
          ),
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                button: const TextStyle(
                  color: Colors.white,
                ),
              ),
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String? titleInput;
  // String? amountInput;

  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  var _showChart = false;

  List<Transaction> get _recentTransactions {
    var afterDate = DateTime.now().subtract(const Duration(days: 7));

    return _userTransactions.where((tx) {
      return tx.date.isAfter(afterDate);
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  child: const Icon(CupertinoIcons.add),
                  onPressed: () => _startAddNewTransaction(context),
                )
              ],
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: const Text(
              'Personal Expenses',
            ),
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: const Icon(Icons.add),
              ),
            ],
          );
    final txList = SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show Chart',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Switch.adaptive(
                    value: _showChart,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (on) {
                      setState(() {
                        _showChart = on;
                      });
                    })
              ],
            ),
          if (!isLandscape)
            SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions)),
          if (!isLandscape) txList,
          if (isLandscape)
            _showChart
                ? SizedBox(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txList,
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      return _startAddNewTransaction(context);
                    },
                  ),
          );
  }
}
