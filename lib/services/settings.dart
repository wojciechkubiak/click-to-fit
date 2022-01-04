import 'dart:async';

import '../models/user.dart';
import '../config/config_service.dart';
import './storage.dart';

abstract class DataSettingsService extends ConfigService {
  Future<List<User>> getUsers();
}

class SettingsService extends DataSettingsService {
  @override
  Future<List<User>> getUsers() async {
    return [];
  }
}
