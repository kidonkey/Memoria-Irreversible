import peasy.*;
PeasyCam cam;
Document doc;
Changelog changelog;
String f = "41"; // outlawed: 43,45,50*,58

void setup() {
  size(600, 600,P3D);
  cam = new PeasyCam(this, 800);
  background(255);
  pixelDensity(2);
  smooth();
  String path = "../changelogs/" + f + ".csv";
  changelog = new Changelog(path);
  doc = new Document();
}

void draw() {
  background(255);
  rotate(PI);
  //println(doc.toString());
  doc.display();
  if (frameCount < 2000 && changelog.t < changelog.log.length) {
    String[] burst = changelog.getNextBurst();
    doc.indel(burst);
    //println("TREE: \"" + doc.structure() + "\"");
  } else if (frameCount == 2000 || changelog.t > changelog.log.length) {
    println("SURFACE:");
    doc.toString();
    println("DONE:", changelog.t*100/changelog.log.length + "%");
  }
  
}