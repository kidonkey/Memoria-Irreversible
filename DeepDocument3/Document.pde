class Document {
  ArrayList<Node> nodes;
  Document() {
    nodes = new ArrayList<Node>();
    String []startLog = {"","0","delete","0","0"};
    nodes.add(new Node(0, startLog));
  }
  void indel(String[] log) {
    Node node = new Node(nodes.size(), log);
    nodes.add(node);
    if (node.isInsert) nodes.get(0).insert(node,-1);
    else nodes.get(0).delete(node,-1);
    for (Node n: nodes) n.visited = false;
    //ArrayList<Node> parents = log[0].search();
  }
  String toString() {
    return nodes.get(0).toString();
  }
  void display() {
    nodes.get(0).display(0,0);
  }
}