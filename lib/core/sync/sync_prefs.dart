abstract class SyncPrefs {
  dynamic get(String key);
  Future<void> put(String key, dynamic value);
}

class HiveSyncPrefs implements SyncPrefs {
  final dynamic _box; // keep dynamic to avoid tight coupling in interface
  HiveSyncPrefs(this._box);

  @override
  dynamic get(String key) => _box.get(key);

  @override
  Future<void> put(String key, dynamic value) => _box.put(key, value);
}

