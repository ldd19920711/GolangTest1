pragma solidity ^0.6.0;

//一个简单的ERC20合约
//is类似继承
contract XyToken is IERC20 {
    //引用库合约
    using SafeMath for uint256;
    //存储地址对应余额
    mapping(address => uint256) private _balances;
    //存储地址对应(地址+授权数量)
    mapping(address => mapping(address => uint256)) private _allowed;
    //发行量
    uint256 private _totalSupply;
    //ERC20代币名称
    string public symbol;
    //合约所有者
    address private owner;
    //构造器
    //部署时指定代币名称,所有者地址=合约部署人地址
    constructor(string memory _symbol) public {
        symbol = _symbol;
        owner = msg.sender;
    }
    //铸造代币
    //onlyOwner表示只有合约所有者能调用
    function mint(address to, uint256 value) public onlyOwner {
        //增加发行量
        _totalSupply = _totalSupply.add(value);
        //给对应的地址增加余额
        _balances[to] = _balances[to].add(value);
        //发送转账事件
        emit Transfer(address(0), to, value);
    }
    //函数修饰器,等同于在方法内插入require语句
    modifier onlyOwner(){
        require(msg.sender == owner,"必须是合约所有者");
        _;
    }
    //查询发行量
    function totalSupply() override public view returns (uint256){
        return _totalSupply;
    }
    //查询余额
    function balanceOf(address user) override public view returns (uint256){
        return _balances[user];
    }
    //授权
    function approve(address spender, uint256 value) override public returns (bool){
        require(spender != address(0));
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    //查询授权数量
    function allowance(address user, address spender) override public view returns (uint256){
        return _allowed[user][spender];
    }
    //授权转账
    function transferFrom(address from, address to, uint256 value) override public returns (bool){
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }
    //普通转账
    function transfer(address to, uint256 value) override public returns (bool){
        require(value <= _balances[msg.sender]);
        require(to != address(0));
        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }
}

interface IERC20 {
    // 查询发行量
    function totalSupply() external view returns (uint256);
    // 查询余额
    function balanceOf(address who) external view returns (uint256);
    // 授权余额查询
    function allowance(address owner, address spender) external view returns (uint256);
    // 转账
    function transfer(address to, uint256 value) external returns (bool);
    // 授权
    function approve(address spender, uint256 value) external returns (bool);
    // 利用授权转账
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    // Transfer事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    // approve事件
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {

    /**
     * @dev Multiplies two numbers, throws on overflow.
     * @param _a Factor number.
     * @param _b Factor number.
     */
    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
        if (_a == 0) {
            return 0;
        }
        uint256 c = _a * _b;
        assert(c / _a == _b);
        return c;
    }

    /**
     * @dev Integer division of two numbers, truncating the quotient.
     * @param _a Dividend number.
     * @param _b Divisor number.
     */
    function div(uint256 _a, uint256 _b) internal pure returns (uint256){
        uint256 c = _a / _b;
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
     * @param _a Minuend number.
     * @param _b Subtrahend number.
     */
    function sub(uint256 _a, uint256 _b) internal pure returns (uint256){
        assert(_b <= _a);
        return _a - _b;
    }

    /**
     * @dev Adds two numbers, throws on overflow.
     * @param _a Number.
     * @param _b Number.
     */
    function add(uint256 _a, uint256 _b) internal pure returns (uint256){
        uint256 c = _a + _b;
        assert(c >= _a);
        return c;
    }
}
