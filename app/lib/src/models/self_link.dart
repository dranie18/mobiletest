/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

class SelfLink {
  final String href;

  SelfLink(this.href) : assert(href != null);

  factory SelfLink.noLink() => SelfLink('');
}
