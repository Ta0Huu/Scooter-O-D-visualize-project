class Dashboard {
  TripDataSet data;
  float x, y, w, h;
  float scrollX = 0;
  float scrollSpeed = 20;
  int[] hourlyCounts = new int[24];

  Dashboard(float x, float y, float w, float h, TripDataSet data) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.data = data;
  }

  void update(String date) {
    for (int i = 0; i < 24; i++) hourlyCounts[i] = 0;

    for (Trip t : data.trips) {
      if (t.start_date.equals(date)) {
        int hour = int(t.start_hour);
        if (hour >= 0 && hour < 24) hourlyCounts[hour]++;
      }
    }
  }

  void display() {
    fill(240);
    stroke(200);
    rect(x, y, w, h);
    fill(0);
    textAlign(CENTER, BOTTOM);
    text("Trip count per hour", x + w / 2, y - 5);

    int maxCount = 1;
    for (int i = 0; i < 24; i++) if (hourlyCounts[i] > maxCount) maxCount = hourlyCounts[i];

    float barW = 5; 
    float gap = 1;
    float chartWidth = (barW + gap) * 24;
    float chartX = x + 40;
    float chartY = y + h - 404;
    float chartH = h - 60;

    pushMatrix();
    clip(int(x), int(y), int(w), int(h));
    translate(-scrollX, 0);

    stroke(0);
    line(chartX, chartY, chartX + chartWidth, chartY);
    line(chartX, chartY, chartX, chartY - chartH);

    int numTicks = 4;
    textAlign(RIGHT, CENTER);
    fill(0);
    for (int i = 0; i <= numTicks; i++) {
      float ty = chartY - i * (chartH / numTicks);
      float val = (maxCount / float(numTicks)) * i;
      stroke(220);
      line(chartX, ty, chartX + chartWidth, ty);
      noStroke();
      text(int(val), chartX - 5, ty);
    }

    for (int i = 0; i < 24; i++) {
      float barHeight = map(hourlyCounts[i], 0, maxCount, 0, chartH);
      float bx = chartX + i * (barW + gap);
      float by = chartY - barHeight;

      fill(100, 150, 255);
      rect(bx, by, barW, barHeight);
      fill(0);
      textAlign(CENTER, TOP);
      text(i, bx + barW / 2, chartY + 5);
    }

    noClip();
    popMatrix();

    drawScrollbar(chartWidth);
  }

  void drawScrollbar(float contentWidth) {
    float scrollbarY = y + h - 15;
    float scrollbarH = 8;
    fill(220);
    rect(x, scrollbarY, w, scrollbarH);
    float visibleRatio = w / contentWidth;
    float handleW = max(visibleRatio * w, 30);
    float handleX = x + map(scrollX, 0, max(0, contentWidth - w), 0, w - handleW);
    fill(120);
    rect(handleX, scrollbarY, handleW, scrollbarH, 4);
  }

  void scroll(float amt) {
    float barW = 20, gap = 6;
    float chartWidth = (barW + gap) * 24;
    scrollX = constrain(scrollX + amt * scrollSpeed, 0, max(0, chartWidth - w));
  }
}
