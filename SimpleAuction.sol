pragma solidity ^0.6.0;

pragma experimental ABIEncoderV2;
//简单的公开拍卖
contract SimpleAuction {
    //受益者地址
    address payable public beneficiary;
    //拍卖结束时间
    uint256 public auctionEndTime;
    //出价最高的地址
    address public highestBidder;
    //出价最高的金额
    uint256 public highestBid;
    //记录不是最高地址的出价,用于用户取回出价被超过的金额
    mapping(address => uint256) pendingReturns;
    //拍卖是否已经结束
    bool ended;
    //出价事件
    event HighestBidIncreased(address bidder, uint256 amount);
    //拍卖结束事件
    event AuctionEnded(address winner, uint256 amount);
    //构造器
    //确定受益人和拍卖周期
    constructor(address payable _beneficiary, uint256 _biddingTime) public {
        beneficiary = _beneficiary;
        //拍卖结束时间 = 当前时间(秒) + 周期(秒);
        auctionEndTime = now + _biddingTime;
    }
    //竞拍
    function bid() public payable {
        //需要当前时间小于等于结束时间
        require(now <= auctionEndTime, "Auction Already ended.");
        //需要出价金额>当前最高出价金额
        //msg.value表示用户支付的eth数量,单位为WEI
        require(msg.value > highestBid, "There already is a higher bid.");
        if (highestBid != 0) {
            //保存出价失败的地址+金额
            pendingReturns[highestBidder] += highestBid;
        }
        //记录最高的出价地址和金额
        //msg.sender=当前调用者地址
        highestBidder = msg.sender;
        highestBid = msg.value;
        //发送竞拍事件
        emit HighestBidIncreased(msg.sender, msg.value);
    }
    //提取出价失败的金额
    function withdraw() public returns (bool){
        //查询调用者是否有未取回的金额
        uint256 amount = pendingReturns[msg.sender];
        //必须>0
        require(amount > 0, "Amount must >0");
        //置为0
        pendingReturns[msg.sender] = 0;
        //如果转账失败
        if (!msg.sender.send(amount)) {
            //重置金额为转账前数据
            pendingReturns[msg.sender] = amount;
            return false;
        }
        return true;
    }

    //拍卖结束
    function auctionEnd() public {
        //需要时间匹配
        require(now >= auctionEndTime, "Auction not yet ended.");
        //需要状态为未操作拍卖结束
        require(!ended, "AuctionEnd has already been called.");
        //置为结束状态
        ended = true;
        //发送拍卖结束事件
        emit AuctionEnded(highestBidder, highestBid);
        //向受益人打钱
        //transfer调用者为接收eth的地址
        beneficiary.transfer(highestBid);
    }
}