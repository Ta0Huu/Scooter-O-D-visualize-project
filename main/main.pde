PImage mapImg;
Map map;
Map3D map3d;
Table scooterData;
TripDataSet tripDataSet;
Timeline timeline = new Timeline(870, 50, 440 , 800, 1);
CalendarView calendar;
String currentDate;

// ขอบเขตแผนที่ (Geo bounds)
float mapGeoLeft   = -114.45432823016655;
float mapGeoRight  = -113.73701666983344;
float mapGeoTop    = 51.18817976402853;
float mapGeoBottom = 50.84975609376225;

void setup() {
  size(1500, 900, P3D);
  mapImg = loadImage("data/map.png");
  map = new Map(mapImg, mapGeoLeft, mapGeoRight, mapGeoTop, mapGeoBottom, 1000, 700);
  scooterData = loadTable("data/ScooterData_July15_Sept27_2019.csv", "header");
  tripDataSet = new TripDataSet(scooterData, map);
  String first_date = tripDataSet.trips[0].start_date;
  String last_date = tripDataSet.trips[tripDataSet.trips.length-1].start_date;
  calendar = new CalendarView(40, 70, 270, 200, first_date, last_date);
  currentDate = first_date;
  map3d = new Map3D(420, 50, map);
}

void draw() {
  background(255);
  tripDataSet.updateTrips(currentDate, timeline.currentMinute);
  Trip[] trips = tripDataSet.display_trips;
  map3d.display(trips);
  hint(DISABLE_DEPTH_TEST); 
  fill(150);
  noStroke();
  rect(0,0,350,900);
  calendar.display();
  timeline.display();
  timeline.update();
  hint(ENABLE_DEPTH_TEST); 
  // noLoop(); 
}

void mousePressed() {
  String clickDate = calendar.handleClick(mouseX, mouseY);
  if(clickDate != null) {
    currentDate = clickDate;
  }
  timeline.handleClick(mouseX, mouseY);
  println(timeline.currentMinute);
}

void keyPressed() {
  timeline.handleKey(key);
}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    map3d.zoomMap(e * 30); // ปรับค่าความเร็วซูม
}
