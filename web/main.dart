import '../lib/services/irc.service.dart';
import 'package:angular2/core.dart';
import 'package:angular2/platform/browser.dart';
import 'package:matirc/app.component.dart';

void main() {
  bootstrap(AppComponent, [
    provide("IRC_HOST", useValue: "irc.sub-r.de"),
    provide("IRC_PORT", useValue: 6669),
    
    IrcService,
  ]);
}