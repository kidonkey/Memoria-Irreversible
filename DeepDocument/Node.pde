import java.util.*;

class Node {
  int id;
  String s;
  Link[] links;
  ArrayList<Node> parents;
  int ibi;
  int dei;
  long timestamp;
  boolean type;
  boolean visited;

  Node(int i, String[] log) {
    id = i;
    timestamp = Long.parseLong(log[1]);
    if (log[2].equals("insert")) type = true;
    else type = false;
    ibi = Integer.parseInt(log[3]);
    parents = new ArrayList<Node>();
    if (type) {
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
  void display(float a) {
    float angle = (float) links.length*PI/500/2;
    translate(0, 20);
    strokeWeight(1);
    rotate(-angle-a);
    for (int i = 0; i < links.length; i++) {
      
      rotate(PI/500);
      if (links[i] != null) {
        
        pushMatrix();
        
        links[i].display(angle*(float)(i+1)/links.length*2-angle);
        popMatrix();
      } else {
        stroke(0,5);
        line(0,0,0,20);
      }
    }
  }
}