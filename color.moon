require 'bit'
require 'useless'
module('color', package.seeall)

export *

hexToRGB = (hex) ->
    hex = string.sub(hex,2) if string.sub(hex, 1,1) == '#'
    r  = tonumber(string.sub(hex,1,2), 16)
    g  = tonumber(string.sub(hex,3,4), 16)
    b  = tonumber(string.sub(hex,5,6), 16)

    return {red: r, green: g, blue: b}

color.decToHex = (dec) ->
  b,k,out,i,d=16,"0123456789ABCDEF","",0
  while dec > 0 do
    i = i + 1
    dec, d = math.floor(dec/b), math.fmod(dec, b) + 1
    out = string.sub(k, d, d) .. out
  return out

color.rgbToHex = (c) ->
  return color.decToHex(c.red) .. color.decToHex(c.green) .. color.decToHex(c.blue)

color.rgbToHSL = (rgb) ->
  r = rgb.red / 255
  g = rgb.green / 255
  b = rgb.blue / 255

  max = math.max r, g, b
  min = math.min r, g, b
  l   = (max + min) / 2

  h = 0
  s = 0

  if max == min
    h = 0
    s = 0
  else
    d = max - min
    
    if l > 0.5 then 
      s = d / (2 - max - min) 
    else 
      s = d / (max + min)

    switch max
      when r then 
        h = (g - b) / d + (if g < b then 6 else 0)
      when g then 
        h = (b - r) / d + 2
      when b then 
        h = (r - g) / d + 4

    h = h / 6

  return {
    hue: math.round(h, 3), 
    saturation: math.round(s,3),
    lightness: math.round(l, 3),
  }

color.hueToRGB = (p, q, t) ->
  if t < 0 then t += 1
  if t > 1 then t -= 1
  if t < 1/6 then return p + (q - p) * 6 * t
  if t < 1/2 then return q
  if t < 2/3 then return p + (q - p) * (2/3 - t) * 6
  return p

color.hslToRGB = (hsl) ->
  h = hsl.hue
  s = hsl.saturation
  l = hsl.lightness

  if s == 0
    r = l
    g = l
    b = l
  else
    q = if l < 0.5 then l * (1 + s) else l + s - l * s
    p = 2 * l - q
    
    r = color.hueToRGB p, q, h + 1/3
    g = color.hueToRGB p, q, h
    b = color.hueToRGB p, q, h - 1/3

  r = r * 255
  g = g * 255
  b = b * 255

  return {red: math.round(r), green: math.round(g), blue: math.round(b)}

rgbToHSV =  (rgb) ->
  r = rgb.red / 255
  g = rgb.green / 255
  b = rgb.blue / 255

  max = math.max r, g, b
  min = math.min r, g, b

  v = max
  d = max - min

  s = if max == 0 then 0 else d / max

  h = 0

  if max != min
    h = switch max
      when r then (g - b) / d + (if g < b then 6 else 0)
      when g then (b - r) / d + 2
      when b then (r - g) / d + 4

    h = h / 6

  return {hue: h, saturation: s, value: v}

color.hsvToRGB = (hsv) ->
  h = hsv.hue
  s = hsv.saturation
  v = hsv.value

  i = math.floor h * 6
  f = h * 6 - i
  p = v * (1 - s)
  q = v * (1 - f * s)
  t = v * (1 - (1 - f) * s)

  r,g,b = 0
  switch i % 6
    when 0 then
      r = v
      g = t
      b = p
    when 1 then
      r = q
      g = v
      b = p
    when 2 then
      r = p
      g = v
      b = t
    when 3 then
      r = p
      g = q
      b = v
    when 4 then
      r = t
      g = p
      b = v
    when 5 then
      r = v
      g = p
      b = q

  return math.clamp({red: r * 255, green: g * 255, blue: b * 255}, 0, 255)

color.rgbToXYZ = (rgb) ->
  r = rgb.red / 255
  g = rgb.green / 255
  b = rgb.blue / 255

  if r > 0.04045
    r = math.pow((r + 0.055) / 1.055, 2.4)
  else
    r /= 12.92

  if g > 0.04045
    g = math.pow((g + 0.055) / 1.055, 2.4)
  else
    g /= 12.92

  if b > 0.04045
    b = math.pow((b + 0.055) / 1.055, 2.4)
  else
    b /= 12.92

  x = r * 0.4124 + g * 0.3576 + b * 0.1805
  y = r * 0.2126 + g * 0.7152 + b * 0.0722
  z = r * 0.0193 + g * 0.1192 + b * 0.9505

  return {x: x * 100, y: y * 100, z: z * 100}

color.xyzToRGB = (xyz) ->
  x = xyz.x / 100
  y = xyz.y / 100
  z = xyz.z / 100

  r = (3.2406  * x) + (-1.5372 * y) + (-0.4986 * z)
  g = (-0.9689 * x) + (1.8758  * y) + (0.0415  * z)
  b = (0.0557  * x) + (-0.2040 * y) + (1.0570  * z)

  if r > 0.0031308
    r = (1.055 * math.pow(r, 0.4166666667)) - 0.055
  else
    r *= 12.92

  if g > 0.0031308
    g = (1.055 * math.pow(g, 0.4166666667)) - 0.055
  else
    g *= 12.92

  if b > 0.0031308
    b = (1.055 * math.pow(b, 0.4166666667)) - 0.055
  else
    b *= 12.92

  return math.clamp {red: r * 255, green: g * 255, blue: b * 255}, 0, 255

color.xyzToLab = (xyz) ->
  whiteX = 95.047
  whiteY = 100.0
  whiteZ = 108.883

  x = xyz.x / whiteX
  y = xyz.y / whiteY
  z = xyz.z / whiteZ

  if x > 0.008856451679
    x = math.pow(x, 0.3333333333)
  else
    x = (7.787037037 * x) + 0.1379310345

  if y > 0.008856451679
    y = math.pow(y, 0.3333333333)
  else
    y = (7.787037037 * y) + 0.1379310345

  if z > 0.008856451679
    z = math.pow(z, 0.3333333333)
  else
    z = (7.787037037 * z) + 0.1379310345

  l = 116 * y - 16
  a = 500 * (x - y)
  b = 200 * (y - z)

  return {l: l, a: a, b: b}

color.labToXYZ = (lab) ->
  y = (lab.l + 16) / 116
  x = y + (lab.a / 500)
  z = y - (lab.b / 200)

  if math.pow(x, 3) > 0.008856
    x = math.pow(x, 3)
  else
    x = (x - 16 / 116) / 7.787

  if math.pow(y, 3) > 0.008856
    y = math.pow(y, 3)
  else
    y = (y - 16 / 116) / 7.787

  if math.pow(z, 3) > 0.008856
    z = math.pow(z, 3)
  else
    z = (z - 16 / 116) / 7.787

  return {x: x * 95.047, y: y * 100.0, z: z * 108.883}

color.labToRGB = (lab) ->
  xyz = labToXYZ(lab)
  math.clamp xyzToRGB(xyz), 0, 255

color.cmykToRGB = (cmyk) ->
  r = (65535 - (cmyk.c * (255 - cmyk.k) + (bit.lshift(cmyk.k, 8))))
  g = (65535 - (cmyk.m * (255 - cmyk.k) + (bit.lshift(cmyk.k, 8)))) 
  b = (65535 - (cmyk.y * (255 - cmyk.k) + (bit.lshift(cmyk.k, 8))))

  r = bit.rshift(r, 8)
  g = bit.rshift(g, 8)
  b = bit.rshift(b, 8)

  return math.clamp {red: r, green: g, blue: b}, 0, 255