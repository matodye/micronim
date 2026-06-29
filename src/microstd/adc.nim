
include ./[gpio]

type
  AdcPin = object
    number: uint8
    direction: PinDirection

proc adc*(pin: Pin; direction: PinDirection): AdcPin =
  return AdcPin(number: pin.number, direction: direction)

proc adc_pin*(number: static int; direction: PinDirection): AdcPin =
  adc pin(number, direction)
