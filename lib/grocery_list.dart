import 'package:flutter/material.dart';
import 'package:shopping_list/data/items.dart';
import 'package:shopping_list/new_item.dart';

class GroceryList extends StatefulWidget
{
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> lst=[];
  Widget screen=Center(child: Text("No items!"),);

  @override
  Widget build(BuildContext context) {
    if(lst.isNotEmpty)
    {
      screen=ListView.builder(
        itemCount: lst.length,
        itemBuilder: (context, index)=>Dismissible(
          onDismissed: (direction){
            setState(() {
              lst.remove(lst[index]);
            });
          },
          key: ValueKey(lst[index]),
          child: ListTile(
          title: Text(lst[index].name),
          leading: Container(height: 24,width: 24, color: lst[index].category.color,),
          trailing: Text(lst[index].quantity.toString()),
                ),
        ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Groceries"),
        actions: [
          IconButton(onPressed: ()async{ 
            final newItem= await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(builder: (context)=>NewItem()));
            if(newItem==null)
            {
              return;
            }
            setState(() {
               lst.add(newItem);
            });
           
          }, icon: Icon(Icons.add))
        ],
      ),
      body: screen
      
      
    );
  }
}