
include ./[gpio]

type
  AdcPin = object
    number: uint8
    direction: PinDirection

proc adc*(pin: Pin): AdcPin = 
  discard

proc adc_pin*(number: static int; direction: PinDirection): AdcPin =
  pin(number, direction)