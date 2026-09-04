// lib/features/offer/presentation/pages/select_product_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luranapp/core/theme/app_colors.dart';
import 'package:luranapp/core/theme/app_text_styles.dart';
import 'package:luranapp/features/product/domain/entities/categoria.dart';
import 'package:luranapp/features/product/domain/entities/sub_categoria.dart';
import 'package:luranapp/features/product/domain/entities/producto.dart';
import '../controllers/add_offer_controller.dart';

class SelectProductPage extends GetView<AddOfferController> {
  const SelectProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar producto'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Indicador de progreso
            _buildProgressIndicator(),
            const SizedBox(height: 16),
            
            // Contenido
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    '¿Qué producto vas a rematar?',
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecciona la categoría y subcategoría para encontrar el producto',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Categoría
                  _buildCategoriaDropdown(),
                  const SizedBox(height: 16),
                  
                  // Subcategoría
                  _buildSubCategoriaDropdown(),
                  const SizedBox(height: 16),
                  
                  // Lista de productos
                  _buildProductosList(),
                  
                  // Botón para registrar nuevo producto
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () {
                      Get.toNamed('/business/producto/register/${controller.businessId}');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar nuevo producto'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
            
            // Botón para continuar
            Container(
              padding: const EdgeInsets.all(24),
              child: GetBuilder<AddOfferController>(
                id: 'product_selection',
                builder: (controller) {
                  return ElevatedButton(
                    onPressed: controller.canContinue
                        ? () {
                            Get.toNamed('/business/oferta/registrar/${controller.businessId}');
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Continuar'),
                  );
                },
              ),
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
          _buildStep(2, 'Oferta', false),
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
  
  Widget _buildCategoriaDropdown() {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: controller.selectedCategoria.value?.id,
        decoration: const InputDecoration(
          labelText: 'Categoría',
          prefixIcon: Icon(Icons.category),
          border: OutlineInputBorder(),
        ),
        hint: const Text('Selecciona una categoría'),
        items: controller.categorias.map((Categoria categoria) {
          return DropdownMenuItem<String>(
            value: categoria.id,
            child: Text(categoria.nombre),
          );
        }).toList(),
        onChanged: controller.isLoadingCategorias.value
            ? null
            : (value) {
                if (value != null) {
                  final categoria = controller.categorias.firstWhere((c) => c.id == value);
                  controller.selectCategoria(categoria);
                }
              },
      );
    });
  }
  
  Widget _buildSubCategoriaDropdown() {
    return Obx(() {
      final enabled = controller.selectedCategoria.value != null && 
                      !controller.isLoadingSubCategorias.value;
      
      return DropdownButtonFormField<String>(
        value: controller.selectedSubCategoria.value?.id,
        decoration: InputDecoration(
          labelText: 'Subcategoría',
          prefixIcon: const Icon(Icons.subdirectory_arrow_right),
          border: const OutlineInputBorder(),
          suffixIcon: controller.isLoadingSubCategorias.value
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
        ),
        hint: Text(
          controller.selectedCategoria.value == null
              ? 'Primero selecciona una categoría'
              : 'Selecciona una subcategoría',
        ),
        items: controller.subCategorias.map((SubCategoria subCategoria) {
          return DropdownMenuItem<String>(
            value: subCategoria.id,
            child: Text(subCategoria.nombre),
          );
        }).toList(),
        onChanged: enabled
            ? (value) {
                if (value != null) {
                  final subCategoria = controller.subCategorias.firstWhere((sc) => sc.id == value);
                  controller.selectSubCategoria(subCategoria);
                }
              }
            : null,
      );
    });
  }
  
  Widget _buildProductosList() {
    return Obx(() {
      if (controller.isLoadingProductos.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      
      if (controller.selectedSubCategoria.value == null) {
        return const SizedBox.shrink();
      }
      
      if (controller.productos.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              const Icon(Icons.inventory_2, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                'No hay productos en esta subcategoría',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Registra un nuevo producto',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Productos disponibles', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          ...controller.productos.map((Producto producto) {
            return _buildProductoCard(producto);
          }),
        ],
      );
    });
  }
  
  Widget _buildProductoCard(Producto producto) {
    return Obx(() {
      final isSelected = controller.selectedProducto.value?.id == producto.id;
      
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
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
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
          title: Text(
            producto.nombre,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: producto.descripcion != null
              ? Text(
                  producto.descripcion!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: AppColors.primary)
              : const Icon(Icons.radio_button_unchecked),
          onTap: () {
            controller.selectProducto(producto);
          },
        ),
      );
    });
  }
}