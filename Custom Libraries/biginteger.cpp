#include <iostream>
using namespace std;

class BigInteger {
    public:
        BigInteger();//
        ~BigInteger();
        BigInteger(int value);
        BigInteger(const BigInteger& other);
        BigInteger& operator=(int number);
        BigInteger& operator=(const BigInteger& other);
        BigInteger& operator+(int number);
        BigInteger& operator+(const BigInteger& other);
        BigInteger& operator-(const BigInteger& other);
        BigInteger& operator*(const BigInteger& other);
        bool operator==(const BigInteger& other);
        bool operator!=(const BigInteger& other);
        void display();
    private:
        struct Node {
            Node* next = nullptr;
            Node* previous = nullptr;
            int value = -1;
        };
        void cleanZeroes();
        void addDigit(int digit); //
        void clear(); //
        Node* head;
        Node* tail;
};

void BigInteger::cleanZeroes() {
    Node* cleaner = head->next;
    if (cleaner != nullptr && cleaner->next != nullptr) {
        while (cleaner->value == 0 && cleaner->next != nullptr) {
            cleaner = cleaner->next;
            head->next = cleaner;
            delete cleaner->previous;
            cleaner->previous = head;
        }
    }
}

void BigInteger::display() {
    Node* current = head;
    if (head->next != nullptr)
        current = head->next;
    else
        return;
    while (current != nullptr) {
        cout << current->value;
        current = current->next;
    }
    cout << endl;
}

void BigInteger::addDigit(int digit) {
    head->previous = new Node;
    head->previous->next = head;
    head->value = digit;
    head = head->previous;
}

void BigInteger::clear() {
    Node* current = head;
    while (head != nullptr) {
        head = head->next;
        delete current;
        current = head;
    }
}

BigInteger::BigInteger() {
    head = new Node;
    tail = head;
}

BigInteger::~BigInteger() {
    clear();
}

BigInteger::BigInteger(int value) {
    head = new Node;
    tail = head;
    if (value == 0) {
        addDigit(0);
        return;
    }
    while (value != 0) {
        addDigit(value % 10);
        value /= 10;
    }
}

BigInteger::BigInteger(const BigInteger& other) {
    head = new Node;
    tail = head;
    Node* otherCurrent = other.tail;
    while (otherCurrent->value != -1) {
        addDigit(otherCurrent->value);
        otherCurrent = otherCurrent->previous;
    }
}

BigInteger& BigInteger::operator=(int number) {
    clear();
    head = new Node;
    tail = head;

    if (number == 0)
        addDigit(0);

    while (number != 0) {
        addDigit(number % 10);
        number /= 10;
    }
    return *this;
}

BigInteger& BigInteger::operator=(const BigInteger& other) {
    Node* current = tail;
    Node* otherCurrent = other.tail;

    while (current->value != -1 && otherCurrent->value != -1) {
        current->value = otherCurrent->value;
        current = current->previous;
        otherCurrent = otherCurrent->previous;
    }

    if (current->value == -1 && otherCurrent->value != -1) {
        while (otherCurrent->value != -1) {
            addDigit(otherCurrent->value);
            otherCurrent = otherCurrent->previous;
        }
        return *this;
    }

    if (current->value != -1 && otherCurrent->value == -1) {
        while (current != head) {
            Node* back = current->previous;
            Node* front = current->next;
            back->next = front;
            front->previous = back;
            delete current;
            current = back;
        }
        return *this;
    }

    return *this;
}

BigInteger& BigInteger::operator+(int number) {
    Node* current = tail;
    int carry = 0;
    while (current->value != -1 && number != 0) {
        int other = number % 10;
        int val = current->value + other + carry;
        current->value = val % 10;
        carry = val/10;
        number /= 10;
        current = current->previous;
    }

    if (current->value == -1 && number == 0) {
        if (carry != 0)
            addDigit(carry);
        return *this;
    }

    if (current->value == -1 && number != 0) {
        while (number != 0) {
            int other = number % 10;
            int val = current->value + other + carry;
            addDigit(val % 10);
            carry = val/10;
            number /= 10;
            current = current->previous;
        }
        if (carry != 0)
            addDigit(carry);
        return *this;
    }

    if (current->value != -1 && number == 0) {
        while (carry != 0 && current->value != -1) {
            int val = current->value + carry;
            current->value = val % 10;
            carry = val/10;
            current = current->previous;
        }
        if (carry != 0)
            addDigit(carry);
        return *this;
    }

    return *this;
}

