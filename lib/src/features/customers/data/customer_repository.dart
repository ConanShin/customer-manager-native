import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/customer.dart';
import '../domain/repair.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'customer_repository.g.dart';

class CustomerRepository {
  final FirebaseDatabase _database;

  CustomerRepository(this._database);

  DatabaseReference _customersRef() => _database.ref('customers');
  DatabaseReference _repairsRef() => _database.ref('repairs');

  Future<List<Customer>> getCustomers() async {
    try {
      print('Fetching customers from RTDB...');
      print('Fetching customers from RTDB...');
      final snapshot = await _customersRef().get();
      final repairsSnapshot = await _repairsRef().get();
      print('Snapshot fetched: exists=${snapshot.exists}');

      if (!snapshot.exists) {
        print('No data found at /customers');
        return [];
      }

      final dynamic value = snapshot.value;
      final List<Customer> customers = [];

      if (value != null) {
        final data = Map<dynamic, dynamic>.from(value as Map);
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
      }
      print('Successfully parsed ${customers.length} customers from main node');

      // Parse repairs node as separate customers
      final List<Customer> repairCustomers = [];
      if (repairsSnapshot.exists && repairsSnapshot.value != null) {
        final repairsData = Map<dynamic, dynamic>.from(
          repairsSnapshot.value as Map,
        );
        repairsData.forEach((key, value) {
          final customerId = key.toString();
          if (value is Map) {
            try {
              final repairNodeMap = _convertMap(value);
              final List<Repair> parsedRepairs = [];

              // extract repairs
              if (repairNodeMap.containsKey('repairReport')) {
                final rawReport = repairNodeMap['repairReport'];
                if (rawReport is List) {
                  for (final item in rawReport) {
                    if (item == null) continue;
                    try {
                      final safeMap = _convertMap(item);
                      if (!safeMap.containsKey('id')) {
                        safeMap['id'] = 'repair_${parsedRepairs.length}';
                      }
                      // Ensure required fields
                      if (safeMap['date'] == null) safeMap['date'] = '';
                      if (safeMap['content'] == null) safeMap['content'] = '';

                      parsedRepairs.add(Repair.fromJson(safeMap));
                    } catch (e) {
                      print('Error parsing repair item for $customerId: $e');
                    }
                  }
                }
                // Remove repairReport from map to avoid confusion/failures in Customer.fromJson if it was strict
                // (Customer.fromJson is permissive so it's fine, but we need to map to 'repairs')
              }

              // Create Customer
              repairNodeMap['id'] = customerId;
              repairNodeMap['repairs'] = parsedRepairs
                  .map((e) => e.toJson())
                  .toList();

              // Handle potentially missing required fields for Customer
              if (repairNodeMap['name'] == null)
                repairNodeMap['name'] = 'Unknown';
              if (repairNodeMap['address'] == null)
                repairNodeMap['address'] = '';

              repairCustomers.add(Customer.fromJson(repairNodeMap));
            } catch (e) {
              print('Error parsing repair customer $customerId: $e');
            }
          }
        });
      }
      print('Parsed ${repairCustomers.length} customers from repairs node');

      customers.addAll(repairCustomers);

      print('Final combined customer count: ${customers.length}');
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

    // Explicitly convert repairs list to avoid "Instance of _Repair" error
    if (json['repairs'] is List) {
      json['repairs'] = (json['repairs'] as List).map((e) {
        if (e is Repair) return e.toJson();
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

    // Explicitly convert repairs list to avoid "Instance of _Repair" error
    if (json['repairs'] is List) {
      json['repairs'] = (json['repairs'] as List).map((e) {
        if (e is Repair) return e.toJson();
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

  Future<List<String>> sanitizeAndMigrateData() async {
    final logs = <String>[];
    try {
      final customers = await getCustomers();
      for (final customer in customers) {
        bool changed = false;
        String logPrefix = '[${customer.name}]';

        String? newBirthDate = customer.birthDate;
        String? newAge = customer.age;
        String? newMobile = customer.mobilePhoneNumber;
        String? newPhone = customer.phoneNumber;
        String? newAddress = customer.address;

        // 1. Migrate Birth Date from Age or Fix incomplete Birth Date
        if (newBirthDate == null || newBirthDate.isEmpty) {
          if (newAge != null && newAge.isNotEmpty) {
            // Handle "7세" or "7" in newAge
            var val = newAge.trim();
            if (val.endsWith('세')) {
              val = val.substring(0, val.length - 1).trim();
            }

            final ageInt = int.tryParse(val);

            if (ageInt != null) {
              final now = DateTime.now();
              final birthYear = now.year - ageInt;
              newBirthDate = '$birthYear-01-01';
              logs.add(
                '$logPrefix Missing BirthDate. Age $newAge -> Created BirthDate $newBirthDate',
              );
              changed = true;
            }
          }
        } else {
          // Normalize input
          final input = newBirthDate.trim();

          // Check if birthDate is just a year (4 digits, optional dot/space)
          // e.g. "1955", "1955.", "1955 "
          final yearMatch = RegExp(r'^(\d{4})[\.\s]*$').firstMatch(input);

          // Check for "Age(Year criteria)" format e.g. "57세(2019년기준)"
          final ageYearMatch = RegExp(
            r'^(\d+)\s*세\s?\((\d{4})년\s?기준\)$',
          ).firstMatch(input);

          // Check for Partial Age match (contains "n세") - safer to check LAST
          // e.g. "7세", "만 7세", "7세입니다", "7 세"
          final partialAgeMatch = RegExp(r'(\d+)\s*세').firstMatch(input);

          // Check if it's JUST a number (1-3 digits) and looks like an age (< 150)
          final numericMatch = RegExp(r'^(\d{1,3})$').firstMatch(input);

          if (yearMatch != null) {
            final year = yearMatch.group(1);
            final oldDate = newBirthDate;
            newBirthDate = '$year-01-01';
            logs.add(
              '$logPrefix Incomplete BirthDate $oldDate -> Fixed BirthDate $newBirthDate',
            );
            changed = true;
          } else if (ageYearMatch != null) {
            // It's "57세(2019년기준)" format
            final ageInt = int.tryParse(ageYearMatch.group(1)!);
            final criteriaYearInt = int.tryParse(ageYearMatch.group(2)!);

            if (ageInt != null && criteriaYearInt != null) {
              final birthYear = criteriaYearInt - ageInt;
              final oldData = newBirthDate;
              newBirthDate = '$birthYear-01-01';
              logs.add(
                '$logPrefix BirthDate field contained "$oldData" -> Calculated BirthDate $newBirthDate',
              );
              changed = true;
            }
          } else if (partialAgeMatch != null) {
            // It contains "n세" somewhere
            final ageInt = int.tryParse(partialAgeMatch.group(1)!);
            if (ageInt != null) {
              final now = DateTime.now();
              final birthYear = now.year - ageInt;
              final oldData = newBirthDate;
              newBirthDate = '$birthYear-01-01';
              logs.add(
                '$logPrefix BirthDate field contained Age "$oldData" -> Converted to BirthDate $newBirthDate',
              );
              changed = true;
            }
          } else if (numericMatch != null) {
            // Just a number, assume age if reasonable
            final ageInt = int.tryParse(numericMatch.group(1)!);
            if (ageInt != null && ageInt > 0 && ageInt < 150) {
              final now = DateTime.now();
              final birthYear = now.year - ageInt;
              final oldData = newBirthDate;
              newBirthDate = '$birthYear-01-01';
              logs.add(
                '$logPrefix BirthDate field was number "$oldData" -> Assumed Age -> BirthDate $newBirthDate',
              );
              changed = true;
            }
          }
        }

        // 2. Sanitize "0" values
        if (newMobile == '0') {
          newMobile = '';
          logs.add('$logPrefix Cleared invalid mobile number "0"');
          changed = true;
        }
        if (newPhone == '0') {
          newPhone = '';
          logs.add('$logPrefix Cleared invalid phone number "0"');
          changed = true;
        }
        if (newAddress == '0') {
          newAddress = '';
          logs.add('$logPrefix Cleared invalid address "0"');
          changed = true;
        }

        // 3. Save if changed
        if (changed) {
          final updated = customer.copyWith(
            birthDate: newBirthDate,
            mobilePhoneNumber: newMobile,
            phoneNumber: newPhone,
            address: newAddress,
          );
          await updateCustomer(updated);
        }
      }
    } catch (e) {
      logs.add('Error during sanitization: $e');
    }
    return logs;
  }

  Future<void> migrateToSupabase() async {
    print('Starting migration to Supabase...');
    // Access Supabase client (assumes Supabase.initialize() has been called)
    final supabase = Supabase.instance.client;
    final customers = await getCustomers();

    int successCount = 0;
    int failCount = 0;

    for (final customer in customers) {
      try {
        // 1. Insert Customer
        // Helper to convert empty strings to null for date fields if needed,
        // strictly speaking Supabase/Postgres dates can't be empty string.
        String? toDate(String? val) {
          if (val == null || val.trim().isEmpty) return null;
          // Validate format YYYY-MM-DD
          if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(val.trim())) {
            return val.trim();
          }
          return null;
        }

        await supabase.from('customers').upsert({
          'id': customer.id,
          'name': customer.name,
          'age': customer.age,
          'birth_date': toDate(customer.birthDate),
          'sex': customer.sex,
          'phone_number': customer.phoneNumber,
          'mobile_phone_number': customer.mobilePhoneNumber,
          'address': customer.address,
          'card_availability': customer.cardAvailability,
          'registration_date': toDate(customer.registrationDate),
          'battery_order_date': customer.batteryOrderDate,
          'note': customer.note,
          'updated_at': DateTime.now().toIso8601String(),
        });

        // 2. Insert Hearing Aids
        if (customer.hearingAid != null && customer.hearingAid!.isNotEmpty) {
          final hearingAidsData = customer.hearingAid!
              .map(
                (ha) => {
                  'customer_id': customer.id,
                  'side': ha.side,
                  'model': ha.model,
                  'date': ha.date,
                },
              )
              .toList();
          await supabase.from('hearing_aids').upsert(hearingAidsData);
        }

        // 3. Insert Repairs
        if (customer.repairs != null && customer.repairs!.isNotEmpty) {
          final repairsData = customer.repairs!.map((r) {
            // Generate a unique ID if the generic one from local parsing was used
            // Or just prefix with customer ID to ensure uniqueness
            final uniqueRepairId = '${customer.id}_${r.id}';

            return {
              'id': uniqueRepairId,
              'customer_id': customer.id,
              'date': r.date,
              'content': r.content,
              'is_completed': r.isCompleted,
              'cost': r.cost,
            };
          }).toList();
          await supabase.from('repairs').upsert(repairsData);
        }

        print('Migrated customer: ${customer.name}');
        successCount++;
      } catch (e) {
        print(
          'Failed to migrate customer ${customer.name} (${customer.id}): $e',
        );
        failCount++;
      }
    }

    print('Migration complete. Success: $successCount, Failed: $failCount');
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
