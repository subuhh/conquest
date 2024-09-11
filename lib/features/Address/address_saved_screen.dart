import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';

class SavedAddress extends StatefulWidget {
  const SavedAddress({super.key});

  @override
  State<SavedAddress> createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'My Addresses',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(
                Icons.add,
                color: Colors.green,
                size: 24,
                weight: 4,
              ),
              title: Text(
                'Add Address',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.green,
                    ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: Divider()),
                const SizedBox(width: 10),
                Text(
                  ' SAVED ADDRESSES ',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.9)),
                ),
                const SizedBox(width: 10),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    tileColor: Colors.white,
                    leading: const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Iconsax.home),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    title: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Home'),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.more_horiz,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              child: SvgPicture.asset(
                                  'assets/icons/appicons/share.svg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: const Flexible(
                      child: Column(
                        children: [
                          Text(
                              '156/35, Neerav Nikunj, Sikandra, Agra, in fornt of kk bar, Agra, Uttar Pradesh, 282007'),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container customAddressTile({
    required IconData icon,
    required String title,
    required String subTitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading Icon on top
          Icon(
            icon, // Adjust the icon size if necessary
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(height: 8), // Spacing between icon and text

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8), // Spacing between title and subtitle

          // Subtitle
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12), // Spacing between subtitle and icons

          // Row with two icons below the subtitle
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  // Add functionality for first icon
                },
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Add functionality for second icon
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
