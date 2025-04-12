class RaktarModel {
  final String nev;
  final String? megjegyzes;
  final List<int>? raktaronBelul; // Módosítás: int? helyett List<int>?

  RaktarModel({
    required this.nev,
    this.megjegyzes,
    this.raktaronBelul, // Módosítás: int? helyett List<int>?
  });

  Map<String, dynamic> toJson() {
    return {
      "nev": nev,
      "megjegyzes": megjegyzes ?? "",
      "raktaronBelul": raktaronBelul ?? [], // Üres lista ha nincs adat
    };
  }
}
