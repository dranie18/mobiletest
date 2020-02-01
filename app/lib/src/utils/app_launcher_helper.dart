/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 31/1/2020
 */

import 'package:url_launcher/url_launcher.dart';

class AppLauncherHelper {
  static Future<bool> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    }
    return false;
  }

  static Future<bool> launchWhatsApp(String phoneNumber) async =>
      _launchUrl('whatsapp://send?phone=$phoneNumber');

  static Future<bool> launchCallApp(String phoneNumber) async =>
      _launchUrl('tel: //$phoneNumber');

  static Future<bool> launchMailApp(String email) async =>
      _launchUrl('mailto:$email');
}
