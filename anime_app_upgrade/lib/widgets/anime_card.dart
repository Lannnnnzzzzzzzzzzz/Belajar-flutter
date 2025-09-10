import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AnimeCard extends StatelessWidget {
  final Map item;
  final VoidCallback onTap;
  AnimeCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final image = item['poster'] ?? item['thumbnail'] ?? '';
    final title = item['title'] ?? 'No title';
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: image,
            width: 70,
            height: 90,
            fit: BoxFit.cover,
            placeholder: (c, s) => Container(width:70,height:90,color:Colors.grey[300]),
            errorWidget: (c, s, d) => Container(width:70,height:90,color:Colors.grey[300], child: Icon(Icons.image_not_supported)),
          ),
        ),
        title: Text(title),
        subtitle: Text(item['current_episode']?.toString() ?? ''),
        onTap: onTap,
      ),
    );
  }
}
