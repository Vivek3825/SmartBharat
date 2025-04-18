import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/localized_text.dart';
import 'providers/language_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Custom color palette (matching your home.dart)
  final Color primaryColor = Color(0xFF3E8E41); // Earthy Green
  final Color secondaryColor = Color(0xFFF4A300); // Golden Yellow
  final Color accentColor = Color(0xFFD94F30); // Brick Orange
  final Color successColor = Color(0xFF2E7D32); // Deep Green
  final Color warningColor = Color(0xFFF9B233); // Bright Yellow
  final Color errorColor = Color(0xFFC62828); // Deep Red
  final Color backgroundColor = Color(0xFFFFF8E1); // Creamy Beige
  final Color cardColor = Color(0xFFFFFFFF); // White
  final Color textPrimary = Color(0xFF212121); // Charcoal Black
  final Color textSecondary = Color(0xFF616161); // Muted Gray
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final bool isTamil = languageProvider.currentLanguageIndex == 3;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: LocalizedText(
          translationKey: 'profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header with Avatar
            _buildProfileHeader(isTamil, screenWidth),
            
            // Main Content Sections
            Padding(
              padding: EdgeInsets.all(isTamil ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Applied Schemes Section
                  _buildSectionHeader('appliedSchemes', Icons.check_circle_outline),
                  _buildSchemesSection(true, isTamil, screenWidth),
                  
                  SizedBox(height: isTamil ? 20 : 24),
                  
                  // Cancelled Schemes Section
                  _buildSectionHeader('cancelledSchemes', Icons.cancel_outlined),
                  _buildSchemesSection(false, isTamil, screenWidth),
                  
                  SizedBox(height: isTamil ? 20 : 24),
                  
                  // Security Section
                  _buildSectionHeader('security', Icons.security),
                  _buildSecuritySection(isTamil, screenWidth),
                  
                  SizedBox(height: isTamil ? 20 : 24),
                  
                  // Feedback Section
                  _buildSectionHeader('feedback', Icons.feedback),
                  _buildFeedbackSection(isTamil, screenWidth),
                  
                  SizedBox(height: isTamil ? 20 : 24),
                  
                  // Logout Option
                  _buildLogoutButton(isTamil),
                  
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileHeader(bool isTamil, double screenWidth) {
    return Container(
      color: primaryColor,
      padding: EdgeInsets.only(
        left: 20, 
        right: 20, 
        bottom: 30,
        top: 5,
      ),
      child: Column(
        children: [
          // Profile Image with Edit Button
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: screenWidth * 0.28,
                height: screenWidth * 0.28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/profile_placeholder.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.person,
                          size: screenWidth * 0.14,
                          color: primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondaryColor,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.edit, color: Colors.white, size: 18),
                  onPressed: () {
                    // Handle edit profile picture
                  },
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // User Name
          LocalizedText(
            translationKey: 'userName',
            style: TextStyle(
              fontSize: isTamil ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 4),
          
          // User Village
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.white.withOpacity(0.9)),
              SizedBox(width: 4),
              LocalizedText(
                translationKey: 'userVillage',
                style: TextStyle(
                  fontSize: isTamil ? 13 : 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String translationKey, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 22),
          SizedBox(width: 8),
          LocalizedText(
            translationKey: translationKey,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildSchemesSection(bool isApplied, bool isTamil, double screenWidth) {
    final List<Map<String, dynamic>> schemes = isApplied 
      ? [
          {'key': 'pmKisan', 'status': 'approved', 'date': '2023-12-10'},
          {'key': 'janDhan', 'status': 'pending', 'date': '2024-01-15'},
          {'key': 'ayushman', 'status': 'approved', 'date': '2023-08-22'},
        ]
      : [
          {'key': 'skillIndia', 'status': 'rejected', 'date': '2023-07-05'},
          {'key': 'mudraLoan', 'status': 'withdrawn', 'date': '2023-05-18'},
        ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: schemes.map((scheme) {
          Color statusColor;
          IconData statusIcon;
          
          switch(scheme['status']) {
            case 'approved':
              statusColor = successColor;
              statusIcon = Icons.check_circle;
              break;
            case 'pending':
              statusColor = warningColor;
              statusIcon = Icons.access_time;
              break;
            case 'rejected':
              statusColor = errorColor;
              statusIcon = Icons.cancel;
              break;
            case 'withdrawn':
              statusColor = textSecondary;
              statusIcon = Icons.remove_circle;
              break;
            default:
              statusColor = textSecondary;
              statusIcon = Icons.help;
          }
          
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withOpacity(0.1),
                      ),
                      child: Icon(statusIcon, color: statusColor, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LocalizedText(
                            translationKey: scheme['key'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              LocalizedText(
                                translationKey: scheme['status'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                ' • ${scheme['date']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14, color: textSecondary),
                  ],
                ),
              ),
              if (schemes.last != scheme) Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSecuritySection(bool isTamil, double screenWidth) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSettingItem('changePin', Icons.lock_outline, primaryColor),
          Divider(height: 1),
          _buildSettingItem('biometrics', Icons.fingerprint, primaryColor),
          Divider(height: 1),
          _buildSettingItem('deviceManagement', Icons.devices, primaryColor),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(bool isTamil, double screenWidth) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSettingItem('rateSuggestions', Icons.star_outline, accentColor),
          Divider(height: 1),
          _buildSettingItem('reportIssue', Icons.warning_amber_outlined, accentColor),
          Divider(height: 1),
          _buildSettingItem('voiceFeedback', Icons.mic_none, accentColor),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String translationKey, IconData icon, Color iconColor) {
    return InkWell(
      onTap: () {
        // Handle setting tap
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            SizedBox(width: 16),
            Expanded(
              child: LocalizedText(
                translationKey: translationKey,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: textSecondary),
          ],
        ),
      ),
    );
  }
  
  // New Logout Button
  Widget _buildLogoutButton(bool isTamil) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: LocalizedText(
                translationKey: 'logoutConfirmTitle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: LocalizedText(
                translationKey: 'logoutConfirmMessage',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.left,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: LocalizedText(
                    translationKey: 'cancel',
                    style: TextStyle(color: textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Perform logout actions
                    Navigator.of(context).pop(); // Go back to home page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: errorColor,
                  ),
                  child: LocalizedText(
                    translationKey: 'logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.logout, color: errorColor, size: 24),
              SizedBox(width: 16),
              Expanded(
                child: LocalizedText(
                  translationKey: 'logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: errorColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}