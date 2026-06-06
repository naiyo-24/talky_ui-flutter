// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ArticleModel {
  final String id;
  final String category;
  ArticleModel({required this.id, required this.category});
}

void main() async {
  final str = File('assets/json/news.json').readAsStringSync();
  final data = jsonDecode(str) as List;
  
  final all = data.map((j) => ArticleModel(id: j['id'] ?? '', category: j['category'] ?? '')).toList();
  
  debugPrint('Total parsed: ${all.length}');
  
  String category = 'Latest';
  
  var filtered = all;
  // skip district filter
  
  if (category.toLowerCase() != 'top' && category.toLowerCase() != 'home') {
      final cat = category.toLowerCase();
      if (cat == 'latest') {
         // sort
         // filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      } else if (cat == 'trending') {
        final list = List<ArticleModel>.from(filtered);
        list.shuffle();
        filtered = list.take(20).toList();
      } else {
        filtered = filtered.where((a) => a.category.toLowerCase() == cat).toList();
      }
  }
  
  if (filtered.isEmpty) {
     debugPrint('filtered is empty!');
  }
  
  debugPrint('Returned: ${filtered.length}');
}
