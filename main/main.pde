PImage mapImg;
Map map;
Table scooterData;
Trip[] trips;
Timeline timeline = new Timeline(700, 50,100, 700, 1);

// ขอบเขตแผนที่ (Geo bounds)
float mapGeoLeft   = -114.45432823016655;
float mapGeoRight  = -113.73701666983344;
float mapGeoTop    = 51.18817976402853;
float mapGeoBottom = 50.84975609376225;

void setup() {
  size(1200, 900);
  mapImg = loadImage("data/map.png");
  map = new Map(mapImg, mapGeoLeft, mapGeoRight, mapGeoTop, mapGeoBottom, 1000, 700);
  // scooterData = loadTable("data/ScooterData_July15_Sept27_2019.csv", "header");
  // trips = new Trip[scooterData.getRowCount()];
  // for(int i=0; i<trips.length; i++){
  //   TableRow row = scooterData.getRow(i);
  //   trips[i] = new Trip(row, map);
  // }
}

void draw() {
  background(255);
  map.display(0,0);

  // stroke(255, 0, 0, 100);
  // for (int i=0; i<trips.length; i++){ 
  //   line(trips[i].startx, trips[i].starty, trips[i].endx, trips[i].endy);
  // }

  timeline.update();
  timeline.display();
  // noLoop(); 
}

void mousePressed() {
  timeline.handleClick(mouseX, mouseY);
  println(timeline.currentMinute);
}