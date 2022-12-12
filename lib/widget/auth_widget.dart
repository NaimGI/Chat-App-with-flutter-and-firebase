import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Pikers/user_piker_img.dart';

class authwidget extends StatefulWidget {
  authwidget(this.SubmitFn, this.isLoding);
  bool isLoding;
  final void Function(String username, String password, String email,
      File _userimg, bool login) SubmitFn;

  @override
  State<authwidget> createState() => _authwidgetState();
}

class _authwidgetState extends State<authwidget> {
  final formKey = GlobalKey<FormState>();

  var isLogin = true;
  String _userEmail = "";
  String _userUserName = "";
  String password = "";
  File? _userimg;
  void _piketImg(File pikImg) {
    _userimg = pikImg;
  }

  void _trySubmit() {
    final validate = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userimg == null && isLogin == false) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please pick an Image")));
      return;
    }
    if (validate) {
      formKey.currentState!.save();
      widget.SubmitFn(_userUserName.trim(), password.trim(), _userEmail.trim(),
          _userimg ?? File("test.text"), isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  if (!isLogin) imgPiker(_piketImg),
                  TextFormField(
                    key: const ValueKey("email"),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(label: Text("Email adress")),
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: const ValueKey("Username"),
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 7) {
                          return "Password at least must be 7 caractere";
                        }
                        return null;
                      }),
                      onSaved: (value) {
                        _userUserName = value!;
                      },
                      decoration:
                          const InputDecoration(label: Text("Username")),
                    ),
                  TextFormField(
                    key: const ValueKey("password"),
                    validator: ((value) {
                      if (value!.isEmpty || value.length < 7) {
                        return "Password at least must be 7 caractere";
                      }
                    }),
                    onSaved: (value) {
                      password = value!;
                    },
                    decoration: const InputDecoration(label: Text("password")),
                    obscureText: true,
                  ),
                  if (widget.isLoding) CircularProgressIndicator(),
                  if (!widget.isLoding)
                    ElevatedButton(
                        onPressed: () {
                          _trySubmit();
                        },
                        child: Text(isLogin ? "Login" : "Sing In")),
                  if (widget.isLoding) CircularProgressIndicator(),
                  if (!widget.isLoding)
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(isLogin
                            ? "Create new User"
                            : "you allready Have an acount"))
                ],
              )),
        )),
      ),
    );
  }
}
