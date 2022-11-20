declare function connectPrinter(host: string, port: number, callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
declare function sendPrintCommand(callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
declare function sendClearTSCCommand(callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
declare function sendBeepTSCCommand(level: number, interval: number, callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
declare function sendSetLabelSizeTSCCommand(width: number, height: number, callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
declare function sendDelayTSCCommand(delay: number, callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
declare function sendEOJTSCCommand(callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
declare function disconnectPrinter(callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
declare function sendImageCommand(base64: string, callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
declare function sendImageWithOptionsCommand(base64: string, opts: {
    width: number;
    height: number;
    paperWidth: number;
}, callbackSuccess: (msg: string) => void, callbackError: (msg: string) => void): void;
export { connectPrinter, sendClearTSCCommand, sendBeepTSCCommand, sendSetLabelSizeTSCCommand, sendDelayTSCCommand, sendEOJTSCCommand, disconnectPrinter, sendImageCommand, sendImageWithOptionsCommand, sendPrintCommand, };
