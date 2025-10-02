class Timeline {
    float width, height;
    float[] timeMarkersPositons;
    int x,y;
    float period_min; // for display 1 day
    float currentMinute = 0; // 0–1439
    float startMillis;
    float offsetMinute = 0;  // เก็บนาที offset ตอนคลิก
    boolean autoRun = true;  // true = วิ่งตามเวลา, false = manual
    
    Timeline(float width, float height,int x, int y, float period_min) {
        this.width = width;
        this.height = height;
        this.x = x;
        this.y = y;
        this.period_min = period_min;
        this.timeMarkersPositons = new float[25];
        for (int i = 0; i <= 24; i++) {
            timeMarkersPositons[i] = i * (width / 24.0);
        }
        startMillis = millis();
    }

    void update(){
        if (autoRun) {
            float elapsedSec = (millis() - startMillis) / 1000.0;
            float simulatedMinutes = offsetMinute + map(elapsedSec, 0, period_min * 60, 0, 1440);
            currentMinute = simulatedMinutes % 1440;
        }
    }

    void display() {
        // เส้นหลัก
        stroke(0);
        line(x, y, x + width, y);

        // ขีดเวลา 0–24
        for (int i = 0; i < timeMarkersPositons.length; i++) {
            float posX = x + timeMarkersPositons[i];
            line(posX, y - 5, posX, y + 5);
            fill(0);
            textAlign(CENTER, TOP);
            text(i, posX, y + 8);
        }

        // จุดเวลาปัจจุบัน
        float posX = x + (currentMinute / 1440.0) * width; 
        fill(255, 0, 0);
        noStroke();
        ellipse(posX, y, 10, 10); 
    }

    void handleClick(int mx, int my) {
        if (mx >= x && mx <= x + width && abs(my - y) <= 10) {
            float ratio = (mx - x) / width;  // 0.0–1.0
            currentMinute = ratio * 1440;   // map กลับเป็นนาที

            // รีเซ็ตให้เริ่มนับจาก currentMinute
            offsetMinute = currentMinute;
            startMillis = millis();
            autoRun = true; // ให้วิ่งต่อจากที่เลือก
        }
    }
}
