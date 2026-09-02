import 'package:get/get.dart';
import 'package:luranapp/core/utils/view_state.dart';

class BusinessDashboardController extends GetxController {
  final Rx<ViewState> state = ViewState.initial.obs;
  final RxInt currentTabIndex = 0.obs;

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    state.value = ViewState.success;
  }
}
