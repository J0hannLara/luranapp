// lib/features/auth/presentation/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../../../core/utils/view_state.dart';
import '../../../../core/routes/app_routes.dart';

class AuthController extends GetxController with ViewStateMixin {
  final AuthRepositoryInterface _authRepository;
  
  AuthController(this._authRepository);
  
  // Controllers para los campos de texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // Controllers para el onboarding
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController paisController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  
  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  
  bool get isAuthenticated => currentUser.value != null;
  bool get needsOnboarding => currentUser.value?.needsOnboarding ?? false;
  bool get isBusiness => currentUser.value?.isBusiness ?? false;
  
  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    paisController.dispose();
    ciudadController.dispose();
    super.onClose();
  }
  
  Future<void> _initializeAuth() async {
    try {
      final user = await _authRepository.getCurrentUser();
      currentUser.value = user;
      
      if (user != null) {
        setSuccess(message: 'Sesión iniciada');
      } else {
        setInitial();
      }
      
      _authRepository.authStateChanges.listen((user) {
        currentUser.value = user;
        if (user != null) {
          setSuccess(message: 'Sesión iniciada');
        } else {
          setInitial();
        }
      });
    } catch (e) {
      setError(e.toString());
    }
  }
  
  Future<void> checkAuthStatus() async {
    try {
      final user = await _authRepository.getCurrentUser();
      currentUser.value = user;
      
      if (user != null) {
        setSuccess(message: 'Sesión iniciada');
      } else {
        setInitial();
      }
    } catch (e) {
      setInitial();
    }
  }
  
  Future<void> loginAsCustomer() async {
    if (emailController.text.trim().isEmpty) {
      setError('Por favor ingresa tu correo electrónico');
      return;
    }
    
    if (passwordController.text.isEmpty) {
      setError('Por favor ingresa tu contraseña');
      return;
    }
    
    await signIn(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }
  
  Future<void> loginAsBusiness() async {
    await signIn(
      email: 'demo@business.com',
      password: 'demo123',
    );
  }
  
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      setLoading();
      
      final user = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      
      currentUser.value = user;
      setSuccess(message: 'Bienvenido ${user.username}');
      
      _clearFields();
      
      // Navegar según el estado de onboarding
      _navigateAfterAuth();
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    }
  }
  
  Future<void> register() async {
    // Validaciones existentes...
    if (nameController.text.trim().isEmpty) {
      setError('Por favor ingresa tu nombre completo');
      return;
    }
    
    if (emailController.text.trim().isEmpty) {
      setError('Por favor ingresa tu correo electrónico');
      return;
    }
    
    if (!_isValidEmail(emailController.text.trim())) {
      setError('Por favor ingresa un correo electrónico válido');
      return;
    }
    
    if (passwordController.text.length < 6) {
      setError('La contraseña debe tener al menos 6 caracteres');
      return;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      setError('Las contraseñas no coinciden');
      return;
    }
    
    await signUp(
      email: emailController.text.trim(),
      password: passwordController.text,
      name: nameController.text.trim(),
    );
  }
  
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      setLoading();
      
      final user = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );
      
      currentUser.value = user;
      setSuccess(message: 'Registro exitoso');
      
      _clearFields();
      
      // Mostrar mensaje de verificación de email
      Get.snackbar(
        'Registro exitoso',
        'Por favor verifica tu email para continuar',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      
      // Navegar al onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    }
  }
  
  Future<void> completeOnboarding() async {
    // Validar campos
    if (usernameController.text.trim().isEmpty) {
      setError('Por favor ingresa un nombre de usuario');
      return;
    }
    
    if (usernameController.text.trim().length < 3) {
      setError('El nombre de usuario debe tener al menos 3 caracteres');
      return;
    }
    
    if (paisController.text.trim().isEmpty) {
      setError('Por favor ingresa tu país');
      return;
    }
    
    if (ciudadController.text.trim().isEmpty) {
      setError('Por favor ingresa tu ciudad');
      return;
    }
    
    try {
      setLoading();
      
      final user = currentUser.value;
      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }
      
      final updatedUser = await _authRepository.updateUserProfile(
        userId: user.id,
        username: usernameController.text.trim(),
        pais: paisController.text.trim(),
        ciudad: ciudadController.text.trim(),
      );
      
      currentUser.value = updatedUser;
      setSuccess(message: 'Perfil actualizado exitosamente');
      
      // Limpiar campos de onboarding
      usernameController.clear();
      paisController.clear();
      ciudadController.clear();
      
      // Navegar al main
      Get.offAllNamed(AppRoutes.customerMain);
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
    }
  }
  
  void skipOnboarding() {
    // Permitir saltar el onboarding (opcional)
    Get.offAllNamed(AppRoutes.customerMain);
  }
  
  Future<void> signOut() async {
    try {
      setLoading();
      
      await _authRepository.signOut();
      currentUser.value = null;
      setInitial();
      
      _clearFields();
      
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      setError(_getErrorMessage(e.toString()));
      Get.snackbar(
        'Error',
        'No se pudo cerrar sesión',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void _navigateAfterAuth() {
    final user = currentUser.value;
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    
    if (user.needsOnboarding) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      Get.offAllNamed(AppRoutes.customerMain);
    }
  }
  
  void _clearFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
  }
  
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  
  String _getErrorMessage(String error) {
    if (error.contains('USERNAME_TAKEN')) {
      return 'El nombre de usuario ya está en uso';
    }
    if (error.contains('invalid_credentials')) {
      return 'Correo o contraseña incorrectos';
    }
    if (error.contains('user_already_exists')) {
      return 'Este correo ya está registrado';
    }
    if (error.contains('weak_password')) {
      return 'La contraseña es demasiado débil';
    }
    if (error.contains('invalid_email')) {
      return 'Correo electrónico inválido';
    }
    return error;
  }
}