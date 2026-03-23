module dessert::ser;
import std::core::types;

macro @serialize(#serializer, #value) {
  var serializer = #serializer;
  var value = #value;
  $switch:
    $case $typeof(value).kindof == POINTER:
      if (value == null) {
        return serializer.serialize_null();
      } else {
        return @serialize(serializer, *value);
      }
    $case $typeof(value).kindof == STRUCT:
      return @serialize_struct(serializer, value);
    $case $typeof(value).kindof == SIGNED_INT:
      return serializer.serialize_int(value);
    $case types::is_same($typeof(value), String):
      return serializer.serialize_string(value);
    $default:
      return NOT_FOUND~;
  $endswitch
}

macro @serialize_struct(#serializer, #value) {
  #serializer.@serialize_struct_start()!;
  $foreach $member : $typeof(#value).membersof:
    #serializer.@serialize_field($member.nameof, #value.$eval($member.nameof))!;
  $endforeach
  return #serializer.@serialize_struct_end();
}
