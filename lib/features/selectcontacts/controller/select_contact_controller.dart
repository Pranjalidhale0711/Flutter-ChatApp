import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:riverpod/riverpod.dart';
import 'package:whatsapp/features/selectcontacts/Repository/select_contact_repository.dart';

final getcontactprovider = FutureProvider((ref) {
  final selectcontactRepository = ref.watch(Selectcontactrepositoryprovider);
  return selectcontactRepository.getcontacts();
});


final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(Selectcontactrepositoryprovider);
  return SelectContactController(
    ref: ref,
    selectContactRepository: selectContactRepository,
  );
});

class SelectContactController {
  final ProviderRef ref;
  final SelectcontactRepository selectContactRepository;
  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactRepository.Selectcontact(selectedContact, context);
  }
}