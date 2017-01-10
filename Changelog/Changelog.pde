/*
*/
PrintWriter output;

void setup() { 
  JSONObject json = getJson("json1.txt");
  JSONObject changelog = json.getJSONObject("changelog");
  print(changelog.getString("is"));
  exit();
}

String[] getData(String json) {
  String[] match = match(json, "{},(.*?)");
  return match;
}