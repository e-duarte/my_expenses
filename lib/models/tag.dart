import 'package:flutter/material.dart';

class Tag {
  final int? id;
  final String tag;
  final String iconPath;
  final Color color;

  Tag({
    this.id,
    required this.tag,
    required this.iconPath,
    required this.color,
  });

  factory Tag.fromMap(Map<String, Object?> data) {
    return Tag(
      id: data['id'] as int,
      tag: data['tag'] as String,
      iconPath: data['iconPath'] as String,
      color: Color(
        int.parse(data['color'] as String),
      ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'tag': tag,
      'iconPath': iconPath,
      'color': color.value.toString(),
    };
  }

  Tag copyWith({
    int? id,
    String? tag,
    String? iconPath,
    Color? color,
  }) {
    return Tag(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      iconPath: iconPath ?? this.iconPath,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return '${toMap()}';
  }
}
