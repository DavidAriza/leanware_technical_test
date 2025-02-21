# Leanware Technical Test

## Overview

The goal of this project is to create a simple video call application that enhances the user experience with the following features starting from example project of agora repository found in https://github.com/AgoraIO-Extensions/Agora-Flutter-SDK/tree/main/example:


## How to run the sample project

#### Developer Environment Requirements

- [Flutter](https://flutter.dev/docs/get-started/install) (Dart needs to be at least 3.6.0)

### Steps to run

*Steps from cloning the code to running the project*

1. Run `flutter pub get`.

2. Open [agora.config.dart](./lib/config/agora.config.dart) file and specify your App ID and Token.

   > See [Set up Authentication](https://docs.agora.io/en/Agora%20Platform/token) to learn how to get an App ID and access token. You can get a temporary access token to quickly try out this sample project.
   >
   > The Channel name you used to generate the token must be the same as the channel name you use to join a channel.

   > To ensure communication security, Agora uses access tokens (dynamic keys) to authenticate users joining a channel.
   >
   > Temporary access tokens are for demonstration and testing purposes only and remain valid for 24 hours. In a production environment, you need to deploy your own server for generating access tokens. See [Generate a Token](https://docs.agora.io/en/Interactive%20Broadcast/token_server) for details.

3. Make the project and run the app in the simulator or connected physical device.

### Steps to deploy web project

1. Run `flutter build web`
   
2. Run `firebase deploy`
