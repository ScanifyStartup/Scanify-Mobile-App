# 🚀 Scanify Mobile App

**¡Herramienta de escaneo y generación de códigos QR desde tu dispositivo móvil!**

---

## ✨ Características

- 📷 **Escaneo rápido de códigos QR**
- 📝 **Generación de códigos QR personalizados** (texto, URL, contacto)
- 📤 **Compartir fácilmente tus códigos QR**
- 📱 **Interfaz moderna y amigable**
- 🔒 **Manejo seguro de permisos**

---

## 🛠️ Ejecución en modo desarrollo

1. **Verifica la configuración de Flutter en tu equipo:**
   ```sh
   flutter doctor -v
   ```

2. **Instala las dependencias del proyecto:**
   ```sh
   flutter pub get
   ```

3. **Ejecuta la app en modo desarrollo:**
   ```sh
   flutter run
   ```

---

## 📦 Generar APK para instalación

1. **Genera el archivo APK en modo release:**
   ```sh
   flutter build apk --release
   ```

2. **Ubica el archivo generado:**

   - El archivo estará en:  
     `build/app/outputs/flutter-apk/app-release.apk`

   - Si no es visible desde tu IDE, haz clic derecho en la carpeta y selecciona:  
     `Open (Reveal) in Explorer`

3. **Transfiere e instala el APK en tu dispositivo Android:**

   - Copia el archivo `app-release.apk` a tu dispositivo.
   - Ábrelo desde el explorador de archivos del dispositivo.
   - Es posible que necesites habilitar la opción:  
     **"Instalar apps desconocidas"**.

---
