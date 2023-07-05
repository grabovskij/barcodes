import 'package:barcode_scanner_generator/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController textEditingController;
  late final FocusNode textFocus;

  @override
  void initState() {
    textEditingController = TextEditingController();
    textFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                focusNode: textFocus,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      textFocus.unfocus();

                      final barcode =
                          await context.push<String?>(AppRouter.scanPage);

                      if (barcode != null) textEditingController.text = barcode;
                    },
                    child: const Icon(Icons.document_scanner_outlined),
                  ),
                ),
                controller: textEditingController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
