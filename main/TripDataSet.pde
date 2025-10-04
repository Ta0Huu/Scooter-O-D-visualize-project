class TripDataSet{
    Trip[] trips;
    Trip[] display_trips;
    String currentDate;

    TripDataSet(Table scooterData, Map map){
        trips = new Trip[scooterData.getRowCount()];
        for(int i=0; i<trips.length; i++){
          TableRow row = scooterData.getRow(i);
          trips[i] = new Trip(row, map);
        }
    }

    void updateTrips(String currentDate, float currentMinute){
        display_trips = new Trip[0];
        for(int i=0; i<trips.length; i++){
            if(trips[i].start_date.equals(currentDate) ){
                if (trips[i].start_hour <= currentMinute/60){
                    display_trips = (Trip[]) append(display_trips, trips[i]);
                }
                if (trips[i].start_hour > currentMinute/60){
                    break;
                }
            }
        }
    }
}