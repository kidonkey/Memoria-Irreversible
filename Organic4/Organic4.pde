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

void setup() { 
  size(400,400, P2D);
  smooth();
  pixelDensity(2);
  changelog = new Changelog(path);
  translate(50,50);
  String[] nextBurst = changelog.getNextBurst();
  println(nextBurst[4]);
  tree = new Node(null,nextBurst[4],PI/2,Integer.parseInt(nextBurst[3]));
  for (int i = 0; i < 4; i++) {
    nextBurst = changelog.getNextBurst();
    println(nextBurst[4]);
    tree.insert(nextBurst[4],Integer.parseInt(nextBurst[3]));
  }
  tree.display();
}

void draw() {
  //background(255);
  //translate(50,50);
  //rotate(PI/frameCount);
  //float x = 0;
  //float y = 0;
  //float r = 100;
  //arc(x, y, r, r, 0, PI/1.8, PIE);
}