import 'package:angular2/core.dart';
import 'services/irc.service.dart';

@Component(
    selector: 'my-app',
    providers: const [IrcService],
    templateUrl: 'app.component.html'
)
class AppComponent {
  IrcService ircService;
  List<dynamic> messages = new List<dynamic>();

  AppComponent(IrcService ircService) {
    this.ircService = ircService;

    ircService.onMessage.listen((message) {
      messages.add(message);
    });

    ircService.connect("testrinu");
  }
}