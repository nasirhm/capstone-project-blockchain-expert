pragma solidity ^0.4.11;

contract capstone {
    address owner;
    mapping (address => uint) public balances;
    
    struct Land {
        address owner;
        bool forSale;
        uint price;
    }
    
    Land[12] public lands;
    
    event LandOwnerChanged(
        uint index
    );
    
    event LandPriceChanged(
        uint index,
        uint price
    );
    
    event LandAvailabilityChanged(
        uint index,
        uint price,
        bool forSale
    );
    
    constructor() public {
        owner = msg.sender;
        lands[0].price = 4000;
        lands[0].forSale = true;
        lands[1].price = 4000;
        lands[1].forSale = true;
        lands[2].price = 4000;
        lands[2].forSale = true;
        lands[3].price = 4000;
        lands[3].forSale = true;
        lands[4].price = 4000;
        lands[4].forSale = true;
        lands[5].price = 4000;
        lands[5].forSale = true;
        lands[6].price = 4000;
        lands[6].forSale = true;
        lands[7].price = 4000;
        lands[7].forSale = true;
        lands[8].price = 4000;
        lands[8].forSale = true;
        lands[9].price = 4000;
        lands[9].forSale = true;
        lands[10].price = 4000;
        lands[10].forSale = true;
        lands[11].price = 4000;
        lands[11].forSale = true;
    }
    
    function putLandUpForSale(uint index, uint price) public {
        Land storage land = lands[index];
        require(msg.sender == land.owner && price > 0);
        land.forSale = true;
        land.price = price;
        emit LandAvailabilityChanged(index, price, true);
    }
    
    function takeOffMarket(uint index) public {
        Land storage land = lands[index];
        require(msg.sender == land.owner);
        land.forSale = false;
        emit LandAvailabilityChanged(index, land.price, false);
    }
    
    function getLands() public view returns(address[], bool[], uint[]) {
        address[] memory addrs = new address[](12);
        bool[] memory available = new bool[](12);
        uint[] memory price = new uint[](12);
        for (uint i = 0; i < 12; i++) {
            Land storage land = lands[i];
            addrs[i] = land.owner;
            price[i] = land.price;
            available[i] = land.forSale;
        }
        return (addrs, available, price);
    }
    
    function buyLand(uint index) public payable {
        Land storage land = lands[index];
        
        require(msg.sender != land.owner && land.forSale && msg.value >= land.price);
        
        if(land.owner == 0x0) {
            balances[owner] += msg.value;
        }else {
            balances[land.owner] += msg.value;
        }
        land.owner = msg.sender;
        land.forSale = false;
        emit LandOwnerChanged(index);
    }
    
    function withdrawFunds() public {
        address payee = msg.sender;
          uint payment = balances[payee];
          require(payment > 0);
          balances[payee] = 0;
          require(payee.send(payment));
    }
    function destroy() payable public {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
}