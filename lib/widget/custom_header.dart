import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Stack(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('http://10.0.2.2/img/image1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            // ignore: deprecated_member_use
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.search, color: Colors.grey, size: 22),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  'ملابس رجالي و ستاتي ',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.grey,
                                size: 22,
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.mail_outline, color: Colors.white, size: 28),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(Icons.menu, color: Colors.white, size: 30),
                      SizedBox(width: 15),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildCategoryItem("kids"),
                              _buildCategoryItem("shoes"),
                              _buildCategoryItem("electronics"),
                              _buildCategoryItem("woman"),
                              _buildCategoryItem("men"),
                              _buildCategoryItem("men"),
                              _buildCategoryItem("all", isSelected: true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildPromoCard(
                  imageUrl: 'http://10.0.2.2/img/image1.jpg',
                  price: '\$20.60',
                ),
                SizedBox(width: 10),
                _buildPromoCard(
                  imageUrl: 'http://10.0.2.2/img/image1.jpg',
                  price: '\$13.60',
                ),

                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.purpleAccent,
                      child: Text(
                        'Trends',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '@ChicAutumn#',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black45,
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildPromoCard({required String imageUrl, required String price}) {
    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
              ),
              child: Text(
                price,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
