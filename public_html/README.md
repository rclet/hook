# Pipit Web Deployment

This directory contains the web build output for deployment to production and staging environments.

## Deployment Structure

```
public_html/
├── pipit/          # Production deployment (pipitgo.com)
│   ├── index.html
│   ├── main.dart.js
│   ├── flutter.js
│   ├── manifest.json
│   └── assets/
└── staging/        # Staging deployment (staging.pipitgo.com)
    ├── index.html
    ├── main.dart.js
    ├── flutter.js
    ├── manifest.json
    └── assets/
```

## Production Deployment

The production build is deployed to `public_html/pipit/` and accessible at:
- https://pipitgo.com/pipit/

## Staging Deployment  

The staging build is deployed to `public_html/staging/` and accessible at:
- https://staging.pipitgo.com/

## Deployment Process

1. **Automated via CI/CD**: Deployments happen automatically through GitHub Actions
   - `main` branch deploys to production
   - `develop` branch deploys to staging

2. **Manual Deployment**: 
   ```bash
   # Build web version
   flutter build web --release --base-href "/pipit/"
   
   # Copy to production
   cp -r build/web/* public_html/pipit/
   
   # Copy to staging  
   cp -r build/web/* public_html/staging/
   ```

## Domain Configuration

### Production (pipitgo.com)
- Document root: `/public_html/pipit/`
- SSL certificate required
- CDN configuration recommended

### Staging (staging.pipitgo.com)
- Document root: `/public_html/staging/` 
- Basic auth protection recommended
- SSL certificate required

## Deep Linking Support

Both environments support deep linking:
- `pipitgo.com/pipit/profile` → Profile page
- `pipitgo.com/pipit/settings` → Settings page
- `staging.pipitgo.com/profile` → Staging profile page

## Performance Optimizations

- Gzip compression enabled
- Browser caching headers configured
- Service worker for offline support
- Progressive Web App (PWA) features

## Monitoring

- Google Analytics tracking
- Error reporting via Sentry
- Performance monitoring via Lighthouse CI