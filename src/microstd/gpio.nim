import picostdlib/[gpio]

import ./[
  errors,
  logger
]

const GPIO_PINS*: array[0..35, Gpio] = [
  0.Gpio, 10.Gpio, 20.Gpio, 30.Gpio,
  1.Gpio, 11.Gpio, 21.Gpio, 31.Gpio,
  2.Gpio, 12.Gpio, 22.Gpio, 32.Gpio,
  3.Gpio, 13.Gpio, 23.Gpio, 33.Gpio,
  4.Gpio, 14.Gpio, 24.Gpio, 34.Gpio,
  5.Gpio, 15.Gpio, 25.Gpio, 35.Gpio,
  6.Gpio, 16.Gpio, 26.Gpio,
  7.Gpio, 17.Gpio, 27.Gpio,
  8.Gpio, 18.Gpio, 28.Gpio,
  9.Gpio, 19.Gpio, 29.Gpio,
]

type
  PinDirection* = enum
    IN, OUT

  Pull* = enum
    Up, Down

  Pin = object
    number: uint8
    direction: PinDirection
    pull: Pull

let pins: seq[Pin] = @[]
let usedPins = new array[0..35, bool]

proc pin*(number: static int; direction: PinDirection; pull: Pull = Down): Pin =
  static:
    if number < 0:
      let error_msg = "You set a negative number (" & $number & ") as a pin. The minimum is 0."
      raise newException(NegativePinNumberError, error_msg)
    elif number > 35:
      let error_msg = "You set " & $number & " as a pin number, but the highest available is 35."
      raise newException(PinNumberAbove35, error_msg)

  if usedPins[number]:
    log(Caution, "You are binding a pin already used: " & $number & ". We will return the previous reference to this pin.")
    return pins[number]

  usedPins[number] = true
  result = Pin(number: number.uint8, direction: direction, pull: pull)
  pins.add(result)

  try:
    number.Gpio.init()
    number.Gpio.setDir(direction == OUT)
  except:
    # TODO: add logic
    discard

proc in_pin*(number: static int): Pin =
  pin(number, IN)

proc out_pin*(number: static int): Pin =
  pin(number, OUT)

proc `==`*(a, b: Pin): bool =
  a.number == b.number

proc `>`*(a, b: Pin): bool =
  a.number > b.number

proc `<`*(a, b: Pin): bool =
  a.number < b.number

proc high*(self: Pin) =
  try: self.number.Gpio.put(High) except: discard  # TODO: add logic & log an error

proc low*(self: Pin) = 
  try: self.number.Gpio.put(Low) except: discard  # TODO: add logic & log an error

proc is_used*(self: Pin): bool =
  usedPins[self.number]