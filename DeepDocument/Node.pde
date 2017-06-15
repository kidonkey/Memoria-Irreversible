import java.util.*;

class Node {
  int id;
  String s;
  Node[] nodes;
  ArrayList<Node> parents;
  String type;
  int ibi;
  int dei;
  long timestamp;
  boolean visited;

  Node(int i, String[] log) {
    id = i;
    timestamp = Long.parseLong(log[1]);
    type = log[2];
    ibi = Integer.parseInt(log[3]);
    parents = new ArrayList<Node>();
    if (type.equals("insert")) {
      s = log[4];
      nodes = new Node[s.length() + 1];
    } else {
      dei = Integer.parseInt(log[4]);
      nodes = new Node[1];
    }
    visited = false;
  }
  String toString() {
    String y = "{" + str(id) + ":";
    for (int i = 0; i < nodes.length; i++) {
      if (i != 0) {
        y += s.substring(i-1, i);
      }
      if (nodes[i] != null) {
        y += nodes[i].toString();
      } else {
        continue;
      }
    }
    return y + "}";
  }
  int delete(Node n, int c) {
    visited = true;
    for (int x = 0; x < nodes.length; x++) {
      if (nodes[x] != null && !nodes[x].visited) c = nodes[x].delete(n, c);
      else if (nodes[x] == null) {
        c++;
        if (c >= n.ibi && c <= n.dei) {
          nodes[x] = n;
          n.parents.add(this);
        }
      }
    }
    return c;
  }
  int insert(Node n, int c) {
    visited = true;
    for (int x = 0; x < nodes.length; x++) {
      if (nodes[x] != null && !nodes[x].visited) c = nodes[x].insert(n, c);
      else if (nodes[x] == null) {
        c++;
        if (c == n.ibi) {
          nodes[x] = n;
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
    for (int i = x; i < nodes.length; i++) {
      if (nodes[i] != null) {
        nodes[i].surf();
        break;
      } else if (i == nodes.length-1) {
        parents.get(parents.size()-1).drop(this);
        break;
      } else if (nodes.length > 0 && i != nodes.length-1) print(s.substring(i, i+1));
    }
  }
  void drop(Node n) {
    int i;
    for (i = nodes.length-1; i >= 0; i--) {
      if (nodes[i] != null && nodes[i].equals(n)) break;
    }
    if (nodes.length > 0 && i != nodes.length-1) print(s.substring(i, i+1));
    surf(i+1);
  }
  void display() {
    translate(0, 10);
    pushMatrix();
    for (int i = 0; i < nodes.length; i++) {

      if (i != 0) {
        stroke(0, 20);
        line(0, 0, 0, 10);
        rotate(PI/60);
      }
      if (nodes[i] != null) {
        nodes[i].display();
      } else {
        continue;
      }
    }
    popMatrix();
  }
}