/*
Imprime un archivo con todas las inserciones de un changelog en orden cronologico
*/
PrintWriter output;

void setup() {
  output = createWriter("is.txt"); 
  String lines[] = loadStrings("json.txt");
  String[][] m = matchAll(lines[1], "\"ty\":\"is\",\"ibi\":(.*?),\"s\":\"(.*?)\"");
  //println("Found '" + m[345][1] +" " + m[345][2] +"' inside the tag.");
  for (int i = 0; i < m.length; i++) {
    String is = m[i][2];
    print(is);
    if (is.equals("\\n")) { //TODO comprobar si hay un \n o mas dentro del string
      output.print(System.getProperty("line.separator"));
    } else {
      output.print(m[i][2]);
    }
  }
  output.flush(); 
  output.close();
  exit(); 
}

void draw(){}