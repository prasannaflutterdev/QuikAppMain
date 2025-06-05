#!/bin/bash

INFO_PLIST="ios/Runner/Info.plist"
echo "✅ Injecting iOS permission usage descriptions..."

add_usage_description() {
  KEY=$1
  MESSAGE=$2
  if ! /usr/libexec/PlistBuddy -c "Print :$KEY" "$INFO_PLIST" &> /dev/null; then
    /usr/libexec/PlistBuddy -c "Add :$KEY string $MESSAGE" "$INFO_PLIST"
    echo "➕ Added $KEY"
  else
    echo "ℹ️ $KEY already exists"
  fi
}

[[ "$IS_CAMERA" == "true" ]] && add_usage_description "NSCameraUsageDescription" "This app uses the camera to scan QR codes or capture images."
[[ "$IS_MIC" == "true" ]] && add_usage_description "NSMicrophoneUsageDescription" "This app uses the microphone to record audio or enable voice input."
[[ "$IS_CHATBOT" == "true" ]] && add_usage_description "NSSpeechRecognitionUsageDescription" "This app uses speech recognition to convert your voice into text."
[[ "$IS_LOCATION" == "true" ]] && add_usage_description "NSLocationWhenInUseUsageDescription" "This app uses your location to provide relevant services nearby."
[[ "$IS_NOTIFICATION" == "true" ]] && add_usage_description "NSUserNotificationUsageDescription" "This app uses notifications to alert you about updates and messages."
[[ "$IS_CONTACT" == "true" ]] && add_usage_description "NSContactsUsageDescription" "This app accesses contacts to personalize your experience."
[[ "$IS_CALENDAR" == "true" ]] && add_usage_description "NSCalendarsUsageDescription" "This app uses your calendar to schedule events or reminders."
[[ "$IS_STORAGE" == "true" ]] && add_usage_description "NSPhotoLibraryUsageDescription" "This app uses your photo library to select or upload media."
[[ "$IS_BIOMETRIC" == "true" ]] && add_usage_description "NSFaceIDUsageDescription" "This app uses Face ID to securely verify your identity."

# ✅ Inject iOS push notification support if enabled
if [[ "$PUSHNOTIFY" == "true" ]]; then
  echo "🔔 Adding push notification keys to Info.plist..."

  # Add UIBackgroundModes
  if ! /usr/libexec/PlistBuddy -c "Print :UIBackgroundModes" "$INFO_PLIST" &> /dev/null; then
    /usr/libexec/PlistBuddy -c "Add :UIBackgroundModes array" "$INFO_PLIST"
    /usr/libexec/PlistBuddy -c "Add :UIBackgroundModes:0 string fetch" "$INFO_PLIST"
    /usr/libexec/PlistBuddy -c "Add :UIBackgroundModes:1 string remote-notification" "$INFO_PLIST"
    echo "➕ Added UIBackgroundModes with fetch and remote-notification"
  else
    echo "ℹ️ UIBackgroundModes already exists"
  fi

  # Add FirebaseAppDelegateProxyEnabled
  if ! /usr/libexec/PlistBuddy -c "Print :FirebaseAppDelegateProxyEnabled" "$INFO_PLIST" &> /dev/null; then
    /usr/libexec/PlistBuddy -c "Add :FirebaseAppDelegateProxyEnabled bool true" "$INFO_PLIST"
    echo "➕ Added FirebaseAppDelegateProxyEnabled = true"
  else
    echo "ℹ️ FirebaseAppDelegateProxyEnabled already exists"
  fi
fi

exit 0