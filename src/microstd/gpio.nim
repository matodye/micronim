import picostdlib/[gpio]

import ./logger

const GPIO_PINS: array[0..35, Gpio] = [
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
    pull: Pull = Down

var Pins: seq[Pin] = @[]

proc pin*(number: int, direction: PinDirection): Pin =
  for p in Pins:
    if number < 0:
      let error_msg = $NegativePinError & "You set a negative number (" & $number & ") as a pin."
      log(Error, error_msg)
      raise newException(NegativePinError, error_msg)
    elif number.uint8 == p.number:
      log(Caution, "You are binding a pin already used:" & $number)
      return p

    result = Pin(number: number.uint8, direction: direction)
    Pins.add(result)

  GPIO_PINS[number].init()
  GPIO_PINS[number].setDir(direction == OUT)

template pin_in*(number: int): Pin =
  pin(number, IN)

template out_pin*(number: int): Pin =
  pin(number, OUT)


