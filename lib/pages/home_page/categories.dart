import 'package:buy_and_sell_used_stuff_mobile_application/pages/home_page/category_products_page.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/colors.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/utils/dimensions.dart';
import 'package:buy_and_sell_used_stuff_mobile_application/widgets/big_text.dart';
import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final String imagePath;

  CategoryItem({required this.name, required this.imagePath});
}

class Categories extends StatelessWidget {
  final List<CategoryItem> categories = [
    CategoryItem(name: "آشپزخانه", imagePath: "assets/image/kitchen.jpg"),
    CategoryItem(name: "لوازم برقی", imagePath: "assets/image/electronics.jpg"),
    CategoryItem(name: "لوازم خانه", imagePath: "assets/image/home.jpg"),
    CategoryItem(name: "پوشاک", imagePath: "assets/image/clothes.jpg"),
    CategoryItem(name: "حمل و نقل", imagePath: "assets/image/car.jpg"),
    CategoryItem(name: "کامپیوتر", imagePath: "assets/image/computer.jpg"),
    CategoryItem(name: "مبایل", imagePath: "assets/image/mobile.jpg"),
  ];

  Categories({super.key});

  void _onCategoryTap(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProductsPage(
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: avgDimension(180),
          child: Card(
            color: AppColors.mainColor,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: avgDimension(5), // فاصله متن کتگوری از بالا
                    right: avgDimension(0),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              right: avgDimension(10),
                            ),
                            child: TitleText(
                              text: "کتگوری ها",
                              fontSize: avgDimension(25),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: avgDimension(120), // ارتفاع پس زمینه تصویر و متن
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      var categoryItem = categories[index];
                      return GestureDetector(
                        onTap: () => _onCategoryTap(
                          context,
                          categoryItem.name,
                        ),
                        child: Container(
                          height: avgDimension(90),
                          width: avgDimension(90),
                          margin: EdgeInsets.all(
                            avgDimension(5),
                          ),
                          // width: avgDimension(120),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    avgDimension(50),
                                  ),
                                  child: Image.asset(
                                    categoryItem.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: avgDimension(5),
                              ),
                              Text(
                                categoryItem.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: avgDimension(14),
                                ),
                                textAlign: TextAlign.center,
                              ),
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
        ),
      ],
    );
  }
}
