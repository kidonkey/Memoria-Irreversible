String text;
float completed;
int border = 10;
int x = border;
int y = border;
int rows = 0;
Changelog changelog;

void setup() { 
  size(800,600);
  pixelDensity(2);
  background(255);
  changelog = new Changelog("../changelogs/48.csv");
}

void draw() {
  completed = frameCount*100/changelog.changes;
  if (frameCount%100==0) {
    println("Frame "+frameCount);
    println(completed + "% completed");
  }
  translate(0,rows*60);
  String[] log = changelog.getNext();
  if (log[2].equals("insert")) {
    
    strokeWeight((float) Math.sqrt(log[4].length()/PI));
    stroke(0,0,255,50);
    point(x,y);
    y++;
  }
  if (log[2].equals("delete")) {
    int l = Integer.parseInt(log[4])-Integer.parseInt(log[3]);
    strokeWeight((float) Math.sqrt(l/PI));
    stroke(255,0,0,50);
    point(x,y);
    x += 2;
    y = border;
  }
  if (x >= width-border) {
    x = border;
    rows++;
  }
} 