import 'package:flutter/material.dart';
import 'package:flutter_crud/components/user_tile.dart';
import 'package:flutter_crud/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../provider/users.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    //const users = {...DUMMY_USERS};
    final users = Provider.of<Users>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lista de Usuários',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.USER_FORM);
                },
                color: Colors.white,
                icon: const Icon(Icons.add))
          ],
        ),
        body: ListView.builder(
            itemCount: users.count,
            itemBuilder: (context, i) => UserTile(users.all.elementAt(i))));
  }
}
