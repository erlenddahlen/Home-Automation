# Imatis

The code was produces for Imatis AS as a summer intern 2018. Imatis AS is a leader in innovative software solutions for the healthcare industry. 

## POC

To achieve the vision: "Creating a seamless flow of communication and logistics in the prison care" we have worked with improvements in automation and communication flow to develop Imatis' technology. To make these improvements, Fibaro's sensor technology, communication protocols and own code have been used.

Developments in sensor technology have made it possible to extract data from sensors and store the data in servers. Therefore, you can now monitor data in real time and learn from data using stored sensor data. In this project, we have looked at the possibility of deploying several types of sensors and extracting associated data. The data will mainly be used for real-time monitoring with the opportunity to use historical data if needed.

To explore this possibility, we have used Fibaro's home network. It consists of Fibaro Home Center 2 (FHC2) which is the brain, and sensors that can be connected. Underliggende techngive and sensors have been described in the Theory section. The image below illustrates how data from sensors are communicated to Imatis' servers and then presented in the Visi product. Data is collected from two categories with sensors for FHC2. Fibaro's sensors can be connected directly to the FHC2 over the Z-wave, while Bluetooth Low Energy (be connected BLE) sensors must through a translator, iNode LAN, which communicates with the FHC2 via a local network. Then FHC2 communicates with Imatis's servers over the Internet. 

<img width="618" alt="System_overview" src="https://user-images.githubusercontent.com/37074633/62566757-03303780-b88a-11e9-88f1-079349d0883a.png">

To reach the end product described above, a “Proof-of-Concept” task was formulated. 

## Task: Sending data from various sensors to Imatis Visi

## Equipment:
Equipment used in this project: 

- Fibaro Home Center 2
- Fibaro Motion sensor
- Fibaro Smoke sensor
- Fibaro The button
- iNode LAN
- iNode Beacon (BLE sensor)
- own computer
- software : Postman, Python

## Procedure
To perform the task of sending data from sensors to Imatis Visi, the task was divided into 4 sub-tasks. They are as follows:

### Subtask 1: Sending sensor data into FHC2
### Subtask 2: Communicating over the Internet from FHC2 (using the REST API)
### Subtask 3: Communicating with Imatis visi from own computer
### Subtask 4: Communicating with Imatis visi from FHC2

The approach to solve these tasks will be explained below on an overall level. 

## Subtask 1: Sending sensor data to FHC2

The first thing to do was to set up and configure FHC2. This was done by following the corresponding manual (https://manuals.fibaro.com/home-center-2/). Here we connected the FHC2 's menu to our own computer and were able to configure settings. 

Then we connected sensors one by one. To connect sensors from Fibaro, we followed the manuals that came with the sensors. When we connected the sensors to the FHC2 they appeared in the overview that we had connected to the computer. 

The BLE sensor cannot communicate directly with the FHC2 and it was therefore necessary to communicate through the iNode LAN. This product receives signals from BLE sensors and communicates this further over Wi-Fi to FHC2. In order for FHC2 to do this, a “Virtual Device” must be created.

## Subtask 2: Communicating over the Internet from FHC2

In FHC2, logic is implemented which is easy for the user to configure. It is easy to set up rules based on sensor, without writing code yourself. The way this is done is that the user selects a sensor, a sensor value and what will happen if the value occurs. This way, it is easy to set up rules within the framework that Fibaro has facilitated. From FHC2 you can add functions to send notifications to mobile or mail, but there is no function to send messages to servers over the Internet.

A major advantage of Fibaro's system is that it allows the user to write their own code which can be run in FHC2. It is possible to implement your own logic through the code language LUA. We created a code snippet that starts running if a sensor value changes. In this code we created logic that sends a request to a server and retrieves information from the REST API. The REST API is the part of the server that tells the server how to retrieve or send data. Here, the following REST API was used https://swapi.co/. After returning information from this code snippet, we were sure that we were able to send requests over the Internet from FHC2.  

## Subtask 3: Communicate with Imatis Visi from your own computer

To be able to communicate with Imatis's servers, we got help from developers from Imatis. We got help to create an adapter in Imatis their servers to recognize the requests we wanted to submit from FHC2. The adapter is part of the back-end to Imati's servers, which determines how the data sent to this adapter will be handled further. In addition, we were helped to structure the data in an XML format. This is necessary for the adapter to understand the request. We also got help authenticating the requests. 

It was now theoretically possible to send messages to Imatis' servers. To do this in practice, we first used Postman, which is an application that allows you to send requests over the Internet. We structured the messages in XML format, fixed authentication, and sent the request to specified url. The information defined in the request then appeared in the defined column and row in Imatis Visi. 

Eventually, this functionality was to be implemented in LUA in FHC2. To get a better understanding of how to do this, implemented wethis logic in the Python programming language on your computer. 

## Subtask 4: Communicate with Imatis Visi from FHC2

We had already implemented code in Interim 2 to communicate over the Internet. Instead of retrieving data from a server, we now wanted to send data to Imatis' servers. We used about the same setup and were able to send data from FHC2 to Visi. 

## Condition: 
After connecting all sensors and implemented logic in FHC2, the system looks like the chart in the figure below. To the left of the figure the various sensors are illustrated. Each sensor leads to an implemented logic in FHC2. This logic then sends data further to Visi. 

<img width="594" alt="Sensor_overview" src="https://user-images.githubusercontent.com/37074633/62566769-07f4eb80-b88a-11e9-8342-ba35eeff6939.png">

## Further work

### Sensors: 
In this project we have connected sensors that communicate wirelessly over Z-wave. These sensors open up many opportunities within home automation. Furthermore, it is possible to investigate the possibility of connecting other types of sensors, which also use Z-wave, to Imatis technology. We have also explored the possibility of connecting sensors over Bluetooth Low Energy (BLE). One challenge that must then be solved is to pair BLE sensors with iNode LAN so that sensor data can be passed from iNode LAN to FHC2.

### Code: 
Some time has been spent optimizing code. To begin with, we had a code snippet for each sensor and many variables were hard-coded. By changing the variables to retrieve information rather than being hard-coded, we have been able to use a code snippet for each type of sensor instead. This makes it easier to adapt code to new systems, since much of the code is general. To communicate with BLE sensors, one must set up a virtual device. There remains some technical development here, such as how to send HTTP requests and format data that you retrieve. 

### Machine Learning / Statistical Analysis: 
As mentioned in the introduction, it is possible to both monitor data in real time and learn from data by looking at the history. Using sensor technology, new data can be accessed. Good solutions should be established to format, anonymize and store this data. In combination with other available data, the possibility of statistical analysis and Machine Learning can be further explored. 


