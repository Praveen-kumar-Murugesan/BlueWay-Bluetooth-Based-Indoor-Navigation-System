#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"
#define SERVICE_UUID        "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define WIFI_SSID "YOUR-WIFI-USERNAME"
#define WIFI_PASSWORD "YOUR-WIFI-PASSWORD"
#define API_KEY "YOUR-FIREBASE-API-KEY"
#define DATABASE_URL "YOUR-DATABASE-URL" 

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
int intValue;
float floatValue;
bool signupOK = false;

void setup() {
  Serial.begin(115200);

  BLEDevice::init("ESP32 BLE-0");
  BLEServer* pServer = BLEDevice::createServer();
  BLEService *pService = pServer->createService(SERVICE_UUID);
  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE
                                       );
  pCharacteristic->setValue("Hello World");
  pService->start();
  pServer->getAdvertising()->addServiceUUID(pService->getUUID());
  pServer->getAdvertising()->start();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  config.api_key = API_KEY;

  config.database_url = DATABASE_URL;

  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("ok");
    signupOK = true;
  }
  else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }

  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 2500 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    if (Firebase.RTDB.getInt(&fbdo, "ack/esp0")) {
      if (fbdo.dataType() == "int") {
        intValue = fbdo.intData();
        Serial.println(intValue);
        if (intValue == 0){
          if (BLEDevice::getInitialized()) {
            if (Firebase.RTDB.setInt(&fbdo, "ack/esp0", 1)){
              Serial.println("PASSED");
            }
            else {
              Serial.println("FAILED");
              Serial.println("REASON: " + fbdo.errorReason());
            }
          } else {
            if (Firebase.RTDB.setInt(&fbdo, "ack/esp0", -1)){
              Serial.println("PASSED");
            }
            else {
              Serial.println("FAILED");
              Serial.println("REASON: " + fbdo.errorReason());
            }
          }
        }
      }
    }
    else {
      Serial.println(fbdo.errorReason());
    }
  }
}