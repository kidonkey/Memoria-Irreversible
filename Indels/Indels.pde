/*
*/
PrintWriter output;
JSONArray changes;

void setup() { 
  size(1200,600);
  background(255);
  String lines[] = loadStrings("../data/54.txt");
  int index = lines[0].indexOf("changelog");
  String changelog = lines[0].substring(index+12);
  println(changelog);
  //String[][] insertion = matchAll(changelog, "\"ty\":\"is\",\"ibi\":(.*?),\"s\":\"(.*?)\".?+\\},(\\d{13}?)");
  String[][] indels = matchAll(changelog, "\"ty\":\"is\",\"ibi\":(\\d+),\"s\":\"(.*?)\"|\"ty\":\"ds\",\"si\":([0-9]+),\"ei\":([0-9]+)");
  for (int i = 0; i < 10; i++) {
    println(indels[i][0]+" "+indels[i][1]+" "+indels[i][2]+" "+indels[i][3]+" "+indels[i][4]);
  }
  int noIs = 0;
  int noDs = 0;
  for (int i = 0; i < indels.length; i ++) {
    float x = map(i,0,indels.length,0,width);
    if (indels[i][1] != null) { //insertions
      int start = Integer.parseInt(indels[i][1]);
      int fin = start + indels[i][2].length();
      float y1 = map(start,0,5000,0,height);
      float y2 = map(fin,0,5000,0,height);
      noIs++;
      stroke(0);
      line(x,height-y1,x,height-y2);
    } else { //deletions
      int start = Integer.parseInt(indels[i][3]);
      int fin = start + indels[i][4].length(); 
      float y1 = map(start,0,5000,0,height);
      float y2 = map(fin,0,5000,0,height);
      noDs++;
      stroke(255,0,0);
      line(x,height-y1,x,height-y2);
    }
  }
  println("Insertions: " + noIs);
  println("Deletions: " + noDs);
}

String insert(String original, String toInsert, int position){
  String p1 = original.substring(0,position);
  String p2 = original.substring(position);
  println(p1 + toInsert + p2);
  return p1 + toInsert + p2;
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