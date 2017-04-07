class Changelog {
  String[][] log;
  int t, l;
  String text;
  int changes;
  Changelog(String path) {
    t = 0;
    l = 0;
    text = "";
    String[] lines = loadStrings(path);
    changes = lines.length;
    log = new String[changes][4];
    for (int line = 0; line < lines.length; line++) {
      log[line] = match(lines[line], "(\\d+),([a-z]+),(\\d+),(.*+)");
      if (Integer.parseInt(log[line][3]) > l) {
        l = Integer.parseInt(log[line][3]);
      }
    }
  }
  String[] getNext() {
    if (t < changes) {
      t++;
      text = applyChange(text, log[t-1]);
      return log[t-1];
    } else {
       String[] emptyLog = {"","","","",""};
       return emptyLog;
    }
  }
  String applyChange(String text, String[] log) {
    String timestamp = log[1];
    String type = log[2];
    int ibi = Integer.parseInt(log[3]);
    String info = log[4];
    if (type.equals("insert")) {
      info = info.substring(1,log[4].length()-1);
      //println(separateLines(info));
      text = text.substring(0,ibi - 1) + separateLines(info) + text.substring(ibi - 1,text.length());
    } else {
      int end = Integer.parseInt(info);
      text = text.substring(0,ibi-1) + text.substring(end,text.length());
    }
    return text;
  }
  String getState() {
    return text;
  }
  String separateLines(String s) {
    int i = s.indexOf("\\n");
    int p = 0;
    while (i >= 0) {
      s = s.substring(0,p+i)+'\n'+s.substring(p+i+2,s.length());
      p = i;
      i = s.substring(i).indexOf("\\n");
    }
    return s;
}
}