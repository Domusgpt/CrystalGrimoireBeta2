# GitHub Pages Path Fix Documentation

## Problem Summary

When deploying a Flutter web app to GitHub Pages in a subdirectory (e.g., `/CrystalGrimoireBeta2/`), the favicon and manifest.json files return 404 errors despite setting the base href correctly.

### Root Cause

1. **Base href behavior**: While `<base href="/CrystalGrimoireBeta2/">` correctly affects most relative URLs in the HTML, browsers handle favicon and manifest links differently.

2. **Service Worker caching**: The Flutter service worker may cache incorrect paths from previous deployments.

3. **Manifest.json path resolution**: Paths inside manifest.json are resolved relative to the manifest file's location, NOT the HTML page or base href.

## Solution

### 1. Use Absolute Paths in HTML

Instead of relative paths, use absolute paths for favicon and manifest:

```html
<!-- Before (relative paths) -->
<link rel="icon" type="image/png" href="favicon.png"/>
<link rel="manifest" href="manifest.json">
<link rel="apple-touch-icon" href="icons/Icon-192.png">

<!-- After (absolute paths for subdirectory) -->
<link rel="icon" type="image/png" href="/CrystalGrimoireBeta2/favicon.png"/>
<link rel="manifest" href="/CrystalGrimoireBeta2/manifest.json">
<link rel="apple-touch-icon" href="/CrystalGrimoireBeta2/icons/Icon-192.png">
```

### 2. Update manifest.json Icon Paths

All icon paths in manifest.json must also be absolute:

```json
{
    "icons": [
        {
            "src": "/CrystalGrimoireBeta2/icons/Icon-192.png",
            "sizes": "192x192",
            "type": "image/png"
        }
        // ... other icons with absolute paths
    ]
}
```

### 3. Build Process

Use the provided build script that automatically fixes paths:

```bash
cd scripts
./build-for-github-pages.sh
```

This script:
1. Builds Flutter web with correct base href
2. Copies build output to repository root
3. Fixes all absolute paths for GitHub Pages

### 4. Deployment

After building:

```bash
git add .
git commit -m "Fix favicon and manifest paths for GitHub Pages"
git push origin main
```

### 5. Verification

After deployment, verify all resources load correctly:

```bash
cd scripts
./verify-deployment.sh
```

## Important Notes

1. **Clear browser cache**: After deployment, users may need to clear their browser cache or use incognito mode to see the fixes.

2. **Service Worker**: The Flutter service worker will update automatically after deployment, but it may take a few minutes.

3. **Future builds**: Always use the `build-for-github-pages.sh` script instead of plain `flutter build web` to ensure paths are correct.

## Alternative Solutions

If absolute paths cause issues:

1. **Use a custom domain**: Map a custom domain to your GitHub Pages site to serve from root.

2. **Deploy to root**: Create a separate repository named `username.github.io` to serve from root.

3. **Use relative paths with ..**: Some developers use `../CrystalGrimoireBeta2/favicon.png` but this is less reliable.

## References

- [MDN: HTML base element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base)
- [Web.dev: Add a web app manifest](https://web.dev/articles/add-manifest)
- [Flutter Web: Deployment](https://docs.flutter.dev/platform-integration/web/deploying)