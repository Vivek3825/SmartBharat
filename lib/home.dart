import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isListening = false;
  bool _isLanguageMenuOpen = false;

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

  // Language selector variables
  int _currentLanguageIndex = 0;
  List<Map<String, dynamic>> _languages = [
    {'code': 'हिंदी', 'name': 'Hindi'},
    {'code': 'ENG', 'name': 'English'},
    {'code': 'मराठी', 'name': 'Marathi'},
    {'code': 'தமிழ்', 'name': 'Tamil'},
    {'code': 'తెలుగు', 'name': 'Telugu'},
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void _showLanguageMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    setState(() {
      _isLanguageMenuOpen = true;
    });

    showMenu<int>(
      context: context,
      position: position,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      items: _languages.asMap().entries.map((entry) {
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
                  color: _currentLanguageIndex == entry.key ? primaryColor : textPrimary,
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
              if (_currentLanguageIndex == entry.key)
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
      setState(() {
        _isLanguageMenuOpen = false;
        if (value != null) {
          _currentLanguageIndex = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    
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
              // Reduced horizontal padding for smaller screens
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  // Profile Icon - slightly reduced size
                  CircleAvatar(
                    radius: screenWidth < 360 ? 22 : 24, // Smaller on very small devices
                    backgroundColor: Color(0xFF2D6E30),
                    child: Icon(
                      Icons.person, 
                      color: Colors.white, 
                      size: screenWidth < 360 ? 28 : 30
                    ),
                  ),

                  // App Title - using expanded to take available space
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Smart Bharat',
                            style: TextStyle(
                              fontSize: screenWidth < 360 ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Digital Assistant for Rural India',
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

                  // Language Selector - with updated dropdown, slightly smaller
                  Builder(
                    builder: (context) => Container(
                      width: screenWidth < 360 ? 65 : 70,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _isLanguageMenuOpen 
                            ? Color(0xFF1F5121)
                            : Color(0xFF2D6E30),
                        borderRadius: BorderRadius.circular(20),
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
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => _showLanguageMenu(context),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: screenWidth < 360 ? 35 : 40,
                                  alignment: Alignment.center,
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 200),
                                    switchInCurve: Curves.easeInOut,
                                    switchOutCurve: Curves.easeInOut,
                                    transitionBuilder:
                                        (Widget child, Animation<double> animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                    child: Text(
                                      _languages[_currentLanguageIndex]['code'],
                                      key: ValueKey<String>(
                                          _languages[_currentLanguageIndex]['code']),
                                      style: TextStyle(
                                        fontSize: screenWidth < 360 ? 12 : 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.clip,
                                      softWrap: false,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: screenWidth < 360 ? 12 : 14,
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
          // Alerts and Updates - with responsive text sizing
          Container(
            width: double.infinity,
            color: warningColor.withOpacity(0.1),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth < 360 ? 6 : 8),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: warningColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(Icons.notifications_active, 
                          color: warningColor, size: screenWidth < 360 ? 18 : 20),
                ),
                Expanded(
                  child: Text(
                    // Change message based on selected language
                    _currentLanguageIndex == 0 ? 'आज शाम 5 बजे आपके गांव में स्वास्थ्य जांच शिविर' :
                    _currentLanguageIndex == 1 ? 'Free health checkup camp at 5pm in your village' :
                    _currentLanguageIndex == 2 ? 'आज संध्याकाळी ५ वाजता तुमच्या गावात आरोग्य शिबिर' :
                    _currentLanguageIndex == 3 ? 'இன்று மாலை 5 மணிக்கு உங்கள் கிராமத்தில் சுகாதார முகாம்' :
                    'మీ గ్రామంలో సాయంత్రం 5 గంటలకు ఆరోగ్య శిబిరం',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 13 : 14, // Slightly smaller on small screens
                      color: textPrimary,
                      fontWeight: FontWeight.w500
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Main content area with scroll view
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message with responsive sizing
                  Text(
                    _currentLanguageIndex == 0 ? 'नमस्ते, विवेक!' :
                    _currentLanguageIndex == 1 ? 'Hello, Vivek!' :
                    _currentLanguageIndex == 2 ? 'नमस्कार, विवेक!' :
                    _currentLanguageIndex == 3 ? 'வணக்கம், விவேக்!' :
                    'హలో, వివేక్!',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 22 : 24,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  Text(
                    _currentLanguageIndex == 0 ? 'आज मैं आपकी कैसे मदद कर सकता हूँ?' :
                    _currentLanguageIndex == 1 ? 'How can I help you today?' :
                    _currentLanguageIndex == 2 ? 'मी आज तुमची कशी मदत करू शकतो?' :
                    _currentLanguageIndex == 3 ? 'இன்று நான் உங்களுக்கு எப்படி உதவ முடியும்?' :
                    'నేడు నేను మీకు ఎలా సహాయం చేయగలను?',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 15 : 16,
                      color: textSecondary,
                    ),
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
                        Text(
                          _isListening ? 
                            _currentLanguageIndex == 0 ? 'सुन रहा हूँ...' :
                            _currentLanguageIndex == 1 ? 'Listening...' :
                            _currentLanguageIndex == 2 ? 'ऐकत आहे...' :
                            _currentLanguageIndex == 3 ? 'கேட்கிறேன்...' :
                            'వింటున్నాను...' :
                            _currentLanguageIndex == 0 ? 'बोलने के लिए टैप करें' :
                            _currentLanguageIndex == 1 ? 'Tap to speak' :
                            _currentLanguageIndex == 2 ? 'बोलण्यासाठी टॅप करा' :
                            _currentLanguageIndex == 3 ? 'பேச தட்டவும்' :
                            'మాట్లాడటానికి నొక్కండి',
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
                  Text(
                    _currentLanguageIndex == 0 ? 'तुरंत पहुंच' :
                    _currentLanguageIndex == 1 ? 'Quick Actions' :
                    _currentLanguageIndex == 2 ? 'त्वरित क्रिया' :
                    _currentLanguageIndex == 3 ? 'விரைவு செயல்கள்' :
                    'త్వరిత చర్యలు',
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickAction(
                        Icons.local_hospital_outlined, 
                        _currentLanguageIndex == 0 ? 'नज़दीकी\nअस्पताल' :
                        _currentLanguageIndex == 1 ? 'Nearby\nHospitals' :
                        _currentLanguageIndex == 2 ? 'जवळील\nरुग्णालये' :
                        _currentLanguageIndex == 3 ? 'அருகிலுள்ள\nமருத்துவமனைகள்' :
                        'సమీప\nఆసుపత్రులు',
                        successColor,
                        screenWidth
                      ),
                      _buildQuickAction(
                        Icons.agriculture_outlined,
                        _currentLanguageIndex == 0 ? 'फसल\nमूल्य' :
                        _currentLanguageIndex == 1 ? 'Crop\nPrices' :
                        _currentLanguageIndex == 2 ? 'पीक\nभाव' :
                        _currentLanguageIndex == 3 ? 'பயிர்\nவிலைகள்' :
                        'పంట\nధరలు',
                        primaryColor,
                        screenWidth
                      ),
                      _buildQuickAction(
                        Icons.newspaper_outlined, 
                        _currentLanguageIndex == 0 ? 'ताज़ा\nख़बरें' :
                        _currentLanguageIndex == 1 ? 'News\nUpdates' :
                        _currentLanguageIndex == 2 ? 'ताज्या\nबातम्या' :
                        _currentLanguageIndex == 3 ? 'செய்தி\nஅறிக்கைகள்' :
                        'తాజా\nవార్తలు',
                        accentColor,
                        screenWidth
                      ),
                      _buildQuickAction(
                        Icons.help_outline_rounded, 
                        _currentLanguageIndex == 0 ? 'मदद\nकैसे?' :
                        _currentLanguageIndex == 1 ? 'How to\nHelp?' :
                        _currentLanguageIndex == 2 ? 'मदत\nकशी?' :
                        _currentLanguageIndex == 3 ? 'எப்படி\nஉதவுவது?' :
                        'సహాయం\nఎలా?',
                        secondaryColor,
                        screenWidth
                      ),
                    ],
                  ),
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
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab(
                    Icons.local_hospital_rounded,
                    _currentLanguageIndex == 0 ? 'स्वास्थ्य' :
                    _currentLanguageIndex == 1 ? 'Health' :
                    _currentLanguageIndex == 2 ? 'आरोग्य' :
                    _currentLanguageIndex == 3 ? 'சுகாதாரம்' :
                    'ఆరోగ్యం',
                    0,
                    successColor,
                    screenWidth
                  ),
                  _buildTab(
                    Icons.account_balance_rounded,
                    _currentLanguageIndex == 0 ? 'योजनाएँ' :
                    _currentLanguageIndex == 1 ? 'Schemes' :
                    _currentLanguageIndex == 2 ? 'योजना' :
                    _currentLanguageIndex == 3 ? 'திட்டங்கள்' :
                    'పథకాలు',
                    1,
                    secondaryColor,
                    screenWidth
                  ),
                  _buildTab(
                    Icons.cloud_rounded,
                    _currentLanguageIndex == 0 ? 'मौसम' :
                    _currentLanguageIndex == 1 ? 'Weather' :
                    _currentLanguageIndex == 2 ? 'हवामान' :
                    _currentLanguageIndex == 3 ? 'வானிலை' :
                    'వాతావరణం',
                    2,
                    Color(0xFF1976D2),
                    screenWidth
                  ),
                  _buildTab(
                    Icons.folder_shared_rounded,
                    _currentLanguageIndex == 0 ? 'डिजिलॉकर' :
                    _currentLanguageIndex == 1 ? 'DigiLocker' :
                    _currentLanguageIndex == 2 ? 'डिजिलॉकर' :
                    _currentLanguageIndex == 3 ? 'டிஜிலாக்கர்' :
                    'డిజిలాకర్',
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

  Widget _buildTab(IconData icon, String label, int index, Color tabColor, double screenWidth) {
    final isSelected = _selectedIndex == index;
    // Shorter tab labels for small screens
    final useCompactLayout = screenWidth < 360;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: useCompactLayout ? 10 : 14, 
          vertical: useCompactLayout ? 8 : 10
        ),
        decoration: BoxDecoration(
          color: isSelected ? tabColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? tabColor : textSecondary,
              size: useCompactLayout ? 24 : 26,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? tabColor : textSecondary,
                fontSize: useCompactLayout ? 11 : 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, double screenWidth) {
    final useCompactLayout = screenWidth < 360;
    
    return Column(
      children: [
        Container(
          height: useCompactLayout ? 60 : 66,
          width: useCompactLayout ? 60 : 66,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: color, size: useCompactLayout ? 30 : 32),
        ),
        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: useCompactLayout ? 11 : 12,
            color: textPrimary,
          ),
        ),
      ],
    );
  }
}
