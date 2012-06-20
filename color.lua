require('bit')
require('useless')
module('color', package.seeall)
hexToRGB = function(hex)
  if string.sub(hex, 1, 1) == '#' then
    hex = string.sub(hex, 2)
  end
  local r = tonumber(string.sub(hex, 1, 2), 16)
  local g = tonumber(string.sub(hex, 3, 4), 16)
  local b = tonumber(string.sub(hex, 5, 6), 16)
  return {
    red = r,
    green = g,
    blue = b
  }
end
color.decToHex = function(dec)
  local b, k, out, i, d = 16, "0123456789ABCDEF", "", 0
  while dec > 0 do
    i = i + 1
    dec, d = math.floor(dec / b), math.fmod(dec, b) + 1
    out = string.sub(k, d, d) .. out
  end
  return out
end
color.rgbToHex = function(c)
  return color.decToHex(c.red) .. color.decToHex(c.green) .. color.decToHex(c.blue)
end
color.rgbToHSL = function(rgb)
  local r = rgb.red / 255
  local g = rgb.green / 255
  local b = rgb.blue / 255
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local l = (max + min) / 2
  local h = 0
  local s = 0
  if max == min then
    h = 0
    s = 0
  else
    local d = max - min
    if l > 0.5 then
      s = d / (2 - max - min)
    else
      s = d / (max + min)
    end
    local _exp_0 = max
    if r == _exp_0 then
      h = (g - b) / d + ((function()
        if g < b then
          return 6
        else
          return 0
        end
      end)())
    elseif g == _exp_0 then
      h = (b - r) / d + 2
    elseif b == _exp_0 then
      h = (r - g) / d + 4
    end
    h = h / 6
  end
  return {
    hue = math.round(h, 3),
    saturation = math.round(s, 3),
    lightness = math.round(l, 3)
  }
end
color.hueToRGB = function(p, q, t)
  if t < 0 then
    t = t + 1
  end
  if t > 1 then
    t = t - 1
  end
  if t < 1 / 6 then
    return p + (q - p) * 6 * t
  end
  if t < 1 / 2 then
    return q
  end
  if t < 2 / 3 then
    return p + (q - p) * (2 / 3 - t) * 6
  end
  return p
end
color.hslToRGB = function(hsl)
  local h = hsl.hue
  local s = hsl.saturation
  local l = hsl.lightness
  if s == 0 then
    local r = l
    local g = l
    local b = l
  else
    local q
    if l < 0.5 then
      q = l * (1 + s)
    else
      q = l + s - l * s
    end
    local p = 2 * l - q
    local r = color.hueToRGB(p, q, h + 1 / 3)
    local g = color.hueToRGB(p, q, h)
    local b = color.hueToRGB(p, q, h - 1 / 3)
  end
  local r = r * 255
  local g = g * 255
  local b = b * 255
  return {
    red = math.round(r),
    green = math.round(g),
    blue = math.round(b)
  }
end
rgbToHSV = function(rgb)
  local r = rgb.red / 255
  local g = rgb.green / 255
  local b = rgb.blue / 255
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local v = max
  local d = max - min
  local s
  if max == 0 then
    s = 0
  else
    s = d / max
  end
  local h = 0
  if max ~= min then
    local _exp_0 = max
    if r == _exp_0 then
      h = (g - b) / d + ((function()
        if g < b then
          return 6
        else
          return 0
        end
      end)())
    elseif g == _exp_0 then
      h = (b - r) / d + 2
    elseif b == _exp_0 then
      h = (r - g) / d + 4
    end
    h = h / 6
  end
  return {
    hue = h,
    saturation = s,
    value = v
  }
end
color.hsvToRGB = function(hsv)
  local h = hsv.hue
  local s = hsv.saturation
  local v = hsv.value
  local i = math.floor(h * 6)
  local f = h * 6 - i
  local p = v * (1 - s)
  local q = v * (1 - f * s)
  local t = v * (1 - (1 - f) * s)
  local r, g, b = 0
  local _exp_0 = i % 6
  if 0 == _exp_0 then
    r = v
    g = t
    b = p
  elseif 1 == _exp_0 then
    r = q
    g = v
    b = p
  elseif 2 == _exp_0 then
    r = p
    g = v
    b = t
  elseif 3 == _exp_0 then
    r = p
    g = q
    b = v
  elseif 4 == _exp_0 then
    r = t
    g = p
    b = v
  elseif 5 == _exp_0 then
    r = v
    g = p
    b = q
  end
  return math.clamp({
    red = r * 255,
    green = g * 255,
    blue = b * 255
  }, 0, 255)
