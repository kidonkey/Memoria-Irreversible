import java.util.*;

class Node {
  int id;
  String s;
  Link[] links;
  ArrayList<Node> parents;
  int ibi;
  int dei;
  long timestamp;
  boolean isInsert;
  boolean visited;
  boolean show;
  int session;
  float x;
  float y;

  Node(int i, String[] log, int _session) {
    id = i;
    timestamp = Long.parseLong(log[1]);
    session = _session;
    show = true;
    if (log[2].equals("insert")) isInsert = true;
    else isInsert = false;
    ibi = Integer.parseInt(log[3]);
    parents = new ArrayList<Node>();
    if (isInsert) {
      s = log[4];
      links = new Link[s.length() + 1];
    } else {
      dei = Integer.parseInt(log[4]);
      links = new Link[1];
    }
    visited = false;
  }
  String toString() {
    String y = "{" + str(id) + ":";
    for (int i = 0; i < links.length; i++) {
      if (i != 0) y += s.substring(i-1, i);
      if (links[i] != null) y += links[i].toString();
    }
    return y + "}";
  }
  String surf() {
    String y = "";
    if (show) {
      for (int i = 0; i < links.length; i++) {
        if (i != 0) y += s.substring(i-1, i);
        if (links[i] != null) y += links[i].surf();
      }
    }
    return y;
  }
  int delete(Node n, int c) {
    visited = true;
    for (int x = 0; x < links.length; x++) {
      if (links[x] != null && !links[x].node.visited) c = links[x].node.delete(n, c);
      else if (links[x] == null) {
        c++;
        if (c >= n.ibi && c <= n.dei) {
          Link l = new Link(n, c-n.ibi);
          links[x] = l;
          n.parents.add(this);
        }
      }
    }
    return c;
  }
  int insert(Node n, int c) {
    visited = true;
    for (int x = 0; x < links.length; x++) {
      if (links[x] != null && !links[x].node.visited) c = links[x].node.insert(n, c);
      else if (links[x] == null) {
        c++;
        if (c == n.ibi) {
          Link l = new Link(n, 0);
          links[x] = l;
          n.parents.add(this);
          break;
        }
      }
    }
    return c;
  }
  void prepare() {
    // TODO calcular los campos de Node antes de display
  }
  void display(float _x, float _y, float a, float t, float k, float v) {
    x = _x;
    y = _y;
    if (isInsert && SHOW) {
      fill(0,100);
      translate(x-5,y);
      textSize(3);
      rotate(PI/2);
      text(id,0,0);
      rotate(-PI/2);
      translate(-x+5,-y);
    }
    float l = links.length;
    float r = 20*SCALE;
    float d = k/r;
    float angle = l*d;
    while (angle >= PI) {
      r = r*2;
      d = k/r;
      angle = l*d;
    }
    if (show) {
      strokeWeight(1);
      if (abs(v) > PI) v = v - TWO_PI; 
      float b = -angle/2 - v * SUN + a;
      v += -angle/2 - v * SUN;
      for (int i = 0; i < links.length; i++) {
        stroke(0,30);
        if (i == 0) line(x, y, x+r*cos(b+d*i), y+r*sin(b+d*i)); // start line
        if (links[i] == null) { 
          stroke(SESSION[session%SESSION.length],127);
          line(x+(r-5)*cos(b+d*i), y+(r-5)*sin(b+d*i), x+r*cos(b+d*i), y+r*sin(b+d*i));
        } else {
          links[i].display(x+r*cos(b+d*i),y+r*sin(b+d*i),b+d*i, r, k, v);
        }
        v += d;
      }
    } else{ 
      fill(220,20,90,127);
      noStroke();
      ellipse(x,y,5,5);
    }
  }
  Node click(float mx, float my) {
    if (abs(mx + x) < 4 && abs(my - y) < 4) return this;
    else return null;
  }
}