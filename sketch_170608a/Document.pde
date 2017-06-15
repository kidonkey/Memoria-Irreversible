class Document {
  Insert root;
  Document() {
  }
  void change(String[] log) {
    if (root == null) {
      root = new Insert(null, log[4], Integer.parseInt(log[3]));
    } else if (log[2].equals("insert")) {
      root.insert(log[4], Integer.parseInt(log[3]));
    } else {
      root.delete(Integer.parseInt(log[3]),Integer.parseInt(log[4]));
    }
  }
  
  void display() {
    root.display();
  }
  
  String play() {
    return root.play();
  }
  
  String structure() {
    return root.structure();
  }
}