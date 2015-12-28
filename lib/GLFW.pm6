unit module GLFW;

use NativeCall;

constant LIB = ('glfw3', v3);

class Monitor is repr('CPointer') { }
class Window is repr('CPointer') { ... }

sub glfwInit() returns int32 is native(LIB) is export { * }
sub glfwTerminate() is native(LIB) is export { * }
sub glfwMakeContextCurrent(Window $window?) is native(LIB) is export { * }


class Window {
  sub glfwCreateWindow(
    int32 $width,
  	int32 $height,
  	Str $title is encoded('utf8'),
  	Monitor $monitor,
    Window $share
  ) returns Window is native(LIB) { * }

  sub glfwDestroyWindow(Window $window) is native(LIB) { * }

  sub glfwMakeContextCurrent(Window $window) is native(LIB) { * }

  method new(Int $width where {$width > 0}, Int $height where {$height > 0}, Str $title, Monitor $monitor?, Window $share? --> Window) {
    glfwCreateWindow($width, $height, $title, $monitor, $share)
  }

  method destroy { glfwDestroyWindow(self) }

  method makeContextCurrent { glfwMakeContextCurrent(self) }
}
