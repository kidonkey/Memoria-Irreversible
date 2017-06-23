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
  void display(float x, float y, float a, float t, float k, float v) {
    float r = t*SCALE;
    if (node.isInsert) {
      stroke(0,50);
      line(x,y,x-5*cos(a),y-5*sin(a));
      node.display(x,y,a,t, k,v);
    } else {
      stroke(0,5);
      line(x-5*cos(a),y-5*sin(a),x-10*cos(a),y-10*sin(a));
      if (pos == 0 && node.links[0] != null) node.links[0].display(x,y,a,t,k,v); // first
      else if (pos == node.parents.size()-1 && node.links[0] != null) ; //last
      else ;
    }
  }
  void click(int x, int y) {
    node.click(x,y);
  }
}