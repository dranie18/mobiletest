/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 31/1/2020
 */

import 'package:url_launcher/url_launcher.dart';

class AppLauncherHelper {

  static Future<bool> launchWhatsApp(String phoneNumber) async {
    final url = 'whatsapp://send?phone=$phoneNumber';
    final _canLaunch = await canLaunch(url);
    if (_canLaunch) {
      await launch(url);
      return true;
    }
    return false;
  }

  static Future<bool> launchCallApp(String phoneNumber) async {
    final url = 'tel: //$phoneNumber';
    final _canLaunch = await canLaunch(url);
    if (_canLaunch) {
      await launch(url);
      return true;
    }
    return false;
  }
}