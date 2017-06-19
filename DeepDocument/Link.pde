class Link {
  Node node;
  int pos;
  Link (Node n, int i) {
    node = n;
    pos = i;
  }
  String toString() {
    if (!node.type) {
      if (pos == 0) return "[";
      else if (pos == node.parents.size()-1) return "]" + node.toString();
      else return "";
    } else {
      return node.toString();
    }
  }
  void display(float a) {
    if (!node.type) {
      stroke(255,0,0,10);
      line(0,0,0,20);
      if (pos == 0) point(0,10);
      else if (pos == node.parents.size()-1) node.display(a);
      else point(0,0);
    } else {
      stroke(0,10);
      line(0,0,0,20);
      node.display(a);
      
    }
  }
}