# ACR Cloud SDK
`** This is an unofficial SDK for flutter`

Automatic content recognition (ACR) is an identification technology to recognise content played on a media device or present in a media file. This enables users quickly obtain detailed information about the content they have just experienced without any text based input or search efforts.



## 🤔 How ACR works
ACR can help users deal with multimedia more effective and make applications more intelligent. [More info](https://docs.acrcloud.com/tutorials/recognize-music).


## 📸 Screen Shots

<p float="left">
<img src="https://github.com/Zfinix/acr_cloud_sdk/blob/main/1.png?raw=true" width="200">
<img src="https://github.com/Zfinix/acr_cloud_sdk/blob/main/2.png?raw=true" width="200">
<img src="https://github.com/Zfinix/acr_cloud_sdk/blob/main/3.png?raw=true" width="200">
</p>

### 🚀 Initialize SDK

```dart
  final AcrCloudSdk arc = AcrCloudSdk();
  
      arc..init(
          host: '', // obtain from https://www.acrcloud.com/ 
          accessKey: '', // obtain from https://www.acrcloud.com/ 
          accessSecret: '', // obtain from https://www.acrcloud.com/ 
          setLog: false,
        )..songModelStream.listen(searchSong);
  
  void searchSong(SongModel song) async {
      print(song); // Recognized song data
  }
```

Initialize sdk and listen for song recognition events.

### ️🎶 Start Recognition

```dart
 bool started = await arc.start();
```
- This function will automatic start the recording and recognizing process.
- When there’s a result, songModelStream & resultStream will return the data as events.
- The whole recognition time is controlled by ACRCloud’s Server.
- You can call the stop function to terminate this process.

### ⛔ Stop Recognition

```dart
 bool started = await arc.stop();
```
- This function will cancel the recognition immediately.


## ✨ Contribution
 Lots of PR's would be needed to improve this plugin. So lots of suggestions and PRs are welcome.
