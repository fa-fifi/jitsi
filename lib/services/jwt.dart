import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitsi/utils/constants.dart';

class JwtService {
// RSA SHA-256 algorithm
  static Future<String> rs256(
      {required String name, required String email}) async {
    final pem = await rootBundle.loadString('assets/jaasauth.pk');

    final jwt = JWT({
      "aud": "jitsi",
      "iss": "chat",
      "sub": jitsiAppID,
      "context": {
        "features": {
          "livestreaming": true,
          "outbound-call": true,
          "sip-outbound-call": false,
          "transcription": true,
          "recording": true,
        },
        "user": {
          "hidden-from-recorder": false,
          "moderator": false,
          "name": name,
          "id": "google-oauth2|105725062313043518546",
          "avatar": "",
          "email": email,
        }
      },
      "room": "*"
    }, header: {
      "kid": "$jitsiAppID/$jitsiKeyID",
      "typ": "JWT",
      "alg": "RS256",
    });

    final token = jwt.sign(RSAPrivateKey(pem),
        algorithm: JWTAlgorithm.RS256, expiresIn: const Duration(days: 1));

    debugPrint('Signed token: $token\n');

    return token;
  }
}
