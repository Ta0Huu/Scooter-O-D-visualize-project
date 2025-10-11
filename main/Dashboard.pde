class Dashboard {
  TripDataSet data;
  float x, y, w, h;
  int[] hourlyCounts = new int[24];

  Dashboard(float x, float y, float w, float h, TripDataSet data) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.data = data;
  }

  void update(String date, float currentMinute) {
      for (int i = 0; i < 24; i++) hourlyCounts[i] = 0;

      for (Trip t : data.trips) {
          if (!t.start_date.equals(date)) continue;

          float tripStart = t.start_hour * 60;
          float tripEnd = tripStart + t.trip_duration_min;

          if (currentMinute < tripStart) continue;

          float progress = constrain(map(currentMinute, tripStart, tripEnd, 0, 1), 0, 1);

          int hour = int(tripStart / 60);
          if (hour >= 0 && hour < 24) {
              hourlyCounts[hour] += progress;
          }
      }
  }

  void display(String date, float currentMinute) {
      fill(240);
      stroke(200);
      rect(x, y, w, h);
      fill(0);
      textAlign(CENTER, BOTTOM);
      text("Trip count per hour (" + date + ")", x + w / 2, y - 5);

      float maxCount = 1;
      for (int i = 0; i < 24; i++) if (hourlyCounts[i] > maxCount) maxCount = hourlyCounts[i];

      float barW = (w - 80) / 24.0;
      float chartX = x + 40;
      float chartY = y + h - 40;
      float chartH = h - 80;

      stroke(0);
      line(chartX, chartY, chartX + barW * 24, chartY);
      line(chartX, chartY, chartX, chartY - chartH);

      int numTicks = 4;
      textAlign(RIGHT, CENTER);
      fill(0);
      for (int i = 0; i <= numTicks; i++) {
          float ty = chartY - i * (chartH / numTicks);
          float val = (maxCount / float(numTicks)) * i;
          stroke(220);
          line(chartX, ty, chartX + barW * 24, ty);
          noStroke();
          text(int(val), chartX - 5, ty);
      }

      for (int i = 0; i < 24; i++) {
          float barHeight = map(hourlyCounts[i], 0, maxCount, 0, chartH);
          float bx = chartX + i * barW;
          float by = chartY - barHeight;

          fill(100, 150, 255);
          rect(bx, by, barW - 2, barHeight);
          fill(0);
          textAlign(CENTER, TOP);
          text(i, bx + barW / 2, chartY + 5);
      }
  }

}
