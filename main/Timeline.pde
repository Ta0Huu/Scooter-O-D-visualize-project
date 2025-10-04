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
        this.speedBoxY = y - speedBoxH / 2;

        // ปุ่ม play อยู่หน้าเส้น timeline
        this.playBtnX = x - 40;
        this.playBtnY = y - playBtnSize / 2;
    }

    void update() {
        if (autoRun) {
            float elapsedSec = (millis() - startMillis) / 1000.0;
            float simulatedMinutes = offsetMinute + map(elapsedSec, 0, (period_min / speed) * 60, 0, 1440);
            currentMinute = simulatedMinutes % 1440;
        }
    }

    void display() {
        // เส้น timeline
        stroke(0);
        line(x, y, x + width, y);

        // markers ชั่วโมง
        for (int i = 0; i < timeMarkersPositons.length; i++) {
            float posX = x + timeMarkersPositons[i];
            line(posX, y - 5, posX, y + 5);
            fill(0);
            textAlign(CENTER, TOP);
            text(i, posX, y + 8);
        }

        // จุดแดงแสดงเวลา
        float posX = x + (currentMinute / 1440.0) * width; 
        fill(255, 0, 0);
        noStroke();
        ellipse(posX, y, 10, 10); 

        // ปุ่ม play/pause
        displayPlayButton();

        // ช่อง speed
        displaySpeedInput();
    }

    void displayPlayButton() {
        stroke(0);
        fill(240);
        rect(playBtnX, playBtnY, playBtnSize, playBtnSize, 5);
        fill(0);
        if (autoRun) {
            // รูปสี่เหลี่ยมคู่ (pause)
            rect(playBtnX + 6, playBtnY + 5, 4, 15);
            rect(playBtnX + 14, playBtnY + 5, 4, 15);
        } else {
            // รูปสามเหลี่ยม (play)
            triangle(playBtnX + 7, playBtnY + 5, playBtnX + 7, playBtnY + 20, playBtnX + 18, playBtnY + 12);
        }
    }

    void displaySpeedInput() {
        fill(0);
        textAlign(LEFT, CENTER);
        text("Speed:", speedBoxX - 45, speedBoxY + speedBoxH / 2);

        fill(typingSpeed ? color(255, 255, 200) : 240);
        stroke(0);
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
                try {
                    newSpeed = Float.parseFloat(speedStr);
                } catch (Exception e) {
                    newSpeed = 1;
                }
                if (newSpeed <= 0) newSpeed = 1;
                setSpeed(newSpeed);
                typingSpeed = false;
                startMillis = millis();
            }
        }
    }

    void setSpeed(float newSpeed) {
        this.speed = newSpeed;
    }
}
