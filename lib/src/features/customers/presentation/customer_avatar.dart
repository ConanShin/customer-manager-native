import 'dart:io';
import 'package:flutter/material.dart';
import '../domain/customer.dart';

class CustomerAvatar extends StatelessWidget {
  final Customer customer;
  final double radius;
  final double? fontSize;
  final File? imageFile;

  const CustomerAvatar({
    super.key,
    required this.customer,
    this.radius = 20,
    this.fontSize,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    const storageBucket = 'starkey.appspot.com';
    final customerId = customer.id;
    final updatedAt = customer.updatedAt;

    // Construct Firebase Storage URL
    final timestamp = updatedAt != null
        ? DateTime.tryParse(updatedAt)?.millisecondsSinceEpoch.toString() ?? ''
        : '';

    final imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/$storageBucket/o/customer_profiles%2F$customerId?alt=media&t=$timestamp';

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors
          .primaries[customer.name.hashCode % Colors.primaries.length]
          .shade100,
      child: ClipOval(
        child: imageFile != null
            ? Image.file(
                imageFile!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
              )
            : Image.network(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      customer.name.trim().isNotEmpty
                          ? String.fromCharCode(
                              customer.name.trim().runes.first,
                            ).toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: Colors
                            .primaries[customer.name.hashCode %
                                Colors.primaries.length]
                            .shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
