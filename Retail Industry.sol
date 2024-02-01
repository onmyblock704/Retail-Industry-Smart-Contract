// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Retail {
    struct Product {
        string name;
        uint256 price;
        uint256 stock;
    }

    mapping(string => Product) public products;
    address payable owner;

    constructor() public {
        owner = payable(msg.sender);
    }

    function addProduct(string memory name, uint256 price, uint256 stock) public {
        require(msg.sender == owner, "Only the owner can add products.");
        products[name] = Product(name, price, stock);
    }

    function updateProductPrice(string memory name, uint256 price) public {
        require(msg.sender == owner, "Only owner can update product prices.");
        require(products[name].price > 0, "Product does not exist.");
        products[name].price = price;
    }

    function updateProductStock(string memory name, uint256 stock) public {
        require(msg.sender == owner, "Only the owner can update product stock.");
        require(products[name].stock > 0, "Product does not exist.");
        products[name].stock = stock;
    }

    function purchase(string memory name, uint256 quantity) public payable {
        require(msg.value == products[name].price * quantity, "Incorrect payment amount.");
        require(quantity <= products[name].stock, "Not enough stock.");
        products[name].stock -= quantity;
    }

    function getProduct(string memory name) public view returns (string memory, uint256, uint256) {
    return (products[name].name, products[name].price, products[name].stock);
    }  

     function grantAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can grant access.");
        owner = user;
     }

     function revokeAccess(address payable user) public {
        require(msg.sender == owner, "Only the owner can revoke access.");
        require(user != owner, "Cannot revoke access for the current owner.");
        owner = payable(msg.sender);
     }

    function destroy() public {
        require(msg.sender == owner, "Only the owner can destroy the contract.");
        selfdestruct(owner);
    }
}

