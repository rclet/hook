# 🚀 Deployment Package for gopipit.com

## Package Contents

This deployment package contains all the necessary files to deploy the Pipit Flutter web application to your Namecheap shared hosting for gopipit.com.

### 📁 Directory Structure

```
public_html/
├── pipit/                    # Production deployment (gopipit.com/pipit/)
│   ├── .htaccess            # Web server configuration
│   ├── index.html           # Main application entry point
│   ├── manifest.json        # PWA manifest
│   ├── flutter.js           # Flutter web runtime
│   ├── flutter_service_worker.js  # Service worker for PWA
│   ├── assets/              # Application assets
│   └── icons/               # App icons for PWA
│
└── staging/                 # Staging deployment (staging.gopipit.com/)
    ├── .htaccess            # Web server configuration
    ├── index.html           # Main application entry point  
    ├── manifest.json        # PWA manifest
    ├── flutter.js           # Flutter web runtime
    ├── flutter_service_worker.js  # Service worker for PWA
    ├── assets/              # Application assets
    └── icons/               # App icons for PWA
```

## 🌐 Deployment Instructions

### Step 1: Upload Files to Namecheap

1. **Connect to your hosting account:**
   - Log in to Namecheap cPanel
   - Open File Manager
   - Navigate to `public_html/`

2. **Upload Production Files:**
   - Upload contents of `public_html/pipit/` to `public_html/pipit/` on your server
   - Ensure the `.htaccess` file is uploaded (it may be hidden)

3. **Upload Staging Files (if using staging subdomain):**
   - Upload contents of `public_html/staging/` to `public_html/staging/` on your server
   - Configure staging.gopipit.com subdomain to point to this directory

### Step 2: DNS Configuration

Configure your Namecheap DNS settings:

#### For gopipit.com (Production)
```
Type: A Record
Host: @
Value: [Your Server IP Address]
TTL: Automatic

Type: CNAME  
Host: www
Value: gopipit.com
TTL: Automatic
```

#### For staging.gopipit.com (Staging) - Optional
```
Type: CNAME
Host: staging
Value: gopipit.com
TTL: Automatic
```

### Step 3: SSL Certificate Setup

Set up SSL certificate for secure HTTPS access:

```bash
# Using Let's Encrypt (recommended)
certbot --apache -d gopipit.com -d www.gopipit.com -d staging.gopipit.com

# Verify SSL
ssl-cert-check -c gopipit.com
```

## 🔗 Access URLs

After deployment, your application will be accessible at:

- **Production**: https://gopipit.com/pipit/
- **Staging**: https://staging.gopipit.com/ (if configured)

## ✅ Testing Your Deployment

1. **Health Check:**
   ```bash
   curl https://gopipit.com/pipit/
   # Should return 200 OK with Flutter app
   ```

2. **Deep Linking:**
   - Test: https://gopipit.com/pipit/profile
   - Test: https://gopipit.com/pipit/settings

3. **PWA Features:**
   - Check manifest.json loads correctly
   - Verify service worker registration
   - Test "Add to Home Screen" functionality

## 🛠️ Configuration Features

### Production (.htaccess)
- ✅ Flutter web routing support
- ✅ Gzip compression enabled
- ✅ Browser caching configured
- ✅ Security headers set
- ✅ CORS configured for gopipit.com

### Staging (.htaccess)
- ✅ Flutter web routing support
- ✅ Basic authentication (optional)
- ✅ Same optimizations as production
- ✅ CORS configured for staging.gopipit.com

## 📱 Progressive Web App (PWA)

The application is configured as a PWA with:
- 📱 Add to Home Screen support
- 🔄 Service worker for offline functionality
- 🎨 Custom splash screen
- 📊 App manifest with proper metadata

## 🚨 Troubleshooting

### Common Issues

1. **Routing Not Working:**
   - Ensure `.htaccess` file is uploaded
   - Check Apache mod_rewrite is enabled

2. **Assets Not Loading:**
   - Verify file permissions (644 for files, 755 for directories)
   - Check file paths in browser developer tools

3. **HTTPS Issues:**
   - Install SSL certificate
   - Update any hardcoded HTTP URLs to HTTPS

### Support

- 📚 Full documentation: `docs/deployment.md`
- 🔧 Deployment script: `deploy.sh`
- 📋 Configuration files included

## 🎉 You're Ready!

Your Pipit Flutter web application is now ready for deployment to gopipit.com on Namecheap shared hosting. Simply upload the files and configure your DNS settings to go live!

---

**Built with ❤️ using Flutter for Nupuit Platform**