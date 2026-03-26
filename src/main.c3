module dessert;
import std::io;
import dessert::ser;
import dessert::json;
import json;
import std::collections::list;
import std::collections::maybe;

struct Animal (Serializable) {
  String name;
  String specie;
}

struct Person (Serializable) {
  int age @Dessert({ .validator = "validate_age" });
  String name;
  Animal[] pets;
  Maybe{Person*} friend;
}

fn void? Animal.serialize(&self, Serializer serializer) @dynamic => 
  ser::impl_serialize(serializer, self);

fn void? Person.serialize(&self, Serializer serializer) @dynamic => 
  ser::impl_serialize(serializer, self); 

fn bool Person.validate_age(&self, int age) => age > 0;

fn int main(String[] args)
{
  Person connor = { .age = 20, .name = "Connor" };
  Animal sharpie = { .name = "Sharpie", .specie = "Cat" };
  Animal gisele = { .name = "Gisele", .specie = "Rabbit" };
  connor.pets = {sharpie, gisele};
  // connor.pet = maybe::value(sharpie);
  // connor.pet = sharpie;

  Person amenda = { .age = 21, .name = "Amenda" };
  connor.friend = maybe::value(&amenda);

  JsonSerializer ser = json::new_json_serializer();
  JsonValue connor_json = ser::serialize(&ser, &connor)!!;
  // if (catch connor_json) {
	 //  io::printn("error");
  //   return 0;
  // }

	io::printn("Success");
  connor_json.print()!!;
	io::printn("");

  JsonValue? amenda_json = ser::serialize(&&json::new_json_serializer(), amenda);
  if (catch amenda_json) {
	  io::printn("error");
    return 0;
  }

	io::printn("Success");
  amenda_json.print()!!;
	io::printn("");
	return 0;
}


