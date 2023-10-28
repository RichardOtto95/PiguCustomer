import 'dart:async';

import 'package:pigu/app/core/services/storage/local_storage_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageSharedPreferences implements ILocalStorage {
  Completer<SharedPreferences> _instance = Completer<SharedPreferences>();

  _init() async {
    _instance.complete(await SharedPreferences.getInstance());
  }

  LocalStorageSharedPreferences() {
    _init();
  }

  @override
  Future delete(String key) async {
    var _shared = await _instance.future;
    _shared.remove(key);
  }

  @override
  Future<List<String>> get(String key) async {
    var _shared = await _instance.future;
    return _shared.getStringList(key);
  }

  @override
  Future put(String key, List<String> value) async {
    var _shared = await _instance.future;
    _shared.setStringList(key, value);
  }
}
