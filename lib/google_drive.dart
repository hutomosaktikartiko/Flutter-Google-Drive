import 'dart:io';

import 'package:flutter_drive/secure_storage.dart';
import 'package:flutter_drive/value.dart';
import 'package:googleapis/drive/v3.dart' as gd;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

const scopes = [gd.DriveApi.DriveFileScope];

class GoogleDrive {
  final storage = SecureStorage();
  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      //Needs user authentication
      var authClient = await clientViaUserConsent(
          ClientId(clientId, clientSecret), scopes, (url) {
        //Open Url in Browser
        launch(url);
      });
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken);
      return authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])),
              credentials["refreshToken"],
              scopes));
    }
  }

  //Upload File
  Future upload(File file) async {
    var client = await getHttpClient();
    var drive = gd.DriveApi(client);

    var response = await drive.files.create(
        gd.File()..name = path.basename(file.absolute.path),
        uploadMedia: gd.Media(file.openRead(), file.lengthSync()));

    print(response.toJson());
  }
}
