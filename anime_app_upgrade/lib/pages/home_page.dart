import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_page.dart';
import '../widgets/anime_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService api = ApiService();
  bool loading = true;
  List ongoing = [], complete = [], popular = [];
  String error = '';

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() { loading = true; error=''; });
    final res = await api.fetchHome();
    if (res == null) {
      setState(() { error = 'Failed to fetch'; loading = false; });
      return;
    }
    final data = res['data'] ?? {};
    setState(() {
      ongoing = data['ongoing_anime'] ?? [];
      complete = data['complete_anime'] ?? [];
      popular = data['popular_anime'] ?? [];
      loading = false;
    });
  }

  Widget buildList(List list) {
    if (list.isEmpty) return Center(child: Text('No data'));
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index] as Map;
        return AnimeCard(item: item, onTap: () {
          final slug = item['slug'];
          if (slug != null) Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(slug: slug)));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text('Lann Anime'), bottom: TabBar(tabs: [Tab(text:'Ongoing'), Tab(text:'Complete'), Tab(text:'Popular')])),
        body: loading ? Center(child: CircularProgressIndicator()) :
          TabBarView(children: [buildList(ongoing), buildList(complete), buildList(popular)]),
      ),
    );
  }
}
