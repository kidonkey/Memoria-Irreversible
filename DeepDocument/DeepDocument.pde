Document doc;
Changelog changelog;
String f = "41";

void setup() {
  size(600, 600);
  background(255);
  pixelDensity(2);
  smooth();
  String path = "../changelogs/" + f + ".csv";
  changelog = new Changelog(path);
  doc = new Document();
}

void draw() {
  background(255);
  //delay(500);
  translate(width/2, height);
  rotate(PI);
  println(doc.toString());
  doc.display();
  if (frameCount < 200) {
    translate(width/2, height);
    rotate(-PI/2);
    String[] burst = changelog.getNextBurst();
    doc.indel(burst);
    //println("TREE: \"" + doc.structure() + "\"");
  } else {
    println("SURFACE:");
    doc.nodes.get(0).surf();
    noLoop();
    println("DONE:", changelog.t*100/changelog.log.length + "%");
  }
}