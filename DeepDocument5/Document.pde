class Document {
  ArrayList<Node> nodes;
  long sot = 1479793965613L;
  long last;
  int session;
  Document() {
    session = 0;
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
    nodes.get(0).display(0,0,0,0,k,0);
  }
  void click(int x, int y) {
    nodes.get(0).click(x,y);
  }
}