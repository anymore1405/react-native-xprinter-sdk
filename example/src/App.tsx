import React from 'react';
import {Button, View} from 'react-native';
import {sendBeepTSCCommand, connectPrinter, sendPrintCommand} from './index';

const connet = () => {
  connectPrinter(
    '192.168.110.230',
    9100,
    () => {
      console.log('connected');
    },
    () => {
      console.log('error');
    },
  );
};

const sendBeep = () => {
  sendBeepTSCCommand(
    6,
    1000,
    () => {},
    () => {},
  );
};

const print = () => {
  sendPrintCommand(
    () => {},
    () => {},
  );
};

export const App = () => {
  return (
    <View style={{flex: 1, paddingTop: 50}}>
      <Button title="connect" onPress={connet} />
      <Button title="sendBeep" onPress={sendBeep} />
      <Button title="print" onPress={print} />
    </View>
  );
};
