// lib/core/services/location_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';

class LocationService {
  final http.Client _client;
  
  LocationService({http.Client? client}) : _client = client ?? http.Client();
  
  // API de países (gratuita y sin key)
  static const String _countriesApiUrl = 'https://restcountries.com/v3.1';
  
  // API de ciudades (gratuita con límite de requests)
  static const String _citiesApiUrl = 'https://wft-geo-db.p.rapidapi.com/v1/geo/cities';
  static const String _geoDbApiKey = 'YOUR_RAPIDAPI_KEY'; // Regístrate en RapidAPI para obtener key gratuita
  
  /// Obtiene lista de países
  Future<List<Country>> getCountries() async {
    try {
      final response = await _client.get(
        Uri.parse('$_countriesApiUrl/all?fields=name,flags,cca2'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        final countries = data.map((country) {
          return Country(
            name: country['name']['common'] as String,
            code: country['cca2'] as String,
            flag: country['flags']['png'] as String?,
          );
        }).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
        
        return countries;
      } else {
        throw LocationException('Error al cargar países: ${response.statusCode}');
      }
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationException('Error de conexión al cargar países: $e');
    }
  }
  
  /// Obtiene lista de ciudades por país
  Future<List<City>> getCitiesByCountry(String countryCode) async {
    try {
      final response = await _client.get(
        Uri.parse('$_citiesApiUrl?countryIds=$countryCode&limit=10&sort=-population'),
        headers: {
          'X-RapidAPI-Key': _geoDbApiKey,
          'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> citiesData = data['data'] ?? [];
        
        final cities = citiesData.map((city) {
          return City(
            name: city['city'] as String,
            country: city['country'] as String,
            countryCode: city['countryCode'] as String,
            region: city['region'] as String?,
            population: city['population'] as int?,
            latitude: (city['latitude'] as num?)?.toDouble(),
            longitude: (city['longitude'] as num?)?.toDouble(),
          );
        }).toList();
        
        return cities;
      } else {
        throw LocationException('Error al cargar ciudades: ${response.statusCode}');
      }
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationException('Error de conexión al cargar ciudades: $e');
    }
  }
  
  /// Buscar ciudades por nombre
  Future<List<City>> searchCities(String query) async {
    try {
      final response = await _client.get(
        Uri.parse('$_citiesApiUrl?namePrefix=$query&limit=10&sort=-population'),
        headers: {
          'X-RapidAPI-Key': _geoDbApiKey,
          'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> citiesData = data['data'] ?? [];
        
        final cities = citiesData.map((city) {
          return City(
            name: city['city'] as String,
            country: city['country'] as String,
            countryCode: city['countryCode'] as String,
            region: city['region'] as String?,
            population: city['population'] as int?,
            latitude: (city['latitude'] as num?)?.toDouble(),
            longitude: (city['longitude'] as num?)?.toDouble(),
          );
        }).toList();
        
        return cities;
      } else {
        throw LocationException('Error al buscar ciudades: ${response.statusCode}');
      }
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationException('Error de conexión al buscar ciudades: $e');
    }
  }
  
  void dispose() {
    _client.close();
  }
}

// Modelos
class Country {
  final String name;
  final String code;
  final String? flag;
  
  Country({
    required this.name,
    required this.code,
    this.flag,
  });
  
  @override
  String toString() => name;
}

class City {
  final String name;
  final String country;
  final String countryCode;
  final String? region;
  final int? population;
  final double? latitude;
  final double? longitude;
  
  City({
    required this.name,
    required this.country,
    required this.countryCode,
    this.region,
    this.population,
    this.latitude,
    this.longitude,
  });
  
  @override
  String toString() => name;
}