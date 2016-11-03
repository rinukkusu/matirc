import 'package:angular2/core.dart';
import 'package:irc/client.dart';
import 'services/irc.service.dart';

@Component(
    selector: 'my-app',
    providers: const [IrcService],
    templateUrl: 'app.component.html'
)
class AppComponent {
  IrcService ircService;
  List<MessageEvent> messages = new List<MessageEvent>();

  AppComponent(IrcService ircService) {
    this.ircService = ircService;

    ircService.onMessage.listen((MessageEvent message) {
      messages.add(message);
    });

    ircService.connect("testrinu", ["#dev"]);
  }
}