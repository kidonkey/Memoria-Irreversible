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
  float posX;
  float posY;

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
      if (i != 0) {
        y += s.substring(i-1, i);
      }
      if (links[i] != null) {
        y += links[i].toString();
      } else {
        continue;
      }
    }
    return y + "}";
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
  void surf() {
    // comes from surface
    surf(0);
  }
  void surf(int x) {
    for (int i = x; i < links.length; i++) {
      if (links[i] != null) {
        links[i].node.surf();
        break;
      } else if (i == links.length-1) {
        parents.get(parents.size()-1).drop(this);
        break;
      } else if (links.length > 0 && i != links.length-1) print(s.substring(i, i+1));
    }
  }
  void drop(Node n) {
    int i;
    for (i = links.length-1; i >= 0; i--) {
      if (links[i] != null && links[i].node.equals(n)) break;
    }
    if (links.length > 0 && i != links.length-1) print(s.substring(i, i+1));
    surf(i+1);
  }
  void display(float x, float y, float a, float t, float k, float v) {
    posX = x;
    posY = y;
    if (show) {
      int border = 5*SCALE;
      float l = links.length;
      float r = 20*SCALE;
      float d = k/r;
      float angle = l*d;
      while (angle >= PI) {
        r = r*2;
        d = k/r;
        angle = l*d;
      }
      strokeWeight(1);
      if (abs(v) > PI) v = v - TWO_PI; 
      float b = -angle/2 - v * SUN + a;
      v += -angle/2 - v * SUN;
      for (int i = 0; i < links.length; i++) {
        stroke(0,30);
        if (i == 0) line(x, y, x+r*cos(b+d*i), y+r*sin(b+d*i)); // start line
        if (links[i] == null) { 
          stroke(SESSION[session%SESSION.length],30);
          line(x+(r-5)*cos(b+d*i), y+(r-5)*sin(b+d*i), x+r*cos(b+d*i), y+r*sin(b+d*i));
        } else {
          links[i].display(x+r*cos(b+d*i),y+r*sin(b+d*i),b+d*i, r, k, v);
        }
        v += d;
      }
    }
  }
  void click(int mx, int my) {
    if (abs(mx + posX) < 5 && abs(my - posY) < 5) show = !show;
    else {
      for (int i = 0; i < links.length; i++) {
        if (links[i]!=null) links[i].click(mx,my);
      }
    }
  }
}