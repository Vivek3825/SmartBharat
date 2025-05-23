import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'widgets/localized_text.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isListening = false;
  
  // Alert banner variables
  int _currentAlertIndex = 0;
  final List<String> _alertKeys = ['healthAlert1', 'healthAlert2', 'healthAlert3', 'healthAlert4'];
  Timer? _alertTimer;
  final PageController _alertController = PageController();

  // Custom color palette
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
  void initState() {
    super.initState();
    // Start the alert rotation timer
    _startAlertRotation();
  }
  
  @override
  void dispose() {
    // Cancel timer when widget is disposed
    _alertTimer?.cancel();
    _alertController.dispose();
    super.dispose();
  }
  
  // Method to start rotating alerts
  void _startAlertRotation() {
    _alertTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentAlertIndex < _alertKeys.length - 1) {
        _currentAlertIndex++;
      } else {
        _currentAlertIndex = 0;
      }
      
      if (_alertController.hasClients) {
        _alertController.animateToPage(
          _currentAlertIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Show language selection menu
  void _showLanguageMenu(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<int>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      items: languageProvider.languages.asMap().entries.map((entry) {
        return PopupMenuItem<int>(
          value: entry.key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.value['code'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: languageProvider.currentLanguageIndex == entry.key ? primaryColor : textPrimary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                entry.value['name'],
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
              if (languageProvider.currentLanguageIndex == entry.key)
                Icon(
                  Icons.check_circle,
                  color: primaryColor,
                  size: 18,
                ),
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        languageProvider.setLanguage(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final bool isTamil = languageProvider.currentLanguageIndex == 3;
    final bool isSmallScreen = screenWidth < 360;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: primaryColor,
          elevation: 2,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  // Profile Icon - slightly reduced size with navigation
                  CircleAvatar(
                    radius: isSmallScreen ? 22 : 24,
                    backgroundColor: Color(0xFF2D6E30),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilePage(key: Key('profile_page'))),
                        );
                      },
                      child: Icon(
                        Icons.person, 
                        color: Colors.white, 
                        size: isSmallScreen ? 28 : 30
                      ),
                    ),
                  ),

                  // App Title - using expanded to take available space
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LocalizedText(
                            translationKey: 'appTitle',
                            style: TextStyle(
                              fontSize: screenWidth < 360 ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2),
                          LocalizedText(
                            translationKey: 'appSubtitle',
                            style: TextStyle(
                              fontSize: screenWidth < 360 ? 10 : 11,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Language selector
                  Builder(
                    builder: (context) => Container(
                      width: screenWidth < 360 ? 60 : 65, // Slightly reduced
                      height: 32, // Reduced height
                      decoration: BoxDecoration(
                        color: Color(0xFF2D6E30),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _showLanguageMenu(context),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2), // Reduced padding
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Fixed width container for text to prevent overflow
                                Container(
                                  width: screenWidth < 360 ? 30 : 35,
                                  alignment: Alignment.center,
                                  child: Text(
                                    languageProvider.currentLanguageDisplay,
                                    style: TextStyle(
                                      fontSize: 11, // Smaller font
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis, // Add ellipsis
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 12,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Replace the existing alert banner with the new sliding version
          _buildSlidingAlertBanner(isTamil, screenWidth, languageProvider),

          // Main content area with scroll view
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isTamil ? 14 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message with responsive sizing
                  LocalizedText(
                    translationKey: 'greeting',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 22 : 24,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  LocalizedText(
                    translationKey: 'helpPrompt',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 15 : 16,
                      color: textSecondary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Voice Assistant Section
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor.withOpacity(0.9), primaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        LocalizedText(
                          translationKey: _isListening ? 'listening' : 'tapToSpeak',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth < 360 ? 16 : 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isListening = !_isListening;
                            });
                          },
                          child: Container(
                            height: screenWidth < 360 ? 80 : 90,
                            width: screenWidth < 360 ? 80 : 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              size: screenWidth < 360 ? 40 : 45,
                              color: _isListening ? accentColor : textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Quick Actions
                  LocalizedText(
                    translationKey: 'quickActions',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickAction(
                        Icons.local_hospital_outlined, 
                        'nearbyHospitals',
                        successColor,
                        screenWidth
                      ),
                      _buildQuickAction(
                        Icons.agriculture_outlined,
                        'cropPrices',
                        primaryColor,
                        screenWidth
                      ),
                      _buildQuickAction(
                        Icons.newspaper_outlined, 
                        'newsUpdates',
                        accentColor,
                        screenWidth
                      ),
                      _buildQuickAction(
                        Icons.help_outline_rounded, 
                        'helpCenter',
                        secondaryColor,
                        screenWidth
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  // App Logo
                ],
              ),
            ),
          ),

          // Bottom Navigation
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                BoxShadow(color: Colors.black12, offset: Offset(0, -1), blurRadius: 5),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Use spaceAround 
                children: [
                  _buildTab(
                    Icons.local_hospital_rounded,
                    'healthTab',
                    0,
                    successColor,
                    screenWidth
                  ),
                  _buildTab(
                    Icons.account_balance_rounded,
                    'schemesTab',
                    1,
                    secondaryColor,
                    screenWidth
                  ),
                  _buildTab(
                    Icons.cloud_rounded,
                    'weatherTab',
                    2,
                    Color(0xFF1976D2),
                    screenWidth
                  ),
                  _buildTab(
                    Icons.folder_shared_rounded,
                    'digilockerTab',
                    3,
                    accentColor,
                    screenWidth
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String translationKey, int index, Color tabColor, double screenWidth) {
    final isSelected = _selectedIndex == index;
    final useCompactLayout = screenWidth < 360;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final bool isTamil = languageProvider.currentLanguageIndex == 3;
    
    // More flexible width calculation
    final double tabWidth = screenWidth / 4;
    
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? tabColor.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(
            vertical: useCompactLayout || isTamil ? 4 : 6
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? tabColor : textSecondary,
                size: useCompactLayout || isTamil ? 20 : 22,
              ),
              SizedBox(height: 2), // Reduced for more text space
              // More flexible text container
              Container(
                constraints: BoxConstraints(maxWidth: tabWidth - 10),
                child: LocalizedText(
                  translationKey: translationKey,
                  style: TextStyle(
                    color: isSelected ? tabColor : textSecondary,
                    fontSize: isTamil ? 8 : 9, // Even smaller for Tamil
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
                  adaptSize: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String translationKey, Color color, double screenWidth) {
    final useCompactLayout = screenWidth < 360;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final bool isTamil = languageProvider.currentLanguageIndex == 3;
    
    return Column(
      children: [
        Container(
          height: useCompactLayout || isTamil ? 54 : 60,
          width: useCompactLayout || isTamil ? 54 : 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: color, size: useCompactLayout || isTamil ? 26 : 30),
        ),
        SizedBox(height: isTamil ? 4 : 6), // Reduced spacing
        Container(
          width: screenWidth / 4 - 8, // More dynamic width
          constraints: BoxConstraints(maxHeight: 40), // Maximum height
          alignment: Alignment.center,
          child: LocalizedText(
            translationKey: translationKey,
            style: TextStyle(
              fontSize: isTamil ? 9 : 10, // Smaller font for Tamil
              color: textPrimary,
            ),
            maxLines: 2,
            adaptSize: true, // Use our enhanced text adaptation
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSlidingAlertBanner(bool isTamil, double screenWidth, LanguageProvider languageProvider) {
    return Container(
      width: double.infinity,
      // Make height adaptive based on language
      height: isTamil ? 85 : 75, // Increased height for Tamil
      decoration: BoxDecoration(
        color: warningColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: warningColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _alertController,
              onPageChanged: (index) {
                setState(() {
                  _currentAlertIndex = index;
                });
              },
              itemCount: _alertKeys.length,
              itemBuilder: (context, index) {
                // Get appropriate icon for each alert
                IconData alertIcon;
                switch(index) {
                  case 0:
                    alertIcon = Icons.local_hospital;
                    break;
                  case 1:
                    alertIcon = Icons.agriculture;
                    break;
                  case 2:
                    alertIcon = Icons.badge;
                    break;
                  case 3:
                    alertIcon = Icons.pets;
                    break;
                  default:
                    alertIcon = Icons.notifications;
                }
                
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16, 
                    vertical: 10
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Changed to start alignment
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 12, top: 2), // Added top margin
                        decoration: BoxDecoration(
                          color: warningColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: warningColor.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          alertIcon,
                          color: warningColor, 
                          size: 20,
                        ),
                      ),
                      // Expanded text container with better overflow handling
                      Expanded(
                        child: LocalizedText(
                          translationKey: _alertKeys[index],
                          style: TextStyle(
                            fontSize: isTamil ? 12 : 13,
                            color: textPrimary,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            height: 1.3,
                          ),
                          maxLines: 3, // Allow more lines for all languages
                          adaptSize: true, // Use our enhanced LocalizedText with size adaptation
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      // Icon with flexibility
                      Container(
                        margin: EdgeInsets.only(left: 4, top: 2),
                        child: Icon(
                          Icons.chevron_right,
                          color: warningColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Page indicator with reduced height
          Container(
            height: 8,
            padding: EdgeInsets.only(bottom: 2),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _alertKeys.length,
                (i) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  width: i == _currentAlertIndex ? 16 : 5,
                  height: 4, // Reduced height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: i == _currentAlertIndex
                      ? warningColor
                      : warningColor.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


