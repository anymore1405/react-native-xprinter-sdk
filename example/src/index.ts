import { NativeModules } from "react-native";

const RNNetPrinter = NativeModules.RNNetPrinter;

function connectPrinter(
  host: string,
  port: number,
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.connectPrinter(host, port, callbackSuccess, callbackError);
}

function sendPrintCommand(
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.sendPrintCommand(callbackSuccess, callbackError);
}
function sendClearTSCCommand(
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.sendClearTSCCommand(callbackSuccess, callbackError);
}

function sendBeepTSCCommand(
  level: number,
  interval: number,
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.sendBeepTSCCommand(
    level,
    interval,
    callbackSuccess,
    callbackError
  );
}

function sendSetLabelSizeTSCCommand(
  width: number,
  height: number,
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.sendSetLabelSizeTSCCommand(
    width,
    height,
    callbackSuccess,
    callbackError
  );
}

function sendDelayTSCCommand(
  delay: number,
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.sendDelayTSCCommand(delay, callbackSuccess, callbackError);
}

function sendEOJTSCCommand(
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.sendEOJTSCCommand(callbackSuccess, callbackError);
}

function disconnectPrinter(
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.disconnect(callbackSuccess, callbackError);
}

function sendImageCommand(
  base64: string,
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.sendImageCommand(base64, callbackSuccess, callbackError);
}

function sendImageWithOptionsCommand(
  base64: string,
  opts: { width: number; height: number; paperWidth: number },
  callbackSuccess: (msg: string) => void,
  callbackError: (msg: string) => void
) {
  RNNetPrinter.sendImageWithOptionsCommand(
    base64,
    opts,
    callbackSuccess,
    callbackError
  );
}

export {
  connectPrinter,
  sendClearTSCCommand,
  sendBeepTSCCommand,
  sendSetLabelSizeTSCCommand,
  sendDelayTSCCommand,
  sendEOJTSCCommand,
  disconnectPrinter,
  sendImageCommand,
  sendImageWithOptionsCommand,
  sendPrintCommand,
};
