module dessert;

struct Dessert {
  bool skip;
  String rename;
  String[] aliases;
  String validator;
}

attrdef @Dessert(Dessert config) = @tag("dessert", config);
