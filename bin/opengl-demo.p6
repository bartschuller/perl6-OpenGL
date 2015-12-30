#!/usr/bin/env perl6

use GLFW;
use GL;
use GL::Types;
use NativeCall;

sub loadShaders(Str $vertexPath, Str $fragmentPath) {
  my $vertexShaderID = glCreateShader(GL_VERTEX_SHADER);
 	my $fragmentShaderID = glCreateShader(GL_FRAGMENT_SHADER);

  my $vertexShaderCode = $vertexPath.IO.slurp;
  my $fragmentShaderCode = $fragmentPath.IO.slurp;

  my int32 $result = GL_FALSE;
  my int32 $infoLogLength;
  my $strings = CArray[Str].new;

 	# Compile Vertex Shader
  $strings[0] = $vertexShaderCode;
 	glShaderSource($vertexShaderID, 1, $strings , Nil);
  glCompileShader($vertexShaderID);

  # Check Vertex Shader
 	glGetShaderiv($vertexShaderID, GL_COMPILE_STATUS, $result);
 	glGetShaderiv($vertexShaderID, GL_INFO_LOG_LENGTH, $infoLogLength);

 	if ($infoLogLength > 0 ) {
 		my $vertexShaderErrorMessage = CArray[uint8].new;
    $vertexShaderErrorMessage[$infoLogLength] = 0;
    my int32 $length;
 		glGetShaderInfoLog($vertexShaderID, $infoLogLength, $length, $vertexShaderErrorMessage);
    say nativecast(str, $vertexShaderErrorMessage);
 	}

  # Compile Fragment Shader
  $strings[0] = $fragmentShaderCode;
  glShaderSource($fragmentShaderID, 1, $strings , Nil);
  glCompileShader($fragmentShaderID);

  # Check Vertex Shader
  glGetShaderiv($fragmentShaderID, GL_COMPILE_STATUS, $result);
  glGetShaderiv($fragmentShaderID, GL_INFO_LOG_LENGTH, $infoLogLength);

  if ($infoLogLength > 0 ) {
    my $fragmentShaderErrorMessage = CArray[uint8].new;
    $fragmentShaderErrorMessage[$infoLogLength] = 0;
    my int32 $length;
    glGetShaderInfoLog($fragmentShaderID, $infoLogLength, $length, $fragmentShaderErrorMessage);
    say nativecast(str, $fragmentShaderErrorMessage);
  }

  # Link the program
 	my uint32 $programID = glCreateProgram();
 	glAttachShader($programID, $vertexShaderID);
 	glAttachShader($programID, $fragmentShaderID);
 	glLinkProgram($programID);

 	# Check the program
 	glGetProgramiv($programID, GL_LINK_STATUS, $result);
 	glGetProgramiv($programID, GL_INFO_LOG_LENGTH, $infoLogLength);

 	if ($infoLogLength > 0 ) {
    my $programErrorMessage = CArray[uint8].new;
    $programErrorMessage[$infoLogLength] = 0;
    my int32 $length;
    glGetProgramInfoLog($programID, $infoLogLength, $length, $programErrorMessage);
    say nativecast(str, $programErrorMessage);
 	}

 	glDetachShader($programID, $vertexShaderID);
 	glDetachShader($programID, $fragmentShaderID);

 	glDeleteShader($vertexShaderID);
 	glDeleteShader($fragmentShaderID);

 	return $programID;
}

glfwInit();

glfwWindowHint(GLFW_SAMPLES, 4); # 4x antialiasing
glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3); # We want OpenGL 3.3
glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, True); # To make MacOS happy; should not be needed
glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE); # We don't want the old OpenGL

my $win = GLFW::Window.new(960, 540, "OpenGL demo");

$win.makeContextCurrent();

# $glewExperimental = 1;
# if (my $err = glewInit() != GLEW_OK) {
#   glfwTerminate();
#   die "glewInit(): $err";
# }

# Dark blue background
glClearColor(0.0e0, 0.0e0, 0.4e0, 0.0e0);

my @vertexArrayIDs := CArray[uint32].new(0);
glGenVertexArrays(1, @vertexArrayIDs);
glBindVertexArray(@vertexArrayIDs[0]);

my @g_vertex_buffer_data := num32Array(
  -1, -1,  0,
   1, -1,  0,
   0,  1,  0
);

my @vertexbuffers := CArray[uint32].new(0);
glGenBuffers(1, @vertexbuffers);
glBindBuffer(GL_ARRAY_BUFFER, @vertexbuffers[0]);
glBufferData(GL_ARRAY_BUFFER, @g_vertex_buffer_data.elems * 4, @g_vertex_buffer_data, GL_STATIC_DRAW);

glfwSwapInterval(1);

sub checkEscape(GLFW::Window $win, int32 $key, int32 $scancode, int32 $action, int32 $mods) {
  if $key == GLFW_KEY_ESCAPE && $action == GLFW_PRESS {
    $win.setShouldClose();
  }
}

$win.setKeyCallback(&checkEscape);

my $programID = loadShaders("SimpleVertexShader.glsl", "SimpleFragmentShader.glsl");

repeat {
  glClear(GL_COLOR_BUFFER_BIT +| GL_DEPTH_BUFFER_BIT);
  glUseProgram($programID);

  glEnableVertexAttribArray(0);
  glBindBuffer(GL_ARRAY_BUFFER, @vertexbuffers[0]);
  glVertexAttribPointer(
    0,                  # attribute 0. No particular reason for 0, but must match the layout in the shader.
    3,                  # size
    GL_FLOAT,           # type
    GL_FALSE,           # normalized?
    0,                  # stride
    Pointer.new(0)      # array buffer offset
  );
  # Draw the triangle !
  glDrawArrays(GL_TRIANGLES, 0, 3); # Starting from vertex 0; 3 vertices total -> 1 triangle
  glDisableVertexAttribArray(0);

  $win.swapBuffers();
  glfwPollEvents();
} until $win.shouldClose();

$win.destroy();

glfwTerminate();
