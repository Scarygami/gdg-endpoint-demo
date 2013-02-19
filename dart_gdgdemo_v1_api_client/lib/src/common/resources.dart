part of gdgdemo_v1_api_client;

class EntriesResource extends Resource {

  EntriesResource(Client client) : super(client) {
  }

  /**
   * Insert a new entry to the database
   *
   * [request] - ApiEntry to send in this request
   *
   * [optParams] - Additional query parameters
   */
  Future<ApiEntry> insert(ApiEntry request, {Map optParams}) {
    var completer = new Completer();
    var url = "entries/new";
    var urlParams = new Map();
    var queryParams = new Map();

    var paramErrors = new List();
    if (optParams != null) {
      optParams.forEach((key, value) {
        if (value != null && queryParams[key] == null) {
          queryParams[key] = value;
        }
      });
    }

    if (!paramErrors.isEmpty) {
      completer.completeError(new ArgumentError(paramErrors.join(" / ")));
      return completer.future;
    }

    var response;
    response = _client.request(url, "POST", body: request.toString(), urlParams: urlParams, queryParams: queryParams);
    response
      .then((data) => completer.complete(new ApiEntry.fromJson(data)))
      .catchError((e) { completer.completeError(e); return true; });
    return completer.future;
  }

  /**
   * Request a list of Guestbook entries
   *
   * [maxResults]
   *   Default: 100
   *
   * [sortOrder]
   *   Default: newest
   *
   * [optParams] - Additional query parameters
   */
  Future<ApiEntryList> list({String maxResults, String sortOrder, Map optParams}) {
    var completer = new Completer();
    var url = "entries";
    var urlParams = new Map();
    var queryParams = new Map();

    var paramErrors = new List();
    if (maxResults != null) queryParams["maxResults"] = maxResults;
    if (sortOrder != null) queryParams["sortOrder"] = sortOrder;
    if (optParams != null) {
      optParams.forEach((key, value) {
        if (value != null && queryParams[key] == null) {
          queryParams[key] = value;
        }
      });
    }

    if (!paramErrors.isEmpty) {
      completer.completeError(new ArgumentError(paramErrors.join(" / ")));
      return completer.future;
    }

    var response;
    response = _client.request(url, "GET", urlParams: urlParams, queryParams: queryParams);
    response
      .then((data) => completer.complete(new ApiEntryList.fromJson(data)))
      .catchError((e) { completer.completeError(e); return true; });
    return completer.future;
  }
}

