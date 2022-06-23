
# react-native-agora-rte-chatview

## Getting started

`$ npm install react-native-agora-rte-chatview --save`

### Mostly automatic installation

`$ react-native link react-native-agora-rte-chatview`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-agora-rte-chatview` and add `RNAgoraRteChatview.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNAgoraRteChatview.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.agorarte.chat.RNAgoraRteChatviewPackage;` to the imports at the top of the file
  - Add `new RNAgoraRteChatviewPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-agora-rte-chatview'
  	project(':react-native-agora-rte-chatview').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-agora-rte-chatview/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-agora-rte-chatview')
  	```


## Usage
```javascript
import RNAgoraRteChatview from 'react-native-agora-rte-chatview';

// TODO: What to do with the module?
RNAgoraRteChatview;
```
  