module json;
import std::collections::map;
import std::io;

enum JsonValueKind {
  INT,
  FLOAT,
  BOOL,
  STRING,
  DICT,
  NULL,
}

struct JsonValue {
  union value {
    int i;
    float f;
    bool b;
    String s;
    HashMap{String, JsonValue} *d;
  }

  JsonValueKind kind;
}

fn void? JsonValue.print(self) {
  switch(self.kind) {
    case NULL:
      io::print("null");
    case INT:
      io::printf("%s", self.value.i);
    case FLOAT:
      io::printf("%s", self.value.f);
    case BOOL:
      io::printf("%s", self.value.b);
    case STRING:
      io::printf("\"%s\"", self.value.s);
    case DICT:
      io::printf("{");
      ulong d_len = self.value.d.len();
      foreach (i, entry : self.value.d.iter()) {
        io::printf("\"%s\": ", entry.key);
        entry.value.print()!;
        if (i < d_len - 1) {
          io::print(", ");
        }
      }
     io::printf("}");

    default:
      return NOT_FOUND~;
  }
}

module dessert::json;
import dessert::ser;
import json;
import std::collections::maybe;
import std::collections::map;

faultdef INVALID_JSON_TYPE;

struct JsonSerializer {
  Maybe{JsonValue} output;
}

fn JsonSerializer new_json_serializer() => { .output = {} };

fn JsonValue? JsonSerializer.serialize_null(JsonSerializer* self) @dynamic 
  => { .kind = JsonValueKind.NULL, .value = { .i = 0 } };

fn JsonValue? JsonSerializer.serialize_bool(JsonSerializer* self, bool b) @dynamic 
  => { .kind = JsonValueKind.BOOL, .value = { .b = b } };

fn JsonValue? JsonSerializer.serialize_int(JsonSerializer* self, int i) @dynamic 
  => { .kind = JsonValueKind.INT, .value = { .i = i } };

fn JsonValue? JsonSerializer.serialize_char(JsonSerializer* self, char c) @dynamic 
  => { .kind = JsonValueKind.STRING, .value = { .s = {c} } };

fn JsonValue? JsonSerializer.serialize_string(JsonSerializer* self, String s) @dynamic
  => { .kind = JsonValueKind.STRING, .value = { .s = s } };


macro void? JsonSerializer.@serialize_struct_start(JsonSerializer* self) {
  HashMap{String, JsonValue} d;
  self.output.set({ .kind = JsonValueKind.DICT, .value = { .d = d.init(mem) } });
}
macro JsonValue? JsonSerializer.@serialize_struct_end(JsonSerializer* self) {
  return self.output.get();
}

macro void? JsonSerializer.@serialize_field(JsonSerializer* self, k, #v) {
  JsonValue output = self.output.get()!;
  if (output.kind != JsonValueKind.DICT) return INVALID_JSON_TYPE~;

  JsonValue key = self.serialize_string(k)!;
  if (key.kind != JsonValueKind.STRING) return INVALID_JSON_TYPE~;

  JsonValue value = ser::@serialize(new_json_serializer(), #v)!;

  output.value.d.set(key.value.s, value);
}

fn JsonValue? JsonSerializer.serialize_key(JsonSerializer* self, Key k) <Key> @dynamic {
  return NOT_FOUND~;
}

fn JsonValue? JsonSerializer.serialize_value(JsonSerializer* self, Value v) <Value> @dynamic {
  return NOT_FOUND~;
}
