<div align="center">

# 🏷️ LURAÑAPP

### Reúne remates, descuentos y ofertas de comercios locales en Bolivia

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![GetX](https://img.shields.io/badge/GetX-8A2BE2?style=for-the-badge&logo=flutter&logoColor=white)](https://pub.dev/packages/get)

</div>

---

## 📖 Descripción

**LURAÑAPP** es una aplicación móvil enfocada en reunir remates, descuentos y ofertas de productos de comercios locales en Bolivia. La app conecta a los usuarios con promociones vigentes de manera simple y accesible, y ofrece a los comercios un canal directo para publicar y gestionar sus ofertas.

El proyecto aplica una **arquitectura escalable por capas** con Flutter, separando repositorios, servicios y controladores, y utiliza **Supabase** como backend con políticas de seguridad a nivel de fila (RLS) para proteger la información de usuarios, comercios y publicaciones.

---

## ✨ Características principales

- 🏪 **Catálogo de comercios locales** con perfil y publicaciones.
- 💰 **Ofertas, remates y descuentos** organizados por categorías.
- 🔍 **Búsqueda y filtrado** de productos y promociones.
- 🔐 **Autenticación de usuarios** con Supabase Auth.
- 🛡️ **Políticas RLS** para proteger la información sensible.
- ☁️ **Almacenamiento en la nube** con Supabase Storage.
- 🧩 **Arquitectura por capas**: repositorios, servicios y controladores.
- ⚡ **Consumo de servicios mediante API** con separación de responsabilidades.

---

## 🛠️ Stack tecnológico

| Capa | Tecnologías |
|------|-------------|
| **Frontend móvil** | Flutter · Dart |
| **Gestión de estado** | GetX |
| **Backend / BaaS** | Supabase |
| **Base de datos** | PostgreSQL |
| **Autenticación** | Supabase Auth |
| **Almacenamiento** | Supabase Storage |
| **Seguridad** | Row Level Security (RLS) |

---

## 🏗️ Arquitectura por capas
┌──────────────────────────────────────────────┐
│ UI (Screens) │
├──────────────────────────────────────────────┤
│ Controllers (GetX) │
├──────────────────────────────────────────────┤
│ Services (API) │
├──────────────────────────────────────────────┤
│ Repositories (Data) │
├──────────────────────────────────────────────┤
│ Supabase Client (Backend) │
└──────────────────────────────────────────────┘

text

---

## 🚀 Instalación

### Requisitos previos

- Flutter SDK `>=3.0.0`
- Cuenta de Supabase
- Android Studio / VS Code

### Pasos

```bash
# Clonar el repositorio
git clone https://github.com/J0hannLara/luranapp.git
cd luranapp

# Instalar dependencias
flutter pub get

# Configurar credenciales de Supabase
# Crea un archivo lib/config/supabase_config.dart con:
#   const supabaseUrl = 'TU_URL';
#   const supabaseAnonKey = 'TU_ANON_KEY';

# Ejecutar la app
flutter run
```

🔒 Seguridad con RLS
LURAÑAPP aplica Row Level Security en todas las tablas críticas de Supabase:

Los usuarios solo pueden leer y modificar sus propios datos.

Los comercios solo pueden gestionar sus propias publicaciones.

Las ofertas públicas son visibles para todos pero solo editables por su dueño.

Los datos sensibles están protegidos por políticas por rol.

🎯 Roadmap
☑ Autenticación con Supabase
☑ Catálogo de ofertas y remates
☑ Arquitectura por capas
☑ Políticas RLS configuradas
□ Notificaciones push
□ Búsqueda con geolocalización
□ Modo favoritos
□ Panel web para comercios
□ Estadísticas para publicaciones
👨‍💻 Autor
Laradev — Desarrollador Full Stack


<div align="center">
⭐ Si te gustó este proyecto, dale una estrella ⭐

</div>
