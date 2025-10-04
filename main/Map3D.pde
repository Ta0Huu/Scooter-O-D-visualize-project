class Map3D {
    Map map;
    float x, y;
    float angle = 0;        
    float startAngle = 0;   
    float startMouseX = -1;  

    float zoom = -200;       // ระยะ Z สำหรับซูม

    Map3D(float x, float y, Map map){
        this.x = x;
        this.y = y;
        this.map = map;
    }

    void display(Trip[] trips, float currentMinute){
        pushMatrix();
        translate(x + map.w/2, y + map.h/2, zoom);
        rotateX(PI/4);

        // หมุนด้วย drag
        if(mousePressed){
            if(startMouseX == -1){
                startMouseX = mouseX;
                startAngle = angle;
            }
            angle = startAngle - (PI * (mouseX - startMouseX) / width);
        } else {
            startMouseX = -1;
        }

        rotateZ(angle);
        translate(-map.w/2, -map.h/2);
        map.display(0,0);

        stroke(255, 0, 0, 150);
        strokeWeight(2);
        int segments = 30;          
        float k = 10;               

        for (int i = 0; i < trips.length; i++){
            Trip trip = trips[i];
            float h = k * trip.trip_length_km;  

            float tripStartMinute = trip.start_hour * 60 ;
            float tripEndMinute = tripStartMinute + trip.trip_duration_min; // trip_duration_min ต้องมีค่า
            float progress = map(currentMinute, tripStartMinute, tripEndMinute, 0, 1);
            progress = constrain(progress, 0, 1);
            int segmentsToDraw = (int)(segments * progress);

            if(segmentsToDraw == 0) continue; // ยังไม่เริ่ม

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
        }

        popMatrix();
    }




    // ฟังก์ชันปรับซูม
    void zoomMap(float delta){
        zoom += delta;
        zoom = constrain(zoom, -800, 500); // กำหนดขอบเขตซูม
    }
}


