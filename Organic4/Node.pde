class Node {
  String original;
  String text;
  ArrayList<Node> offspring = new ArrayList<Node>();
  Node parent;
  float arc;
  int place;
  int start;
  int end;
  float r;
  
  Node(Node p, String t, float a, int i) {
    parent = p;
    arc = a;
    text = t;
    original = t;
    place = i;
    start = i;
    end = start + t.length();
    r = (float) Math.sqrt(text.length()/a)*10;
  }
  
  void display() {
    noStroke();
    if (original.contains("#")) {
      fill(255,0,0,100);
    } else {
      fill(0,0,255,100);
    }
    arc(0, 0, r, r, 0, arc, PIE);
    for (Node child: offspring) {
      pushMatrix();
      println(start);
      println(end);
      println(child.place);
      println((child.place-start-1)/(float) original.length());
      rotate(-PI/4+arc*(child.place-start-1)/ (float) original.length());
      translate(r*sin(PI/4)/2,r*cos(PI/4)/2);
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
  }
  
  void insert(String t, int ibi) {
    end += t.length();
    boolean higher = false;
    for (Node child: offspring) {
      if (child.start > ibi) {
        child.transpose(t.length());
      }
      else if (child.start <= ibi && child.end > ibi) {
        child.insert(t, ibi);
        higher = true;
      }
    }
    if (!higher) {
      insertHere(t, ibi);
    }
  }
  
  void delete(int ibi, String delete) {
    end -= delete.length();
    boolean higher = false;
    for (Node child: offspring) {
      if (child.start > ibi) {
        child.transpose(-delete.length());
      }
      else if (child.start <= ibi && child.end > ibi) {
        child.delete(ibi, delete);
        higher = true;
      }
    }
    if (!higher) {
      insertHere(delete, ibi);
    }
  }
  
  void insertHere(String t, int ibi) {
    Node insertion = new Node(this, t, arc, ibi);
    offspring.add(insertion);
  }
}