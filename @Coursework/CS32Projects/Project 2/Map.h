#ifndef MAP_H
#define MAP_H

#include <string>

using KeyType = std::string;
using ValueType = double;

class Map
{
    private:
        struct Node {
            KeyType Key;
            ValueType Value;
            Node* next = nullptr;
            Node* previous = nullptr;
        };

        Node* head;
    public:
        Map();
        ~Map();
        Map(const Map& obj);
        Map& operator=(const Map& obj);
        bool empty() const;
        int size() const;
        bool insert(const KeyType& key, const ValueType& value);
        bool update(const KeyType& key, const ValueType& value);
        bool insertOrUpdate(const KeyType& key, const ValueType& value);
        bool erase(const KeyType& key);
        bool contains(const KeyType& key) const;
        bool get(const KeyType& key, ValueType& value) const;
        bool get(int i, KeyType& key, ValueType& value) const;
        void swap(Map& other);
};

bool merge(const Map& m1, const Map& m2, Map& result);
void reassign(const Map& m, Map& result);

#endif