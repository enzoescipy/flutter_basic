class GPSTimes{
  int id;

  String lat;
  String long;

  int year = 0;
  int month = 0;
  int date = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;

  GPSTimes({
    this.id,
    this.lat,
    this.long,
    this.year,
    this.month,
    this.date,
    this.hour,
    this.minute,
    this.second,
});

  GPSTimes.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lat = json['lat'],
        long = json['long'],
        year = json['year'],
        month = json['month'],
        date = json['date'],
        hour = json['hour'],
        minute = json['minute'],
        second = json['second'];
}