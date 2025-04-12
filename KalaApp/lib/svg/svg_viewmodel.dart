import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/raktar_model.dart';

class SvgViewModel extends StateNotifier<SVGRaktarState> {
  SvgViewModel(SVGRaktarState initialModel) : super(initialModel);

  void updateSelectedId(String id) {
    state = state.copyWith(selectedId: id);
  }

  void updateRaktarModel(SVGRaktarState updatedModel) {
    state = updatedModel;
  }
}


final svgViewModelProvider =
StateNotifierProvider<SvgViewModel, SVGRaktarState>(
      (ref) => SvgViewModel(SVGRaktarState(nev: "Alap Raktár")),
);


class SVGRaktarState {
  final String nev;
  final String? selectedId;

  SVGRaktarState({
    required this.nev,
    this.selectedId,
  });

  SVGRaktarState copyWith({
    String? nev,
    String? selectedId,
  }) {
    return SVGRaktarState(
      nev: nev ?? this.nev,
      selectedId: selectedId ?? this.selectedId,
    );
  }

  @override
  String toString() => 'SVGRaktarState(nev: $nev, selectedId: $selectedId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SVGRaktarState &&
        other.nev == nev &&
        other.selectedId == selectedId;
  }

  @override
  int get hashCode => nev.hashCode ^ selectedId.hashCode;
}

