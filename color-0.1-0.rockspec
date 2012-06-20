package = 'color'
version = "0.1-0"
source = {
  url = 'git://github.com/bookworm/color.lua.git',
}
description = {
  summary  = "Color utilities.",
  detailed = [[Detail]],
  homepage = 'http://github.com/bookworm/color.lua',
  license  = 'none',
}
dependencies = {
  'lua ~> 5.1',
  'useless',
}
build = { type = 'builtin',
  modules = {
    color = 'color.lua'
  }, 
}