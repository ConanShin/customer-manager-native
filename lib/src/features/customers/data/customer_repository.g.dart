// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(customerRepository)
final customerRepositoryProvider = CustomerRepositoryProvider._();

final class CustomerRepositoryProvider
    extends
        $FunctionalProvider<
          CustomerRepository,
          CustomerRepository,
          CustomerRepository
        >
    with $Provider<CustomerRepository> {
  CustomerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerRepository create(Ref ref) {
    return customerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRepository>(value),
    );
  }
}

String _$customerRepositoryHash() =>
    r'c40a0b698fa04c381b284c69834239137ef75929';

@ProviderFor(customersList)
final customersListProvider = CustomersListProvider._();

final class CustomersListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Customer>>,
          List<Customer>,
          FutureOr<List<Customer>>
        >
    with $FutureModifier<List<Customer>>, $FutureProvider<List<Customer>> {
  CustomersListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customersListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customersListHash();

  @$internal
  @override
  $FutureProviderElement<List<Customer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Customer>> create(Ref ref) {
    return customersList(ref);
  }
}

String _$customersListHash() => r'11a55711090b3addba4e517a66e730c141612c9c';
