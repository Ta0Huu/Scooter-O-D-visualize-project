PImage mapImg;
Map map;
Map3D map3d;
Table scooterData;
TripDataSet tripDataSet;
Timeline timeline = new Timeline(870, 50, 440 , 800, 1);
CalendarView calendar;
String currentDate;
Dashboard dashboard;
Heatmap heatmap;
PFont lexendFont;

float mapGeoLeft   = -114.45432823016655;
float mapGeoRight  = -113.73701666983344;
float mapGeoTop    = 51.18817976402853;
float mapGeoBottom = 50.84975609376225;

void setup() {
  size(1500, 900, P3D);
  smooth();
  lexendFont = createFont("Lexend-Regular.ttf", 48); // ขนาด 20 หรือปรับตามต้องการ
  textFont(lexendFont);
  mapImg = loadImage("data/map.png");
  map = new Map(mapImg, mapGeoLeft, mapGeoRight, mapGeoTop, mapGeoBottom, 1000, 700);
  scooterData = loadTable("data/ScooterData_July15_Sept27_2019.csv", "header");
  tripDataSet = new TripDataSet(scooterData, map);
  String first_date = tripDataSet.trips[0].start_date;
  String last_date = tripDataSet.trips[tripDataSet.trips.length-1].start_date;
  calendar = new CalendarView(35, 60, 270, 200, first_date, last_date);
  currentDate = first_date;
  map3d = new Map3D(420, 50, map);
  heatmap = new Heatmap(35, 300 , 270, 200, map, tripDataSet);
  dashboard = new Dashboard(35, 615, 270, 250, tripDataSet);

}

void draw() {
  textSize(16);
  background(#f4f5f6);
  textFont(lexendFont);
  tripDataSet.updateTrips(currentDate, timeline.currentMinute);
  Trip[] trips = tripDataSet.display_trips;
  map3d.handleDrag();
  map3d.display(trips, timeline.currentMinute);
  hint(DISABLE_DEPTH_TEST); 
  fill(#ffffff);
  noStroke();
  rect(0,0,350,900,0,50,50,0);
  heatmap.display(currentDate, timeline.currentMinute);
  dashboard.update(currentDate, timeline.currentMinute);
  dashboard.display(currentDate, timeline.currentMinute);
  calendar.display();
  fill(255);
  rect(380, 770, 1090, 70, 20);
  timeline.display();
  timeline.update();
  drawTimelabel();
  hint(ENABLE_DEPTH_TEST); 
}

void drawTimelabel() {
  pushStyle();
  textAlign(RIGHT,BOTTOM);
  String timeLabel = String.format("%02d:%02d", int(timeline.currentMinute / 60), int(timeline.currentMinute % 60));
  fill(0);
  // แปลง currentDate จาก yyyy/MM/dd เป็น dd MMMM yyyy
  String dateFormatted = "";
  try {
    java.text.SimpleDateFormat inputFormat = new java.text.SimpleDateFormat("yyyy/MM/dd");
    java.text.SimpleDateFormat outputFormat = new java.text.SimpleDateFormat("dd MMMM yyyy");
    java.util.Date dateObj = inputFormat.parse(currentDate);
    dateFormatted = outputFormat.format(dateObj);
  } catch(Exception e) {
    dateFormatted = currentDate;
  }
  textSize(48);
  text("Calgary, Candana", 1450 , 85);
  textSize(24);
  fill(#D5972A);
  text(dateFormatted + ", ", 1300 , 120);
  text(timeLabel , 1360 , 120);
  text("O'clock", 1450 , 120);
  popStyle();
}

void mousePressed() {
  String clickDate = calendar.handleClick(mouseX, mouseY);
  if(mouseButton == LEFT)  map3d.startDragLeft();
  if(mouseButton == CENTER) map3d.startDragMiddle();
  heatmap.handleClick(mouseX, mouseY);
  if(clickDate != null) {
    currentDate = clickDate;
  }
  timeline.handleClick(mouseX, mouseY);
  println(timeline.currentMinute);
}

void mouseReleased(){
  map3d.endDragLeft();
  map3d.endDragMiddle();
}

void keyPressed() {
  timeline.handleKey(key);
}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    map3d.zoomMap(e * 30, mouseX, mouseY);

}
