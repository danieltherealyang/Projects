#!/usr/bin/env python3
import sys
import socket
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('-c', '--client', action='store_true', dest='client', default=True, help='set socket as client')
parser.add_argument('-s', '--server', action='store_false', dest='client', help='set socket as server')
parser.add_argument('-p', '--port', required=True, dest='port', help='set port for the socket to connect/listen on', type=int)
parser.add_argument('-i', '--ip_address', required=True, dest='ip_address', help='set ip-address for the socket to connect/listen on', type=str)

args = parser.parse_args()

print(args)

_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

print(type(args.port))


if args.client:
	_socket.connect((args.ip_address, args.port))
else:
	_socket.bind((args.ip_address, args.port))
	_socket.listen(10)

message = bytes(input("Type a message to send: ") + '\n', 'utf-8')

reply = ''

if args.client:
	_socket.send(message)
	reply = _socket.recv(1024).decode('utf-8')
	print(reply)
else:
	while True:
		connection, address = _socket.accept()
		connection.send(message)
		reply = connection.recv(1024).decode('utf-8')
		print(reply)

_socket.close()
