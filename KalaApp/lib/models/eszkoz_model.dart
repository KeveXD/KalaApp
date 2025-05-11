import 'elozmeny_bejegyzes_model.dart';
import 'leltar_bejegyzes_model.dart';
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
  final List<ElozmenyBejegyzesModel> elozmenyek;
  final double? ertek;
  final int? raktaronBelul;
  List<LeltarBejegyzesModel> leltarozasok;

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
    List<LeltarBejegyzesModel>? leltarozasok,
  }) : leltarozasok = leltarozasok ?? [];



  Map<String, dynamic> toJson() {
    return {
      'eszkozNev': eszkozNev,
      'eszkozAzonosito': eszkozAzonosito,
      'location': lokacio,
      'felelosNev': felelosNev,
      'comment': komment,
      'kepek': kepek,
      'kinelVan': kinelVan,
      'ertek': ertek,
      'raktaronBelul': raktaronBelul,
    };
  }

  factory EszkozModel.fromJson(Map<String, dynamic> json) {
    return EszkozModel(
      eszkozNev: json['eszkozNev'] ?? '',
      eszkozAzonosito: json['eszkozAzonosito'] ?? '',
      lokacio: json['location'] ?? '',
      felelosNev: json['felelosNev'] ?? '',
      komment: json['comment'] ?? '',

      kepek: List<String>.from(json['kepek'] ?? []),
      kinelVan: json['kinelVan'] ?? '',

      ertek: (json['ertek'] ?? 0.0).toDouble(),
      raktaronBelul: json['raktaronBelul'] as int?,

    );
  }

  EszkozModel copyWith({
    String? eszkozNev,
    String? eszkozAzonosito,
    String? lokacio,
    String? felelosNev,
    String? komment,
    List<MegjegyzesModel>? megjegyzesek,
    List<String>? kepek,
    String? kinelVan,
    List<ElozmenyBejegyzesModel>? elozmenyek,
    double? ertek,
    int? raktaronBelul,
    List<LeltarBejegyzesModel>? leltarozasok,
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
