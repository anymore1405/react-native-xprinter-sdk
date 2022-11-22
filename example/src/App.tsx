import React from 'react';
import {Button, View} from 'react-native';
import {
  sendBeepTSCCommand,
  connectPrinter,
  sendPrintCommand,
  sendDelayTSCCommand,
  disconnectPrinter,
  sendImageWithOptionsCommand,
  sendEOJTSCCommand,
} from './index';

const connet = () => {
  connectPrinter(
    '192.168.110.230',
    9100,
    () => {
      console.log('connected');
    },
    e => {
      console.log('error connect', e);
    },
  );
};
const disconnect = () => {
  disconnectPrinter(
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
    100,
    () => {},
    () => {},
  );
  sendDelayTSCCommand(
    100,
    () => {},
    () => {},
  );
  sendBeepTSCCommand(
    6,
    100,
    () => {},
    () => {},
  );
};

const print = () => {
  sendImageWithOptionsCommand(
    '',
    {width: 200, height: 120, paperHeight: 240},
    () => {
      console.log('done');
    },
    e => {
      console.log('error image', e);
    },
  );
  sendEOJTSCCommand(
    () => {},
    () => {},
  );
  sendPrintCommand(
    () => {},
    () => {},
  );
};

export const App = () => {
  return (
    <View style={{flex: 1, paddingTop: 50}}>
      <Button title="connect" onPress={connet} />
      <Button title="disconnect" onPress={disconnect} />
      <Button title="sendBeep" onPress={sendBeep} />
      <Button title="print" onPress={print} />
    </View>
  );
};
