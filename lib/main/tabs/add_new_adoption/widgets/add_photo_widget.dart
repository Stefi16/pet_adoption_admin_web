import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../add_new_adoption_viewmodel.dart';

const double _photoSize = 130;

class AddPhotoWidget extends ViewModelWidget<AddNewAdoptionViewModel> {
  const AddPhotoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, AddNewAdoptionViewModel viewModel) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => viewModel.uploadPhoto(),
      behavior: HitTestBehavior.translucent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_photoSize),
        child: Image.memory(
          viewModel.chosenPhoto,
          fit: BoxFit.fitHeight,
          errorBuilder: (_, __, ___) => Container(
            width: _photoSize,
            height: _photoSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primaryColor,
            ),
            child: Center(
              child: Icon(
                Icons.add_a_photo_outlined,
                color: theme.scaffoldBackgroundColor,
                size: _photoSize / 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
