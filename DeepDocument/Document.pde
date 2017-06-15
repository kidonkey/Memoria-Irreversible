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
    if (node.type.equals("insert")) nodes.get(0).insert(node,-1);
    else nodes.get(0).delete(node,-1);
    for (Node n: nodes) n.visited = false;
    //ArrayList<Node> parents = log[0].search();
  }
  String toString() {
    return nodes.get(0).toString();
  }
  void surf() {
    Node n = nodes.get(0);
    while (true) {
      for (int i = 0; i < n.nodes.length; i++) {
        if (n.nodes[i] != null) n.nodes[i].surf();
        if (n.nodes.length> 0 &&i != n.nodes.length-1) print(n.s.substring(i, i+1));
      }
    }
  }
}