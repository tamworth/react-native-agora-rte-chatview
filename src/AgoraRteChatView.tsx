import PropTypes from "prop-types";
import React from "react";
import {
  requireNativeComponent,
  Platform,
  View,
  UIManager,
} from "react-native";

class AgoraRteChatView extends React.Component {
  // static propTypes: {
  //   whiteBoardId: PropTypes.Requireable<StyleProp>;
  //   roomUuid: PropTypes.Requireable<any>;
  // };
  render(): JSX.Element {
    return <RCTAgoraChatView {...this.props} />;
  }
}

// WhiteBoardView.propTypes = {
//   whiteBoardId: PropTypes.string,
//   roomUuid: PropTypes.string,
//   roomToken: PropTypes.string,
// };

const LINKING_ERROR =
  "The package 'react-native-agora-rte-chatview' doesn't seem to be linked. Make sure: \n\n" +
  Platform.select({ ios: "- You have run 'pod install'\n", default: "" }) +
  "- You rebuilt the app after installing the package\n" +
  "- You are not using Expo managed workflow\n";

const ComponentName = "RCTRteChatView";

export const RCTAgoraChatView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

export default AgoraRteChatView;
