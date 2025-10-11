import 'package:shopping_list/data/categories.dart' as cat;


class GroceryItem
{
  const GroceryItem({required this.id,required this.name,required this.quantity,required this.category});
  final String id;
  final String name;
  final int quantity;
  final cat.Category category;
}
final groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: cat.categories[cat.Categories.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: cat.categories[cat.Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: cat.categories[cat.Categories.meat]!),
]; 