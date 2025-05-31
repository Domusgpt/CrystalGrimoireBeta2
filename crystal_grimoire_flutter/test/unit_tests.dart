import 'package:flutter_test/flutter_test.dart';
import 'package:crystal_grimoire_flutter/services/enhanced_payment_service.dart';
import 'package:crystal_grimoire_flutter/services/storage_service.dart';
import 'package:crystal_grimoire_flutter/models/crystal.dart';

void main() {
  group('Payment Service Tests', () {
    test('should initialize without errors', () async {
      expect(() async => await EnhancedPaymentService.initialize(), returnsNormally);
    });

    test('should return free tier by default', () async {
      await EnhancedPaymentService.initialize();
      final status = await EnhancedPaymentService.getSubscriptionStatus();
      expect(status.tier, equals('free'));
      expect(status.isActive, equals(false));
    });

    test('should handle web platform gracefully', () async {
      final offerings = await EnhancedPaymentService.getOfferings();
      expect(offerings, isNotEmpty);
      expect(offerings.length, equals(3)); // Premium, Pro, Founders
    });
  });

  group('Storage Service Tests', () {
    test('should store and retrieve subscription tier', () async {
      await StorageService.saveSubscriptionTier('premium');
      final tier = await StorageService.getSubscriptionTier();
      expect(tier, equals('premium'));
    });

    test('should return default free tier if none stored', () async {
      await StorageService.clearUserData();
      final tier = await StorageService.getSubscriptionTier();
      expect(tier, equals('free'));
    });

    test('should track daily identifications', () async {
      await StorageService.clearUserData();
      
      // Should start at 0
      var used = await StorageService.getDailyIdentifications();
      expect(used, equals(0));
      
      // Should increment
      await StorageService.incrementIdentifications();
      used = await StorageService.getDailyIdentifications();
      expect(used, equals(1));
    });
  });

  group('Crystal Model Tests', () {
    test('should create crystal with required fields', () {
      final crystal = Crystal(
        id: 'test-id',
        name: 'Test Crystal',
        scientificName: 'Testite',
        description: 'A test crystal',
        metaphysicalProperties: ['Test property'],
        healingProperties: ['Test healing'],
        chakras: ['Root'],
        colorDescription: 'Clear',
        hardness: '7',
        formation: 'Natural',
        careInstructions: 'Test care',
        identificationDate: DateTime.now(),
        imageUrls: [],
        confidence: 0.8,
      );

      expect(crystal.name, equals('Test Crystal'));
      expect(crystal.confidence, equals(0.8));
      expect(crystal.chakras, contains('Root'));
    });

    test('should serialize to JSON', () {
      final crystal = Crystal(
        id: 'test-id',
        name: 'Test Crystal',
        scientificName: 'Testite',
        description: 'A test crystal',
        metaphysicalProperties: ['Test property'],
        healingProperties: ['Test healing'],
        chakras: ['Root'],
        colorDescription: 'Clear',
        hardness: '7',
        formation: 'Natural',
        careInstructions: 'Test care',
        identificationDate: DateTime.now(),
        imageUrls: [],
        confidence: 0.8,
      );

      final json = crystal.toJson();
      expect(json['name'], equals('Test Crystal'));
      expect(json['confidence'], equals(0.8));
    });

    test('should deserialize from JSON', () {
      final json = {
        'id': 'test-id',
        'name': 'Test Crystal',
        'scientificName': 'Testite',
        'description': 'A test crystal',
        'metaphysicalProperties': ['Test property'],
        'healingProperties': ['Test healing'],
        'chakras': ['Root'],
        'colorDescription': 'Clear',
        'hardness': '7',
        'formation': 'Natural',
        'careInstructions': 'Test care',
        'identificationDate': DateTime.now().toIso8601String(),
        'imageUrls': <String>[],
        'confidence': 0.8,
      };

      final crystal = Crystal.fromJson(json);
      expect(crystal.name, equals('Test Crystal'));
      expect(crystal.confidence, equals(0.8));
    });
  });

  group('Integration Tests', () {
    test('should handle end-to-end user flow', () async {
      // Initialize services
      await EnhancedPaymentService.initialize();
      
      // Check initial state
      var status = await EnhancedPaymentService.getSubscriptionStatus();
      expect(status.tier, equals('free'));
      
      // Simulate identification usage
      await StorageService.incrementIdentifications();
      var used = await StorageService.getDailyIdentifications();
      expect(used, equals(1));
      
      // Check if can make more identifications
      var canIdentify = await StorageService.canMakeIdentification();
      expect(canIdentify, equals(true)); // Should be true for first few
    });
  });

  group('Error Handling Tests', () {
    test('should handle invalid subscription tier gracefully', () async {
      await StorageService.saveSubscriptionTier('invalid_tier');
      final tier = await StorageService.getSubscriptionTier();
      expect(tier, equals('free')); // Should default to free
    });

    test('should handle payment failure gracefully', () async {
      final result = await EnhancedPaymentService.purchasePremium();
      expect(result.success, equals(false)); // Should fail gracefully on web
      expect(result.error, isNotNull);
    });
  });
}