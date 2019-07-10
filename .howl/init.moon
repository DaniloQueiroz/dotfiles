import config, mode from howl
import File from howl.io

-- Set indent globally to two spaces
config.indent = 2
config.font = 'Source Code Pro Medium Regular'
config.font_size = 12
config.theme = 'Dracula'

-- Use four spaces for C files
mode.configure 'py', {
  indent: 4
}
