import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pet_adoption_admin_web/utils/extensions.dart';
import 'package:stacked/stacked.dart';

import 'approve_adoption_viewmodel.dart';

const double _photoSize = 100;

class ApproveAdoptionView extends StatelessWidget {
  const ApproveAdoptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ApproveAdoptionViewModel>.reactive(
      viewModelBuilder: () => ApproveAdoptionViewModel(),
      builder: (context, viewModel, child) {
        final adoptions = viewModel.getNotApprovedAdoptions();
        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            itemBuilder: (context, index) {
              final currentAdoption = adoptions.elementAt(index);

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          _AdoptionPhoto(
                            photoUrl: viewModel.getPhotoUrl(index),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentAdoption.animalName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      currentAdoption.animalType
                                          .getAnimalTypeName()
                                          .capitalizeFirstLetter(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      ' · ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      currentAdoption.genderType
                                          .getAnimalGenderName()
                                          .capitalizeFirstLetter(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Text(
                                      ' · ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      currentAdoption.animalAge
                                          .getAnimalAgeText(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  currentAdoption.description,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          _RoundedButton(
                            approve: true,
                            onTap: () => viewModel.onApprove(currentAdoption),
                          ),
                          const SizedBox(width: 5),
                          _RoundedButton(
                            approve: false,
                            onTap: () =>
                                viewModel.onRemove(currentAdoption.adoptionId),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: adoptions.length,
          ),
        );
      },
    );
  }
}

class _AdoptionPhoto extends StatelessWidget {
  const _AdoptionPhoto({
    Key? key,
    required this.photoUrl,
  }) : super(key: key);

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_photoSize),
        child: Image.network(
          photoUrl,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          width: _photoSize,
          height: _photoSize,
          fit: BoxFit.fill,
          errorBuilder: (_, __, error) {
            log(error.toString());
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _RoundedButton extends StatelessWidget {
  const _RoundedButton({
    Key? key,
    required this.approve,
    required this.onTap,
  }) : super(key: key);

  final bool approve;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = approve ? Colors.green : Colors.red;
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(_photoSize),
      hoverColor: theme.iconTheme.color!.withOpacity(0.5),
      splashColor: theme.iconTheme.color!.withOpacity(0.6),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: buttonColor.withOpacity(0.8),
          border: Border.all(color: buttonColor),
        ),
        child: Icon(
          approve ? Icons.check : Icons.delete,
          color: theme.scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
