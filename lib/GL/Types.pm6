unit module GL::Types;

use NativeCall;

sub num32Array(*@items) returns CArray[num32] is export {
  my $array = CArray[num32].new;
  $array[$_] = Num(@items[$_]) for ^@items.elems;
  $array;
}

sub sizeof($thing) is export {
  given $thing {
    when CArray {
      say "It's a CArray of ";
    }
    default {
      say "dunno"
    }
  }
}
