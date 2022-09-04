import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zanalys/upload_document/upload_document.dart';

import 'upload_document_picker_bottomsheet.dart';

class UploadDocumentBody extends StatefulWidget {
  const UploadDocumentBody({Key? key}) : super(key: key);

  @override
  State<UploadDocumentBody> createState() => _UploadDocumentBodyState();
}

class _UploadDocumentBodyState extends State<UploadDocumentBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          Text(
            context.l10n.upload_document_title,
            // style: TextStyle(
            //     fontSize: 26,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.textBlack),
          ),
          const SizedBox(height: 40),
          BasicTextField(
              initialValue:
                  context.read<UploadDocumentBloc>().state.accessCode.value,
              labelText: context.l10n.upload_document_hint_access_code,
              onChanged: (code) {
                context.read<UploadDocumentBloc>().accessCodeUpdated(code);
              }),
          const SizedBox(height: 34),
          const _UploadButton(),
        ],
      ),
    );
  }

  _inputFolderId(BuildContext context) {}
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({
    Key? key,
  }) : super(key: key);

  void _onUploadDocumentPressed(BuildContext context, UploadDocumentBloc bloc,) {
        context.read<UploadDocumentBloc>().documentSelected(pickedFile.path);
    _showSourceSelectionSheet(context);
    
      final pickedFile = await ImagePicker().pickImage(source: source);
    
      }
    }
  }

  void _showSourceSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return UploadDocumentPickerBottomSheet(
          onSelected: (source) => _pickImage(context, source),
        );
      },
    );
  }

  void _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      context.read<UploadDocumentBloc>().documentSelected(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onUploadDocumentPressed,
      child: Text(context.l10n.upload_document_button),
    );
  }
}