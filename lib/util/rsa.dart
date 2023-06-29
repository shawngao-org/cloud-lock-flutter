import 'dart:convert';

import 'package:cloud_lock/data/api_router.dart';
import 'package:cloud_lock/db/sqlite/cache.dart';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/api.dart';

class Rsa {

  String pubKeyHead = "-----BEGIN PUBLIC KEY-----\n";
  String pubKeyEnd = "\n-----END PUBLIC KEY-----\n";

  Future<String> encrypt(String source, context) async {
    final host = await Cache().get('host');
    http.Response res = await http.get(Uri.parse(host + ApiRouter.getRsaPubKey));
    final pubKey = pubKeyHead + jsonDecode(res.body)['message'] + pubKeyEnd;
    final encrypter = Encrypter(RSA(publicKey: RSAKeyParser().parse(pubKey) as RSAPublicKey));
    return encrypter.encrypt(source).base64;
  }
}
