import 'megjegyzes_model.dart';

class EszkozModel {
  final String eszkozNev;
  final String eszkozAzonosito;
  final String? lokacio;
  final String? felelosNev;
  final String? komment;
  final List<MegjegyzesModel> megjegyzesek;
  final List<String> kepek;
  final String? kinelVan;
  final List<Map<String, String>> elozmenyek;
  final double? ertek;
  final int? raktaronBelul;
  final List<DateTime> leltarozasok; // Új mező

  EszkozModel({
    required this.eszkozNev,
    required this.eszkozAzonosito,
    this.lokacio = "",
    this.felelosNev = "",
    this.komment = "",
    this.megjegyzesek = const [],
    this.kepek = const [],
    this.kinelVan = "",
    this.elozmenyek = const [],
    this.ertek = 0.0,
    this.raktaronBelul,
    this.leltarozasok = const [], // Új mező default értékkel
  });

  Map<String, dynamic> toJson() {
    return {
      'eszkozNev': eszkozNev,
      'eszkozAzonosito': eszkozAzonosito,
      'location': lokacio,
      'felelosNev': felelosNev,
      'comment': komment,
      'megjegyzesek': megjegyzesek.map((m) => m.toJson()).toList(),
      'kepek': kepek,
      'kinelVan': kinelVan,
      'elozmenyek': elozmenyek,
      'ertek': ertek,
      'raktaronBelul': raktaronBelul,
      'leltarozasok': leltarozasok.map((d) => d.toIso8601String()).toList(), // Dátumok ISO formátumban
    };
  }

  factory EszkozModel.fromJson(Map<String, dynamic> json) {
    return EszkozModel(
      eszkozNev: json['eszkozNev'] ?? '',
      eszkozAzonosito: json['eszkozAzonosito'] ?? '',
      lokacio: json['location'] ?? '',
      felelosNev: json['felelosNev'] ?? '',
      komment: json['comment'] ?? '',
      megjegyzesek: (json['megjegyzesek'] as List<dynamic>?)
          ?.map((m) => MegjegyzesModel.fromJson(m as Map<String, dynamic>))
          .toList() ??
          [],
      kepek: List<String>.from(json['kepek'] ?? []),
      kinelVan: json['kinelVan'] ?? '',
      elozmenyek: List<Map<String, String>>.from(
        (json['elozmenyek'] ?? []).map((e) => Map<String, String>.from(e)),
      ),
      ertek: (json['ertek'] ?? 0.0).toDouble(),
      raktaronBelul: json['raktaronBelul'] as int?,
      leltarozasok: (json['leltarozasok'] as List<dynamic>?)
          ?.map((d) => DateTime.parse(d as String))
          .toList() ??
          [],
    );
  }

  /// **copyWith függvény az EszkozModel frissítéséhez**
  EszkozModel copyWith({
    String? eszkozNev,
    String? eszkozAzonosito,
    String? lokacio,
    String? felelosNev,
    String? komment,
    List<MegjegyzesModel>? megjegyzesek,
    List<String>? kepek,
    String? kinelVan,
    List<Map<String, String>>? elozmenyek,
    double? ertek,
    int? raktaronBelul,
    List<DateTime>? leltarozasok,
  }) {
    return EszkozModel(
      eszkozNev: eszkozNev ?? this.eszkozNev,
      eszkozAzonosito: eszkozAzonosito ?? this.eszkozAzonosito,
      lokacio: lokacio ?? this.lokacio,
      felelosNev: felelosNev ?? this.felelosNev,
      komment: komment ?? this.komment,
      megjegyzesek: megjegyzesek ?? this.megjegyzesek,
      kepek: kepek ?? this.kepek,
      kinelVan: kinelVan ?? this.kinelVan,
      elozmenyek: elozmenyek ?? this.elozmenyek,
      ertek: ertek ?? this.ertek,
      raktaronBelul: raktaronBelul ?? this.raktaronBelul,
      leltarozasok: leltarozasok ?? this.leltarozasok,
    );
  }
}
