import 'package:flutter/material.dart';
import 'package:hive_data/models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

import '../boxes/boxes.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var titleController = TextEditingController();
  var desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database'),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context,box, _ ){
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Container(
                  height: 90,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data[index].title.toString()),
                              const Spacer(),
                              InkWell(
                               onTap: (){
                                 _editDialog(data[index],
                                     titleController.text,
                                     desController.text,
                                 );
                               },
                                 child:const  Icon(Icons.edit)),
                              const SizedBox(width: 10,),
                              InkWell(
                                onTap: (){
                                  delete(data[index]);
                                },
                                  child: const  Icon(Icons.delete,color: Colors.pink,)),

                            ],
                          ),
                          Text(data[index].description.toString()),

                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  void delete(NotesModel notesModel)async{
    await notesModel.delete();
  }
  Future<void> _editDialog(NotesModel notesModel,String title,description)async{
    titleController.text = title;
    desController.text = description;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Edit Notes'),
            content: SingleChildScrollView(
              child: Column(
                children:  [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const  SizedBox(height: 20,),
                  TextField(
                    controller: desController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder()
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: (){
                  notesModel.title = titleController.text.toString();
                  notesModel.description = desController.text.toString();
                  notesModel.save();
                  titleController.clear();
                  desController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Edit'),
              ),
            ],
          );
        }
    );
  }

  Future<void> _showMyDialog()async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Add Notes'),
            content: SingleChildScrollView(
              child: Column(
                children:  [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                      border: OutlineInputBorder()
                    ),
                  ),
                 const  SizedBox(height: 20,),
                  TextField(
                    controller: desController,
                    decoration: const InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder()
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: (){
                  final data = NotesModel(
                      title: titleController.text,
                      description: desController.text,
                  );
                  final box = Boxes.getData();
                  box.add(data);
                 // data.save();
                  titleController.clear();
                  desController.clear();
                  print(box);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        }
    );
  }
}
