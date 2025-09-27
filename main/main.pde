PImage mapImg;
Table scooterData;

// ขอบเขตแผนที่ (Geo bounds)
float mapGeoLeft   = -114.45432823016655;
float mapGeoRight  = -113.73701666983344;
float mapGeoTop    = 51.18817976402853;
float mapGeoBottom = 50.84975609376225;

void setup() {
  size(1000, 750);
  mapImg = loadImage("data/map.png");
  scooterData = loadTable("data/ScooterData_July15_Sept27_2019.csv", "header");
}

void draw() {
  background(255);
  image(mapImg, 0, 0, width, height);

  stroke(255, 0, 0, 100);
    float minX = width, minY = height, maxX = 0, maxY = 0;
    float minStartLat = 999, maxStartLat = -999, minStartLon = 999, maxStartLon = -999;
    float minEndLat = 999, maxEndLat = -999, minEndLon = 999, maxEndLon = -999;
    for (TableRow row : scooterData.rows()) {
      float startLon = row.getFloat("startx");
      float startLat = row.getFloat("starty");
      float endLon = row.getFloat("endx");
      float endLat = row.getFloat("endy");

      // หาค่า min/max ละติจูด/ลองจิจูด
      minStartLat = min(minStartLat, startLat);
      maxStartLat = max(maxStartLat, startLat);
      minStartLon = min(minStartLon, startLon);
      maxStartLon = max(maxStartLon, startLon);
      minEndLat = min(minEndLat, endLat);
      maxEndLat = max(maxEndLat, endLat);
      minEndLon = min(minEndLon, endLon);
      maxEndLon = max(maxEndLon, endLon);

      // แปลงพิกัด geo เป็นตำแหน่งบนภาพ
      float x1 = map(startLon, mapGeoLeft, mapGeoRight, 0, width);
      float y1 = map(startLat, mapGeoTop, mapGeoBottom, 0, height);
      float x2 = map(endLon, mapGeoLeft, mapGeoRight, 0, width);
      float y2 = map(endLat, mapGeoTop, mapGeoBottom, 0, height);

      // หาค่า min/max ตำแหน่งบนภาพ
      minX = min(minX, x1, x2);
      minY = min(minY, y1, y2);
      maxX = max(maxX, x1, x2);
      maxY = max(maxY, y1, y2);

      line(x1, y1, x2, y2);
    }

  // วาดกรอบสี่เหลี่ยมรอบจุด start/end ทั้งหมด
  noFill();
  stroke(0, 0, 255, 200); // สีน้ำเงิน
  strokeWeight(2);
  rect(minX, minY, maxX-minX, maxY-minY);

  // print min/max ละติจูด/ลองจิจูด
  println("Start Lat: min=" + minStartLat + ", max=" + maxStartLat);
  println("Start Lon: min=" + minStartLon + ", max=" + maxStartLon);
  println("End Lat: min=" + minEndLat + ", max=" + maxEndLat);
  println("End Lon: min=" + minEndLon + ", max=" + maxEndLon);

  noLoop(); // วาดครั้งเดียวพอ

}