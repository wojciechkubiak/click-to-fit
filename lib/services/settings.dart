import 'dart:async';

import '../models/user.dart';

abstract class DataSettingsService {
  Future<List<User>> getUsers();
}

class SettingsService extends DataSettingsService {
  @override
  Future<List<User>> getUsers() async {
    return [];
  }
}
