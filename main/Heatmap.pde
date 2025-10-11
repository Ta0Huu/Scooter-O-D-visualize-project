class Heatmap {
  Map map;         
  TripDataSet data;
  float x, y;
  float w, h;
  int gridSize = 5;
  String mode = "end"; // สามารถตั้งเป็น "start" หรือ "end" ถ้าต้องการ logic ต่างกัน

  Heatmap(float x, float y, float w, float h, Map map, TripDataSet data){
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.map = map;
      this.data = data;
  }

  void display(String currentDate, float currentMinute){
      image(map.img, x, y, w, h); 

      int cols = int(w / gridSize);
      int rows = int(h / gridSize);
      float[][] density = new float[cols][rows];

      for (Trip t : data.trips) {
          if (!t.start_date.equals(currentDate)) continue;

          float tripStart = t.start_hour * 60;
          float tripEnd = tripStart + t.trip_duration_min;

          if (currentMinute < tripStart) continue;
          float progress = constrain(map(currentMinute, tripStart, tripEnd, 0, 1), 0, 1);

          float px = lerp(t.startx, t.endx, progress) * (w / map.w);
          float py = lerp(t.starty, t.endy, progress) * (h / map.h);

          int cx = int(px / gridSize);
          int cy = int(py / gridSize);
          if (cx >= 0 && cx < cols && cy >= 0 && cy < rows) {
              density[cx][cy]++;
          }
      }

      float maxDensity = 0;
      for (int i = 0; i < cols; i++) {
          for (int j = 0; j < rows; j++) {
              if (density[i][j] > maxDensity) maxDensity = density[i][j];
          }
      }
      if (maxDensity < 1) maxDensity = 1;

      PGraphics heatLayer = createGraphics(int(w), int(h));
      heatLayer.beginDraw();
      heatLayer.clear();
      heatLayer.noStroke();
      heatLayer.blendMode(ADD);

      for (int i = 0; i < cols; i++) {
          for (int j = 0; j < rows; j++) {
              if (density[i][j] == 0) continue;

              float val = pow(density[i][j] / maxDensity, 0.5);
              int c = lerpColor(color(0, 255, 0), color(255, 0, 0), val*3);
              int alpha = int(80 + 175 * val);
              heatLayer.fill(c, alpha);

              float cx = i * gridSize + gridSize / 2;
              float cy = j * gridSize + gridSize / 2;
              float r = gridSize * 3.5;
              heatLayer.ellipse(cx, cy, r, r);
          }
      }

      heatLayer.endDraw();
      image(heatLayer, x, y);
  }
}
