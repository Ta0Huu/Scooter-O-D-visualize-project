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

    void display(Trip[] trips){
        pushMatrix();
        translate(x + map.w/2, y + map.h/2, zoom);  // ใช้ zoom แทน -200
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
        stroke(255, 0, 0, 100);
        for (int i=0; i<trips.length; i++){ 
            line(trips[i].startx, trips[i].starty, trips[i].endx, trips[i].endy);
        }
        popMatrix();
    }

    // ฟังก์ชันปรับซูม
    void zoomMap(float delta){
        zoom += delta;
        zoom = constrain(zoom, -800, 500); // กำหนดขอบเขตซูม
    }
}


