import 'package:get/get.dart';
import 'package:luranapp/core/utils/view_state.dart';

class HomeController extends GetxController {
  final Rx<ViewState> state = ViewState.initial.obs;
  final RxInt currentTabIndex = 0.obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  Future<void> loadHomeData() async {
    state.value = ViewState.loading;
    // TODO(FASE 4): Cargar ofertas con GetNearbyOffers, GetFeaturedOffers, etc.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    state.value = ViewState.success;
  }

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }
}
