import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool load = false;
  final controller = TextEditingController();
  final List<Map<String, String>> conversations = [];
  final List<String> prompts=["Explain like iam a beginner","Can you please summarize this article for me?","Can you translate this sentence into English?","Can you recommend books similar to","Can you recommend movies similar to","Act as Tony Stark","Why this code is not working?","What this code does?","Translate this code into Python:","Add comments to this code: ","Please extract all the numbers from this text"];
  String prompt="";
  Color color=Colors.grey;

  void Prompts(String prompt) async {
    const apiKey = "AIzaSyD8JN5sLPGLwy4pf3JCHH9crBxZ-GI1Zrw"; // Replace with your API key
    final client = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    String? result = "";
    try {
      final response = await client.generateContent([Content.text((prompt.contains("Act"))?prompt+"while asnwering this question":prompt)]);
      result = response.text;
      result = result?.replaceAll(RegExp(r'##\s*'), '');
      result = result?.replaceAll(RegExp(r'\*\*|\*'), '');
    } catch (e) {
      result = "error";
    }
    setState(() {
      conversations.add({'question': prompt, 'response': result!});
      load = false; // Reset the loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 35,),
              const Text("Suggested Prompts",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 15,),
              Container(
                  height: 65,
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey,
                    border: Border.all(color: Colors.black,width: 2.0)
                  ),
                  child: Center(child: Text((prompt=="")?"Selected Prompt":prompt,style: const TextStyle(fontSize: 17),),),
                ),
              Expanded(
                child: ListView.builder(
                    itemCount: prompts.length,
                    itemBuilder: (context,i){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey, // Background color of ListTile
                            borderRadius: BorderRadius.circular(15), // Circular border radius
                            border: Border.all(color: Colors.black, width: 2.0), // Border color and width
                          ),
                          child:ListTile(
                            
                            title: Text(prompts[i]),
                            onTap: (){
                              setState(() {
                                (prompt==prompts[i])?prompt="":prompt=prompts[i];
                              });
                            },
                          ),
                        )
                      );
                    }
                ),
              )
            ],
          ),
        )
      ),
      appBar: AppBar(
        title: const Text(
          "ChatBot",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true, // Ensures the keyboard doesn't overlap the input
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var convo in conversations) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Q: ${convo['question']}",
                            style: const TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.white, width: 2.0),
                              color: Colors.black,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              convo['response']!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (load)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: controller,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      load = true;
                    });
                    Prompts(prompt+" "+controller.text);
                    //controller.clear(); // Clear the text field after submitting
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
