# Terminal Chatroom Program
## About
This program is written in python and uses the python socket module to create TCP connections between instances.
The program is intended to be run from the command line with a server instantiated to mediate connections between clients.
The purpose in creating this program was to refresh my python skills as well as to learn about the socket module in case I need to use it for a CTF competition.
Learning about multithreading in python was unintended but necessary to implement the server functionality.

### Server
**serverSocket.py**: Creates a process to act as a server for the chatroom

**Functions/Classes**
- parseArgs(ArgumentParser): allows for the program to be run as a command from the terminal
- class new_client(threading.Thread): creates a new thread on the server for each client that connects, functions define client behavior and can be called from other threads

**Usage** \
Run as a terminal command: \
`user@host$ python serverSocket.py -i {ip-address} -p {port}`

### Client
**clientSocket.py**: Connects terminal to a running chatroom server created by serverSocket.py
**Functions/Classes**
- parseArgs(ArgumentParser): allows for the program to be run as a command from the terminal
- init_socket(\_socket, \_address, \_name=None): connects the client to the chatroom server via a TCP socket
- clear_term(): clears the terminal
- get_message(prompt): prompts the user to type a message
- send_message(\_socket, \_address, \_message): sends a message to the chatroom server
- print_banner(): just a banner with ASCII art to look pretty :)

**Usage** \
Run as terminal command: \
`user@host$ python clientSocket.py -i {ip-address} -p {port} [-n {name}]`

### Example
**Server** \
`user@host$ python serverSocket.py -i 127.0.0.1 -p 1337`

**Clients** \
Client 1: \
`user@host$ python clientSocket.py -i 127.0.0.1 -p 1337` \
Client 2: \
`python clientSocket.py -i 127.0.0.1 -p 1337 -n Todd` \
Client 3: \
`python clientSocket.py -i 127.0.0.1 -p 1337 -n Jared`

**Output**

Server: \
![Server Output](./.images/(Output)%20server_socket.PNG)

Client 1: \
![Client 1 Output](.images/Client%201.PNG)

Client 2: \
![Todd Output](.images/Todd.PNG)

Client 3: \
![Jared Output](.images/Jared.PNG)
