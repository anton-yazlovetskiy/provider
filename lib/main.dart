import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyChangeNotiferProvider>.value(
            value: MyChangeNotiferProvider()),
        FutureProvider(
            create: (_) async => MyFutureProvider().getUsers(),
            initialData: null),
        StreamProvider(
          create: (context) => MyStreamProvider().intStream(),
          initialData: 0,
        ),
      ],
      child: const DefaultTabController(
        length: 3,
        child: TabBarView(children: <Widget>[
          Page1(),
          Page2(),
          Page3(),
        ]),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MyChangeNotiferProvider _stateChangeProvider =
        Provider.of<MyChangeNotiferProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test ChangeNotiferProvider'),
      ),
      body: Container(
        color: Colors.green[100],
        child: Column(
          children: [
            Consumer<MyChangeNotiferProvider>(builder: (context, value, child) {
              return Text('${value.countValue}');
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _stateChangeProvider._decrementCount(),
                  child: const Icon(Icons.minimize),
                ),
                TextButton(
                  onPressed: () => _stateChangeProvider._incrementCount(),
                  child: const Icon(Icons.add),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<List?>(
      builder: (context, List? users, child) {
        return users == null
            ? const Text('loading . . ')
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => Card(
                  elevation: 2,
                  child: Text('$index | ${users[index]}'),
                ),
              );
      },
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var _value = Provider.of<int>(context);
    //return Text('${_value.toString()}');
    return Consumer<int>(builder: (context, int value, child) {
      return Text('${value.toString()}');
    });
  }
}

class MyChangeNotiferProvider extends ChangeNotifier {
  int _count = 0;

  int get countValue => _count;

  void _incrementCount() {
    _count++;
    notifyListeners();
  }

  void _decrementCount() {
    _count--;
    notifyListeners();
  }
}

class MyFutureProvider {
  List users = ['user 1', 'user 2', 'user 3', 'user 4', 'user 5', 'user 6'];

  Future<List> getUsers() async {
    return await Future.delayed(const Duration(seconds: 6), () async {
      return users;
    });
  }
}

class MyStreamProvider {
  Stream<int> intStream() {
    Duration interval = const Duration(seconds: 1);
    return Stream<int>.periodic(interval, (int _count) => _count++);
  }
}
