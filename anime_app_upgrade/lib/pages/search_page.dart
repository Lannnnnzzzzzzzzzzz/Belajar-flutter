import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/anime_card.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService api = ApiService();
  final TextEditingController _c = TextEditingController();
  List results = [];
  bool loading = false;

  Future<void> doSearch(String q) async {
    if (q.trim().isEmpty) return;
    setState(() { loading = true; });
    final res = await api.search(q);
    setState(() { results = res ?? []; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _c,
          textInputAction: TextInputAction.search,
          onSubmitted: doSearch,
          decoration: InputDecoration(hintText: 'Search anime...', border: InputBorder.none),
        ),
      ),
      body: loading ? Center(child: CircularProgressIndicator()) :
        results.isEmpty ? Center(child: Text('No results')) :
        ListView.builder(itemCount: results.length, itemBuilder: (c,i){
          final item = results[i] as Map;
          return AnimeCard(item: item, onTap: () {
            final slug = item['slug'];
            if (slug != null) Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(slug: slug)));
          });
        }),
    );
  }
}