BigInteger& BigInteger::operator+(const BigInteger& other) {
    Node* current = tail;
    Node* otherCurrent = other.tail;

    int carry = 0;

    while (current->value != -1 && otherCurrent->value != -1) {
        int val = current->value + otherCurrent->value + carry;
        int units = val % 10;
        current->value = units;
        carry = val/10;
        current = current->previous;
        otherCurrent = otherCurrent->previous;
    }

    if (current->value == -1 && otherCurrent->value == -1) {
        if (carry != 0)
            addDigit(carry);
        return *this;
    }

    if (current->value != -1 && otherCurrent->value == -1) {
        while (carry != 0 && current->value != -1) {
            int val = current->value + carry;
            int units = val % 10;
            current->value = units;
            carry = val / 10;
            current = current->previous;
        }
        if (carry != 0)
            addDigit(carry);
        return *this;
    }

    if (current->value == -1 && otherCurrent->value != -1) {
        while (carry != 0 && otherCurrent->value != -1) {
            int val = otherCurrent->value + carry;
            int units = val % 10;
            addDigit(units);
            carry = val/10;
            otherCurrent = otherCurrent->previous;
        }
        if (carry != 0)
            addDigit(carry);
        while (carry == 0 && otherCurrent->value != -1) {
            addDigit(otherCurrent->value);
            otherCurrent = otherCurrent->previous;
        }
        return *this;
    }

    return *this;
}

BigInteger& BigInteger::operator-(const BigInteger& other) {
    Node* current = tail;
    Node* otherCurrent = other.tail;
    
    while (current->value != -1 && otherCurrent->value != -1) {
        int val = current->value - otherCurrent->value;
        if (val < 0) {
            Node* helper = current->previous;
            if (helper->value == -1)
                return *this;
            while (helper->value == 0)
                helper = helper->previous;
            if (helper->value == -1)
                break;
            helper = helper->next;
            while (helper != current->next) {
                helper->previous->value--;
                helper->value += 10;
                helper = helper->next;
            }
            val = current->value - otherCurrent->value;
        }
        current->value = val;
        current = current->previous;
        otherCurrent = otherCurrent->previous;
    }

    if (otherCurrent->value != -1) {
        return *this;
    }

    cleanZeroes();

    return *this;
}

BigInteger& BigInteger::operator*(const BigInteger& other) {
    Node* current = tail;
    Node* otherCurrent = other.tail;
    BigInteger tabulate = 0;
    int counter = 0;
    int carry = 0;
    while (otherCurrent->value != -1) {
        BigInteger tempInt;
        for (int i = 0; i < counter; i++) {
            tempInt.addDigit(0);
        }

        while (current->value != -1) {
            int val = (current->value * otherCurrent->value) + carry;
            tempInt.addDigit(val % 10);
            carry = val/10;
            current = current->previous;
        }
        
        if (carry != 0)
            tempInt.addDigit(carry);
        carry = 0;
        tempInt.cleanZeroes();
        tabulate = tabulate + tempInt;
        counter++;
        otherCurrent = otherCurrent->previous;
        current = tail;
    }
    
    *this = tabulate;
    return *this;
}

bool BigInteger::operator==(const BigInteger& other) {
    Node* current = tail;
    Node* otherCurrent = other.tail;

    while (current->value != -1 && otherCurrent->value != -1) {
        if (current->value != otherCurrent->value)
            return false;
        current = current->previous;
        otherCurrent = otherCurrent->previous;
    }

    if (current->value == -1 && otherCurrent->value == -1)
        return true;
    return false;
}

bool BigInteger::operator!=(const BigInteger& other) {
    Node* current = tail;
    Node* otherCurrent = other.tail;

    while (current->value != -1 && otherCurrent->value != -1) {
        if (current->value != otherCurrent->value)
            return true;
        current = current->previous;
        otherCurrent = otherCurrent->previous;
    }

    if (current->value == -1 && otherCurrent->value == -1)
        return false;
    return true;
}

void extraLongFactorials(int n) {
    if (n < 2) {
        cout << 1 << endl;
        return;
    }

    BigInteger number = n;
    BigInteger temp = number;
    temp = temp - 1;
    BigInteger lowerBound = 1;
    while (temp != lowerBound) {
        number = number * temp;
        temp = temp - 1;
    }
    number.display();
}

int main () {
    extraLongFactorials(212);
}