import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MyProvider()),
    ],
    child: const MyApp(),
  ));

  final prefs = await MyProvider().loadPreferences();
}

/// Provider Class - MyProvider
class MyProvider with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isSelected = true;

  bool get isSelected => _isSelected;

  setSelected(bool val) {
    _isSelected = val;
    notifyListeners();
    print(_isSelected);
  }

  loadPreferences() async {
    final SharedPreferences prefs = await _prefs;

    prefs.getBool('isSelectedShared') == null
        ? _isSelected == true
        : _isSelected == prefs.getBool('isSelectedShared');

    print('Loaded Preferences Successfully. Is Selected = ' +
        _isSelected.toString());
  }

  setSelectedSharedPrefs(bool val) async {
    _isSelected = val;
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isSelectedShared', val);
    print(val);
    notifyListeners();
  }
}

/// My App Class
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Switch + Provider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Switch + Provider'),
    );
  }
}

/// MyHomePage Class
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Switch(
              value: context.read<MyProvider>()._isSelected,
              onChanged: (bool value) {
                setState(() {
                  context.read<MyProvider>().setSelectedSharedPrefs(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
