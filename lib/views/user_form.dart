import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, String> _formData = {};

  void _loadFormData(User user) {
    _formData['id'] = user.id;
    _formData['name'] = user.name;
    _formData['email'] = user.email;
    _formData['avatarUrl'] = user.avatarUrl;
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments;
    if (user != null) {
      _loadFormData(user as User);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Formulário de Usuário',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () async {
                final isValid = _form.currentState!.validate();
                if (isValid) {
                  _form.currentState!.save();
                  print(_formData);

                  setState(() {
                    _isLoading = true;
                  });

                  await Provider.of<Users>(context, listen: false).put(User(
                      id: _formData['id'] != null
                          ? _formData['id'] as String
                          : '',
                      name: _formData['name']!,
                      email: _formData['email']!,
                      avatarUrl: _formData['avatarUrl']!));
                  Navigator.of(context).pop();

                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _formData['name'],
                        decoration: InputDecoration(labelText: 'Nome'),
                        validator: (value) {
                          if (value == null || value!.trim().isEmpty) {
                            return "Informe um nome...";
                          }

                          if (value.trim().length < 3) {
                            return "Nome muito pequeno. No mínimo 3 letras";
                          }

                          return null;
                        },
                        onSaved: (value) => _formData['name'] = value!,
                      ),
                      TextFormField(
                        initialValue: _formData['email'],
                        decoration: InputDecoration(labelText: 'E-mail'),
                        onSaved: (value) => _formData['email'] = value!,
                      ),
                      TextFormField(
                        initialValue: _formData['avatarUrl'],
                        decoration: InputDecoration(labelText: 'URL do avatar'),
                        onSaved: (value) => _formData['avatarUrl'] = value!,
                      )
                    ],
                  )),
            ),
    );
  }
}
