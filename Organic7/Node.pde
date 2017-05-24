import java.util.*;

class Node implements Comparable<Node>{
  String s;
  ArrayList<Insert> offspring = new ArrayList<Insert>();
  ArrayList<Delete> deleted = new ArrayList<Delete>();
  Node parent;
  int start;
  int end;
  
  Node(Node p, String t, int i) {
    //TODO create delete type node
    parent = p;
    s = t;
    start = i;
    end = start + t.length(); // end no inclusivo
    offspring = new ArrayList<Insert>();
    deleted = new ArrayList<Delete>();
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
  
  int compareTo(Node sibling) {
    return (int) Math.signum(start - sibling.start);
  }
}