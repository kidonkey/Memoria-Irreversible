/*
*/
PrintWriter output;

void setup() { 
  String data = getData("json.txt"); 
  String[][] insertions = getInsertions(data);
  String[][] deletions = getDeletions(data);
  
  for (int i = 0; i < insertions.length; i++) {
    String ins = insertions[i][2];
    String del = deletions[i][1];
    if (ins.equals("\\n")) { //TODO comprobar si hay un \n o mas dentro del string
      println("");
      output.print(System.getProperty("line.separator"));
    } else {
      print(ins);
      output.print(ins);
    }
  }
  output.flush(); 
  output.close();
  exit(); 
}