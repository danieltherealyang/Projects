#!/usr/bin/env python3
import sys
import socket
import argparse
import threading

def parseArgs(ArgumentParser):
	ArgumentParser.add_argument('-p', '--port', required=True, dest='port', help='set port for the socket to listen on', type=int)
	ArgumentParser.add_argument('-i', '--ip_address', required=True, dest='ip_address', help='set ip-address for the socket to listen on', type=str)

class new_client(threading.Thread):
	def __init__(self, connection, address, thread_list, exit_event):
		super(new_client, self).__init__()

		self.connection = connection
		init_message = self.connection.recv(2048).decode('utf-8')
		self.address = address

		if (init_message.startswith("Name: ") and len(init_message) > 6):
			self.name = init_message[6:]
		else:
			self.name = self.address[0] + ":" + str(self.address[1])
		
		self.threads = thread_list

	def run(self):
		self.connection.settimeout(0.5)
		while not exit_event.is_set():
			try:
				data = self.connection.recv(2048).decode('utf-8')
			except:
				continue
			
			if not data or str.lower(data) == "quit":
				break

			self.broadcast(data)
		self.terminate()
		
	def getName(self):
		return self.name

	def end(self):
		self.connection.close()

	def send(self, message):
		self.connection.sendall(str.encode(message))
	
	def broadcast(self, message):
		for thread in self.threads:
			if self != thread:
				thread.send(self.getName() + ": " + message)

	def terminate(self):
		print("Disconnected from " + self.address[0] + ":" + str(self.address[1]))
		self.send("Disconnected from " + self.address[0] + ":" + str(self.address[1]))
		self.end()

		for thread in self.threads:
			if self == thread:
				self.threads.remove(thread)

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parseArgs(parser)
	args = parser.parse_args()

	server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	server_address = (args.ip_address, args.port)
	print("Server starting on address {0} port {1}...".format(server_address[0], server_address[1]))
	
	try:
		server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
		server_socket.bind(server_address)
	except socket.error as error:
		print(error)

	print("Waiting for a connection...")
	server_socket.listen(10)

	threads = list()
	exit_event = threading.Event()

	while True:
		try:
			client, address = server_socket.accept()
			print("Connected to " + address[0] + ":" + str(address[1]))
			thread = new_client(client, address, threads, exit_event)
			threads.append(thread)
			thread.start()
		except (KeyboardInterrupt, SystemExit):
			print("Ending server threads...")
			exit_event.set()
			for thread in threads:	
				thread.join()
			break
	
	server_socket.close()