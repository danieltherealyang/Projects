#!/usr/bin/env python3
import sys
import socket
import argparse
import threading
import queue
from os import system, name

def parseArgs(ArgumentParser):
    ArgumentParser.add_argument('-n', '--name', required=False, dest='name', help='set name for client', type=str)
    ArgumentParser.add_argument('-p', '--port', required=True, dest='port', help='set port for the socket to connect/listen on', type=int)
    ArgumentParser.add_argument('-i', '--ip_address', required=True, dest='ip_address', help='set ip-address for the socket to connect/listen on', type=str)

def init_socket(_socket, _address, _name=None):
    print("Connecting to server on address {0} port {1}...".format(_address[0], _address[1]))
    try:
        _socket.connect(_address)
    except socket.error as error:
        print(error)
    
    if _name is not None:
        _socket.sendall(str.encode("Name: " + _name))
    else:
        client_socket.sendall(str.encode("None"))

def clear_term():
    if name == 'nt':
        _ = system('cls')
  
    else:
        _ = system('clear')

def get_message(prompt):
    _input = input(prompt)
    print('\033[1A' + "You: " + _input + '\033[K')
    return _input

def send_message(_socket, _address, _message):
    try:
        _socket.sendall(str.encode(_message))
    except:
        try:
            print("Reconnecting...")
            _socket.connect(_address)
        except socket.error as error:
            print(error)

def print_banner():
    print("""
    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
    █▄▄░▄▄█░▄▄█░▄▄▀█░▄▀▄░██▄██░▄▄▀█░▄▄▀█░█████░▄▄▀█░████░▄▄▀█▄░▄█░▄▄▀█▀▄▄▀█▀▄▄▀█░▄▀▄░█
    ███░███░▄▄█░▀▀▄█░█▄█░██░▄█░██░█░▀▀░█░█████░████░▄▄░█░▀▀░██░██░▀▀▄█░██░█░██░█░█▄█░█
    ███░███▄▄▄█▄█▄▄█▄███▄█▄▄▄█▄██▄█▄██▄█▄▄████░▀▀▄█▄██▄█▄██▄██▄██▄█▄▄██▄▄███▄▄██▄███▄█
    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
""")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parseArgs(parser)
    args = parser.parse_args()

    client_socket = socket.socket()
    client_address = (args.ip_address, args.port)
    
    init_socket(client_socket, client_address, args.name)
    clear_term()    
    print_banner()
    print("QUIT to end connection")
 
    que = queue.Queue()
    prompt = "Type Message: "
    input_thread = threading.Thread(target=lambda q, m: q.put(get_message(m)), args=(que, prompt,))
    input_thread.start()
    _input = None

    while True:
        if not input_thread.is_alive():
            while not que.empty():
                _input = que.get()
                send_message(client_socket, client_address, _input)
            if _input.lower() == "quit":
                try:
                    response = client_socket.recv(2048)
                    print("\r" + response.decode('utf-8'))
                except:
                    break
                break
            
            input_thread = threading.Thread(target=lambda q, m: q.put(get_message(m)), args=(que, prompt))
            input_thread.start()
        
        client_socket.settimeout(1.0)
        try:
            response = client_socket.recv(2048)
            if not response:
                break
            print("\r" + response.decode('utf-8') + "\n" + prompt, end="")
        except:
            continue
    
    client_socket.close()