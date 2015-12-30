unit module GLEW;

use NativeCall;

constant LIB = ('GLEW', v1.13);

sub glewInit() returns int32 is native(LIB) is export { * }

sub glGenVertexArrays(int32 $n, CArray[uint32] $arrays) is native(LIB) is export { * } # is symbol('__glewGenVertexArrays')
sub glBindVertexArray(uint32 $array) is native(LIB) is symbol('__glewBindVertexArray') is export { * }
sub glGenBuffers(int32 $n, CArray[uint32] $buffers) is native(LIB) is symbol('__glewGenBuffers') is export { * }
sub glBindBuffer(uint32 $target, uint32 $buffer) is native(LIB) is symbol('__glewBindBuffer') is export { * }
sub glBufferData(uint32 $target, size_t $size, Pointer $data, uint32 $usage) is native(LIB) is symbol('__glewBufferData') is export { * }

our $glewExperimental is export := cglobal(LIB, 'glewExperimental', uint8);

enum GLEW_ERROR_CODES is export (
  GLEW_OK => 0,
  GLEW_NO_ERROR => 0,
  GLEW_ERROR_NO_GL_VERSION => 1, # missing GL version
  GLEW_ERROR_GL_VERSION_10_ONLY => 2, # Need at least OpenGL 1.1
  GLEW_ERROR_GLX_VERSION_11_ONLY => 3 # Need at least GLX 1.2
);

enum GL_DEFINES is export (
  GL_ARRAY_BUFFER => 0x8892,
  GL_STATIC_DRAW => 0x88E4
);
