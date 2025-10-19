import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/items.dart';
import 'package:shopping_list/new_item.dart';
import "package:http/http.dart" as http ;
import 'dart:convert';
class GroceryList extends StatefulWidget
{
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> lst=[];
  int isLoading=1;
  String? error;
  void getItems() async {
    final url=Uri.https("grocery-listapp-default-rtdb.firebaseio.com","list.json");
           

          try
          {
              final res= await http.get(url);
              if(res.statusCode>=400)
           {
            setState(() {
              error="Failed to fetch data.\nTry again later.";
            });
            
           }
           if(res.body=="null")
           {
            setState(() {
              isLoading=0;
            });
              return;
           }
           List <GroceryItem> items=[];
           Map<String,dynamic> receivedItems=json.decode(res.body);
          for(final i in receivedItems.entries)
          {
            Category cat=categories[Categories.vegetables]!;
            for(final j in categories.entries)
            {
              if(j.value.title==i.value["category"])
              {
                cat=j.value;
                break;
              }
            }
            items.add(GroceryItem(id: i.key, name: i.value["name"], quantity: i.value["quantity"], category: cat));
            
          }
          setState(() {
            lst=items;
            isLoading=0;
          });
          }

          catch(err)
          {
            setState(() {
              error="Something went wrong.\nTry again later.";
            });
          }

           
          
  }
  void initState(){
    super.initState();
           getItems();
  }
  

  @override

  Widget build(BuildContext context) {
    Widget screen=Center(child: Text("No items!"),);
    if(isLoading==1)
    {
      screen=Center(child: CircularProgressIndicator(),);
    }
    if(lst.isNotEmpty)
    {
      screen=ListView.builder(
        itemCount: lst.length,
        itemBuilder: (context, index)=>Dismissible(
          onDismissed: (direction) async {
            var i=lst[index];
           setState(() {
              lst.remove(lst[index]);
            }); 
          final url=Uri.https("grocery-listapp-default-rtdb.firebaseio.com","list/${i.id}.json");
          final response=await http.delete(url);
          if (response.statusCode>=400)
          {
            setState(() {
              lst.insert(index, i);
            }); 
          }
            
          },
          key: ValueKey(lst[index]),
          child: ListTile(
          title: Text(lst[index].name),
          leading: Container(height: 24,width: 24, color: lst[index].category.color,),
          trailing: Text(lst[index].quantity.toString()),
                ),
        ));
    }
    if(error!=null)
      {
        screen=Center(child: Text(error!),);
      }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Groceries"),
        actions: [
          IconButton(onPressed: ()async{ 
           final itm =await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(builder: (context)=>NewItem()));
          //getItems();
          if(itm==null)
          {
            return;
          }
          setState(() {
            lst.add(itm);
          });

          }, icon: Icon(Icons.add))
        ],
      ),
      body: screen
      
      
    );
  }
}