import os
import sys
import time
import json
import re
import sqlite3
from http.server import HTTPServer, BaseHTTPRequestHandler
import threading

WORKSPACE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(WORKSPACE_DIR, 'sql_trainer.db')
CHROME_DIR = os.path.join(WORKSPACE_DIR, '.dart_tool', 'chrome-device')

def sync_from_chrome():
    if not os.path.exists(CHROME_DIR):
        return
    
    users_to_insert = []
    for root, dirs, files in os.walk(CHROME_DIR):
        for f in files:
            if 'leveldb' in root:
                p = os.path.join(root, f)
                try:
                    data_bytes = open(p, 'rb').read()
                    # Pattern 1: registered_users_map
                    idx = 0
                    while True:
                        idx = data_bytes.find(b'registered_users_map', idx)
                        if idx == -1:
                            break
                        # Find json snippet
                        brace_start = data_bytes.find(b'{', idx)
                        if brace_start != -1 and brace_start - idx < 50:
                            # Read until matching }
                            depth = 0
                            end = -1
                            for i in range(brace_start, min(brace_start + 1500, len(data_bytes))):
                                if data_bytes[i:i+1] == b'{':
                                    depth += 1
                                elif data_bytes[i:i+1] == b'}':
                                    depth -= 1
                                    if depth == 0:
                                        end = i + 1
                                        break
                            if end != -1:
                                raw_str = data_bytes[brace_start:end].decode('utf-8', errors='ignore')
                                # Unescape \" if present
                                clean_str = raw_str.replace('\\"', '"')
                                try:
                                    parsed = json.loads(clean_str)
                                    if isinstance(parsed, dict):
                                        for email, u in parsed.items():
                                            if isinstance(u, dict) and 'name' in u and 'password' in u:
                                                users_to_insert.append((u['name'], u['email'], u['password']))
                                except:
                                    pass
                        idx += 20
                except:
                    pass

    if users_to_insert and os.path.exists(DB_PATH):
        try:
            conn = sqlite3.connect(DB_PATH)
            for name, email, password in users_to_insert:
                conn.execute('''
                    INSERT OR IGNORE INTO users (name, email, password, total_xp, streak_days, level)
                    VALUES (?, ?, ?, 0, 1, 1)
                ''', (name, email, str(password)))
            conn.commit()
            conn.close()
        except:
            pass

class BridgeHandler(BaseHTTPRequestHandler):
    def _set_cors_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')

    def do_OPTIONS(self):
        self.send_response(200)
        self._set_cors_headers()
        self.end_headers()

    def do_POST(self):
        if self.path == '/api/register':
            content_length = int(self.headers.get('Content-Length', 0))
            post_data = self.rfile.read(content_length)
            try:
                payload = json.loads(post_data.decode('utf-8'))
                name = payload.get('name', '').strip()
                email = payload.get('email', '').strip()
                password = payload.get('password', '').strip()

                if name and email and password:
                    conn = sqlite3.connect(DB_PATH)
                    conn.execute('''
                        INSERT OR IGNORE INTO users (name, email, password, total_xp, streak_days, level)
                        VALUES (?, ?, ?, 0, 1, 1)
                    ''', (name, email, password))
                    conn.commit()
                    conn.close()
                self.send_response(200)
                self._set_cors_headers()
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({'status': 'ok'}).encode('utf-8'))
            except Exception as e:
                self.send_response(500)
                self._set_cors_headers()
                self.end_headers()
                self.wfile.write(str(e).encode('utf-8'))
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        pass # Quiet logging

def run_loop():
    while True:
        try:
            sync_from_chrome()
        except:
            pass
        time.sleep(2)

def main():
    threading.Thread(target=run_loop, daemon=True).start()
    server = HTTPServer(('127.0.0.1', 8765), BridgeHandler)
    server.serve_forever()

if __name__ == '__main__':
    main()
