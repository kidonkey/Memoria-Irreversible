String separateLines(String s) {
  int i = s.indexOf("\\n");
  int p = 0;
  while (i >= 0) {
    print(i); //<>//
    s = s.substring(0,p+i)+'\n'+s.substring(p+i+2,s.length());
    p = i;
    i = s.substring(i).indexOf("\\n");
  }
  return s;
}

void setup() {
  print(separateLines("Hola.\\nLali\\nPuna\\n."));
  println("FINISHED");
}