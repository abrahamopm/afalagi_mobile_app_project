import 'package:flutter/material.dart';

class TagsService {
  static final List<Map<String, dynamic>> _tags = [
    {'name': 'Luxury', 'properties': 124, 'color': const Color(0xFF1B385E)},
    {'name': 'Villa', 'properties': 86, 'color': const Color(0xFF2E6B4F)},
    {'name': 'Bole', 'properties': 312, 'color': const Color(0xFF6B3E0C)},
    {'name': 'Under Construction', 'properties': 42, 'color': const Color(0xFF006D8E)},
    {'name': 'Commercial', 'properties': 58, 'color': const Color(0xFFA6EBC9)},
  ];

  static List<Map<String, dynamic>> getTags() => _tags;

  static List<String> getTagNames() => _tags.map((t) => t['name'] as String).toList();

  static void addTag(Map<String, dynamic> tag) {
    _tags.insert(0, tag);
  }

  static void deleteTagByName(String name) {
    _tags.removeWhere((t) => t['name'] == name);
  }
}
