require 'color'
rgb = color.hexToRGB('#364C2F')
hex = color.rgbToHex(rgb)
print rgb.red, rgb.green, rgb.blue
hsv = color.rgbToHSV(rgb)
print hsv.hue, hsv.saturation, hsv.value
rgb = color.hsvToRGB(hsv)
print rgb.red, rgb.green, rgb.blue
xyz = color.rgbToXYZ(rgb)
print xyz.x, xyz.y, xyz.z
rgb = color.xyzToRGB(xyz)
print rgb.red, rgb.green, rgb.blue
lab = color.xyzToLab(xyz)
print lab.l, lab.a, lab.b
xyz = color.labToXYZ(lab)
print xyz.x, xyz.y, xyz.z
rgb = color.labToRGB(lab)
print rgb.red, rgb.green, rgb.blue-- 