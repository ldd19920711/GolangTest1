//声明编译器版本
pragma solidity ^0.6.0;
//声明使用任意嵌套数组和结构体进行编码和解码
pragma experimental ABIEncoderV2;

//投票例子
contract Ballot {
    //结构体
    //构建一个选民,包含了选民的一些属性
    struct Voter {
        //权重,表示当前选民可以投票的数量
        uint256 weight;
        //表示当前选民是否已经投过了
        bool voted;
        //表示当前选票是否委托给他人,如果委托了,则该参数=被委托人地址
        address delegate;
        //表示投票对应的提案索引
        uint256 vote;
    }
    //结构体
    //构建一个提案
    struct Proposal {
        //提案名称
        string name;
        //已经得到的票数
        uint256 voteCount;
    }
    //合约创建者
    //public会自动创建get方法
    address public chairperson;
    //映射,用来存储用户地址+选民
    mapping(address => Voter) public voters;
    //数据,用来存储提案列表
    Proposal[] public proposals;
    //投票事件
    event VoteEvent(address sender, uint256 proposal, uint256 vote);
    //授权投票事件
    event ApproveVoteEvent(address voter, uint256 vote);
    //构造方法
    //会在合约构建时执行
    constructor(string[] memory proposalNames) public {
        //确定合约所有者
        chairperson = msg.sender;
        //未所有者权重数+1
        voters[chairperson].weight = 1;
        //参数proposalNames用户添加提案列表
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
            name : proposalNames[i],
            voteCount : 0
            }));
        }
    }

    //授权用户投票权限
    function giveRightToVote(address voter) public {
        //需要合约所有者才能执行此方法
        //require类似断言,如果不符合条件会执行失败,终止执行，撤销所有对状态和以太币余额的改动。
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote");
        //需要该用户从未投过票
        require(
            !voters[voter].voted,
            "The voter already voted"
        );
        //需要该用户从未授权
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
        //发送授权成功事件
        emit ApproveVoteEvent(voter, voters[voter].weight);
    }
    //委托,将你的选票权限委托给to地址
    function delegate(address to) public {
        //拿到调用者的选民数据,storage表示会对源数据进行修改
        Voter storage sender = voters[msg.sender];
        //需要调用者从未投票
        require(!sender.voted, "You already voted.");
        //需要被委托人不是自己
        require(to != msg.sender, "Self-delegation is disallowed");
        //如果被委托人已经委托给他人,需要向上传递委托权限
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Found loop in delegation.");
        }
        //委托成功
        //将调用者选民置为已投票
        sender.voted = true;
        //将调用者委托地址置为to地址
        sender.delegate = to;
        //拿到被委托人选民
        Voter storage delegate_ = voters[to];
        //如果被委托人已经投过票,则直接对投过票的提案票数+调用者选民的权重
        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            //如果没有投过票,则被委托人选民权重+调用者选民的权重
            delegate_.weight += sender.weight;
        }
    }
    //投票
    //proposal 提案索引
    function vote(uint256 proposal) public {
        //拿到调用者选民
        Voter storage sender = voters[msg.sender];
        //需要从未投票
        require(!sender.voted, "Already voted.");
        //需要选票权重>0
        require(sender.weight > 0, "Weight must > 0.");
        //投票成功
        //置为已经投票
        sender.voted = true;
        //投票提案索引填充
        sender.vote = proposal;
        //提案得票数+选民权重
        proposals[proposal].voteCount += sender.weight;
        //发送投票事件
        emit VoteEvent(msg.sender, proposal, sender.weight);
    }
    //查询得票最多的提案索引
    function winningProposal() public view returns (uint256){
        uint256 winningVoteCount = 0;
        uint256 winningProposal_;
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
        return winningProposal_;
    }
    //查询得票最多的提案名称
    function winnerName() public view returns (string memory){
        return proposals[winningProposal()].name;
    }

}