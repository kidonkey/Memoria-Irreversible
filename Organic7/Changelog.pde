class Changelog {
  String[][] log;
  String state;
  int t;
  
  Changelog(String path) {
    String[] lines = loadStrings(path);
    log = new String[lines.length][4];
    for (int line = 0; line < lines.length; line++) {
      log[line] = match(lines[line], "(\\d+),([a-z]+),(\\d+),(.*+)");
    }
   
    state = "";
    t = 0;
  }
  
  String[] getNext() {
    // Returns log t and commits changes
    String [] nextLog = {"","","","",""};
    if (t < log.length) {
      nextLog = log[t];
      state = commit(state, log[t]);
    }
    //println(nextLog[2],nextLog[3],nextLog[4]);
    return nextLog;
  }
  
  String commit(String state, String[] log) {
    // Updates state according to changes and t
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
    // Utility function that replaces tab and newline characters
    int i = s.indexOf("\\n");
    int j = s.indexOf("\\t");
    int p = 0;
    while (i >= 0) {
      s = s.substring(0,p+i)+System.getProperty("line.separator")+s.substring(p+i+2,s.length());
      p = i;
      i = s.substring(i).indexOf("\\n");
    }
    while (j >= 0) {
      s = s.substring(0,p+j)+'\t'+s.substring(p+j+2,s.length());
      p = j;
      j = s.substring(j).indexOf("\\t");
    }
    return s;
  }
  
  String[] getNextBurst() {
    // Returns the next coherent log block (burst) as one log
    String[] startLog = getNext();
    int start = Integer.parseInt(startLog[3]);
    String burst = "";
    String[] currentLog = startLog;
    
    if (startLog[2].equals("delete")) {
      int deletion = Integer.parseInt(currentLog[4]);
      int ibi = start;
      int lastPos = start;
      while (true) {
        int l = Integer.parseInt(currentLog[4]) - ibi + 1;
        lastPos = ibi - l;
        deletion = Integer.parseInt(currentLog[4]);
        if (log[t][2].equals("insert") || Integer.parseInt(log[t][3]) != lastPos) {
          break;
        }
        currentLog = getNext();
        ibi = lastPos;
      }
      if (deletion < Integer.parseInt(startLog[3])) {
        start = deletion;
        deletion = Integer.parseInt(startLog[3]);
      } else {
        start = Integer.parseInt(startLog[3]);
      }
      String[] burstLog = {"",startLog[1],startLog[2],str(start - 1),str(deletion)};
      println("DELETION from "+(start- 1)+" to "+deletion);
      return burstLog;
      
    } else {
      while (true) {   
        if (currentLog[2].equals("insert")) {
          burst += separateLines(currentLog[4].substring(1,currentLog[4].length()-1));
        } else {
          int deletion = Integer.parseInt(currentLog[4])-Integer.parseInt(currentLog[3])+1;
          burst = burst.substring(0,burst.length()-deletion);
        }
        int nextIbi = Integer.parseInt(log[t][3]);
        int currentPos = start + burst.length();
        if (log[t][2].equals("delete")) {
          int nextDel = Integer.parseInt(log[t][4])-nextIbi+1;
          if (nextIbi != currentPos-1 || burst.length()-nextDel < 0) {
            break;
          }
        } else if (nextIbi != currentPos) {
          break;
        }
        currentLog = getNext();
        currentPos = start + burst.length();
      }
    }
    int ibi = start - 1;
    println("INSERTION in "+ ibi + ": \"" +burst + "\"");
    String[] burstLog = {"",startLog[1],startLog[2],str(ibi),burst};
    return burstLog;
  }
}