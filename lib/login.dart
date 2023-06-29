import 'package:cloud_lock/db/sqlite/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'FadeAnimation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  int connState = -1;
  TextEditingController textEditingController = TextEditingController();
  
  Future<String> _serverHost() async {
    return Cache().get('host');
  }

  _checkConn() async {
    EasyLoading.show(status: 'Checking server...');
    Cache().set('host', textEditingController.text).then((value) {
      http.get(Uri.parse("${textEditingController.text}/ping")).then((http.Response response) {
        EasyLoading.dismiss();
        setState(() {
          connState = 1;
        });
      }).onError((Object error, StackTrace stackTrace) {
        EasyLoading.dismiss();
        setState(() {
          connState = 0;
        });
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
      body: SingleChildScrollView(
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
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
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
                            controller: textEditingController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "服务器地址",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                icon: const Icon(FontAwesomeIcons.server),
                                suffixIcon: connState == -1
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
                  FadeAnimation(2, Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, 0.6),
                            ]
                        )
                    ),
                    child: const Center(
                      child: Text("登  录", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),),
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
    );
  }
}
