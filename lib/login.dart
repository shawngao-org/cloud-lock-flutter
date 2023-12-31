import 'dart:convert';

import 'package:cloud_lock/data/toast.dart';
import 'package:cloud_lock/db/sqlite/cache.dart';
import 'package:cloud_lock/layout.dart';
import 'package:cloud_lock/main.dart';
import 'package:cloud_lock/util/rsa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'FadeAnimation.dart';
import 'package:cloud_lock/data/api_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  int connState = -1;
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController pwdEditingController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode pwdFocusNode = FocusNode();
  FocusNode hostFocusNode = FocusNode();

  @override
  initState() {
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        _checkEmail();
      }
    });
    pwdFocusNode.addListener(() {
      if (!pwdFocusNode.hasFocus) {
        _checkPwd();
      }
    });
    hostFocusNode.addListener(() {});
    super.initState();
  }

  Future<String> _serverHost() async {
    return Cache().get('host');
  }

  bool checkEmail() {
    RegExp regExp = RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$');
    return regExp.hasMatch(emailEditingController.text);
  }

  bool checkPwd() {
    RegExp regExp = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[a-zA-Z\d~!@#$%^&*]{8,16}$');
    return regExp.hasMatch(pwdEditingController.text);
  }

  _emailToast() => Toast.errToast("电子邮件地址格式不正确", context);

  _pwdToast() => Toast.errToast("必须包含大小写和数字, 长度在 8 到 16 个字符之间，可以使用：~!@#%^&*", context);

  _checkEmail() {
    if (!checkEmail()) {
      _emailToast();
    }
  }

  _checkPwd() {
    if (!checkPwd()) {
      _pwdToast();
    }
  }

  _checkConn() async {
    EasyLoading.show(status: 'Checking server...');
    Cache().set('host', textEditingController.text).then((value) {
      http.get(Uri.parse("${textEditingController.text}/ping")).then((http.Response response) {
        EasyLoading.dismiss();
        if (response.statusCode == 200) {
          setState(() {
            connState = 1;
          });
          Toast.successToast("服务器连接成功", context);
        } else {
          setState(() {
            connState = -2;
          });
          Toast.warnToast("服务器连接成功, 但似乎连接到了错误的服务器", context);
        }
      }).onError((Object error, StackTrace stackTrace) {
        EasyLoading.dismiss();
        setState(() {
          connState = 0;
        });
        Toast.errToast("无服务器连接", context);
      });
    });
  }

  _doLogin() async {
    EasyLoading.show(status: 'Login ...');
    if (!checkEmail()) {
      EasyLoading.dismiss();
      _emailToast();
      return;
    }
    if (!checkPwd()) {
      EasyLoading.dismiss();
      _pwdToast();
      return;
    }
    Rsa().encrypt(pwdEditingController.text, context).then((encoded) {
      if (encoded.isEmpty) {
        EasyLoading.dismiss();
        return;
      }
      var map = <String, String>{};
      map['email'] = emailEditingController.text;
      map['password'] = encoded;
      Cache().set('host', textEditingController.text).then((value) {
        final uri = textEditingController.text + ApiRouter.login;
        http.post(Uri.parse(uri), body: map).then((value) {
          EasyLoading.dismiss();
          if (value.statusCode == 200) {
            Toast.successToast("登录成功", context);
            Cache().set('token', (jsonDecode(value.body))['token']).then((value) {
              Navigator.of(context)
                  .pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const MyHomePage(title: appName)
                  )
              );
            });
          } else {
            Toast.errToast((jsonDecode(value.body))['exception'], context);
          }
        }).onError((error, stackTrace) {
          EasyLoading.dismiss();
          Toast.errToast(error.toString(), context);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _serverHost().then((value) => textEditingController.text = value);
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          emailFocusNode.unfocus();
          pwdFocusNode.unfocus();
          hostFocusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeAnimation(1, Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(1.3, Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/light-2.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(1.5, Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/clock.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      child: FadeAnimation(1.6, Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text("登  录",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(1.8, Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, 0.2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10)
                            )
                          ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey))
                            ),
                            child: TextField(
                              onEditingComplete: _checkEmail,
                              focusNode: emailFocusNode,
                              controller: emailEditingController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "电子邮件地址",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                icon: const Icon(FontAwesomeIcons.envelope),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey))
                            ),
                            child: TextField(
                              focusNode: pwdFocusNode,
                              controller: pwdEditingController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              onEditingComplete: _checkPwd,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "密码",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                icon: const Icon(FontAwesomeIcons.key),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              focusNode: hostFocusNode,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "服务器地址",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  icon: const Icon(FontAwesomeIcons.server),
                                  suffixIcon: connState == -2
                                      ? const Icon(FontAwesomeIcons.circleExclamation, color: Colors.orange,)
                                      : connState == -1
                                      ? const Icon(FontAwesomeIcons.question)
                                      : connState == 0
                                      ? const Icon(FontAwesomeIcons.circleXmark, color: Colors.red,)
                                      : const Icon(FontAwesomeIcons.circleCheck, color: Colors.green,)
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    const SizedBox(height: 30,),
                    FadeAnimation(2, SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                        ),
                        onPressed: _doLogin,
                        child: const Center(
                          child: Text("登  录", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    )),
                    const SizedBox(height: 15,),
                    FadeAnimation(2, SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _checkConn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(255, 178, 98, 1.0),
                        ),
                        child: const Center(
                          child: Text("检查服务器连通性",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 70,),
                    const FadeAnimation(1.5, Text("忘记了密码 ?",
                      style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
