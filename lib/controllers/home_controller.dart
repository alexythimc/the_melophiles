import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomeController extends GetxController {
  // Reactive list to track animation state for each option
  var isAnimating = <RxBool>[false.obs, false.obs, false.obs, false.obs];

  // Toggle animation for a specific index with a brief scale effect
  void triggerAnimation(int index) {
    isAnimating[index].value = true;
    // Auto-reset after animation duration for a pulsing effect
    Future.delayed(const Duration(milliseconds: 300), () {
      isAnimating[index].value = false;
    });
  }

  @override
  void onClose() {
    // Clean up observables if needed
    super.onClose();
  }
}
