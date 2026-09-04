// lib/features/offer/presentation/pages/register_offer_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/features/businesses/domain/entities/sucursal.dart';
import '../controllers/add_offer_controller.dart';

class RegisterOfferPage extends GetView<AddOfferController> {
  const RegisterOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar oferta'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Indicador de progreso (no necesita Obx)
            _buildProgressIndicator(),
            const SizedBox(height: 16),
            
            // Contenido
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Producto seleccionado
                  _buildProductoSeleccionado(),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Detalles de la oferta',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 16),
                  
                  // Precio regular
                  TextField(
                    controller: controller.precioRegularController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Precio regular *',
                      prefixIcon: Icon(Icons.monetization_on),
                      border: OutlineInputBorder(),
                      hintText: 'Ej: 100.00',
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Precio remate
                  TextField(
                    controller: controller.precioRemateController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Precio de remate *',
                      prefixIcon: Icon(Icons.local_offer),
                      border: OutlineInputBorder(),
                      hintText: 'Ej: 70.00',
                    ),
                  ),
                  
                  // Descuento calculado - CORREGIDO: usar GetBuilder
                  GetBuilder<AddOfferController>(
                    id: 'offer_form',
                    builder: (controller) {
                      final descuento = controller.porcentajeDescuento;
                      if (descuento == null) {
                        return const SizedBox.shrink();
                      }
                      
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.percent, size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              'Descuento: ${descuento.toStringAsFixed(2)}%',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Stock
                  TextField(
                    controller: controller.stockController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Stock disponible *',
                      prefixIcon: Icon(Icons.inventory),
                      border: OutlineInputBorder(),
                      hintText: 'Ej: 10',
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Sucursales
                  Text(
                    'Sucursales disponibles',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 8),
                  _buildSucursalesList(),
                  
                  // Mensaje de error - CORREGIDO: usar Obx correctamente
                  Obx(() {
                    if (controller.errorMessage.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.errorMessage,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            
            // Botón para crear ofertas - CORREGIDO: usar GetBuilder
            GetBuilder<AddOfferController>(
              id: 'offer_form',
              builder: (controller) {
                return ElevatedButton(
                  onPressed: controller.canSubmit && !controller.isSubmitting.value
                      ? controller.createOfertas
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Obx(() {
                    if (controller.isSubmitting.value) {
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    }
                    return Text(
                      'Crear ${controller.sucursalesSeleccionadas.length} oferta(s)',
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildStep(1, 'Producto', true),
          _buildConnector(true),
          _buildStep(2, 'Oferta', true),
        ],
      ),
    );
  }
  
  Widget _buildStep(int number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isActive ? AppColors.primary : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
  
  Widget _buildConnector(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isActive ? AppColors.primary : Colors.grey.shade300,
    );
  }
  
  // CORREGIDO: Usar Obx correctamente con .value
  Widget _buildProductoSeleccionado() {
    return Obx(() {
      final producto = controller.selectedProducto.value;
      if (producto == null) {
        return const SizedBox.shrink();
      }
      
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: producto.imagen != null && producto.imagen!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        producto.imagen!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.inventory_2, color: AppColors.primary);
                        },
                      ),
                    )
                  : const Icon(Icons.inventory_2, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: AppTextStyles.h3,
                  ),
                  if (producto.descripcion != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      producto.descripcion!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
  
  // CORREGIDO: Usar Obx correctamente
  Widget _buildSucursalesList() {
    return Obx(() {
      if (controller.isLoadingSucursales.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      
      if (controller.sucursales.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              const Icon(Icons.location_off, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'No hay sucursales activas',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
      
      return Column(
        children: controller.sucursales.map((Sucursal sucursal) {
          return _buildSucursalCard(sucursal);
        }).toList(),
      );
    });
  }
  
  // CORREGIDO: Usar GetBuilder para el checkbox
  Widget _buildSucursalCard(Sucursal sucursal) {
    return GetBuilder<AddOfferController>(
      id: 'offer_form',
      builder: (controller) {
        final isSelected = controller.isSucursalSelected(sucursal.id);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: CheckboxListTile(
            value: isSelected,
            onChanged: (_) {
              controller.toggleSucursal(sucursal.id);
            },
            title: Text(
              sucursal.direccion,
              style: const TextStyle(fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: sucursal.celular != null
                ? Text(sucursal.celular!)
                : null,
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        );
      },
    );
  }
}