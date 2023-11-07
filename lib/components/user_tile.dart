import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';

class UserTile extends StatelessWidget {
  final User user;

  const UserTile(this.user);

  @override
  Widget build(BuildContext context) {
    final avatar = user.avatarUrl == null || user.avatarUrl.isEmpty
        ? CircleAvatar(child: Icon(Icons.person))
        : CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl));

    return ListTile(
        leading: avatar,
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.USER_FORM, arguments: user);
                  },
                  color: Colors.orange,
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text('Excluir Usuário'),
                            content: Text('Tem certeza?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Não')),
                              TextButton(
                                  onPressed: () {
                                    Provider.of<Users>(context, listen: false)
                                        .remove(user);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Sim')),
                            ],
                          );
                        });
                  },
                  color: Colors.red,
                  icon: Icon(Icons.delete)),
            ],
          ),
        ));
  }
}
