import 'package:flutter/material.dart';

class Tag {
  final int? id;
  final String tagName;
  final String iconPath;

  Tag({
    this.id,
    required this.tagName,
    required this.iconPath,
  });

  factory Tag.fromMap(Map<String, Object?> data) {
    return Tag(
      id: data['id'] as int,
      tagName: data['tagName'] as String,
      iconPath: data['iconPath'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tagName': tagName,
      'iconPath': iconPath,
    };
  }

  Tag copyWith({
    int? id,
    String? tagName,
    String? iconPath,
    Color? color,
  }) {
    return Tag(
      id: id ?? this.id,
      tagName: tagName ?? this.tagName,
      iconPath: iconPath ?? this.iconPath,
    );
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
