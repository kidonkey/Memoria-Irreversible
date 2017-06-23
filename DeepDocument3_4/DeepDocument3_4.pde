import processing.pdf.*;

import peasy.*;
PeasyCam cam;
Document doc;
Changelog changelog;
String f = "41"; // outlawed: 43,45,46,50*,58
boolean pause = false;
float k = .2;
int SCALE = 1;
float SUN = .5;
boolean showChars = false;
color[] SESSION = {color(0,20,200), color(0,200,20), color(200,100,0)};

void setup() {
  size(600, 600,P3D);
  cam = new PeasyCam(this, 800);
  cam.setMinimumDistance(80);
  cam.setMaximumDistance(2500);
  background(255);
  pixelDensity(2);
  smooth();
  textMode(SHAPE);
  String path = "../changelogs/" + f + ".csv";
  changelog = new Changelog(path);
  doc = new Document();
}

void draw() {
  background(255);
  rotate(PI);
  //println(doc.toString());
  doc.display(k);
  if (!pause && changelog.t < changelog.log.length) {
    String[] burst = changelog.getNextBurst();
    doc.indel(burst);
    //println("TREE: \"" + doc.structure() + "\"");
  } else if (changelog.t > changelog.log.length) {
    println("SURFACE:");
    doc.toString();
    println("DONE:", changelog.t*100/changelog.log.length + "%");
  }
  if (keyPressed && keyCode == UP) {
    SUN = constrain(SUN+.01,0,1);
  } else if (keyPressed && keyCode == DOWN) {
    SUN = constrain(SUN-.01,0,1);
  }
  if (keyPressed && keyCode == RIGHT) {
    k = constrain(k+.002,0,3);
  } else if (keyPressed && keyCode == LEFT) {
    k = constrain(k-.002,0,3);
  }
}
void keyReleased() {
  if (key == 32) {
    pause = !pause;
    println("DONE:", (float) changelog.t*100/changelog.log.length + "%");
  } if (key == ENTER) showChars = !showChars;
  if (key == 'p') save(f + ".png");
}