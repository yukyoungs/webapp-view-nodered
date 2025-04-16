# webapp_view_nodered

Embedding the Node-RED web interface in a Flutter WebView

## Getting Started

### 📌 Purpose  
To display the Node-RED dashboard (UI) directly within a Flutter mobile or tablet app using WebView, allowing users to monitor and control IoT systems without leaving the app.

---

### 🛠️ Implementation  
- Used the `webview_flutter` package to embed a WebView widget in the Flutter app  
- Loaded the Node-RED dashboard URL into the WebView  
- Users can view and interact with the Node-RED UI directly inside the app

```dart
WebView(
  initialUrl: 'http://<YOUR_NODE_RED_IP>:1880/ui',
  javascriptMode: JavascriptMode.unrestricted,
);
```

---

### ⚠️ Considerations  
- The Node-RED server must be accessible on the same local network (e.g., Wi-Fi)  
- On Android, `android:usesCleartextTraffic="true"` must be added to allow HTTP access  
- Additional configuration might be needed for CORS, SSL certificates, or remote access

---
