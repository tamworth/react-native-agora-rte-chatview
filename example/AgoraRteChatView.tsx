import PropTypes from 'prop-types';
import React from 'react';
import {requireNativeComponent, Platform, View} from 'react-native';

class AgoraRteChatView extends React.Component {
  static propTypes: {
    whiteBoardId: PropTypes.Requireable<string>;
    roomUuid: PropTypes.Requireable<any>;
  };
  render(): JSX.Element {
    if (Platform.OS == 'android') {
      return <View />;
    }
    return <RCTAgoraChatView {...this.props} />;
  }
}

// WhiteBoardView.propTypes = {
//   whiteBoardId: PropTypes.string,
//   roomUuid: PropTypes.string,
//   roomToken: PropTypes.string,
// };

const RCTAgoraChatView = requireNativeComponent('RCTRteChatView');
export default AgoraRteChatView;