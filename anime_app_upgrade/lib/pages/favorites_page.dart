import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorite_service.dart';
import '../services/api_service.dart';
import '../widgets/anime_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ApiService api = ApiService();
  List items = [];
  bool loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    final favSvc = Provider.of<FavoriteService>(context, listen: false);
    final slugs = favSvc.favorites;
    setState(() { loading = true; });
    List out = [];
    for (var s in slugs) {
      final detail = await api.animeDetail(s);
      if (detail != null && detail['data'] != null) out.add(detail['data']);
    }
    setState(() { items = out; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final favSvc = Provider.of<FavoriteService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: loading ? Center(child: CircularProgressIndicator()) :
        items.isEmpty ? Center(child: Text('No favorites')) :
        ListView.builder(itemCount: items.length, itemBuilder: (c,i){
          final item = items[i] as Map;
          return AnimeCard(item: item, onTap: () {
            final slug = item['slug'];
            if (slug != null) Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(slug: slug)));
          });
        }),
    );
  }
}
