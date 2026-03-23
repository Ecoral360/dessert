module dessert;
import std::io;
import dessert::ser;
import dessert::json;
import json;

struct Animal {
  String name;
  String specie;
}

struct Person {
  int age;
  String name;
  Animal *pet;
}

fn int main(String[] args)
{
  Person connor = { .age = 20, .name = "Connor" };
  Animal sharpie = { .name = "Sharpie", .specie = "Cat" };
  connor.pet = &sharpie;

  Person amenda = { .age = 21, .name = "Amenda" };

  JsonValue? connor_json = ser::@serialize(json::new_json_serializer(), connor);
  if (catch connor_json) {
	  io::printn("error");
    return 0;
  }

	io::printn("Success");
  connor_json.print()!!;
	io::printn("");

  JsonValue? amenda_json = ser::@serialize(json::new_json_serializer(), amenda);
  if (catch amenda_json) {
	  io::printn("error");
    return 0;
  }

	io::printn("Success");
  amenda_json.print()!!;
	io::printn("");
	return 0;
}
