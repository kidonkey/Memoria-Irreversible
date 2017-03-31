/*
*/
PrintWriter output;
JSONArray changes;
String[] lines;
String text;
float completed;

void setup() { 
  size(800,600);
  pixelDensity(2);
  background(255);
  lines = loadStrings("../changelogs/43.csv");
  text = "";
}

void draw() {
  completed = frameCount*100/lines.length;
  if (frameCount%100==0) {
    println("Frame "+frameCount);
    println(completed + "% completed");
  }
  if (frameCount < lines.length) {
    int i = frameCount-1;
    String[] log = match(lines[i], "(\\d+),([a-z]+),(\\d+),(.*+)");
    text = applyChange(text,log);
    pushMatrix();
    translate(width/2-map(text.length(),0,6000,0,width)/2,0);
    
    float l = map(text.length(),0,6000,0,width);
    float y = height-map(i,0,lines.length,0,height);
    stroke(0,2);
    strokeWeight(1);
    line(0,y,l,y);
    float x = map(Integer.parseInt(log[3]),0,6000,0,width);
    if(log[2].equals("insert")) {
      stroke(50,255,0);
    } else {
      stroke(255,0,0);
    }
    point(x,y);
    
    inscribe(text, ".\n", i, color(60));
    inscribe(text, ".", i, color(180));
    popMatrix();
  } else {
    noLoop();
  }
}

void inscribe(String text, String symbol, int time, int chroma) {
  int index = text.indexOf(symbol);
  int p = 0;
  while(index >= 0) {
    float x = map(p + index,0,6000,0,width);
    float y = height-map(time,0,lines.length,0,height);
    strokeWeight(.5);
    stroke(chroma);
    point(x,y);
    
    p += index + 1;
    index = text.substring(p).indexOf(symbol);
  }
}

void inscribeChar(String text, char symbol, int time, int chroma) {
  int index = text.indexOf(symbol);
  int p = 0;
  while(index >= 0) {
    float x = map(p + index,0,6000,0,width);
    float y = height-map(time,0,lines.length,0,height);
    strokeWeight(.5);
    stroke(chroma);
    point(x,y);
    
    p += index + 1;
    index = text.substring(p).indexOf(symbol);
  }
}


String applyChange(String text, String[] log) {
  String timestamp = log[1]; //<>//
  String type = log[2];
  int ibi = Integer.parseInt(log[3]);
  String info = log[4];
  if (type.equals("insert")) {
    info = info.substring(1,log[4].length()-1);
    //println(separateLines(info));
    text = text.substring(0,ibi - 1) + separateLines(info) + text.substring(ibi - 1,text.length());
  } else {
    int end = Integer.parseInt(info);
    text = text.substring(0,ibi-1) + text.substring(end,text.length());
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