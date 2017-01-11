/*
Parsea a un jon el archivo
*/
PrintWriter output;
JSONArray changes;

void setup() { 
  JSONArray changes = new JSONArray();
  String lines[] = loadStrings("json.txt");
  int index = lines[0].indexOf("changelog");
  String changelog = lines[0].substring(index+12);
  //println(changelog);
  //String[][] insertion = matchAll(changelog, "\"ty\":\"is\",\"ibi\":(.*?),\"s\":\"(.*?)\".?+\\},(\\d{13}?)");
  String[][] indels = matchAll(changelog, "\"ty\":\"is\",\"ibi\":(\\d+),\"s\":\"(.*?)\"|\"ty\":\"ds\",\"si\":([0-9]+),\"ei\":([0-9]+)");
  for (int i = 0; i < 100; i++) {
    println(indels[i][0]+"\n "+indels[i][1]+" "+indels[i][2]+" "+indels[i][3]+" "+indels[i][4]);
  }
  
  exit();
}

String[] splitChangelog(String changelog) {
  StringList split = new StringList();
  int start = 0;
  int counter = 0;
  for(int i = 0; i < changelog.length(); i++) {
    char now = changelog.charAt(i);
    if(now == '[') {
      if (counter == 0) {
        start = i+1;
      }
      counter++;
    }
    if(now == ']') {
      counter--;
      if (counter == 0) {
        split.append(changelog.substring(start+1,i+1));
      }
    }
  }
  return split.array();
}

String[] getData(String json) {
  String[] match = match(json, "{},(.*?)");
  return match;
}