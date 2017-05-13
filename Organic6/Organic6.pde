String text;
float completed;
int border = 10;
int x = border;
int y = border;
int rows = 0;
float sizeFactor = 2;
String previous = "insert";
Changelog changelog;
String n = "41";
String path = "../changelogs/" + n + ".csv";
Node tree;
String[] nextBurst;

void setup() { 
  size(400,400, P2D);
  smooth();
  pixelDensity(2);
  
  changelog = new Changelog(path);
  translate(width/2,height/2);
  rotate(-PI/2);
  
  nextBurst = changelog.getNextBurst();
  println(nextBurst[4]);
  tree = new Node(null,nextBurst[4],Integer.parseInt(nextBurst[3]));
}

void draw() {
  background(199);
  delay(200);
  translate(width/2,height/2);
  rotate(-PI/2);
  
  if (changelog.t < 1600) {
    nextBurst = changelog.getNextBurst();
    if (nextBurst[2].equals("insert")) {
      //tree.insert(nextBurst[4],Integer.parseInt(nextBurst[3]));
    } else {
      //tree.delete(Integer.parseInt(nextBurst[3]),Integer.parseInt(nextBurst[4]));
    }
  }
  tree.display();
}