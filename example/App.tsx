/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
  requireNativeComponent,
} from 'react-native';

import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';

// import AgoraRteChatView from './node_modules/react-native-agora-rte-chatview/index';
// const AgoraRteChatView = requireNativeComponent('RCTRteChatView');
import AgoraRteChatView from './AgoraRteChatView';

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };
  const chatInfo = {
    appKey: "1129210531094378#apaas-edu",
    chatRoomId:  '185131943919617',
    nickName:  'ssssssss',
    roomUuid:  'rrrrrrrr0',
    userName:  'c71db6b1dadb6bf72adf083611e2150b',
  }
  return (
    <View style={{flex:1, backgroundColor: '#00ff00'}}>
      <AgoraRteChatView style={{flex:1}} chatInfo= {chatInfo} />
    </View>);
};

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
  chat: {
    flex:1,
  }
});

export default App;
