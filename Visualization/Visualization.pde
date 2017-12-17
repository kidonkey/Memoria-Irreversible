//TODO dibujar en el círculo gris la medida (la hora en caracteres), tiene que ser dinámica y considerar todos los glifos.
import peasy.*;
PeasyCam cam;
Document doc;
Changelog changelog;
String f = "41"; // outlawed: 45,46,50,54*,58
boolean pause = false;
float k = .2;
int SCALE = 1;
float SUN = .5;
//color[] SESSION = {color(243, 147, 69),color(86, 192, 176), color(15,98,93), color(34,113,180), color(40,36,91)};
color[] SESSION = {color(187, 47, 134), color(251, 100, 200), color(92, 149, 162), color(147, 197, 190), color(202, 79, 27), color(220, 145, 27), color(35, 77, 126), color(58, 117, 181)};
boolean SHOW = false;
boolean showText = true;
boolean crosshairs = true;
boolean showDead = true;
String cache = "";
void setup() { 
  //size(800, 800, P3D);
  fullScreen(P3D);
  smooth(8);
  background(255);
  pixelDensity(2);
  String path = "../data_preprocessed/" + f + ".csv";
  changelog = new Changelog(path);
  doc = new Document();
  
  cam = new PeasyCam(this, 520);
  cam.setMinimumDistance(80);
  cam.setMaximumDistance(5000);
  PeasyDragHandler leftHandler = cam.getPanDragHandler();
  cam.setLeftDragHandler(leftHandler);
}

void draw() {
  background(255);
  //translate(width/2,height/2);
  //rotate(-PI/2);
  cam.beginHUD();
  fill(60);
  textSize(12);
  if (showText) text(cache,12,12,width/2,height);
  if (crosshairs) drawCrosshairs();
  cam.endHUD();
  rotate(-PI/2);
  doc.display(k);

  if (!pause && changelog.t < changelog.log.length) {
    String[] burst = changelog.getNextBurst();
    doc.indel(burst);
  } else if (changelog.t > changelog.log.length) {
  }
  if (keyPressed && keyCode == UP) {
    SUN = constrain(SUN+.01, 0, 1);
  } else if (keyPressed && keyCode == DOWN) {
    SUN = constrain(SUN-.01, 0, 1);
  }
  if (keyPressed && keyCode == RIGHT) {
    k = constrain(k+.002, 0, 3);
  } else if (keyPressed && keyCode == LEFT) {
    k = constrain(k-.002, 0, 3);
  }

  //cam.lookAt((double)doc.nodes.get(doc.nodes.size()-1).posX, (double)doc.nodes.get(doc.nodes.size()-1).posY, (double)frameCount);
}
void drawCrosshairs() {
  int l = 10;
  translate(width/2, height/2);
  stroke(0, 127);
  line(-l, 0, l, 0);
  line(0, -l, 0, l);
  translate(-width/2, -height/2);
}
void keyReleased() {
  if (key == 32) {
    pause = !pause;
    println("SURFACE:\n", doc.surf(0));
    println("DONE:", (float) changelog.t*100/changelog.log.length + "%");
  }
  if (keyCode == BACKSPACE) {
    String [] a = {doc.toString()};
    saveStrings(f+".txt", a);
  }
  if (keyCode == ENTER) SHOW = !SHOW;
  if (key == 'p') save(f + ".png");
  if (key == 'c') crosshairs = !crosshairs;
  if (key == 't') showText = !showText;
  if (key == 'd') showDead = !showDead;
}
void mouseClicked() {
  float[] pos = cam.getPosition();
  float[] lookAt = cam.getLookAt();
  doc.nodes.get(0).deselect();
  Node n = doc.click(mouseY+pos[1]-height/2, mouseX+pos[0]-width/2);
  if (n != null) {
    if (mouseButton == RIGHT) n.show = !n.show;
    n.select();
    showText = true;
    cache = n.surf();
    println(cache);
  } else {
    cache = "";
  }
  println(cam.getPosition()[0], cam.getPosition()[1], mouseX, mouseY, lookAt[0], lookAt[1]);
}