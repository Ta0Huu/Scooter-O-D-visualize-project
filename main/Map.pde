class Map{
    PImage img;
    float mapGeoLeft, mapGeoRight, mapGeoTop, mapGeoBottom;
    float w, h;
    
    Map(PImage img, float mapGeoLeft, float mapGeoRight, float mapGeoTop, float mapGeoBottom, float w, float h){
        this.img = img;
        this.mapGeoLeft = mapGeoLeft;
        this.mapGeoRight = mapGeoRight;
        this.mapGeoTop = mapGeoTop;
        this.mapGeoBottom = mapGeoBottom;
        this.w = w;
        this.h = h;
    }
    
    void display(float x, float y){
        image(img, x, y, w, h);
    }
}