import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/raktar_model.dart';

class RaktarWidgetViewModel extends StateNotifier<RaktarWidgetState?> {
  RaktarWidgetViewModel() : super(null);

  void selectRaktar(RaktarModel raktar) {
    state = RaktarWidgetState(selectedRaktar: raktar);
  }

  void clearSelection() {
    state = null;
  }
}

final raktarWidgetViewModelProvider =
StateNotifierProvider<RaktarWidgetViewModel, RaktarWidgetState?>(
      (ref) => RaktarWidgetViewModel(),
);


class RaktarWidgetState {
  final RaktarModel selectedRaktar;

  RaktarWidgetState({required this.selectedRaktar});
}