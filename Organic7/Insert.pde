class Insert extends Node {
  
  Insert(Node p, String t, int i) {
    super(p,t,i);
    println("CREATED insert at " + start + " " + end);
  }
  
  void insert(String t, int ibi) {
    end += t.length();
    boolean higher = false;
    for (Delete child: deleted) {
      if (child.start > ibi) {
        child.transpose(t.length());
      }
    }
    for (Insert child: offspring) {
      if (child.start > ibi) {
        child.transpose(t.length());
      }
      else if (child.start <= ibi && child.end >= ibi) {
        child.insert(t, ibi);
        higher = true;
      }
    }
    if (!higher) {
      Insert insertion = new Insert(this, t, ibi);
      offspring.add(insertion);
      Collections.sort(offspring);
    }
  }
  
  void delete(int ibi, int stop) {
    int l = stop - ibi;
    end -= l;
    int rest = l; //<>//
    int mod = 0;
    boolean[] here = new boolean[l];
    ArrayList<Delete> antichildren = new ArrayList<Delete>();
    for (int i = 0; i < l; i++) {
      here[i] = true;
    }
    for (Delete child: deleted) {
      if (child.start > start) {
        child.transpose(-l);
      }
    }
    for (Insert child: offspring) {
      if (child.start > stop) {
        child.transpose(-l);
      } else if (child.start <= ibi && child.end >= stop) {
        child.delete(ibi, stop);
        rest -= stop - ibi;
      } else if (child.start >= ibi && child.start <= stop || child.end >= ibi && child.end <= stop) {
        int j = max(child.start, ibi);
        int k = min(child.end, stop);
        child.delete(j, k);
        for (int i = j; i <k; i++) {
          here[i - child.start] = false;
          rest--;
        };
        mod += child.s.length();
      } else {
        mod += child.s.length();
      }
    }
    if (rest > 0) {
      println(start, end);
      String deletedText = s.substring(ibi - start - mod,stop - start - mod); //<>//
      println("DELETED: \""+deletedText+ "\"");
      s = s.substring(0,ibi - start - mod) + s.substring(stop - start - mod);
      Delete delete = new Delete(this, deletedText, ibi);
      deleted.add(delete);
    }
  }
  
  String play() {
    String t = s;
    for (Insert child: offspring) {
      int breakpoint = child.start - start;
      if (breakpoint < s.length()) {
        t = t.substring(0, breakpoint) + child.play() + t.substring(breakpoint);
      } else {
        println(child.start, child.end);
        t = t.substring(0, breakpoint) + child.play(); //<>//
      }
    }
    return t;
  }
  
  String structure() {
    String str = "(" + start + ":" + s;
    for (Insert child: offspring) {
      str += child.structure();
    }
    return str+":"+ end +")";
  }
  
  void display() {
    // Draw itself then place matrix for each child node
    float l = s.length();
    float a = PI/2;
    float r = l/a;
    stroke(0,100);
    noFill();
    strokeWeight(.5);
    arc(0, 0, r, r, -a/2, a/2, PIE);
    strokeWeight(1);
    arc(0, 0, r, r, -a/2, a/2);
    
    float betha,a2,r2,l2;
    int mod = 0;
    for (Insert child: offspring) {
      betha = a*(-start-mod)/l;
      l2 = child.s.length();
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
      mod += child.end - child.start;
    }
  }
}