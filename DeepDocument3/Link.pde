class Link {
  Node node;
  int pos;
  Link (Node n, int i) {
    node = n;
    pos = i;
  }
  String toString() {
    if (!node.isInsert) {
      if (pos == 0) return "[";
      else if (pos == node.parents.size()-1) return "]" + node.toString();
      else return "";
    } else {
      return node.toString();
    }
  }
  void display(float a, float t) {
    float r = t;
    if (node.isInsert) {
      stroke(0,20);
      line(0,r-5,0,r);
      node.display(a,t);
    } else {
      stroke(255,0,0,20);
      line(0,r-10,0,r-5);
      if (pos == 0 && node.links[0] != null) node.links[0].display(a,t); // first
      else if (pos == node.parents.size()-1 && node.links[0] != null) ; //last
      else ;
    }
  }
}