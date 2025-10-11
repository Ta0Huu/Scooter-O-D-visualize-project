class Timeline {
    float width, height;
    float[] timeMarkersPositons;
    int x, y;
    float period_min; // for display 1 day
    float currentMinute = 0; // 0–1439
    float startMillis;
    float offsetMinute = 0;  // เก็บนาที offset ตอนคลิกหรือหยุด
    boolean autoRun = false;  // เริ่มต้น: หยุด
    float speed = 1.0;       // ความเร็วเริ่มต้น (ตัวหาร period_min)
    
    // ช่อง speed input
    float speedBoxX, speedBoxY, speedBoxW = 60, speedBoxH = 25;
    boolean typingSpeed = false;
    boolean clearedOnFirstType = false;  
    String speedStr = "1.0";

    // ปุ่ม play/pause
    float playBtnX, playBtnY, playBtnSize = 25;

    Timeline(float width, float height, int x, int y, float period_min) {
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

        // ช่อง speed อยู่หลังเส้น timeline
        this.speedBoxX = x + width + 80;
        this.speedBoxY = y - speedBoxH / 2 + 5;

        // ปุ่ม play อยู่หน้าเส้น timeline
        this.playBtnX = x - 44;
        this.playBtnY = y - playBtnSize / 2 ;
    }

    void update() {
        if (autoRun) {
            float elapsedSec = (millis() - startMillis) / 1000.0;
            float simulatedMinutes = offsetMinute + map(elapsedSec, 0, (period_min / speed) * 60, 0, 1440);
            currentMinute = simulatedMinutes % 1440;
        }
    }

    void display() {
        pushStyle();
        // เส้น timeline
        strokeWeight(3);
        stroke(#2abed5);
        line(x, y, x + width, y);

        // markers ชั่วโมง
        for (int i = 0; i < timeMarkersPositons.length; i++) {
            float posX = x + timeMarkersPositons[i];
            line(posX, y - 8, posX, y + 8);
            fill(0);
            textAlign(CENTER, TOP);
            text(i, posX, y + 10);
        }

        // จุดแดงแสดงเวลา
        float posX = x + (currentMinute / 1440.0) * width; 
        fill(#D52A68);
        noStroke();
        ellipse(posX, y, 15, 15); 

        popStyle();

        // ปุ่ม play/pause
        displayPlayButton();

        // ช่อง speed
        displaySpeedInput();
    }

    void displayPlayButton() {
        if (autoRun) {
        // Pause icon
        fill(#D5972A);
        rect(playBtnX + 8, playBtnY + 6, 6, 20);
        rect(playBtnX + 18, playBtnY + 6, 6, 20);
    } else {
        // Play icon
        fill(#D52A68);
        triangle(
            playBtnX + 9,  playBtnY + 6,  
            playBtnX + 9,  playBtnY + 26,  
            playBtnX + 26, playBtnY + 16  
        );
    }
    }

    void displaySpeedInput() {
        fill(0);
        textAlign(LEFT, CENTER);
        text("Speed:", speedBoxX - 60, speedBoxY + speedBoxH / 2);

        fill(typingSpeed ? color(255, 255, 200) : 240);
        stroke(#D52A68);
        rect(speedBoxX, speedBoxY, speedBoxW, speedBoxH, 5);

        fill(0);
        textAlign(LEFT, CENTER);
        text("x" + speedStr, speedBoxX + 5, speedBoxY + speedBoxH / 2);
    }

    void handleClick(int mx, int my) {
        // กดปุ่ม play/pause
        if (mx >= playBtnX && mx <= playBtnX + playBtnSize &&
            my >= playBtnY && my <= playBtnY + playBtnSize) {
            if (autoRun) {
                // หยุด: เก็บ offsetMinute ปัจจุบัน
                float elapsedSec = (millis() - startMillis) / 1000.0;
                offsetMinute += map(elapsedSec, 0, (period_min / speed) * 60, 0, 1440);
                offsetMinute %= 1440;
                autoRun = false;
            } else {
                // เล่นต่อ: เริ่มจับเวลาจาก offset เดิม
                startMillis = millis();
                autoRun = true;
            }
            return;
        }

        // คลิกช่อง speed
        if (mx >= speedBoxX && mx <= speedBoxX + speedBoxW &&
            my >= speedBoxY && my <= speedBoxY + speedBoxH) {
            typingSpeed = true;
            clearedOnFirstType = false; 
            return;
        } else {
            typingSpeed = false;
        }

        // คลิกบน timeline
        if (mx >= x && mx <= x + width && abs(my - y) <= 10) {
            float ratio = (mx - x) / width;
            currentMinute = ratio * 1440;
            currentMinute = floor(currentMinute / 60) * 60;
            offsetMinute = currentMinute;
            startMillis = millis();
        }
    }

    void handleKey(char key) {
        if (typingSpeed) {
            if (!clearedOnFirstType && ((key >= '0' && key <= '9') || key == '.')) {
                speedStr = "";
                clearedOnFirstType = true;
            }

            if (key == BACKSPACE && speedStr.length() > 0) {
                speedStr = speedStr.substring(0, speedStr.length() - 1);
            } else if ((key >= '0' && key <= '9') || key == '.') {
                speedStr += key;
            } else if (key == ENTER || key == RETURN) {
                float newSpeed = 1;
                // หยุด: เก็บ offsetMinute ปัจจุบัน
                float elapsedSec = (millis() - startMillis) / 1000.0;
                offsetMinute += map(elapsedSec, 0, (period_min / speed) * 60, 0, 1440);
                offsetMinute %= 1440;
                autoRun = false;
                try {
                    newSpeed = Float.parseFloat(speedStr);
                } catch (Exception e) {
                    newSpeed = 1;
                }
                if (newSpeed <= 0) newSpeed = 1;
                setSpeed(newSpeed);
                typingSpeed = false;
                // เล่นต่อ: เริ่มจับเวลาจาก offset เดิม
                startMillis = millis();
                autoRun = true;
            }
        }
    }

    void setSpeed(float newSpeed) {
        this.speed = newSpeed;
    }
}
