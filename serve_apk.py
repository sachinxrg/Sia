import os
import time
import socket
from http.server import BaseHTTPRequestHandler, HTTPServer

APK_PATH = r"d:\TY-IT\Projects\Sia\build\app\outputs\flutter-apk\app-release.apk"
apk_bytes = None

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/sia.apk':
            self.send_response(200)
            self.send_header('Content-type', 'application/vnd.android.package-archive')
            self.send_header('Content-Disposition', 'attachment; filename="sia.apk"')
            self.send_header('Content-Length', str(len(apk_bytes)))
            self.end_headers()
            self.wfile.write(apk_bytes)
        else:
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b"<html><body><h1>Sia Download Server</h1><a href='/sia.apk'>Download sia.apk</a></body></html>")

def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

print("Waiting for APK to be built...")
while True:
    if os.path.exists(APK_PATH):
        try:
            with open(APK_PATH, 'rb') as f:
                apk_bytes = f.read()
            if len(apk_bytes) > 0:
                print(f"Successfully loaded {len(apk_bytes)} bytes into RAM!")
                break
        except Exception as e:
            pass
    time.sleep(0.05)

ip = get_ip()
print(f"\n=============================================")
print(f"SERVER READY! To download the APK, open this link on your phone (must be on same Wi-Fi):")
print(f"http://{ip}:8000/")
print(f"=============================================\n")

httpd = HTTPServer(('0.0.0.0', 8000), SimpleHTTPRequestHandler)
httpd.serve_forever()
