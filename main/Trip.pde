class Trip{
    Map map;
    int id;
    String start_date;
    int start_hour, start_day_of_week;
    float trip_duration_min, trip_length_km;
    String starting_grid_id, ending_grid_id;
    float startx, starty, endx, endy;

    Trip(TableRow row, Map map){
        this.map = map;
        this.id = row.getInt("ID");
        this.start_date = row.getString("start_date");
        this.start_hour = row.getInt("start_hour");
        this.start_day_of_week = row.getInt("start_day_of_week");
        this.trip_duration_min = row.getFloat("trip_duration_min");
        this.trip_length_km = row.getFloat("trip_length_km");
        this.starting_grid_id = row.getString("starting_grid_id");
        this.ending_grid_id = row.getString("ending_grid_id");
        this.startx = findXposition(row.getFloat("startx"));
        this.starty = findYposition(row.getFloat("starty"));
        this.endx = findXposition(row.getFloat("endx"));
        this.endy = findYposition(row.getFloat("endy"));
    }

    float findXposition(float lon){
        float x = map.w*(lon - map.mapGeoLeft)/( map.mapGeoRight-map.mapGeoLeft );
        return x;
    }

    float findYposition(float lat){
        float y = map.h*(lat - map.mapGeoTop)/( map.mapGeoBottom-map.mapGeoTop );
        return y;
    }

}