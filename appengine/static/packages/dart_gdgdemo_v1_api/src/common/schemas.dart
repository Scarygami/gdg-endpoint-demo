part of gdgdemo_v1_api_client;

/** One Guestbook entry */
class ApiEntry {
  String author;
  String date;
  int id;
  String text;

  /** Create new ApiEntry from JSON data */
  ApiEntry.fromJson(Map json) {
    if (json.containsKey("author")) {
      author = json["author"];
    }
    if (json.containsKey("date")) {
      date = json["date"];
    }
    if (json.containsKey("id")) {
      id = json["id"];
    }
    if (json.containsKey("text")) {
      text = json["text"];
    }
  }

  /** Create JSON Object for ApiEntry */
  Map toJson() {
    var output = new Map();

    if (author != null) {
      output["author"] = author;
    }
    if (date != null) {
      output["date"] = date;
    }
    if (id != null) {
      output["id"] = id;
    }
    if (text != null) {
      output["text"] = text;
    }

    return output;
  }

  /** Return String representation of ApiEntry */
  String toString() => JSON.stringify(this.toJson());

}

/** List of Guestbook entries */
class ApiEntryList {

  /** One Guestbook entry */
  List<ApiEntry> items;

  /** Create new ApiEntryList from JSON data */
  ApiEntryList.fromJson(Map json) {
    if (json.containsKey("items")) {
      items = [];
      json["items"].forEach((item) {
        items.add(new ApiEntry.fromJson(item));
      });
    }
  }

  /** Create JSON Object for ApiEntryList */
  Map toJson() {
    var output = new Map();

    if (items != null) {
      output["items"] = new List();
      items.forEach((item) {
        output["items"].add(item.toJson());
      });
    }

    return output;
  }

  /** Return String representation of ApiEntryList */
  String toString() => JSON.stringify(this.toJson());

}

