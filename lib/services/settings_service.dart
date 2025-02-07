import 'package:my_expenses/models/settings.dart';
import 'package:my_expenses/utils/db_utils.dart';

class SettingsService {
  static const table = 'settings';

  Future<Settings> insertSettings(Settings settings) async {
    final settingId = await DbUtils.insertData(table, settings.toMap());
    return settings.copyWith(id: settingId);
  }

  Future<Settings> getSettings() async {
    final data = await DbUtils.listData(table);
    var settingsList = data.map((tr) => Settings.fromMap(tr)).toList();

    if (settingsList.isNotEmpty) {
      return settingsList.first;
    }

    return await insertSettings(Settings(monthValue: 0.0));
  }

  Future<Settings> update(int id, Settings settings) async {
    final updatedSettings = settings.copyWith(id: id);
    await DbUtils.updateData(table, updatedSettings.toMap());
    return updatedSettings;
  }
}
