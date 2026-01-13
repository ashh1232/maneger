import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  static const String _title =
      'MAANGE 1/2/4/5/7Pcs Professional Facial Makeup Brushes,Bevel&Taper Foundation Brush Contour Brush Powder Brush Eyeshadow Brush Concealer Brush,Makeup Tools With Soft Fiber For Easy To Carrying,Brush For Travel,Gift For Women&Girls,Brush Set,Makeup Brush Kit,Make Up Brush Set,Make Up Set Complete,Makeup Brush Set,Complete Makeup Kit,Brush Kit,Brushes Makeup Set,Makeup Gift Set,Set | SHEIN';

  static const String _description =
      'To find out about the MAANGE makeup brush set and shop online.\nThis view is a converted representation of the original HTML file and includes sample images and meta details.';

  static const List<String> _images = [
    'https://img.ltwebstatic.com/images3_spmp/2024/12/18/5f/173450380855aa9898441974be73217ed64ac794e0_thumbnail_405x552.webp',
    'https://via.placeholder.com/640x400.png?text=Product+Image+1',
    'https://via.placeholder.com/640x400.png?text=Product+Image+2',
  ];

  static const Map<String, String> _meta = {
    'theme-color': '#FFFFFE',
    'lang': 'en',
    'canonical': 'https://www.shein.com/...',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodo — Converted Page')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Image carousel
              SizedBox(
                height: 320,
                child: PageView.builder(
                  itemCount: _images.length,
                  itemBuilder:
                      (context, index) => _networkImage(_images[index]),
                ),
              ),

              const SizedBox(height: 12),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(_description),

              const SizedBox(height: 16),
              Text('Meta', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              ..._meta.entries.map((e) => _metaRow(e.key, e.value)),

              const SizedBox(height: 16),
              Text('Notes', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              const Text(
                'This page is a simplified Flutter conversion of the provided HTML. Replace the placeholder images and meta values with the real data or wire it to your backend as needed.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _networkImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
              ),
            ),
      ),
    );
  }

  Widget _metaRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$key: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
