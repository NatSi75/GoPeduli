import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'user_authentication/login_screen.dart';
import 'user_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Removed redundant fetchUserData call to rely on user data set after login
  }

  Widget buildProfileHeader() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        String defaultImage;

        // Always use local default image based on gender, ignore profilePicture
        switch (userProvider.gender.toLowerCase().trim()) {
          case 'female':
            defaultImage = 'assets/images/default_female.png';
            break;
          case 'male':
            defaultImage = 'assets/images/default_male.png';
            break;
          default:
            defaultImage = 'assets/images/default_person.png';
        }

        return Container(
          decoration: const BoxDecoration(color: Color(0xFF119C8E)),
          padding: const EdgeInsets.only(top: 36, bottom: 25),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(255, 10, 97, 89)
                        // ignore: deprecated_member_use
                        .withOpacity(0.7),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage(defaultImage),
                    )),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProvider.userName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      userProvider.role[0].toUpperCase() +
                          userProvider.role.substring(1),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            leading: Icon(icon, color: iconColor ?? const Color(0xFF119C8E)),
            title: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: onTap,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(height: 4, thickness: 1),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF119C8E),
      body: Column(
        children: [
          buildProfileHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 20),
                children: [
                  buildMenuItem(
                    icon: Icons.person_outline,
                    text: 'User Details',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UserDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  buildMenuItem(
                    icon: Icons.credit_card,
                    text: 'Payment Method',
                    onTap: () {},
                  ),
                  buildMenuItem(
                    icon: Icons.chat_bubble_outline,
                    text: 'FAQs',
                    onTap: () {},
                  ),
                  buildMenuItem(
                    icon: Icons.logout,
                    text: 'Logout',
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Provider.of<UserProvider>(context, listen: false)
                          .setUserData(
                        userName: "Guest",
                        userEmail: "",
                        gender: "male",
                        role: "Patient",
                        profilePicture: "",
                      );
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    iconColor: Colors.red,
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
