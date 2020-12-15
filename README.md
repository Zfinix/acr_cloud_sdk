# ACR Cloud SDK
`** This is an unofficial SDK for flutter`

Automatic content recognition (ACR) is an identification technology to recognise content played on a media device or present in a media file. This enables users quickly obtain detailed information about the content they have just experienced without any text based input or search efforts.

ACR can help users deal with multimedia more effective and make applications more intelligent. [More info](https://docs.acrcloud.com/docs/acrcloud/introduction/automatic-content-recognition/).

## 🤔 How ACR works
Take the most popular music recognition and discovery app Shazam for example. The ACR workflow is as follows.

<p float="left">
<img src="https://www.acrcloud.com/docs/wp-content/uploads/2016/04/shazam_overview-min.jpg" width="500">
</p>

[More info](https://docs.acrcloud.com/docs/acrcloud/introduction/automatic-content-recognition/).


## 📸 Screen Shots

<p float="left">
<img src="https://github.com/Zfinix/carrier_info/blob/main/1.png?raw=true" width="200">
</p>

### allowsVOIP (iOS only)

```dart
 bool carrierInfo = await CarrierInfo.allowsVOIP; // Indicates if the carrier allows VoIP calls to be made on its network.
```

- If you configure a device for a carrier and then remove the SIM card, this property retains the Boolean value indicating the carrier’s policy regarding VoIP.
- Always return `true` on Android.

### carrierName

```dart
 String carrierInfo = await CarrierInfo.carrierName;  // The name of the user’s home cellular service provider.
```

- This string is provided by the carrier and formatted for presentation to the user. The value does not change if the user is roaming; it always represents the provider with whom the user has an account.
- If you configure a device for a carrier and then remove the SIM card, this property retains the name of the carrier.
- The value for this property is 'nil' if the device was never configured for a carrier.

### isoCountryCode

```dart
String carrierInfo = await CarrierInfo.isoCountryCode;  // The ISO country code for the user’s cellular service provider.
```

- This property uses the ISO 3166-1 country code representation.
- The value for this property is 'nil' if any of the following apply:
  - The device is in Airplane mode.
  - There is no SIM card in the device.
  - The device is outside of cellular service range.

### mobileCountryCode

```dart
String carrierInfo = await CarrierInfo.mobileCountryCode;  //The mobile country code (MCC) for the user’s cellular service provider.
```

- MCCs are defined by ITU-T Recommendation E.212, “List of Mobile Country or Geographical Area Codes.”
- The value for this property is 'nil' if any of the following apply:
  - There is no SIM card in the device.
  - The device is outside of cellular service range.
- The value may be 'nil' on hardware prior to iPhone 4S when in Airplane mode.

### mobileNetworkCode

```dart
String carrierInfo = await CarrierInfo.mobileNetworkCode // The mobile network code (MNC) for the user’s cellular service provider.
```

- The value for this property is 'nil' if any of the following apply:
  - There is no SIM card in the device.
  - The device is outside of cellular service range.
- The value may be 'nil' on hardware prior to iPhone 4S when in Airplane mode.

### networkGeneration

```dart
String carrierInfo = await CarrierInfo.networkGeneration // 5G, 4G ... 2G
```

### radioType

```dart
String carrierInfo = await CarrierInfo.radioType // LTE, HSDPA, e.t.c
```

## ✨ Contribution

 Lots of PR's would be needed to make this plugin standard, as for iOS there's a permanent limitation for getting the exact data usage, there's only one way arount it and it's super complex.
