# LuaProject
Weather Monitoring System

The project was developed to analyze temperature and humidity (weather) using sensors. It involves machine to machine communication where one machine is reading the weather and the other one is receiving it and analyzing it. 					              

Files:
1. ESPLORER: application for running Lua scripts onto the nodemcu board.
2. ESP8266FLASHER: to flash latest OS onto the Node MCU board.
3. nodemcu-master-24-modules-2017-06-26-12-17-39-float.bin : OS

Project:
1. sendtoMQTT: Reading from sensor and publishing to mqtt server
2. sendToThingspeak: Reading from thr cloud(mqtt) and dsiplaying on the ThingSpeak platform.
