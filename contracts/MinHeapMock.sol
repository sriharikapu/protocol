pragma solidity  ^0.4.8;

import "./MinHeap.sol";

contract MinHeapMock {
    using MinHeap for MinHeap.Heap;

    MinHeap.Heap public heap;

    function init(uint _size) {
        heap.init(_size);
    }

    function contains(address _addr) constant returns (bool) {
        return heap.contains(_addr);
    }

    function isFull() constant returns (bool) {
        return heap.isFull();
    }

    function getKey(address _addr) constant returns (uint256) {
        return heap.getKey(_addr);
    }

    function size() constant returns (uint256) {
        return heap.size();
    }

    function insert(address _addr, uint _key) {
        heap.insert(_addr, _key);
    }

    function extractMin() {
        heap.extractMin();
    }

    function increaseKey(address _addr, uint _key) {
        heap.increaseKey(_addr, _key);
    }

    function decreaseKey(address _addr, uint _key) {
        heap.decreaseKey(_addr, _key);
    }

    function deleteId(address _addr) {
        heap.deleteId(_addr);
    }

    function min() constant returns (address, uint) {
        return heap.min();
    }
}