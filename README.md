# Leanware Technical Test

## Overview

This project is an open-source demo that will show you different scenes on how to integrate [agora_rtc_engine](https://pub.dev/packages/agora_rtc_engine) APIs into your project.

Any scene of this project can run successfully alone.


## How to run the sample project

#### Developer Environment Requirements

- [Flutter](https://flutter.dev/docs/get-started/install)

### Steps to run

*Steps from cloning the code to running the project*

1. Run `flutter pub get`.

3. Open [agora.config.dart](./lib/config/agora.config.dart) file and specify your App ID and Token.

   > See [Set up Authentication](https://docs.agora.io/en/Agora%20Platform/token) to learn how to get an App ID and access token. You can get a temporary access token to quickly try out this sample project.
   >
   > The Channel name you used to generate the token must be the same as the channel name you use to join a channel.

   > To ensure communication security, Agora uses access tokens (dynamic keys) to authenticate users joining a channel.
   >
   > Temporary access tokens are for demonstration and testing purposes only and remain valid for 24 hours. In a production environment, you need to deploy your own server for generating access tokens. See [Generate a Token](https://docs.agora.io/en/Interactive%20Broadcast/token_server) for details.

4. Make the project and run the app in the simulator or connected physical device.

