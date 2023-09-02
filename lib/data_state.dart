import 'package:flutter/material.dart';

enum TaskStatus {
  kWait,
  kStartBlogInit,
  kFinishBlogInit,
  kStartGit,
  kFinishGit,
  kFinishAll
}

class DataState extends ChangeNotifier {
  bool? _checkGit;
  bool? get checkGit => _checkGit;
  set checkGit(state) {
    _checkGit = state;
    notifyListeners();
  }

  bool? _checkHugo;
  bool? get checkHugo => _checkHugo;
  set checkHugo(state) {
    _checkHugo = state;
    notifyListeners();
  }

  TaskStatus _taskStatus = TaskStatus.kWait;
  TaskStatus get taskStatus => _taskStatus;
  set taskStatus(state) {
    _taskStatus = state;
    notifyListeners();
  }

  String? _errorInfo;
  String? get errorInfo => _errorInfo;
  set errorInfo(state) {
    _errorInfo = state;
    notifyListeners();
  }
}
