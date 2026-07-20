# Printoo - Professional PDF Printing Management System

A comprehensive Flutter desktop application designed for efficient PDF printing, order management, and business statistics tracking. Perfect for printing shops, educational institutions, and businesses that require organized document printing workflows.

## 🚀 Features

### Core Functionality

- **Multi-Printer Support**: Detect and manage multiple printers with real-time status monitoring
- **PDF Batch Processing**: Queue and print multiple PDF files efficiently
- **Duplex Printing**: Support for double-sided printing with toggle control
- **Copy Management**: Print multiple copies with customizable settings
- **File Organization**: Structured file management with educational categories

### Business Management

- **Pricing System**: Configurable price-per-page with automatic cost calculation
- **Order Queue**: Manage print jobs with real-time status tracking
- **Statistics Dashboard**: Comprehensive analytics for business insights
- **Print History**: Detailed records of all printing activities
- **Earnings Tracking**: Monitor revenue and calculate profits

### User Interface

- **Modern Dark Theme**: Professional and easy-on-the-eyes interface
- **Animated Transitions**: Smooth animations and micro-interactions
- **Responsive Layout**: Optimized for desktop displays
- **Arabic/English Support**: Bilingual interface with RTL support

### Security & Licensing

- **Free Trial**: 3-day trial period for new users
- **License Activation**: Secure license validation system
- **Data Protection**: Encrypted storage for sensitive information

## 📋 System Requirements

- **Operating System**: Windows 10/11
- **Flutter SDK**: 3.7.2 or higher
- **Memory**: Minimum 4GB RAM (8GB recommended)
- **Storage**: 500MB available space
- **Printer**: Compatible with Windows printing subsystem

## 🛠️ Installation

### Prerequisites

1. Install [Flutter SDK](https://flutter.dev/docs/get-started/install)
2. Ensure Windows development tools are installed
3. Install [SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader.html) for enhanced printing

### Setup Instructions

```bash
# Clone the repository
git clone https://github.com/iziadehap/printoo.git
cd printoo

# Install dependencies
flutter pub get

# Run the application
flutter run -d windows
```

### Build for Distribution

```bash
# Build Windows executable
flutter build windows --release

# The executable will be located in build/windows/runner/Release/
```

## 📁 Project Structure

```
lib/
├── controller/
│   └── controler.dart          # Main application controller
├── model/
│   ├── page_Counter_model.dart # Page counting logic
│   ├── printOrderModel.dart    # Print order data model
│   ├── print_record.dart       # Print history records
│   ├── print_statistics.dart   # Statistics data model
│   └── printerInfo.dart        # Printer information model
├── screens/
│   ├── ActivationScreen.dart  # License activation screen
│   ├── OrderMangment.dart     # Order management interface
│   ├── home_screen.dart        # Main application screen
│   ├── password_screen.dart    # Statistics and reports
│   ├── path_screen.dart        # File path configuration
│   ├── splash_screen.dart      # Application splash screen
│   └── statistics_screen.dart # Detailed statistics view
├── services/
│   ├── free_trial_protection_or_active.dart  # License management
│   ├── password_service.dart    # Security services
│   └── statistics_service.dart  # Statistics management
└── widgets/
    ├── animated_gradient_container.dart  # UI animations
    ├── getPageCount.dart         # PDF page counting
    ├── pdf_in_file.dart         # PDF file utilities
    ├── priceBottomSheet.dart    # Pricing configuration
    └── print_pdf.dart           # PDF printing engine
```

## 💡 Usage Guide

### First-Time Setup

1. Launch the application
2. Choose between free trial or purchase option
3. Configure your file paths for PDF documents
4. Set up printer preferences and pricing

### Daily Operations

1. **Select Printer**: Choose from available printers with real-time status
2. **Configure Print Job**:
   - Select PDF files from organized folders
   - Set duplex printing option
   - Adjust copy count
   - Review calculated costs
3. **Queue Management**: Add jobs to print queue
4. **Monitor Progress**: Track printing status in real-time
5. **View Statistics**: Access business analytics and reports

### File Organization

The app supports educational file structure:

- **Categories**: المتميز, المتفوق, التاسيس السليم
- **Classes**: 3ب, 4ب, 5ب, 6ب, 1ع
- **Types**: اسئله, اجابه

## 🔧 Configuration

### Printer Setup

- Automatic printer detection
- Real-time status monitoring
- Support for various printer types

### Pricing Configuration

- Set custom price per page
- Support for different pricing tiers
- Automatic cost calculation

### Path Configuration

- Customizable file paths
- Support for network drives
- Automatic file detection

## 📊 Statistics & Reports

### Available Metrics

- Total files printed
- Pages printed per day/week/month
- Revenue tracking
- Most printed files
- Printer usage statistics

### Export Options

- Print history reports
- Financial summaries
- Usage analytics

## 🔒 Security Features

- **License Validation**: Secure activation system
- **Data Encryption**: Protected user data storage
- **Trial Management**: Controlled access during trial period
- **Offline Operation**: Works without internet connection

## 🐛 Troubleshooting

### Common Issues

**Printer Not Detected**

- Ensure printer is properly connected
- Check Windows printer drivers
- Restart the application

**PDF Not Printing**

- Verify SumatraPDF.exe is in application directory
- Check file permissions
- Ensure PDF files are not corrupted

**License Issues**

- Verify internet connection for activation
- Check license key validity
- Contact support for assistance

### Error Codes

- **Error 128**: Git repository not initialized
- **Error 129**: Invalid command parameters
- **Exit Code 1**: General operation failure

## 🤝 Contributing

We welcome contributions to improve Printoo! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Development Guidelines

- Follow Flutter best practices
- Maintain code documentation
- Test on multiple Windows versions
- Ensure backward compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and inquiries:

- **Email**: support@printoo.app
- **GitHub Issues**: [Create an issue](https://github.com/iziadehap/printoo/issues)
- **Documentation**: [Online Guide](https://printoo.app/docs)

## 🔄 Updates

### Version 2.0.0+1

- Enhanced printer status monitoring
- Improved statistics tracking
- Better file organization
- Optimized performance
- Bug fixes and stability improvements

### Upcoming Features

- Cloud synchronization
- Mobile companion app
- Advanced reporting
- Multi-language support expansion
- Integration with popular cloud storage services

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing cross-platform framework
- **SumatraPDF**: For reliable PDF printing capabilities
- **Community**: For valuable feedback and suggestions

---

**Made with ❤️ by @Axon_plus**

_Printoo - Making printing simple, efficient, and profitable_
