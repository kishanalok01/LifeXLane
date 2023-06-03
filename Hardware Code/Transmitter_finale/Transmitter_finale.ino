#include <LoRa.h>
#include <WiFi.h>
#include <SPI.h>
#include "BluetoothSerial.h"
 
#define ss 5
#define rst 14
#define dio0 2

//BT initial config
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif
 
int counter;
BluetoothSerial SerialBT;
String data;
void setup() 
{
  Serial.begin(115200); 

  SerialBT.begin("ESP32 Device"); //Bluetooth device name
  Serial.println("Transmitter Pair now ..............");


  while (!Serial);
    Serial.println("LoRa Sender");
 
  LoRa.setPins(ss, rst, dio0);    //setup LoRa transceiver module
  
  while (!LoRa.begin(433E6))     //433E6 - Asia, 866E6 - Europe, 915E6 - North America
  {
    Serial.println("No LoRA");
    delay(500);
  }
  LoRa.setSyncWord(0xA5); // to isolate transmission
  Serial.println("LoRa Initializing OK!");


  Serial.println(WiFi.macAddress());
  LoRa.beginPacket();
  delay(500); 
  //LoRa.print(WiFi.macAddress());
  LoRa.print("Approaching!!!!......\n");
  LoRa.endPacket();
}

void loop() {
  if (Serial.available()) //if data is available to read
  {
    SerialBT.write(Serial.read());
  }
  if (SerialBT.available()) {
    data = SerialBT.readString();
    Serial.print(data);
    counter=1;
  }
  if(counter ==1)
  {
  LoRa.beginPacket();   //Send LoRa packet to receiver
  LoRa.print(data);
  LoRa.endPacket();
  counter=0;
  }
  delay(20);
}