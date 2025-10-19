import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/items.dart';
import "package:http/http.dart" as http ;
import 'dart:convert';

class NewItem extends StatefulWidget
{
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}
class _NewItemState extends State<NewItem>
{
  final formKey=GlobalKey<FormState>();
  String name="";
  int quantity=0;
  var category=categories[Categories.vegetables]!;
  int isSending=0;
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new item"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
         child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(label: Text("Name")),
                validator: (value){
                  if(value==null || value.isEmpty)
                  {
                    return "Input must be 1 to 50 characters.";
                  }
                  else
                  {
                    return null;
                  }
                },
                onSaved: (value){
                  name=value!;
                },
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(label: Text("Quantity")),
                    initialValue: "1",
                    validator: (value){
                  if(value==null || value.isEmpty || int.tryParse(value)==null || int.tryParse(value)!<0)
                  {
                    return "Input must be an non-negative integer number.";
                  }
                  else
                  {
                    return null;
                  }
                },
                onSaved: (value){
                  quantity=int.parse(value!);
                },
                  ),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: DropdownButtonFormField(
                    value: category,
                    items:[
                      for(final i in categories.entries)
                        DropdownMenuItem(
                          value: i.value,
                          child: 
                          Row(
                            children: [ Container(
                              width: 16, height: 16, color: i.value.color
                            ),
                            SizedBox(width: 6,),
                            Text(i.value.title)]
                           
                          )
                          )
                    ], onChanged: (value){setState(() {
                      category=value!;
                    }); }
                    ),
                )
              ],
            ),
            SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: isSending==0? (){
                  formKey.currentState!.reset();
                } : null, child: Text("Reset")),
                ElevatedButton(onPressed: isSending==0 ? () async {
                  if(formKey.currentState!.validate())
                  {
                      final url=Uri.https("grocery-listapp-default-rtdb.firebaseio.com","list.json");
                      formKey.currentState!.save();
                      setState(() {
                        isSending=1;
                      });
                      final response=await http.post(url, headers: {
                        "Content-Type":"application/json"
                      }, body: json.encode({
                        "name": name, "quantity": quantity, "category": category.title
                      }));
                      if(!context.mounted)
                      {
                        return;
                      }
                      final Map<String, dynamic> dat=json.decode(response.body);
                      Navigator.of(context).pop(GroceryItem(id: dat["name"], name: name, quantity: quantity, category: category));
                      print(name);
                      print(quantity);
                      print(category);
                  }
                }:null, child: isSending==0? Text("Add item"):Text("Adding"))
              ],
            )
            ],
          ) 
          ),
        ),
    );
  }
}