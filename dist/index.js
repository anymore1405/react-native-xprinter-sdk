import { NativeModules } from "react-native";
var RNNetPrinter = NativeModules.RNNetPrinter;
function connectPrinter(host, port, callbackSuccess, callbackError) {
    RNNetPrinter.connectPrinter(host, port, callbackSuccess, callbackError);
}
function sendPrintCommand(callbackSuccess, callbackError) {
    RNNetPrinter.sendPrintCommand(callbackSuccess, callbackError);
}
function sendClearTSCCommand(callbackSuccess, callbackError) {
    RNNetPrinter.sendClearTSCCommand(callbackSuccess, callbackError);
}
function sendBeepTSCCommand(level, interval, callbackSuccess, callbackError) {
    RNNetPrinter.sendBeepTSCCommand(level, interval, callbackSuccess, callbackError);
}
function sendSetLabelSizeTSCCommand(width, height, callbackSuccess, callbackError) {
    RNNetPrinter.sendSetLabelSizeTSCCommand(width, height, callbackSuccess, callbackError);
}
function sendDelayTSCCommand(delay, callbackSuccess, callbackError) {
    RNNetPrinter.sendDelayTSCCommand(delay, callbackSuccess, callbackError);
}
function sendEOJTSCCommand(callbackSuccess, callbackError) {
    RNNetPrinter.sendEOJTSCCommand(callbackSuccess, callbackError);
}
function disconnectPrinter(callbackSuccess, callbackError) {
    RNNetPrinter.disconnect(callbackSuccess, callbackError);
}
function sendImageCommand(base64, callbackSuccess, callbackError) {
    RNNetPrinter.sendImageCommand(base64, callbackSuccess, callbackError);
}
function sendImageWithOptionsCommand(base64, opts, callbackSuccess, callbackError) {
    RNNetPrinter.sendImageWithOptionsCommand(base64, opts, callbackSuccess, callbackError);
}
export { connectPrinter, sendClearTSCCommand, sendBeepTSCCommand, sendSetLabelSizeTSCCommand, sendDelayTSCCommand, sendEOJTSCCommand, disconnectPrinter, sendImageCommand, sendImageWithOptionsCommand, sendPrintCommand, };
