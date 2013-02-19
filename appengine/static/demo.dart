import "dart:html";
import "package:dart_gdgdemo_v1_api/gdgdemo_v1_api_browser.dart" as gdglib;
import "package:google_plus_v1_api/plus_v1_api_browser.dart" as pluslib;
import "package:google_oauth2_client/google_oauth2_browser.dart";

final CLIENT_ID = "817861005374.apps.googleusercontent.com";
final SCOPES = ["https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/plus.me"];

void main() {
  var auth = new GoogleOAuth2(CLIENT_ID, SCOPES);
  var gdg = new gdglib.Gdgdemo(auth);
  var plus = new pluslib.Plus(auth);
  var container = query("#entries");
  var loginButton = query("#login");
  var sendButton = query("#send");
  InputElement textInput = query("#text");
  var authorSpan = query("#author");
  pluslib.Person me;

  void fetch() {
    gdg.makeAuthRequests = false;
    gdg.entries.list(sortOrder: "oldest").then((l) {
      container.text = "";
      if (l.items != null) {
        l.items.forEach((e) {
          var p = new ParagraphElement();
          var date = e.date.replaceAll("T", " ");
          p.text = "$date - ${e.author}: ${e.text}";
          container.append(p);
        });
      }
    });
  }
  
  loginButton.onClick.listen((Event e) {
    auth.login().then((token) {
      loginButton.style.display = "none";
      plus.makeAuthRequests = true;
      plus.people.get("me").then((p) {
        me = p;
        authorSpan.text = "${me.displayName}:";
        authorSpan.style.display = "inline-block";
        textInput.style.display = "inline-block";
        sendButton.style.display = "inline-block";
        
        sendButton.onClick.listen((Event e) {
          var text = textInput.value;
          textInput.value = "";
          var entry = new gdglib.ApiEntry.fromJson({
            "author": me.displayName,
            "text": text
          });
          gdg.makeAuthRequests = true;
          gdg.entries.insert(entry).then((entry) {
            fetch();
          });
        });
      });
    });
  });
  
  fetch();
}
