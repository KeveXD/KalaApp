import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/raktar_model.dart';

class SvgViewModel extends StateNotifier<RaktarModel> {
  SvgViewModel(RaktarModel initialModel) : super(initialModel);

  void updateRaktarModel(RaktarModel updatedModel) {
    state = updatedModel;
  }
}

final svgViewModelProvider = StateNotifierProvider<SvgViewModel, RaktarModel>(
      (ref) => SvgViewModel(RaktarModel(nev: "Alap Raktár",)),
);
