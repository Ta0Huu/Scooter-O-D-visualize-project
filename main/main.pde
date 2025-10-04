PImage mapImg;
Map map;
Table scooterData;
TripDataSet tripDataSet;
Timeline timeline = new Timeline(700, 50,100, 700, 1);
CalendarView calendar;
String currentDate;

// ขอบเขตแผนที่ (Geo bounds)
float mapGeoLeft   = -114.45432823016655;
float mapGeoRight  = -113.73701666983344;
float mapGeoTop    = 51.18817976402853;
float mapGeoBottom = 50.84975609376225;

void setup() {
  size(1200, 900);
  mapImg = loadImage("data/map.png");
  map = new Map(mapImg, mapGeoLeft, mapGeoRight, mapGeoTop, mapGeoBottom, 1000, 700);
  scooterData = loadTable("data/ScooterData_July15_Sept27_2019.csv", "header");
  tripDataSet = new TripDataSet(scooterData, map);
  String first_date = tripDataSet.trips[0].start_date;
  String last_date = tripDataSet.trips[tripDataSet.trips.length-1].start_date;
  calendar = new CalendarView(40, 50, 150, 150, first_date, last_date);
  currentDate = first_date;
}

void draw() {
  background(255);
  map.display(0,0);

  stroke(255, 0, 0, 100);
  tripDataSet.updateTrips(currentDate, timeline.currentMinute);
  Trip[] trips = tripDataSet.display_trips;
  for (int i=0; i<trips.length; i++){ 
    line(trips[i].startx, trips[i].starty, trips[i].endx, trips[i].endy);
  }
  calendar.display();
  timeline.display();
  timeline.update();
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