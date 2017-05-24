import java.util.*;

class Node implements Comparable<Node>{
  String original;
  String text;
  ArrayList<Node> offspring = new ArrayList<Node>();
  ArrayList<Node> deleted = new ArrayList<Node>();
  Node parent;
  int place;
  int start;
  int end;
  ArrayList<int[]> mods;
  String type;
  
  Node(Node p, String t, int i, String k) {
    //TODO create delete type node
    parent = p;
    text = t;
    original = t;
    place = i;
    start = i; // TODO Cambiar a i - 1
    end = start + t.length();
    type = k;
    offspring = new ArrayList<Node>();
    deleted = new ArrayList<Node>();
  }
  
  void display() {
    float l = original.length();
    float r = l/1.5;
    float a = l/r;
    if (a > PI) {
      a = PI;
      r = l/a;
    }
    stroke(0,100);
    noFill();
    strokeWeight(.5);
    arc(0, 0, r, r, -a/2, a/2, PIE);
    strokeWeight(1);
    arc(0, 0, r, r, -a/2, a/2);
    float betha,a2,r2,l2;
    int mod = 0;
    for (Node child: offspring) {
      mod = 0;
      for (Node sibling: offspring) {
        if (sibling.start < child.start) {
          mod += sibling.end - sibling.start;
        }
      }
      betha = a*(child.place-start-1-mod)/l;
      l2 = child.original.length();
      r2 = 30;
      a2 = l2/r;
      if (a2 > PI) {
        a2 = PI;
        r2 = l2/a2;
      }
      betha = betha-a/2;
      pushMatrix();
      rotate(betha);
      translate(r/2,0);
      child.display();
      popMatrix();
    }
  }
  
  void transpose(int l) {
    start += l;
    end += l;
    for (Node child: offspring) {
      child.transpose(l);
    }
    for (Node child: deleted) {
      child.transpose(l);
    }
  }
  
  void insert(String t, int ibi) {
    end += t.length();
    boolean higher = false;
    for (Node child: deleted) {
      if (child.start > ibi) {
        child.transpose(t.length());
      }
    }
    for (Node child: offspring) {
      if (child.start > ibi) {
        child.transpose(t.length());
      }
      else if (child.start <= ibi && child.end >= ibi) {
        child.insert(t, ibi);
        higher = true;
      }
    }
    if (!higher) {
      insertHere(t, ibi);
    }
  }
  
  void delete(int ibi, int deletion) {
    // TODO esta wea esta mas redundante q la chucha
    // hay q diferenciar nodos de antinodos
    int l = deletion-ibi+1;
    end -= l;
    int rest = l;
    boolean[] here = new boolean[l];
    ArrayList<Node> antichildren = new ArrayList<Node>();
    for (int i = 0; i < l; i++) {
      here[i] = true;
    }
    // TODO asignar nuevas relaciones
    for (Node child: deleted) {
      if (child.start > deletion) {
        child.transpose(-l);
      }
    }
    for (Node child: offspring) {
      if (child.start > deletion) {
        child.transpose(-l);
      } else if (ibi >= child.start && ibi <= child.end) {
        int max = min(deletion,child.end);
        child.delete(ibi, max);
        for (int i = 0; i < max-ibi+1; i++) {
          here[i] = false;
          rest--;
        }
        antichildren.add(child);
      } else if ( ibi <= child.start && deletion >= child.end) {
        child.delete(child.start, child.end);
        for (int i= child.start-ibi; i <= child.end-ibi; i++) {
          here[i] = false;
          rest--;
        }
        antichildren.add(child);
      } else if (deletion >= child.start && deletion <= child.end) {
        int m = max(child.start, ibi);
        child.delete(m,deletion);
        for (int i = m-ibi;i < l; i++) {
          here[i] = false;
          rest--;
        }
        antichildren.add(child);
      }
    }
    if (rest > 0) {
      int pos = ibi;
      for (int i = 0; i < l; i++) {
        if (here[i]) {
          pos += i;
          break;
        }
      }
      println(text.length());
      int a = pos-start;
      int b = pos-start+l;
      println(a, b);
      String deletedText = text.substring(pos-start,pos-start+l); //<>//
      println("deleted: " + deletedText);
      String text1 = text.substring(0,a);
      String text2 = text.substring(b);
      text= text1+text2;
      println("remaining:" + text);
      Node antinode = new Node(this, deletedText, pos, "delete");
      antinode.deleted = antichildren;
      deleted.add(antinode);
    }
  }
  
  void insertHere(String t, int ibi) {
    Node insertion = new Node(this, t, ibi, "insert");
    offspring.add(insertion);
  }
  
  String produce() { // TODO que pasa mas arriba
    String s = text;
    Collections.sort(offspring); // TODO Mover a insert
    for (Node child: offspring) {
      int breakpoint = child.start - start;
      if (breakpoint < text.length()) {
        s = s.substring(0, breakpoint) + child.produce() + s.substring(breakpoint);
      } else {
        s = s.substring(0, breakpoint) + child.produce(); //<>//
      }
    }
    return s;
  }
  
  int compareTo(Node sibling) {
    return (int) Math.signum(start - sibling.start);
  }
}