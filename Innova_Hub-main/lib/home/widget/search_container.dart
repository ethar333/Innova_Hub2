
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Constant.mainColor,
        borderRadius:
            BorderRadius.only(bottomRight: Radius.circular(60)),
      ),
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Search by name..",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Added Expanded here
                  child: SizedBox(
                    height: 30,
                    child: TextField(
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                            color: Colors.grey), // Hint text color
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.grey), // Icon color
                        filled: true,
                        fillColor:
                            Colors.white, // TextField background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none, // Remove border
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Range From",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(width: 45),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: TextField(
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          color: Colors.grey), // Hint text color
                      // Icon color
                      filled: true,
                      fillColor:
                          Colors.white, // TextField background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none, // Remove border
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  "to",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: TextField(
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          color: Colors.grey), // Hint text color
                      // Icon color
                      filled: true,
                      fillColor:
                          Colors.white, // TextField background color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none, // Remove border
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  "Search by location..",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Added Expanded here
                  child: SizedBox(
                    height: 30,
                    child: TextField(
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                            color: Colors.grey), // Hint text color
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.grey), // Icon color
                        filled: true,
                        fillColor:
                            Colors.white, // TextField background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none, // Remove border
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


