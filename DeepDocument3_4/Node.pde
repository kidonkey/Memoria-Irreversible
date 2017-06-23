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
  int session;

  Node(int i, String[] log, int _session) {
    id = i;
    timestamp = Long.parseLong(log[1]);
    session = _session;
    println("TIMESTAMP:", timestamp);
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
          if (n.s.length() > 0) {
            Link l = new Link(n, 0);
            links[x] = l;
            n.parents.add(this);
            break;
          } else {
            //s += n.s; // TODO malloooo
            //Link[] links2 = new Link[s.length() + 2];
            //for (int j = 0; j < links2.length; j++) {
            //  if (j != x) links2[j] = links[j];
            //  else j++;
            //}
            //links = links2;
          }
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
  void display(float a, float t, float k, float v) {
    int border = 5*SCALE;
    //float k = .2;
    float l = links.length;
    float r = 20*SCALE; // log(timestamp-parents.get(0).timestamp+2)
    //println(r);
    float d = k/r;
    float angle = l*d;
    while (angle >= PI) {
      r = r*2;
      d = k/r;
      angle = l*d;
    }
    strokeWeight(1);
    translate(0, t);
    if (abs(v) > PI) v = v - TWO_PI; 
    rotate(-angle/2 - v * SUN); // a-symmetric tilt
    v += -angle/2 - v * SUN;
    for (int i = 0; i < links.length; i++) {
      if (i == 0) line(0, 0, 0, r); // start line
      if (links[i] == null) { 
        stroke(SESSION[session%SESSION.length],30);
        line(0, r-border, 0, r);
      } else {
        try {
          pushMatrix();
          if (showChars && isInsert && i != links.length-1) {
            pushMatrix();
            //translate(0,20);
            rotateZ(PI/2);
            //rotateX(PI/2);
            fill(0);
            textSize(.5);
            text(s.charAt(i), 0, 20);
            popMatrix();
          }
          links[i].display(0, r, k, v);
          popMatrix();
        } 
        catch (Exception e) {
        }
      }
      rotate(d);
      v += d;
    }
  }
}