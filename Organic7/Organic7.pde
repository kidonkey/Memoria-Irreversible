Tree tree;
Changelog changelog;
String f = "41";

void setup() {
  size(400,400);
  pixelDensity(2);
  smooth();
  String path = "../changelogs/" + f + ".csv";
  changelog = new Changelog(path);
  tree = new Tree();
}

void draw() {
  background(190);
  translate(width/2,height/2);
  rotate(-PI/2);
  String[] burst = changelog.getNextBurst();
  tree.change(burst);
  
  println("TREE: \"" + tree.structure() + "\"");
}