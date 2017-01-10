String getData(String filename) {
  String lines[] = loadStrings("json.txt");
  return lines[1]; //La primera linea es basura
}

String[][] getInsertions(String data) {
  String[][] insertions = matchAll(data, "\"ty\":\"is\",\"ibi\":(.*?),\"s\":\"(.*?)\"");
  return insertions;
}

String[][] getDeletions(String data) {
  String[][] deletions = matchAll(data, "\"ty\":\"ds\",\"si\":(.*?),\"ei\":(.*?)");
  return deletions;
}