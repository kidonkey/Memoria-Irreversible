/*
*/
PrintWriter output;
JSONArray changes;
String[] lines;
String text;
float completed;
Changelog changelog;

void setup() { 
  size(800,600);
  pixelDensity(2);
  background(255);
  changelog = new Changelog("../changelogs/43.csv");
  text = "";
  
}

void draw() {
  completed = frameCount*100/changelog.changes;
  if (frameCount%100==0) {
    println("Frame "+frameCount);
    println(completed + "% completed");
  }
  if (frameCount < changelog.changes) {
    int i = frameCount-1;
    String[] log = changelog.getNext();
    text = changelog.getState();
    pushMatrix();
    translate(width/2-map(text.length(),0,6000,0,width)/2,0);
    
    float l = map(text.length(),0,6000,0,width);
    float y = height-map(i,0,changelog.changes,0,height);
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
    float y = height-map(time,0,changelog.changes,0,height);
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