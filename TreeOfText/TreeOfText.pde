/*
*/
PrintWriter output;
JSONArray changes;
String[] lines;
String text;

void setup() { 
  size(800,600);
  background(255);
  lines = loadStrings("../changelogs/42.csv");
  text = "";
}

void draw() {
  println("*****frame "+frameCount);
  if (frameCount < lines.length) {
    int i = frameCount;
    String[] log = match(lines[i], "(\\d+),([a-z]+),(\\d+),(.*+)");
    text = applyChange(text,log);
    inscribe(text, ".", i);
    println(text);
  }
}

void inscribe(String text, String symbol, int time) {
  int index = text.indexOf(symbol);
  int p = 0;
  while(index >= 0) {
    float x = map(p + index,0,6000,0,width);
    float y = height-map(time,0,lines.length,0,height);
    stroke(50);
    point(x,y);
    
    p += index + 1;
    index = text.substring(p).indexOf(symbol);
  }
}

String applyChange(String text, String[] log) {
  String timestamp = log[1];
  String type = log[2];
  int ibi = Integer.parseInt(log[3]);
  String info = log[4];
  if (type.equals("insert")) {
    info = info.substring(1,log[4].length()-1);
    //println(separateLines(info));
    text = text.substring(0,ibi - 1) + separateLines(info) + text.substring(ibi - 1,text.length());
  } else {
    int end = Integer.parseInt(info);
    print(text.length()+" "+ibi+" "+end);
    text = text.substring(0,ibi - 1) + text.substring(end,text.length());
  }
  return text;
}

String separateLines(String s) {
  int i = s.indexOf("\\n");
  int p = 0;
  while (i >= 0) { //<>//
    s = s.substring(0,p+i)+'\n'+s.substring(p+i+2,s.length());
    p = i;
    i = s.substring(i).indexOf("\\n");
  }
  return s;
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