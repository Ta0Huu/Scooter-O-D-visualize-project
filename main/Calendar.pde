import java.text.SimpleDateFormat;
import java.util.*;

class CalendarView {
  int x, y, w, h;
  Calendar current;
  ArrayList<int[]> dayCells = new ArrayList<int[]>();

  CalendarView(int x, int y, int w, int h, Date startDate) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    current = new GregorianCalendar();
    current.setTime(startDate);
    current.setTime(startDate);
  }

  void draw() {
    dayCells.clear();

    int days = current.getActualMaximum(Calendar.DAY_OF_MONTH);
    Calendar temp = (Calendar) current.clone();
    temp.set(Calendar.DAY_OF_MONTH, 1);
    int firstDay = (temp.get(Calendar.DAY_OF_WEEK) + 5) % 7;

    int cellW = w / 7;
    int cellH = h / 7;
    
    fill(#F1E7FF);
    stroke(0);
    strokeWeight(1);
    rect(x - 10, y - 40, w + 20, h + 45);

    SimpleDateFormat fmt = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
    String header = fmt.format(current.getTime());

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
          fill(0);
          textAlign(LEFT, TOP);
          text(d, xpos + 5, ypos + 5);
          dayCells.add(new int[]{xpos, ypos, cellW, cellH, d});
          d++;
        }
      }
    }

  }

String mousePressed(int mx, int my) {
  if (mx > x && mx < x + 20 && my > y - 35 && my < y - 15) {
    current.add(Calendar.MONTH, -1);
    println("Prev: " + (current.get(Calendar.MONTH) + 1));
    redraw();
  } else if (mx > x + w - 20 && mx < x + w && my > y - 35 && my < y - 15) {
    current.add(Calendar.MONTH, 1);
    println("Next: " + (current.get(Calendar.MONTH) + 1));
    redraw();
  } else {
    for (int[] cell : dayCells) {
      int cx = cell[0], cy = cell[1], cw = cell[2], ch = cell[3], day = cell[4];
      if (mx > cx && mx < cx + cw && my > cy && my < cy + ch) {
        int year = current.get(Calendar.YEAR);
        int month = current.get(Calendar.MONTH) + 1;
        String dateStr = String.format("%04d/%02d/%02d", year, month, day);
        println(dateStr);
        return dateStr;
      }
    }
  }
  return null;
}

}
