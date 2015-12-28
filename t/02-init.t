use Test;
use GLFW;

plan 4;

is(glfwInit(), 1);

my $win = GLFW::Window.new(640, 480, "My first window!");

ok($win);

$win.destroy;
pass("destroy");

glfwTerminate();
pass("glfwTerminate");
