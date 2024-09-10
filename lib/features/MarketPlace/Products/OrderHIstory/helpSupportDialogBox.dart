import 'package:flutter/material.dart';

void showContactSupportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // For alignment, as we don't need a back button
                  Text(
                    'Thank you for ordering from us!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'In case of any concern, please email us at:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // This can open email client or copy to clipboard
                  // For example, you can use the url_launcher package to open email:
                  // launch('mailto:info@muscleblaze.com');
                },
                child: Text(
                  'support@conquest.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    //decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  foregroundColor: Colors.yellow[700], // Set button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:  Text('OK',style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white),),
              ),
            ],
          ),
        ),
      );
    },
  );
}
