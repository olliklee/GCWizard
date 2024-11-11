import 'package:flutter/material.dart';
import 'package:gc_wizard/application/tools/tool_licenses/widget/tool_license_types.dart';

// v0.1

void main() {
  runApp(const SymbolTableApp());
}

class SymbolTableApp extends StatelessWidget {
  const SymbolTableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Symbol Table Configuration Files Helper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SymbolTableForm(),
    );
  }
}

class SymbolTableForm extends StatefulWidget {
  const SymbolTableForm({super.key});

  @override
  _SymbolTableFormState createState() => _SymbolTableFormState();
}

class _SymbolTableFormState extends State<SymbolTableForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _folderController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchStringControllerEN = TextEditingController();
  final _searchStringControllerCOM = TextEditingController();
  final _authorController = TextEditingController();
  final _titleController = TextEditingController();
  final _sourceURLController = TextEditingController();
  final _customCommentController = TextEditingController();
  late String _output = "";

  String toSnakeCase(String text) {
    text = text.replaceAll(RegExp(r'[^\w\s]'), ' ');
    text = text.replaceAllMapped(RegExp(r'(?<!^)(?=[A-Z])'), (match) => '_').toLowerCase();
    text = text.replaceAll(RegExp(r'\s+'), '_');
    return text.replaceAll(RegExp(r'_+'), '_').trim();
  }

  var licensesList = ToolLicenseType.values;
  var licensesUseList = ToolLicenseUseType.values;

  ToolLicenseType? _selectedLicenseType;
  ToolLicenseUseType? _selectedLicenseUseType;

  void _generateOutput() {

    final name = _nameController.text;
    var folderName = _folderController.text;
    final description = _descriptionController.text;
    final searchStringEN = _searchStringControllerEN.text.toLowerCase();
    final searchStringCOM = _searchStringControllerCOM.text.toLowerCase();
    final licenseInfo = {
      'type': _selectedLicenseType?.toString(),
      'author': _authorController.text,
      'title': _titleController.text,
      'sourceUrl': "https://${_sourceURLController.text}",
      'useType': _selectedLicenseUseType?.toString(),
      'customComment': _customCommentController.text,
    };

    setState(() {
      folderName = folderName.isEmpty ? toSnakeCase(name) : folderName;

      _output = '''
// 1. Create a New Directory for Symbol Table Assets
//    Path: lib/tools/symbol_tables/_common/assets/
//     Structure:
//      - Create a subdirectory: lib/tools/symbol_tables/_common/assets/$folderName/
//      - Place the zip file with symbol assets in this directory.
//      - Include a logo.png file in the same directory.
// ----------------------------------------------


// 2. Add Symbol Table to the pubspec.yaml File
//    File: pubspec.yaml
// ----------------------------------------------
// assets:
/* 
    - lib/tools/symbol_tables/_common/assets/$folderName/
*/


// 3. Integrate Symbol Table into English Language File
//    File: lib/application/i18n/assets/en.json
// ----------------------------------------------
/*
  "symboltables_${folderName}_title": "$name",
  "symboltables_${folderName}_description": "$description",
*/


// 4. Add Search Strings
//    The search strings are located in the files common.json and en.json within lib/application/searchstrings/assets/.
//    common.json contains general, language-independent search strings.
//    en.json contains only English-specific search strings. Other translations will be added later via Crowdin.
//
//    File: lib/application/searchstrings/assets/en.json
// ----------------------------------------------
/*
  "symbol_$folderName": "$searchStringEN",
*/

//    File: lib/application/searchstrings/assets/common.json
//    ----------------------------------------------
/*
  "symbol_$folderName": "$searchStringCOM",
*/


// 5. Register the Symbol Table Language File
//     Delete 
//     Purpose: Ensure the symbol table is recognized in the app.
//
//     File: lib/application/registry.dart
//    
// ----------------------------------------------
/*
  GCWSymbolTableTool(symbolKey: '$folderName', symbolSearchStrings: const [
    'symbol_$folderName',
  ], licenses: [
    ToolLicenseOnlineArticle(
        context: context,
        author: '${licenseInfo["author"]}',
        title: '${licenseInfo["title"]}',
        sourceUrl: '${licenseInfo["sourceUrl"]}',
        licenseType: ${licenseInfo["type"]}(
        customComment: '${licenseInfo["customComment"]}'),
  ]),
*/
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symbol Table Configuration Files Helper'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name of table'),
                ),
                TextFormField(
                  controller: _folderController,
                  decoration: const InputDecoration(labelText: 'Folder name'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Short description'),
                ),
                TextFormField(
                  controller: _searchStringControllerEN,
                  decoration: const InputDecoration(labelText: 'Search strings EN'),
                ),
                TextFormField(
                  controller: _searchStringControllerCOM,
                  decoration: const InputDecoration(labelText: 'Search strings COMMON'),
                ),
                const Divider(),
                const Text("License Information", style: TextStyle(fontWeight: FontWeight.bold)),

                DropdownButtonFormField<ToolLicenseType>(
                  value: _selectedLicenseType,
                  decoration: InputDecoration(
                    labelText: 'License Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: licensesList.map((ToolLicenseType license) {
                    return DropdownMenuItem<ToolLicenseType>(
                      value: license,
                      child: Text(license.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (ToolLicenseType? newValue) {
                    setState(() {
                      _selectedLicenseType = newValue;
                    });
                  },
                ),

                DropdownButtonFormField<ToolLicenseUseType>(
                  value: _selectedLicenseUseType,
                  decoration: InputDecoration(
                    labelText: 'License Use Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: licensesUseList.map((ToolLicenseUseType license) {
                    return DropdownMenuItem<ToolLicenseUseType>(
                      value: license,
                      child: Text(license.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (ToolLicenseUseType? newValue) {
                    setState(() {
                      _selectedLicenseUseType = newValue;
                    });
                  },
                ),

                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(labelText: 'Author'),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  controller: _sourceURLController,
                  decoration: const InputDecoration(labelText: 'Source URL (without https://)'),
                ),
                TextFormField(
                  controller: _customCommentController,
                  decoration: const InputDecoration(labelText: 'Custom Comment (e.g., CCA 4.0)'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _generateOutput,
                  child: const Text('Generate Configuration'),
                ),
                const SizedBox(height: 20),
                if (_output.isNotEmpty)
                  const Text("Generated Configuration:\n", style: TextStyle(fontWeight: FontWeight.bold)),
                SelectableText(_output),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
