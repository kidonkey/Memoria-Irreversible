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
  void display(float a, float t, float k, float v) {
    float r = t*SCALE;
    if (node.isInsert) {
      stroke(0,50);
      line(0,r-5,0,r);
      node.display(a,t, k,v);
    } else {
      stroke(0,10);
      line(0,r-10,0,r-5);
      if (pos == 0 && node.links[0] != null) node.links[0].display(a,t,k,v); // first
      else if (pos == node.parents.size()-1 && node.links[0] != null) ; //last
      else ;
    }
  }
}