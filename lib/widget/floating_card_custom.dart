import 'package:flutter/material.dart';

class CustomFloatingCard extends StatelessWidget {
  final String? profileImage;
  final String? name;
  final String? rate;
  final String? status;
  final String? description;
  final VoidCallback? onButtonTap;
  final String buttonLabel;

  const CustomFloatingCard({
    Key? key,
    this.profileImage,
    this.name,
    this.rate,
    this.status,
    this.description,
    this.onButtonTap,
    this.buttonLabel = 'Chat',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: 55),
      padding: const EdgeInsets.only(left: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.green, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 80.0,
          width: width , // Adjust width based on screen size
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Profile Image
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    backgroundImage: profileImage != null
                        ? NetworkImage(profileImage!)
                        : const AssetImage('assets/default_profile.png')
                    as ImageProvider,
                  ),
                ),
              ),
SizedBox(width:10),
              /// Content
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (name != null)
                      Text(
                        name!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        if (rate != null)
                          Text(
                            "\u{20B9}$rate /min.",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        const SizedBox(width: 5),
                        if (status != null)
                          Text(
                            "($status)",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    if (description != null)
                      Text(
                        description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),

              /// Action Button
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: onButtonTap,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      buttonLabel,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,)
            ],
          ),
        ),
      ),
    );
  }
}
