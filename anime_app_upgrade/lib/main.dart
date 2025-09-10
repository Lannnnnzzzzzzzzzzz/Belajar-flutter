import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';
import 'pages/favorites_page.dart';
import 'services/favorite_service.dart';
import 'services/history_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favService = FavoriteService();
  await favService.init();
  final historyService = HistoryService();
  await historyService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => favService),
        ChangeNotifierProvider(create: (_) => historyService),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: AnimeApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class AnimeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Lann Anime Upgrade',
      themeMode: themeProvider.mode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MainShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainShell extends StatefulWidget {
  @override
  _MainShellState createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;
  final pages = [
    HomePage(),
    SearchPage(),
    FavoritesPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.brightness_6),
        onPressed: () {
          Provider.of<ThemeProvider>(context, listen: false).toggle();
        },
      ),
    );
  }
}
