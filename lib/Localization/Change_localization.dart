import 'package:comeback/Localization/Cubit/Locale_State.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubit/Locale_Cubit.dart';
import 'AppLocalizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          actions: [
            Icon(Icons.settings,size: 30,color: Colors.white)
          ],
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocConsumer<Locale_cubit, ChangedLocalState>(
                listener: (context, state) {
                  Navigator.of(context).pop();
                },
                builder: (context, state) {
                  return DropdownButton<String>(
                    value: state.locale,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: ['ar', 'en'].map((String items) {
                      return DropdownMenuItem<String>(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        context.read<Locale_cubit>().changelanguage(newValue);
                      }
                    },
                  );
                },
              )),
        ),
      ),
    );
  }
}