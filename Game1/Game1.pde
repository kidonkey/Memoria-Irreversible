String text;
float completed;
int edge = 10;
int x = edge;
int y = edge;
int rows = 0;
float sizeFactor = 2;
String previous = "insert";
Changelog changelog;
String n = "43";
String path = "../changelogs/"+n+".csv";


void setup() { 
  size(800,600, P2D);
  smooth();
  pixelDensity(2);
  background(255);
  changelog = new Changelog(path);
}

void draw() {
  completed = frameCount*100/changelog.changes;
  if (frameCount%100==0) {
    println("Frame "+frameCount);
    println(completed + "% completed");
  }
  if (completed >= 100 || rows > 10) {
    saveFrame("pictures/"+n+".png");
    noLoop();
  }
  translate(0,rows*60);
  String[] log = changelog.getNext();
  if (log[2].equals("insert")) {
    if (previous.equals("delete")) {
      x += 2;
      y = edge;
    }
    strokeWeight((float) Math.sqrt(log[4].length()/PI)*sizeFactor);
    stroke(0,0,255,50);
    point(x,y);
    y++;
    previous = "insert";
  }
  if (log[2].equals("delete")) {
    if (previous.equals("insert")) {
      x += 2;
      y = edge;
    }
    int l = Integer.parseInt(log[4])-Integer.parseInt(log[3])+1;
    strokeWeight((float)Math.sqrt(l/PI)*sizeFactor);
    stroke(255,0,0,50);
    point(x,y);
    y++;
    previous = "delete";
  }
  if (x >= width-edge) {
    x = edge;
    rows++;
  }
} 