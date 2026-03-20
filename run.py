#!/usr/bin/env python3
"""
WhisperMeet Web - Auto Start
Double-click this file or run: python run.py
"""
import http.server
import socketserver
import webbrowser
import os
import sys
import threading
import time

# Configuration
PORT = 8080
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class QuietHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        pass  # Suppress log output

def open_browser():
    time.sleep(1)  # Wait for server to start
    webbrowser.open(f"http://localhost:{PORT}/index.html")

def main():
    os.chdir(DIRECTORY)

    print("=" * 50)
    print("  WhisperMeet Web - Starting...")
    print("=" * 50)
    print(f"\nOpening: http://localhost:{PORT}/index.html\n")

    # Start browser in background
    threading.Thread(target=open_browser, daemon=True).start()

    # Start server
    with socketserver.TCPServer(("", PORT), QuietHandler) as httpd:
        print(f"Server running at http://localhost:{PORT}/")
        print("\nPress Ctrl+C to stop the server\n")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n\nServer stopped.")
            sys.exit(0)

if __name__ == "__main__":
    main()
