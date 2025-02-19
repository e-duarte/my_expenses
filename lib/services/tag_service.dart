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
        tagName: 'Merenda',
        iconPath: 'assets/icons/merenda_icon.png',
      ),
      Tag(
        tagName: 'Refeição',
        iconPath: 'assets/icons/meal_icon.png',
      ),
      Tag(
        tagName: 'Compras',
        iconPath: 'assets/icons/compras_icon.png',
      ),
      Tag(
        tagName: 'Mercado',
        iconPath: 'assets/icons/mercado_icon.png',
      ),
      Tag(
        tagName: 'Ninos',
        iconPath: 'assets/icons/cats_icon.png',
      ),
      Tag(
        tagName: 'Despesas',
        iconPath: 'assets/icons/home_icon.png',
      ),
      Tag(
        tagName: 'Reserva',
        iconPath: 'assets/icons/reserva_icon.png',
      ),
      Tag(
        tagName: 'Geral',
        iconPath: 'assets/icons/general_icon.png',
      ),
      Tag(
        tagName: 'Terceiros',
        iconPath: 'assets/icons/users_icon.png',
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
