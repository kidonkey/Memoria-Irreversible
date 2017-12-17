class Document {
  ArrayList<Node> nodes;
  long sot = 1479793965613L;
  long last;
  int session;
  Document() {
    session = SESSION.length-1;
    nodes = new ArrayList<Node>();
    String []startLog = {"","0","delete","0","0"};
    Node root = new Node(0, startLog, session);
    root.parents.add(new Node(0, startLog, session));
    nodes.add(root);
    last = root.timestamp;
  }
  void indel(String[] log) {
    //println("TIME DIFF:", Long.parseLong(log[1]) - last);
    if (Long.parseLong(log[1]) - last >= 43200000) session++;
    Node node = new Node(nodes.size(), log, session);
    nodes.add(node);
    if (node.isInsert) nodes.get(0).insert(node,-1);
    else nodes.get(0).delete(node,-1);
    for (Node n: nodes) n.visited = false;
    last = node.timestamp;
    //ArrayList<Node> parents = log[0].search();
  }
  String toString() {
    return nodes.get(0).toString();
  }
  void display(float k) {
    noStroke();
    stroke(240);
    fill(0,20);
    ellipse(-20,0,40,40);
    displayRoot();
    nodes.get(0).display(0,0,0,0,k,0);
  }
  Node click(float x, float y) {
    Node a;
    for (Node n: nodes) {
      a = n.click(x,y);
      if (a != null) return a;
    }
    return null;
  }
  String surf(int n) {
    return nodes.get(n).surf();
  }
  void displayRoot() {
    int v = 0;
    int x = -20;
    int y = 0;
    strokeWeight(1);
    float l = 100;
    float r = 20*SCALE;
    float d = k/r;
    float angle = l*d;
    float b = -angle/2 - v * SUN;
    v += -angle/2 - v * SUN;
    for (int j = 0; j < 1; j++) {
      
      for (int i = 0; i < 100; i++) {
        stroke(0,10);
        line(x+(r-5)*cos(b+d*i), y+(r-5)*sin(b+d*i), x+r*cos(b+d*i), y+r*sin(b+d*i));
        v += d;
      }
      r = r*2;
      d = k/r;
      angle = l*d;
    }
  }
}