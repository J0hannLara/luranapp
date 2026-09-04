// lib/features/business/presentation/controllers/business_management_controller.dart
import 'package:get/get.dart';
import 'package:luranapp/features/auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/negocio.dart';
import '../../domain/repositories/business_repository_interface.dart';
import '../../../../core/utils/view_state.dart';

class BusinessManagementController extends GetxController with ViewStateMixin {
  final BusinessRepositoryInterface _businessRepository;
  
  BusinessManagementController(this._businessRepository);
  
  final RxList<Negocio> negocios = <Negocio>[].obs;
  final Rx<Negocio?> selectedNegocio = Rx<Negocio?>(null);
  final RxString currentUserId = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Obtener el usuario actual
    final authController = Get.find<AuthController>();
    currentUserId.value = authController.currentUser.value?.id ?? '';
    
    if (currentUserId.value.isNotEmpty) {
      loadBusinesses();
    }
  }
  
  Future<void> loadBusinesses() async {
    if (currentUserId.value.isEmpty) return;
    
    try {
      setLoading();
      setError('');
      
      final userBusinesses = await _businessRepository.getBusinessesByUser(
        currentUserId.value,
      );
      
      negocios.value = userBusinesses;
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  void retryLoad() {
    loadBusinesses();
  }
  
  void selectBusiness(Negocio negocio) {
    selectedNegocio.value = negocio;
  }
  
  void clearSelection() {
    selectedNegocio.value = null;
  }
}