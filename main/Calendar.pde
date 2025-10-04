import java.text.SimpleDateFormat;
import java.util.*;

class CalendarView {
  int x, y, w, h;
  java.util.Calendar current;
  java.util.Calendar startCal;
  java.util.Calendar stopCal;
  ArrayList<int[]> dayCells = new ArrayList<int[]>();

  CalendarView(int x, int y, int w, int h, String startDate, String stopDate) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd", Locale.US);

    try {
      Date sDate = sdf.parse(startDate);
      Date eDate = sdf.parse(stopDate);

      startCal = new java.util.GregorianCalendar();
      startCal.setTime(sDate);

      stopCal = new java.util.GregorianCalendar();
      stopCal.setTime(eDate);

      current = new java.util.GregorianCalendar();
      current.setTime(sDate);

    } catch(Exception e) {
      e.printStackTrace();
    }
  }

void display() {
  dayCells.clear();

  int days = current.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
  java.util.Calendar temp = (java.util.Calendar) current.clone();
  temp.set(java.util.Calendar.DAY_OF_MONTH, 1);
  int firstDay = (temp.get(java.util.Calendar.DAY_OF_WEEK) + 5) % 7;
  int cellW = w / 7;
  int cellH = h / 7;

  fill(#F1E7FF);
  stroke(0);
  strokeWeight(1);
  rect(x - 10, y - 40, w + 20, h + 45);

  SimpleDateFormat fmtHeader = new SimpleDateFormat("yyyy/MM/dd", Locale.US);
  String header = fmtHeader.format(current.getTime());

  textAlign(CENTER, CENTER);
  fill(0);
  text(header, x + w / 2, y - 20);

  fill(200);
  rect(x, y - 35, 20, 20);
  fill(0);
  text("<", x + 10, y - 25);

  fill(200);
  rect(x + w - 20, y - 35, 20, 20);
  fill(0);
  text(">", x + w - 10, y - 25);

  String[] daysName = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};
  for (int i = 0; i < 7; i++) {
    int xpos = x + i * cellW;
    int ypos = y;
    fill(200);
    stroke(0);
    rect(xpos, ypos, cellW, cellH);
    fill(0);
    textAlign(CENTER, CENTER);
    text(daysName[i], xpos + cellW / 2, ypos + cellH / 2);
  }

  int d = 1;
  int rows = 6;
  for (int row = 1; row <= rows; row++) {
    for (int col = 0; col < 7; col++) {
      int xpos = x + col * cellW;
      int ypos = y + row * cellH;

      fill(255);
      stroke(0);
      rect(xpos, ypos, cellW, cellH);

      if (row == 1 && col < firstDay) continue;

      if (d <= days) {
        java.util.Calendar dayCal = (java.util.Calendar) current.clone();
        dayCal.set(java.util.Calendar.DAY_OF_MONTH, d);

        if (!dayCal.before(startCal) && !dayCal.after(stopCal)) {
          fill(0);
          textAlign(LEFT, TOP);
          text(d, xpos + 5, ypos + 5);
          dayCells.add(new int[]{xpos, ypos, cellW, cellH, d});
        }

        d++;
      }
    }
  }
}

  String handleClick(int mx, int my) {
    if (mx > x && mx < x + 20 && my > y - 35 && my < y - 15) {
      java.util.Calendar prevMonth = (java.util.Calendar) current.clone();
      prevMonth.add(java.util.Calendar.MONTH, -1);
      
      prevMonth.set(java.util.Calendar.DAY_OF_MONTH, prevMonth.getActualMaximum(java.util.Calendar.DAY_OF_MONTH));
      if (!prevMonth.before(startCal)) {
        current.add(java.util.Calendar.MONTH, -1);
        redraw();
      }
    } 
    else if (mx > x + w - 20 && mx < x + w && my > y - 35 && my < y - 15) {
      java.util.Calendar nextMonth = (java.util.Calendar) current.clone();
      nextMonth.add(java.util.Calendar.MONTH, 1);
      
      nextMonth.set(java.util.Calendar.DAY_OF_MONTH, 1);
      if (!nextMonth.after(stopCal)) {
        current.add(java.util.Calendar.MONTH, 1);
        redraw();
      }
    } 
    else {
      for (int[] cell : dayCells) {
        int cx = cell[0], cy = cell[1], cw = cell[2], ch = cell[3], day = cell[4];
        if (mx > cx && mx < cx + cw && my > cy && my < cy + ch) {
          java.util.GregorianCalendar selectedCal = new java.util.GregorianCalendar(
            current.get(java.util.Calendar.YEAR),
            current.get(java.util.Calendar.MONTH),
            day
          );
        
          SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd", Locale.US);
          return fmt.format(selectedCal.getTime());
        }
      }
    }
    return null;
  }

}
