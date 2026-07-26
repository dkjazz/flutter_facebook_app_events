import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('kids-app privacy defaults', () {
    test('Android removes advertising permissions before manifest merge', () {
      final manifest =
          File('android/src/main/AndroidManifest.xml').readAsStringSync();

      for (final permission in <String>[
        'com.google.android.gms.permission.AD_ID',
        'android.permission.ACCESS_ADSERVICES_AD_ID',
        'android.permission.ACCESS_ADSERVICES_ATTRIBUTION',
        'android.permission.ACCESS_ADSERVICES_CUSTOM_AUDIENCE',
        'android.permission.ACCESS_ADSERVICES_TOPICS',
      ]) {
        expect(manifest, contains('android:name="$permission"'));
      }
      expect(RegExp('tools:node="remove"').allMatches(manifest), hasLength(5));
    });

    test('Android disables advertiser ID and automatic logging at startup', () {
      final manifest =
          File('android/src/main/AndroidManifest.xml').readAsStringSync();

      expect(
        manifest,
        contains(
            'android:name="com.facebook.sdk.AdvertiserIDCollectionEnabled"'),
      );
      expect(
        manifest,
        contains('android:name="com.facebook.sdk.AutoLogAppEventsEnabled"'),
      );
      expect(
        RegExp(
          r'com\.facebook\.sdk\.(?:AdvertiserIDCollectionEnabled|AutoLogAppEventsEnabled)"\s+android:value="false"',
        ).allMatches(manifest),
        hasLength(2),
      );
    });

    test('native bridges enforce advertiser ID collection off', () {
      final android = File(
        'android/src/main/kotlin/id/oddbit/flutter/facebook_app_events/'
        'FacebookAppEventsPlugin.kt',
      ).readAsStringSync();
      final ios = File(
        'ios/facebook_app_events/Sources/facebook_app_events/'
        'FacebookAppEventsPlugin.swift',
      ).readAsStringSync();

      expect(
        RegExp(r'setAdvertiserIDCollectionEnabled\(false\)')
            .allMatches(android),
        hasLength(2),
      );
      expect(
        RegExp(r'isAdvertiserIDCollectionEnabled = false').allMatches(ios),
        hasLength(2),
      );
    });

    test('native SDK versions are bounded and Audience Network is absent', () {
      final androidGradle = File('android/build.gradle').readAsStringSync();
      final podspec =
          File('ios/facebook_app_events.podspec').readAsStringSync();
      final packageSwift = File(
        'ios/facebook_app_events/Package.swift',
      ).readAsStringSync();
      final swiftBridge = File(
        'ios/facebook_app_events/Sources/facebook_app_events/'
        'FacebookAppEventsPlugin.swift',
      ).readAsStringSync();

      expect(androidGradle, contains('facebook-android-sdk:18.3.0'));
      expect(podspec, contains("'FBSDKCoreKit', '18.1.0'"));
      expect(
        packageSwift,
        contains('"18.0.0"..<"19.0.0"'),
      );
      expect(podspec, isNot(contains('FBAudienceNetwork')));
      expect(swiftBridge, isNot(contains('FBAudienceNetwork')));
    });
  });
}
