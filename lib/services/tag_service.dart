import 'package:flutter/material.dart';
import 'package:my_expenses/models/tag.dart';
import 'package:my_expenses/utils/db_utils.dart';

class TagService {
  static const table = 'tags';

  Future<Tag> insertTag(Tag tag) async {
    final tagId = await DbUtils.insertData(table, tag.toMap());
    return tag.copyWith(id: tagId);
  }

  Future<List<Tag>> getTags() async {
    final data = await DbUtils.listData(table);
    var tags = data.map((tr) => Tag.fromMap(tr)).toList();

    if (tags.isNotEmpty) {
      return tags;
    }

    tags = [
      Tag(
        tag: 'Ninos',
        iconPath: 'assets/icons/cats_icon.png',
        color: Color(int.parse('0xFFF4DBB4')),
      ),
      Tag(
        tag: 'Compras',
        iconPath: 'assets/icons/compras_icon.png',
        color: Color(int.parse('0xFFB4C4ED')),
      ),
      Tag(
        tag: 'Mercado',
        iconPath: 'assets/icons/mercado_icon.png',
        color: Color(int.parse('0xFFB4EDBD')),
      ),
      Tag(
        tag: 'Merenda',
        iconPath: 'assets/icons/merenda_icon.png',
        color: Color(int.parse('0xFFE8B4ED')),
      ),
      Tag(
        tag: 'Refeição',
        iconPath: 'assets/icons/meal_icon.png',
        color: Color(int.parse('0xFFF6989FA')),
      ),
      Tag(
        tag: 'Despesas',
        iconPath: 'assets/icons/home_icon.png',
        color: Color(int.parse('0xFFF7FF9A')),
      ),
      Tag(
        tag: 'Reserva',
        iconPath: 'assets/icons/reserva_icon.png',
        color: Color(int.parse('0xFF69FAE8')),
      ),
      Tag(
        tag: 'Geral',
        iconPath: 'assets/icons/general_icon.png',
        color: Color(int.parse('0xFFD7D7D7')),
      ),
      Tag(
        tag: 'Terceiros',
        iconPath: 'assets/icons/users_icon.png',
        color: Color(int.parse('0xFFD7D7D7')),
      ),
    ];
    List<Tag> tagsWithId = [];
    for (var tag in tags) {
      tagsWithId.add(await insertTag(tag));
    }

    return tagsWithId;
  }

  Future<Tag> getTag(int id) async {
    final tagMap = await DbUtils.fetchById(table, id);
    return Tag.fromMap(tagMap);
  }
}
