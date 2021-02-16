class Juz{
  Map ayahs;

  Juz({this.ayahs});

  factory Juz.fromJson(Map<String,dynamic> json)
  {
    return Juz(ayahs: json['data']);
  }

}

