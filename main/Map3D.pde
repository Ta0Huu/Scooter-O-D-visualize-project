class Map3D {
  Map map;
  float x, y;

  float rotZ = 0;        // หมุนรอบ Z
  float rotX = PI/4;     // ความเอียง map
  float zoom = -200;

  float panX = 0;
  float panY = 0;

  boolean draggingLeft = false;
  boolean draggingMiddle = false;

  float lastMouseX, lastMouseY;

  Map3D(float x, float y, Map map){
    this.x = x;
    this.y = y;
    this.map = map;
  }

  void display(Trip[] trips, float currentMinute){
    pushMatrix();
    translate(x + map.w/2 + panX, y + map.h/2 + panY, zoom);
    rotateX(rotX);
    rotateZ(rotZ);
    translate(-map.w/2, -map.h/2);
    map.display(0,0);

    int segments = 30;          
    float k = 10;               

    for (int i = 0; i < trips.length; i++){
      stroke(#2abed5, 150);
      strokeWeight(2);
      Trip trip = trips[i];
      float h = k * trip.trip_length_km;  

      float tripStartMinute = trip.start_hour * 60 ;
      float tripEndMinute = tripStartMinute + trip.trip_duration_min;
      float progress = map(currentMinute, tripStartMinute, tripEndMinute, 0, 1);
      progress = constrain(progress, 0, 1);
      int segmentsToDraw = (int)(segments * progress);

      if(segmentsToDraw == 0) continue;

      float px = trip.startx;
      float py = trip.starty;
      float pz = 0;

      for(int j = 1; j <= segmentsToDraw; j++){
        float t = j / (float)segments;
        float x1 = lerp(trip.startx, trip.endx, t);
        float y1 = lerp(trip.starty, trip.endy, t);
        float z1 = h * 4 * t * (1 - t);
        line(px, py, pz, x1, y1, z1);
        px = x1;
        py = y1;
        pz = z1;
      }

      // box เริ่ม
      pushMatrix();
      translate(trip.startx, trip.starty, 0);
      fill(#D5972A);
      noStroke();
      box(5);
      popMatrix();

      // box ปลาย
      if (progress >= 1.0) {
        pushMatrix();
        translate(trip.endx, trip.endy, 0);
        fill(#D52A68);
        noStroke();
        box(5);
        popMatrix();
      }
    }

    popMatrix();
  }

  // ฟังก์ชันซูมโดยให้ mouse เป็นจุดโฟกัส
  void zoomMap(float delta, float mouseX, float mouseY){
    // world position ของ mouse ก่อน zoom
    float worldX = mouseX - (x + map.w/2 + panX);
    float worldY = mouseY - (y + map.h/2 + panY);

    // ปรับ zoom
    zoom += delta;
    zoom = constrain(zoom, -800, 500);

    // world position ของ mouse หลัง zoom
    float newWorldX = mouseX - (x + map.w/2 + panX);
    float newWorldY = mouseY - (y + map.h/2 + panY);

    // ปรับ pan เพื่อให้ mouse อยู่คงที่
    panX += (newWorldX - worldX);
    panY += (newWorldY - worldY);
  }

  // เริ่ม drag ด้วย mouse
  void startDragLeft() { draggingLeft = true; lastMouseX = mouseX; lastMouseY = mouseY; }
  void endDragLeft()   { draggingLeft = false; }
  void startDragMiddle(){ draggingMiddle = true; lastMouseX = mouseX; lastMouseY = mouseY; }
  void endDragMiddle() { draggingMiddle = false; }

  // เรียกทุก frame เพื่ออัปเดต drag
  void handleDrag(){
    if(draggingLeft){
      float dx = mouseX - lastMouseX;
      rotZ -= dx * 0.01;
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    }
    if(draggingMiddle){
      float dx = mouseX - lastMouseX;
      float dy = mouseY - lastMouseY;
      panX += dx;
      panY += dy;
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    }
  }
}
