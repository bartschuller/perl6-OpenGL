use Test;
use GLFW;

plan 5;

is(+GLFW_KEY_SPACE, 32);

is(glfwInit(), 1);

my $win = GLFW::Window.new(640, 480, "My first window!");

ok($win);

$win.destroy;
pass("destroy");

glfwTerminate();
pass("glfwTerminate");