end
color.rgbToXYZ = function(rgb)
  local r = rgb.red / 255
  local g = rgb.green / 255
  local b = rgb.blue / 255
  if r > 0.04045 then
    r = math.pow((r + 0.055) / 1.055, 2.4)
  else
    r = r / 12.92
  end
  if g > 0.04045 then
    g = math.pow((g + 0.055) / 1.055, 2.4)
  else
    g = g / 12.92
  end
  if b > 0.04045 then
    b = math.pow((b + 0.055) / 1.055, 2.4)
  else
    b = b / 12.92
  end
  local x = r * 0.4124 + g * 0.3576 + b * 0.1805
  local y = r * 0.2126 + g * 0.7152 + b * 0.0722
  local z = r * 0.0193 + g * 0.1192 + b * 0.9505
  return {
    x = x * 100,
    y = y * 100,
    z = z * 100
  }
end
color.xyzToRGB = function(xyz)
  local x = xyz.x / 100
  local y = xyz.y / 100
  local z = xyz.z / 100
  local r = (3.2406 * x) + (-1.5372 * y) + (-0.4986 * z)
  local g = (-0.9689 * x) + (1.8758 * y) + (0.0415 * z)
  local b = (0.0557 * x) + (-0.2040 * y) + (1.0570 * z)
  if r > 0.0031308 then
    r = (1.055 * math.pow(r, 0.4166666667)) - 0.055
  else
    r = r * 12.92
  end
  if g > 0.0031308 then
    g = (1.055 * math.pow(g, 0.4166666667)) - 0.055
  else
    g = g * 12.92
  end
  if b > 0.0031308 then
    b = (1.055 * math.pow(b, 0.4166666667)) - 0.055
  else
    b = b * 12.92
  end
  return math.clamp({
    red = r * 255,
    green = g * 255,
    blue = b * 255
  }, 0, 255)
end
color.xyzToLab = function(xyz)
  local whiteX = 95.047
  local whiteY = 100.0
  local whiteZ = 108.883
  local x = xyz.x / whiteX
  local y = xyz.y / whiteY
  local z = xyz.z / whiteZ
  if x > 0.008856451679 then
    x = math.pow(x, 0.3333333333)
  else
    x = (7.787037037 * x) + 0.1379310345
  end
  if y > 0.008856451679 then
    y = math.pow(y, 0.3333333333)
  else
    y = (7.787037037 * y) + 0.1379310345
  end
  if z > 0.008856451679 then
    z = math.pow(z, 0.3333333333)
  else
    z = (7.787037037 * z) + 0.1379310345
  end
  local l = 116 * y - 16
  local a = 500 * (x - y)
  local b = 200 * (y - z)
  return {
    l = l,
    a = a,
    b = b
  }
end
color.labToXYZ = function(lab)
  local y = (lab.l + 16) / 116
  local x = y + (lab.a / 500)
  local z = y - (lab.b / 200)
  if math.pow(x, 3) > 0.008856 then
    x = math.pow(x, 3)
  else
    x = (x - 16 / 116) / 7.787
  end
  if math.pow(y, 3) > 0.008856 then
    y = math.pow(y, 3)
  else
    y = (y - 16 / 116) / 7.787
  end
  if math.pow(z, 3) > 0.008856 then
    z = math.pow(z, 3)
  else
    z = (z - 16 / 116) / 7.787
  end
  return {
    x = x * 95.047,
    y = y * 100.0,
    z = z * 108.883
  }
end
color.labToRGB = function(lab)
  local xyz = labToXYZ(lab)
  return math.clamp(xyzToRGB(xyz), 0, 255)
end
color.cmykToRGB = function(cmyk)
  local r = (65535 - (cmyk.c * (255 - cmyk.k) + (bit.lshift(cmyk.k, 8))))
  local g = (65535 - (cmyk.m * (255 - cmyk.k) + (bit.lshift(cmyk.k, 8))))
  local b = (65535 - (cmyk.y * (255 - cmyk.k) + (bit.lshift(cmyk.k, 8))))
  r = bit.rshift(r, 8)
  g = bit.rshift(g, 8)
  b = bit.rshift(b, 8)
  return math.clamp({
    red = r,
    green = g,
    blue = b
  }, 0, 255)
end
