// lib/features/business/domain/entities/rol_negocio.dart

enum RolNegocio {
  propietario('propietario', 'Propietario'),
  administrador('administrador', 'Administrador'),
  empleado('empleado', 'Empleado');

  final String value;
  final String label;

  const RolNegocio(this.value, this.label);

  static RolNegocio fromString(String? value) {
    return RolNegocio.values.firstWhere(
      (rol) => rol.value == value,
      orElse: () => RolNegocio.empleado,
    );
  }

  String toJson() => value;
}