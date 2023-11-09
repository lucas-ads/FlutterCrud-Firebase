import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_crud/data/dummy_users.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class Users with ChangeNotifier {
  static const _baseUrl = 'https://sua-url-do-firebase.firebaseio.com/';

  final Map<String, User> _items = {};

  Users() {
    loadUsers();
  }

  List<User> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }

  Future<void> put(User user) async {
    if (user.id.trim().isNotEmpty && _items.containsKey(user.id)) {
      final response = await http.patch(
        Uri.parse("$_baseUrl/users/${user.id}.json"),
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl
        }),
      );

      _items.update(
          user.id,
          (param) => User(
              id: user.id,
              name: user.name,
              email: user.email,
              avatarUrl: user.avatarUrl));
    } else {
      final response = await http.post(
        Uri.parse("$_baseUrl/users.json"),
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl
        }),
      );

      final id = json.decode(response.body)['name'];

      _items.putIfAbsent(
          id,
          () => User(
              id: id,
              name: user.name,
              email: user.email,
              avatarUrl: user.avatarUrl));
    }
    notifyListeners();
  }

  Future<void> remove(User user) async {
    final response =
        await http.delete(Uri.parse("$_baseUrl/users/${user.id}.json"));

    if (user.id != null) {
      _items.remove(user.id);
      notifyListeners();
    }
  }

  Future<void> loadUsers() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/users.json"),
    );

    var jsonUsers = json.decode(response.body) as Map<String, dynamic>;

    _items.addAll(jsonUsers.map((key, value) {
      return MapEntry(
          key,
          User(
            id: key,
            name: value['name'] as String,
            email: value['email'] as String,
            avatarUrl: value['avatarUrl'] as String,
          ));
    }));

    notifyListeners();
  }
}
