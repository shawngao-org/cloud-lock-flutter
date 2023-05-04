import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import 'layout.dart';
import 'main.dart';

const users = {
  'shawngao@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

// "733013771840-ismdoe650p2i4aqvt9pirn8turmbill6.apps.googleusercontent.com"
// "AIzaSyCjJJ31hL1eEdf1TRV7eTTi1V2D_-zS1Oo"

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return '用户不存在';
      }
      if (users[data.name] != data.password) {
        return '密码不正确';
      }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('注册名称: ${data.name}, 密码: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('用户名: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return '用户不存在';
      }
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '门禁管理',
      logo: const AssetImage('assets/images/login-logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      messages: LoginMessages(
        passwordHint :  '密码',
        confirmPasswordHint :  '确认密码',
        forgotPasswordButton :  '忘记了密码?',
        loginButton :  '登 录',
        signupButton :  '注册',
        recoverPasswordButton :  '恢复密码',
        recoverPasswordIntro :  '在这里重置您的密码',
        recoverPasswordDescription :
        '我们会将您的纯文本密码发送到此电子邮件帐户.',
        recoverCodePasswordDescription :
        '我们会将密码恢复代码发送到您的电子邮箱.',
        goBackButton :  '返回',
        confirmPasswordError :  '密码不匹配!',
        recoverPasswordSuccess :  '已发送电子邮件',
        flushbarTitleSuccess :  '成功',
        flushbarTitleError :  '错误',
        signUpSuccess :  '已发送激活链接',
        providersTitleFirst :  '或通过一下方式登录',
        providersTitleSecond :  '或者',
        additionalSignUpSubmitButton :  '提交',
        additionalSignUpFormDescription : '请填写此表格以完成注册',
        confirmRecoverIntro : '设置新密码的恢复代码已发送到您的电子邮箱.',
        recoveryCodeHint :  '恢复代码',
        recoveryCodeValidationError :  '恢复代码为空',
        setPasswordButton :  '设置密码',
        confirmRecoverSuccess :  '找回密码.',
        confirmSignupIntro : '确认码已发送至您的电子邮箱. '
            '请输入验证码以确认您的帐户.',
        confirmationCodeHint :  '验证码',
        confirmationCodeValidationError : '验证码为空',
        resendCodeButton :  '重新发送验证码',
        resendCodeSuccess :  '已发送一封新电子邮件.',
        confirmSignupButton :  '确认',
        confirmSignupSuccess :  '帐户已确认.',
      ),
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            debugPrint('start google sign in');
            await Future.delayed(loginTime);
            debugPrint('stop google sign in');
            return null;
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.facebookF,
          label: 'Facebook',
          callback: () async {
            debugPrint('start facebook sign in');
            await Future.delayed(loginTime);
            debugPrint('stop facebook sign in');
            return null;
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.githubAlt,
          label: 'Github',
          callback: () async {
            debugPrint('start github sign in');
            await Future.delayed(loginTime);
            debugPrint('stop github sign in');
            return null;
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MyHomePage(title: appName),
        ));
      },
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        primaryColor: const Color(0xff5859f1)
      ),
    );
  }
}