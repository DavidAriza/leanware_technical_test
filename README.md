# Leanware Technical test - Video call App

## Project Overview

The goal of this project is to create a simple video call application that enhances the user experience with the following features starting from example project of agora repository found in https://github.com/AgoraIO-Extensions/Agora-Flutter-SDK/tree/main/example:

- User Registration: Allows users to sign up and log in.
- Waiting Room: Hosts are placed in a waiting room until a remote user joins.
- Call Timeout: Automatically ends the call after a 10 minutes of waiting.
- Blur effect
- Play a sound as notification when a user joins the channel

## Prerequisites

Before you begin, ensure you have the following tools installed on your machine:

- [Flutter](https://flutter.dev/docs/get-started/install) (recommended version 3.27.4)
- [Android Studio](https://developer.android.com/studio) or any other editor that supports Flutter.
- [Xcode](https://developer.apple.com/xcode/) (macOS only)

## Getting started

To run this application locally in your machine follow the next steps:

### Step 1: Clone the Repository and navigate to the project


```bash
git clone https://github.com/DavidAriza/leanware_technical_test.git
```

## Installing Dependencies

Once you are on the project folder run the following command to install the dependencies:

```bash
flutter pub get
```
## Launch the application

To launch te application use the following command:

```bash
flutter run
```

## Select the device

Select the device or run the folowwing commands to launch the app in a specific device:

```bash
flutter run -d <device_id>
```

to get the device id you can use the next command: 
```bash
flutter devices
```
