import java.text.SimpleDateFormat;
import java.util.*;

class CalendarView {
  int x, y, w, h;
  java.util.Calendar current;      // เดือนที่แสดง
  java.util.Calendar startCal;     // ขอบเขตเริ่ม
  java.util.Calendar stopCal;      // ขอบเขตสิ้นสุด
  java.util.Calendar currentDate;  // วันที่เลือกปัจจุบัน
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

      currentDate = new java.util.GregorianCalendar();
      currentDate.setTime(sDate); // default currentDate = startDate

    } catch(Exception e) {
      e.printStackTrace();
    }
  }

  void display() {
    pushStyle(); 
    dayCells.clear();

    int days = current.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
    java.util.Calendar temp = (java.util.Calendar) current.clone();
    temp.set(java.util.Calendar.DAY_OF_MONTH, 1);
    int firstDay = (temp.get(java.util.Calendar.DAY_OF_WEEK) + 5) % 7;
    int cellW = w / 7;
    int cellH = h / 7;

    SimpleDateFormat fmtHeader = new SimpleDateFormat("MMMM yyyy", Locale.US);
    String header = fmtHeader.format(current.getTime());

    textAlign(CENTER, CENTER);
    // fill(#D5972A);
    fill(0);
    textSize(20);
    text(header, x + w / 2, y - 20);

    fill(#D52A68);
    textSize(28);
    text("<", x + 15, y - 25);

    fill(#D52A68);
    textSize(28);
    text(">", x + w - 15, y - 25);

    textSize(16);

    noStroke();

    String[] daysName = {"M", "Tu", "W", "Th", "F", "S", "S"};
    for (int i = 0; i < 7; i++) {
      int xpos = x + i * cellW;
      int ypos = y;
      fill(#2abed5);
      if (i == 0) {
        // ซ้ายสุด มนขอบบนซ้ายและล่างซ้าย
        rect(xpos, ypos, cellW, cellH, 20, 0, 0, 20);
      } else if (i == 6) {
        // ขวาสุด มนขอบบนขวาและล่างขวา
        rect(xpos, ypos, cellW, cellH, 0, 20, 20, 0);
      } else {
        rect(xpos, ypos, cellW, cellH);
      }
      fill(255);
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
        rect(xpos, ypos, cellW, cellH);

        if (row == 1 && col < firstDay) continue;

        if (d <= days) {
          java.util.Calendar dayCal = (java.util.Calendar) current.clone();
          dayCal.set(java.util.Calendar.DAY_OF_MONTH, d);

          if (dayCal.get(java.util.Calendar.YEAR) == currentDate.get(java.util.Calendar.YEAR)
              && dayCal.get(java.util.Calendar.MONTH) == currentDate.get(java.util.Calendar.MONTH)
              && dayCal.get(java.util.Calendar.DAY_OF_MONTH) == currentDate.get(java.util.Calendar.DAY_OF_MONTH)) {
                fill(#D52A68);
                rect(xpos, ypos, cellW, cellH,20);

                fill(255);
                textAlign(CENTER, CENTER);
                text(d, xpos + cellW / 2, ypos + cellH / 2);
          }
          else if (!dayCal.before(startCal) && !dayCal.after(stopCal)) {
            fill(#2abed5);
          }
          else {
            fill(#2abed5, 80);
          }
          textAlign(CENTER, CENTER);
          text(d,  xpos + cellW / 2, ypos + cellH / 2);

          if (!dayCal.before(startCal) && !dayCal.after(stopCal)) {
            dayCells.add(new int[]{xpos, ypos, cellW, cellH, d});
          }

          d++;
        }
      }
    }
    popStyle();   
  }

  String handleClick(int mx, int my) {
    // ปุ่มเดือนก่อนหน้า
    if (mx > x && mx < x + 20 && my > y - 35 && my < y - 15) {
      java.util.Calendar prevMonth = (java.util.Calendar) current.clone();
      prevMonth.add(java.util.Calendar.MONTH, -1);

      prevMonth.set(java.util.Calendar.DAY_OF_MONTH, prevMonth.getActualMaximum(java.util.Calendar.DAY_OF_MONTH));
      if (!prevMonth.before(startCal)) {
        current.add(java.util.Calendar.MONTH, -1);
        redraw();
      }
    } 
    // ปุ่มเดือนถัดไป
    else if (mx > x + w - 20 && mx < x + w && my > y - 35 && my < y - 15) {
      java.util.Calendar nextMonth = (java.util.Calendar) current.clone();
      nextMonth.add(java.util.Calendar.MONTH, 1);

      nextMonth.set(java.util.Calendar.DAY_OF_MONTH, 1);
      if (!nextMonth.after(stopCal)) {
        current.add(java.util.Calendar.MONTH, 1);
        redraw();
      }
    } 
    // คลิกวัน
    else {
      for (int[] cell : dayCells) {
        int cx = cell[0], cy = cell[1], cw = cell[2], ch = cell[3], day = cell[4];
        if (mx > cx && mx < cx + cw && my > cy && my < cy + ch) {
          // update currentDate
          currentDate.set(current.get(java.util.Calendar.YEAR),
                          current.get(java.util.Calendar.MONTH),
                          day);

          SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd", Locale.US);
          return fmt.format(currentDate.getTime());
        }
      }
    }
    return null;
  }
}
