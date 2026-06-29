type NegativePinError* = object of ValueError

type LogType* = enum
  Advice
  Caution
  Error
  Hint
  Tip


proc log*(logType: LogType; data: string) =
  discard