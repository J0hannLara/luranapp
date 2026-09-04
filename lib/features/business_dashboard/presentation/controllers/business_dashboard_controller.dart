import 'package:get/get.dart';
import 'package:luranapp/core/utils/view_state.dart';
import 'package:luranapp/features/businesses/domain/entities/negocio_completo.dart';
import 'package:luranapp/features/businesses/domain/repositories/business_repository_interface.dart';

class BusinessDashboardController extends GetxController with ViewStateMixin {
  final Rx<ViewState> state = ViewState.initial.obs;
  final RxInt currentTabIndex = 0.obs;
  final BusinessRepositoryInterface _businessRepository;
  final String businessId;

  BusinessDashboardController(this._businessRepository, this.businessId);
  final Rx<NegocioCompleto?> negocioCompleto = Rx<NegocioCompleto?>(null);

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    state.value = ViewState.success;
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      setLoading();
      setError('');

      // Cargar datos por separado para evitar timeout
      final negocio = await _businessRepository.getBusinessById(businessId);
      final sucursales = await _businessRepository.getBusinessComplete(
        businessId,
      );

      // Actualizar solo lo que se necesite
      negocioCompleto.value = sucursales;

      setSuccess();
    } catch (e) {
      // Si falla, intentar cargar solo el negocio
      try {
        final negocio = await _businessRepository.getBusinessById(businessId);
        negocioCompleto.value = NegocioCompleto(
          negocio: negocio,
          sucursales: [],
          usuarios: [],
          productos: [],
        );
        setSuccess();
      } catch (e2) {
        setError('Error al cargar el dashboard: $e');
      }
    }
  }
}
