class District {
  final String id;
  final String name;
  final List<Taluka> talukas;

  District({required this.id, required this.name, required this.talukas});
}

class Taluka {
  final String id;
  final String name;
  final List<GramPanchayat> gps;

  Taluka({required this.id, required this.name, required this.gps});
}

class GramPanchayat {
  final String id;
  final String name;

  GramPanchayat({required this.id, required this.name});
}
