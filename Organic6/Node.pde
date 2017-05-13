class Node {
  String original;
  String text;
  ArrayList<Node> offspring = new ArrayList<Node>();
  Node parent;
  int place;
  int start;
  int end;
  ArrayList<int[]> mods;
  
  Node(Node p, String t, int i) {
    parent = p;
    text = t;
    original = t;
    place = i;
    start = i;
    end = start + t.length();
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
    stroke(0);
    strokeWeight(2);
    arc(0, 0, r, r, -a/2, a/2);
    float betha,a2,r2,l2;
    int mod = 0;
    for (Node child: offspring) {
      for (Node sibling: offspring) {
        mod = 0;
        if (sibling.start < child.start) {
          mod += sibling.end - sibling.end;
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
  
  void delete(int ibi, int deletion) {
    println("deletion:"+deletion); //<>//
    int l = ibi-deletion+1;
    end -= l;
    boolean higher = false;
    for (Node child: offspring) {
      if (child.start > ibi) {
        child.transpose(-l);
      }
      else if (child.start <= ibi && child.end > ibi) {
        child.delete(ibi, deletion);
        higher = true;
      }
    }
    if (!higher) {
      println(text);
      //text = text.substring(0,ibi-start)+"#"+text.substring(ibi-start,ibi+l-start)+"#"+text.substring(ibi+l-start,end-start); //<>//
      text = text.substring(0,ibi-start)+text.substring(ibi+l-start,end-start);
      println("DEL: " + text);
    }
  }
  
  void insertHere(String t, int ibi) {
    Node insertion = new Node(this, t, ibi);
    offspring.add(insertion);
  }
}