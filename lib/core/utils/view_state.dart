import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ViewState {
  initial,
  loading,
  success,
  error,
  empty,
}

extension ViewStateExtension on ViewState {
  bool get isInitial => this == ViewState.initial;
  bool get isLoading => this == ViewState.loading;
  bool get isSuccess => this == ViewState.success;
  bool get isError => this == ViewState.error;
  bool get isEmpty => this == ViewState.empty;
  
  String get label {
    switch (this) {
      case ViewState.initial:
        return 'Inicial';
      case ViewState.loading:
        return 'Cargando';
      case ViewState.success:
        return 'Éxito';
      case ViewState.error:
        return 'Error';
      case ViewState.empty:
        return 'Vacío';
    }
  }
}

// Clase mejorada para manejar estados con datos
class ViewStateModel<T> {
  final ViewState state;
  final T? data;
  final String? error;
  final String? message;
  final bool isLoading;
  final bool isRefreshing;
  
  const ViewStateModel({
    this.state = ViewState.initial,
    this.data,
    this.error,
    this.message,
    this.isLoading = false,
    this.isRefreshing = false,
  });
  
  // Factory constructors para estados comunes
  factory ViewStateModel.initial() {
    return const ViewStateModel(state: ViewState.initial);
  }
  
  factory ViewStateModel.loading({bool refreshing = false}) {
    return ViewStateModel(
      state: ViewState.loading,
      isLoading: true,
      isRefreshing: refreshing,
    );
  }
  
  factory ViewStateModel.success(T data, {String? message}) {
    return ViewStateModel(
      state: ViewState.success,
      data: data,
      message: message,
    );
  }
  
  factory ViewStateModel.error(String error) {
    return ViewStateModel(
      state: ViewState.error,
      error: error,
    );
  }
  
  factory ViewStateModel.empty({String? message}) {
    return ViewStateModel(
      state: ViewState.empty,
      message: message ?? 'No hay datos disponibles',
    );
  }
  
  // Getters útiles
  bool get isInitial => state == ViewState.initial;
  bool get isLoadingState => state == ViewState.loading;
  bool get isSuccess => state == ViewState.success;
  bool get isError => state == ViewState.error;
  bool get isEmpty => state == ViewState.empty;
  bool get hasData => data != null;
  bool get hasError => error != null;
  
  // Método para copiar con modificaciones
  ViewStateModel<T> copyWith({
    ViewState? state,
    T? data,
    String? error,
    String? message,
    bool? isLoading,
    bool? isRefreshing,
    bool clearData = false,
    bool clearError = false,
  }) {
    return ViewStateModel(
      state: state ?? this.state,
      data: clearData ? null : (data ?? this.data),
      error: clearError ? null : (error ?? this.error),
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
  
  @override
  String toString() {
    return 'ViewStateModel(state: $state, data: $data, error: $error, message: $message)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ViewStateModel<T> &&
        other.state == state &&
        other.data == data &&
        other.error == error &&
        other.message == message &&
        other.isLoading == isLoading &&
        other.isRefreshing == isRefreshing;
  }
  
  @override
  int get hashCode {
    return state.hashCode ^
        data.hashCode ^
        error.hashCode ^
        message.hashCode ^
        isLoading.hashCode ^
        isRefreshing.hashCode;
  }
}

// Mixin para agregar funcionalidad de estado a cualquier Controller
mixin ViewStateMixin<T> {
  final Rx<ViewState> _viewState = ViewState.initial.obs;
  final Rx<String> _errorMessage = ''.obs;
  final Rx<String> _successMessage = ''.obs;
  
  ViewState get viewState => _viewState.value;
  String get errorMessage => _errorMessage.value;
  String get successMessage => _successMessage.value;
  
  bool get isLoading => _viewState.value == ViewState.loading;
  bool get isSuccess => _viewState.value == ViewState.success;
  bool get isError => _viewState.value == ViewState.error;
  bool get isEmpty => _viewState.value == ViewState.empty;
  bool get isInitial => _viewState.value == ViewState.initial;
  
  void setInitial() {
    _viewState.value = ViewState.initial;
    _errorMessage.value = '';
    _successMessage.value = '';
  }
  
  void setLoading() {
    _viewState.value = ViewState.loading;
    _errorMessage.value = '';
  }
  
  void setSuccess({String? message}) {
    _viewState.value = ViewState.success;
    _successMessage.value = message ?? '';
    _errorMessage.value = '';
  }
  
  void setError(String error) {
    _viewState.value = ViewState.error;
    _errorMessage.value = error;
    _successMessage.value = '';
  }
  
  void setEmpty({String? message}) {
    _viewState.value = ViewState.empty;
    _successMessage.value = message ?? 'No hay datos disponibles';
    _errorMessage.value = '';
  }
  
  Stream<ViewState> get viewStateStream => _viewState.stream;
  Stream<String> get errorMessageStream => _errorMessage.stream;
  Stream<String> get successMessageStream => _successMessage.stream;
}

// Widget helper para manejar diferentes estados
class ViewStateBuilder<T> extends StatelessWidget {
  final ViewStateModel<T> viewState;
  final Widget Function(T data) onSuccess;
  final Widget Function()? onLoading;
  final Widget Function(String error)? onError;
  final Widget Function(String? message)? onEmpty;
  final Widget Function()? onInitial;
  
  const ViewStateBuilder({
    Key? key,
    required this.viewState,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.onEmpty,
    this.onInitial,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    switch (viewState.state) {
      case ViewState.initial:
        return onInitial?.call() ?? const SizedBox.shrink();
        
      case ViewState.loading:
        return onLoading?.call() ?? 
            const Center(child: CircularProgressIndicator());
        
      case ViewState.success:
        if (viewState.data != null) {
          return onSuccess(viewState.data as T);
        }
        return onEmpty?.call(viewState.message) ?? 
            const Center(child: Text('No hay datos'));
        
      case ViewState.error:
        return onError?.call(viewState.error ?? 'Error desconocido') ?? 
            Center(child: Text(viewState.error ?? 'Error desconocido'));
        
      case ViewState.empty:
        return onEmpty?.call(viewState.message) ?? 
            const Center(child: Text('No hay datos disponibles'));
    }
  }
}

// Extensión para Rx<ViewState>
extension RxViewStateExtension on Rx<ViewState> {
  bool get isInitial => value == ViewState.initial;
  bool get isLoading => value == ViewState.loading;
  bool get isSuccess => value == ViewState.success;
  bool get isError => value == ViewState.error;
  bool get isEmpty => value == ViewState.empty;
}