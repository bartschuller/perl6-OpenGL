#!/usr/bin/env perl6

use GLFW;

glfwInit();

my $win = GLFW::Window.new(640, 480, "OpenGL demo");

$win.makeContextCurrent();

sleep 5;

glfwMakeContextCurrent();

glfwTerminate();
