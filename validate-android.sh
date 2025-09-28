#!/bin/bash

# Validation script for Android configuration
echo "🔍 Validating Android Configuration..."

# Check if essential Android files exist
echo "📱 Checking Android files..."
FILES=(
    "android/app/build.gradle"
    "android/build.gradle"
    "android/settings.gradle"
    "android/gradle.properties"
    "android/app/src/main/AndroidManifest.xml"
    "android/app/src/main/kotlin/com/nupuit/pipit/MainActivity.kt"
    "android/app/debug.keystore"
)

for file in "${FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

# Check flavor configurations
echo ""
echo "📋 Checking Flavor Configurations..."
FLAVORS=("dev" "staging" "prod")

for flavor in "${FLAVORS[@]}"; do
    if [[ -f "android/app/src/$flavor/google-services.json" ]]; then
        echo "✅ Firebase config for $flavor exists"
    else
        echo "❌ Firebase config for $flavor missing"
    fi
done

# Check build.gradle for flavors
echo ""
echo "🛠️  Checking build.gradle flavor configuration..."
if grep -q "productFlavors" android/app/build.gradle; then
    echo "✅ Product flavors configured in build.gradle"
else
    echo "❌ Product flavors not found in build.gradle"
fi

# Check for Firebase plugin
if grep -q "com.google.gms.google-services" android/app/build.gradle; then
    echo "✅ Firebase plugin configured"
else
    echo "❌ Firebase plugin missing"
fi

echo ""
echo "🏗️  Checking package structure..."
if [[ -d "android/app/src/main/kotlin/com/nupuit/pipit" ]]; then
    echo "✅ Kotlin package structure correct"
else
    echo "❌ Kotlin package structure incorrect"
fi

echo ""
echo "🔑 Checking keystore..."
if [[ -f "android/app/debug.keystore" ]]; then
    echo "✅ Debug keystore exists"
    # Try to list keystore contents
    if command -v keytool >/dev/null 2>&1; then
        echo "🔐 Debug keystore contents:"
        keytool -list -v -keystore android/app/debug.keystore -storepass android 2>/dev/null | head -5
    fi
else
    echo "❌ Debug keystore missing"
fi

echo ""
echo "✨ Validation complete!"