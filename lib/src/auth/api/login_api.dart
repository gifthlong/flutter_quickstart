import 'dart:convert';

import 'package:flutter_quick_start/src/core/api/base_api.dart';
import 'package:flutter_quick_start/src/core/core.dart';
import 'package:flutter_quick_start/src/core/exception/exceptions.dart';
import 'package:flutter_quick_start/src/core/storage/token_storage.dart';
import 'package:http/http.dart';

class LoginApi extends BaseApi {
  LoginApi({BaseClient baseClient, TokenStorage tokenStorage})
      : super(baseClient: baseClient, tokenStorage: tokenStorage);

  Future<String> authenticate({String username, String password}) async {
    if (username == 'error') {
      throw ApiException(message: 'Error: 400', causedBy: 'bad username');
    }
    try {
      Response response = await super.httpPost(
        '${sl<AppConfig>().apiBaseUrl}/api/login',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': username, // valid email for testing: eve.holt@reqres.in
          'password': password,
        }),
      );

      var body = jsonDecode(response.body);
      // Maybe parse to some kind of class representing the full response body
      return body['token'];
    } on HttpException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 401 || e.statusCode == 403) {
        // possible status codes for invalid credentials
        return null;
      } else {
        throw ApiException(message: 'unexpected response', causedBy: e);
      }
    } catch (e) {
      throw ApiException(message: 'something bad happened', causedBy: e);
    }
  }
}
