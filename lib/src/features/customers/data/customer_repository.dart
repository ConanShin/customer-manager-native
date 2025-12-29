import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/customer.dart';

part 'customer_repository.g.dart';

class CustomerRepository {
  final FirebaseDatabase _database;

  CustomerRepository(this._database);

  DatabaseReference _customersRef() => _database.ref('customers');

  Future<List<Customer>> getCustomers() async {
    try {
      print('Fetching customers from RTDB...');
      final snapshot = await _customersRef().get();
      print('Snapshot fetched: exists=${snapshot.exists}');

      if (!snapshot.exists) {
        print('No data found at /customers');
        return [];
      }

      final dynamic value = snapshot.value;
      if (value == null) return [];

      final data = Map<dynamic, dynamic>.from(value as Map);
      final List<Customer> customers = [];

      for (final entry in data.entries) {
        try {
          // Convert the inner map safely
          final safeMap = _convertMap(entry.value);
          safeMap['id'] = entry.key.toString();

          customers.add(Customer.fromJson(safeMap));
        } catch (e) {
          print('Error parsing customer ${entry.key}: $e');
        }
      }
      print('Successfully parsed ${customers.length} customers');
      return customers;
    } catch (e, stack) {
      print('Error in getCustomers: $e');
      print(stack);
      rethrow;
    }
  }

  /// Recursively converts Map<dynamic, dynamic> to Map<String, dynamic>
  /// and ensures basic types match what Freezed expects (e.g. int -> String).
  Map<String, dynamic> _convertMap(dynamic input) {
    if (input == null) return {};

    final Map<dynamic, dynamic> original = input as Map<dynamic, dynamic>;
    final Map<String, dynamic> converted = {};

    original.forEach((key, value) {
      final String stringKey = key.toString();

      if (value is Map) {
        converted[stringKey] = _convertMap(value);
      } else if (value is List) {
        converted[stringKey] = value.map((e) {
          if (e is Map) return _convertMap(e);
          return e;
        }).toList();
      } else {
        // Since the Customer model uses 'String' for almost all fields,
        // we safely convert numbers and booleans to String to prevent cast errors.
        if (value is num || value is bool) {
          converted[stringKey] = value.toString();
        } else {
          converted[stringKey] = value;
        }
      }
    });

    return converted;
  }

  Future<void> addCustomer(Customer customer) async {
    final json = customer.toJson();
    json.remove('id');

    // Explicitly convert nested objects to avoid "Instance of _HearingAid" error
    if (json['hearingAid'] is List) {
      json['hearingAid'] = (json['hearingAid'] as List).map((e) {
        // Check if it's already a map or needs conversion
        if (e is HearingAid) return e.toJson();
        // If generic object (rare), try dynamic call or leave it
        try {
          return (e as dynamic).toJson();
        } catch (_) {
          return e;
        }
      }).toList();
    }

    await _customersRef().push().set(json);
  }

  Future<void> updateCustomer(Customer customer) async {
    final json = customer.toJson();
    json.remove('id');

    // Explicitly convert nested objects to avoid "Instance of _HearingAid" error
    if (json['hearingAid'] is List) {
      json['hearingAid'] = (json['hearingAid'] as List).map((e) {
        if (e is HearingAid) return e.toJson();
        try {
          return (e as dynamic).toJson();
        } catch (_) {
          return e;
        }
      }).toList();
    }

    await _customersRef().child(customer.id).set(json);
  }

  Future<void> deleteCustomer(String customerId) async {
    await _customersRef().child(customerId).remove();
  }
}

@riverpod
CustomerRepository customerRepository(Ref ref) {
  return CustomerRepository(FirebaseDatabase.instance);
}

@riverpod
Future<List<Customer>> customersList(Ref ref) async {
  final repository = ref.watch(customerRepositoryProvider);
  return repository.getCustomers();
}
