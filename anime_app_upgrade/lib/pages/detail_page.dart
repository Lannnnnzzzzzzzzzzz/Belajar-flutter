import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import '../services/history_service.dart';
import 'player_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPage extends StatefulWidget {
  final String slug;
  DetailPage({required this.slug});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService api = ApiService();
  bool loading = true;
  Map? anime;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() { loading = true; error=''; });
    final res = await api.animeDetail(widget.slug);
    if (res == null) {
      setState(() { error='Failed to fetch'; loading=false; });
      return;
    }
    setState(() { anime = res['data']; loading=false; });
  }

  @override
  Widget build(BuildContext context) {
    final favSvc = Provider.of<FavoriteService>(context);
    final hist = Provider.of<HistoryService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(anime?['title'] ?? 'Detail'),
        actions: [
          IconButton(
            icon: Icon(favSvc.isFav(widget.slug) ? Icons.favorite : Icons.favorite_border),
            onPressed: () => favSvc.toggle(widget.slug),
          )
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : anime == null ? Center(child: Text('No data')) :
      SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: anime?['poster'] ?? anime?['thumbnail'] ?? '',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (c,s) => Container(height:200,color:Colors.grey[300]),
            ),
            SizedBox(height: 12),
            Text(anime?['title'] ?? '', style: TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Genres: ' + (anime?['genre']?.join(', ') ?? '')),
            SizedBox(height: 8),
            Text('Synopsis', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height:6),
            Text(anime?['synopsis'] ?? anime?['description'] ?? ''),
            SizedBox(height:12),
            Text('Episodes', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height:6),
            ...(anime?['episodes'] is List ? (anime?['episodes'] as List).map((ep){
              final title = ep['title'] ?? ep['name'] ?? 'Episode';
              final url = ep['file'] ?? ep['url'] ?? ep['source'] ?? '';
              return ListTile(
                title: Text(title),
                subtitle: Text(url.isNotEmpty ? 'Playable' : 'No url'),
                onTap: () {
                  if (url.isNotEmpty) {
                    // save last episode to history
                    hist.savePosition(widget.slug, 0.0, episode: title);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerPage(slug: widget.slug, episodeTitle: title, url: url)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('URL not available')));
                  }
                },
              );
            }).toList() : [Text('No episode list')]),
          ],
        ),
      ),
    );
  }
}
