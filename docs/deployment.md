# Deployment Guide

This comprehensive guide covers deployment processes for the Pipit Flutter application to both staging and production environments.

## 🌐 Environment Overview

### Production Environment
- **Domain**: gopipit.com
- **Path**: /pipit/
- **Full URL**: https://gopipit.com/pipit/
- **Directory**: public_html/pipit/
- **Branch**: main

### Staging Environment  
- **Domain**: staging.gopipit.com
- **Path**: / (root)
- **Full URL**: https://staging.gopipit.com/
- **Directory**: public_html/staging/
- **Branch**: develop

## 🚀 Deployment Methods

### 1. Automated Deployment (Recommended)

#### Production Deployment
```bash
# Trigger production deployment
git checkout main
git merge develop
git push origin main
```

The GitHub Actions workflow will:
1. Run tests and quality checks
2. Build the web application
3. Deploy to `public_html/pipit/`
4. Update production environment

#### Staging Deployment
```bash
# Trigger staging deployment
git checkout develop
git add .
git commit -m "feat: new feature"
git push origin develop
```

### 2. Manual Deployment

#### Prerequisites
- Flutter SDK installed
- Access to hosting provider (Namecheap)
- FTP/SSH credentials

#### Steps for Production
```bash
# 1. Build web application
flutter build web --release --base-href "/pipit/"

# 2. Test build locally
cd build/web
python -m http.server 8000
# Visit http://localhost:8000

# 3. Deploy to production
# Option A: FTP Upload
# Upload contents of build/web/ to public_html/pipit/

# Option B: SSH/SCP
scp -r build/web/* user@server:public_html/pipit/

# Option C: Copy locally (if on same server)
cp -r build/web/* public_html/pipit/
```

#### Steps for Staging
```bash
# 1. Build web application (no base-href for staging)
flutter build web --release

# 2. Deploy to staging
cp -r build/web/* public_html/staging/
```

## 🔧 Configuration Files

### Web Configuration (.htaccess)
Create in both pipit/ and staging/ directories:

```apache
# public_html/pipit/.htaccess
RewriteEngine On

# Handle Flutter web routing
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /pipit/index.html [L]

# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>

# Set cache headers
<IfModule mod_expires.c>
    ExpiresActive on
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
</IfModule>

# Security headers
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"
```

### Staging .htaccess
```apache
# public_html/staging/.htaccess
RewriteEngine On

# Handle Flutter web routing
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.html [L]

# Basic authentication for staging
AuthType Basic
AuthName "Staging Environment"
AuthUserFile /path/to/.htpasswd
Require valid-user

# Same compression and cache rules as production
```

## 🔗 Domain Configuration

### Namecheap DNS Settings

#### For gopipit.com (Production)
```
Type: A Record
Host: @
Value: [Server IP Address]
TTL: Automatic

Type: CNAME  
Host: www
Value: gopipit.com
TTL: Automatic
```

#### For staging.gopipit.com (Staging)
```
Type: CNAME
Host: staging
Value: gopipit.com
TTL: Automatic
```

### SSL Certificate Setup
```bash
# Using Let's Encrypt (recommended)
certbot --apache -d gopipit.com -d www.gopipit.com -d staging.gopipit.com

# Verify SSL
ssl-cert-check -c gopipit.com
```

## 📊 Monitoring & Health Checks

### Health Check Endpoints
The app includes basic health checks:

```bash
# Production health check
curl https://gopipit.com/pipit/
# Should return 200 OK with Flutter app

# Staging health check  
curl https://staging.gopipit.com/
# Should return 200 OK with Flutter app
```

### Performance Monitoring
```bash
# Lighthouse CI (automated)
npx lighthouse-ci autorun

# Manual Lighthouse
lighthouse https://gopipit.com/pipit/ --output=html
```

### Error Monitoring
- Browser console errors
- Network request failures
- Performance metrics via Lighthouse

## 🔄 Rollback Procedures

### Quick Rollback (Production)
```bash
# Option 1: Revert to previous commit
git checkout main
git revert HEAD
git push origin main

# Option 2: Deploy previous build
# Restore from backup in public_html/pipit-backup/
cp -r public_html/pipit-backup/* public_html/pipit/
```

### Rollback Staging
```bash
# Reset to working state
git checkout develop
git reset --hard HEAD~1
git push --force-with-lease origin develop
```

## 🔒 Security Considerations

### Production Security
- HTTPS enforced via .htaccess
- Security headers configured
- Regular dependency updates
- API keys stored securely

### Staging Security
- Basic authentication enabled
- Limited access via .htpasswd
- Same security headers as production
- Separate API endpoints for testing

## 📋 Deployment Checklist

### Pre-Deployment
- [ ] Tests passing locally
- [ ] Code reviewed and approved
- [ ] Dependencies updated
- [ ] Environment variables configured
- [ ] Database migrations (if any)

### During Deployment
- [ ] Build completes successfully
- [ ] No build warnings or errors
- [ ] Assets copied correctly
- [ ] Routing configuration updated

### Post-Deployment
- [ ] Health checks pass
- [ ] Navigation works correctly
- [ ] API integration functional
- [ ] Performance metrics acceptable
- [ ] Error monitoring active

### Rollback Plan
- [ ] Backup of previous version
- [ ] Rollback procedure documented
- [ ] Team notified of deployment
- [ ] Monitoring alerts configured

## 🚨 Troubleshooting

### Common Issues

#### 1. Routing Not Working
```bash
# Check .htaccess exists
ls -la public_html/pipit/.htaccess

# Verify rewrite rules
cat public_html/pipit/.htaccess
```

#### 2. Assets Not Loading
```bash
# Check file permissions
chmod -R 644 public_html/pipit/
chmod 755 public_html/pipit/

# Verify file existence
ls -la public_html/pipit/assets/
```

#### 3. Build Failures
```bash
# Clean build
flutter clean
flutter pub get
flutter build web --release

# Check for errors
dart analyze
```

#### 4. SSL Issues
```bash
# Test SSL
openssl s_client -connect gopipit.com:443

# Renew certificate
certbot renew
```

### Support Contacts
- **Hosting Support**: Namecheap support
- **Development Team**: development@nupuit.com
- **DevOps**: devops@nupuit.com

---

This deployment guide ensures reliable and consistent deployments across all environments while maintaining security and performance standards.