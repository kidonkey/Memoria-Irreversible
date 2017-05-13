class Changelog {
  String[][] log;
  int t;
  String state;
  
  Changelog(String path) {
    state = "";
    String[] lines = loadStrings(path);
    log = new String[lines.length][4];
    for (int line = 0; line < lines.length; line++) {
      log[line] = match(lines[line], "(\\d+),([a-z]+),(\\d+),(.*+)");
    }
    t = 0;
  }
  
  String[] getNext() {
    String [] nextLog = {"","","","",""};
    if (t < log.length) {
      nextLog = log[t];
      state = applyChange(state, log[t]);
    }
    return nextLog;
  }
  
  String[] seeNext() {
    String [] nextLog = {"","","","",""};
    if (t < log.length) {
      nextLog = log[t];
    }
    return nextLog;
  }
  
  String[] getNextBurst() {
    String[] startLog = getNext();
    int start = Integer.parseInt(startLog[3]);
    String burst = "";
    String[] currentLog = startLog;
    if (startLog[2] == "delete") {
      println("deletion cycle");
      int deletion = Integer.parseInt(currentLog[4]);
      int ibi = start;
      int lastPos = start;
      while (ibi == lastPos) {
        int l = Integer.parseInt(currentLog[4]) - ibi + 1;
        lastPos = ibi - l;
        deletion = Integer.parseInt(currentLog[4]);
        if (log[t][2].equals("insert") || Integer.parseInt(log[t][3]) != lastPos) {
          break;
        }        
      }
      String[] burstLog = {"",startLog[1],startLog[2],startLog[3],str(deletion)};
      println("deletion from "+startLog[3]+" to "+str(deletion));
      return burstLog;
    } else {
      int nextInsertion =  start;
      int currentPos = start + burst.length();
      while (nextInsertion == currentPos || currentLog[2].equals("delete") && nextInsertion == currentPos-1) {    //<>//
        if (currentLog[2].equals("insert")) {
          burst += separateLines(currentLog[4].substring(1,currentLog[4].length()-1));
        } else {
          int deletion = Integer.parseInt(currentLog[4])-Integer.parseInt(currentLog[3])+1;
          burst = burst.substring(0,burst.length()-deletion);
        }
        int nextIbi = Integer.parseInt(log[t][3]);
        int nextDel = Integer.parseInt(log[t][4])-nextIbi+1;
        
        if (nextIbi != currentPos || (log[t][2].equals("delete") && nextIbi != currentPos-1) || burst.length()-nextDel >= 0) {
          break;
        }
        currentLog = getNext();
        nextInsertion = Integer.parseInt(currentLog[3]);
        currentPos = start + burst.length();
      }
    }
    println("insertion in "+startLog[3]+ ": " +burst);
    String[] burstLog = {"",startLog[1],startLog[2],startLog[3],burst};
    return burstLog;
  }
  
  String applyChange(String state, String[] log) {
    String type = log[2];
    int ibi = Integer.parseInt(log[3]);
    String info = log[4];
    if (type.equals("insert")) {
      info = info.substring(1,log[4].length()-1);
      state = state.substring(0,ibi - 1) + separateLines(info) + state.substring(ibi - 1,state.length());
    } else {
      int end = Integer.parseInt(info);
      state = state.substring(0,ibi-1) + state.substring(end,state.length());
    }
    t++;
    return state;
  }
  
  String separateLines(String s) {
    int i = s.indexOf("\\n");
    int p = 0;
    while (i >= 0) {
      s = s.substring(0,p+i)+System.getProperty("line.separator")+s.substring(p+i+2,s.length());
      p = i;
      i = s.substring(i).indexOf("\\n");
    }
    return s;
  }
}