/**
 *Submitted for verification at Etherscan.io on 2022-11-30
*/

// SPDX-License-Identifier: MIT
/* Smartcontract author: @TonyBoyDeFi
Genesis project contract on Ethereum blockchain */
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUniswapV3Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV3Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

// Uniswap & Pancakeswap Router

interface IUniswapV3Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV3Router02 is IUniswapV3Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract KWorld is ERC20, Ownable {
    // using SafeMath for uint256;

    IUniswapV3Router02 public uniswapV3Router;
    address public uniswapV3Pair;
    bool private swapping;

    address public marketingWallet;
    address public DevWallet;
    address public rewardWallet;
    address autoLiquidityReceiver;

    // uint256 public percentForMarketing = 50;
    // bool public buyBackEnabled = true;

    uint256 public swapTokensAtAmount;

    uint256 private tradingActiveBlock = 0;

    bool public tradingActive = true;
    bool public swapEnabled = true;

    uint256 public feeDivisor = 100;

    // uint256 public totalSellFees;
    uint256 public marketingSellFee;
    uint256 public devSellFee;
    uint256 public rewardSellFee;


    // uint256 public totalBuyFees;
    uint256 public marketingBuyFee;
    uint256 public devBuyFee;
    uint256 public LPBuyFee;

    uint256 private tokensForMarketing;
    uint256 private tokensForDev;
    uint256 private tokensForLP;
    uint256 private tokensForReward;

    mapping (address => bool) private _isExcludedFromFees;

    mapping (address => bool) public automatedMarketMakerPairs;

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
    event rewardWalletUpdated(address indexed newWallet, address indexed oldWallet);
    event WalletUpdated(address indexed newWallet, address indexed oldWallet);



    constructor() ERC20("KhabyWorld", "$KWorld"){

        address newOwner = address(0x027814f84608EDdbaAE145778A55651079E2b52d);

        // Total Supply minted once during deployment and never minted again | Set number in tokens
        uint256 totalSupply = 1_000_000_000 * (10**18);

        // Tokens for SwapAndLiquify and automated BuyBack | Set number in tokens
        swapTokensAtAmount = 7500 * (10**18);

        // Contracts Sell fees
        marketingSellFee = 3;
        devSellFee = 3;
        rewardSellFee = 3;
        // totalSellFees = marketingSellFee + devSellFee;

        // Contracts Buy fees
        marketingBuyFee = 1;
        devBuyFee = 1;
        LPBuyFee = 1;
        // totalBuyFees = marketingBuyFee + devBuyFee;

        // Project Marketing DevWallet | Updateable at a later point if necessary
        marketingWallet = address(0x94E709272FA55BB86e61C1Ec829Ba04f61128578);

        // Project Dev DevWallet | Updateable at a later point if necessary
        DevWallet = address(0xbCCA432372F1967B75B2acFCB2bfCe8F3C5EF629);

        autoLiquidityReceiver = 0x380F93819191cAC5FF4f49C4b4CB0C457ca13B28;

        rewardWallet = 0x380F93819191cAC5FF4f49C4b4CB0C457ca13B28;

        // Router settings for Ethereum:
        // Uniswap V3 mainnet: 0xE592427A0AEce92De3Edee1F18E0157C05861564
        // Uniswap V2 testnet: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        // Uniswap V2 mainnet: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D

        IUniswapV3Router02 _uniswapV3Router = IUniswapV3Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        address _uniswapV3Pair = IUniswapV3Factory(_uniswapV3Router.factory())
            .createPair(address(this), _uniswapV3Router.WETH());

        uniswapV3Router = _uniswapV3Router;
        uniswapV3Pair = _uniswapV3Pair;

        _setAutomatedMarketMakerPair(_uniswapV3Pair, true);

        excludeFromFees(newOwner, true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);
        excludeFromFees(autoLiquidityReceiver, true);

        _mint(newOwner, totalSupply);
        transferOwnership(newOwner);
    }

    receive() external payable {

    }

    // Change SwapAndLiquidy token swap amounts | Set number in exact tokens
    function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
          swapTokensAtAmount = newAmount * (10**18);
          return true;
      }


    // Exclude a wallet from all fees | Only for presale addresses, presale router and the deployer of the contract
    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);
    }

    // Exclude multiple wallets from all fees | Only for presale addresses, presale router and the deployer of the contract
    function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
        for(uint256 i = 0; i < accounts.length; i++) {
            _isExcludedFromFees[accounts[i]] = excluded;
        }

        emit ExcludeMultipleAccountsFromFees(accounts, excluded);
    }

    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
        require(pair != uniswapV3Pair, "The UniSwap pair cannot be removed from AutomatedMarketMakerPairs");
        _setAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    // Set a new project marketing wallet | DevWallet name can be changed to whatever suites the best
    function updateAutoLiquidityReceiver(address newAutoLiquidityReceiver) external onlyOwner {
        require(newAutoLiquidityReceiver != address(0), "cannot set to 0 address");
        excludeFromFees(newAutoLiquidityReceiver, true);
        autoLiquidityReceiver = newAutoLiquidityReceiver;
    }

    // Set a new project marketing wallet | DevWallet name can be changed to whatever suites the best
    function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
        require(newMarketingWallet != address(0), "cannot set to 0 address");
        excludeFromFees(newMarketingWallet, true);
        emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
        marketingWallet = newMarketingWallet;
    }

    // Set a new project marketing wallet | Reward wallet name can be changed to whatever suites the best
    function updateRewardWallet(address newRewardWallet) external onlyOwner {
        require(newRewardWallet != address(0), "cannot set to 0 address");
        excludeFromFees(newRewardWallet, true);
        emit rewardWalletUpdated(newRewardWallet, marketingWallet);
        rewardWallet = newRewardWallet;
    }

    // Set a new  wallet | DevWallet name can be changed to whatever suites the best
    function updateDevWallet(address newWallet) external onlyOwner {
        require(newWallet != address(0), "cannot set to 0 address");
        excludeFromFees(newWallet, true);
        emit WalletUpdated(newWallet, DevWallet);
        DevWallet = newWallet;
    }

    function isExcludedFromFees(address account) public view returns(bool) {
        return _isExcludedFromFees[account];
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

         if(amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if(!tradingActive || tradingActiveBlock + 2 >= block.number){
            require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is always active after deployment");
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if(
            canSwap &&
            swapEnabled &&
            !swapping &&
            !automatedMarketMakerPairs[from] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            swapping = true;
            swapBack();
            swapping = false;
        }

        bool takeFee = !swapping;


        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;


        if(takeFee){

            // Assets selling process
            if (automatedMarketMakerPairs[to] ){
                uint256 totalSellFees = marketingSellFee + devSellFee + rewardSellFee;
                fees = amount * totalSellFees/ feeDivisor;
                tokensForMarketing += fees * marketingSellFee / totalSellFees;
                tokensForDev += fees * devSellFee / totalSellFees;
                tokensForReward += fees * rewardSellFee / totalSellFees;
            }
            // Assets buying process
            else if(automatedMarketMakerPairs[from] ) {
                uint256 totalBuyFees = marketingBuyFee + devBuyFee + LPBuyFee;
                fees = amount * totalBuyFees / feeDivisor;
                tokensForMarketing += fees * marketingBuyFee / totalBuyFees;
                tokensForDev += fees * devBuyFee / totalBuyFees;
                tokensForLP += fees * LPBuyFee / totalBuyFees;
            }


            if(fees > 0){
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);

    }

    function swapEthForNativeToken(uint256 ethAmount) private {
        if(ethAmount > 0){
            address[] memory path = new address[](2);
            path[0] = uniswapV3Router.WETH();
            path[1] = address(this);

            uniswapV3Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
                0,
                path,
                address(marketingWallet),
                block.timestamp
            );
        }
    }

    function swapTokensForEth(uint256 tokenAmount) private {

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV3Router.WETH();

        _approve(address(this), address(uniswapV3Router), tokenAmount);

        uniswapV3Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );

    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {

        _approve(address(this), address(uniswapV3Router), tokenAmount);


        uniswapV3Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            autoLiquidityReceiver,
            block.timestamp
        );

    }

    // Automated buyback to fight sell pressure

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));
        uint256 totalTokensToSwap = tokensForMarketing + tokensForDev + tokensForReward + tokensForLP;

        if(contractBalance == 0 || totalTokensToSwap == 0) {return;}

        bool success;

        uint256 initialETHBalance = address(this).balance;

        swapTokensForEth(contractBalance - tokensForLP / 2);

        uint256 ethBalance = address(this).balance - (initialETHBalance);

        uint256 ethForMarketing = ethBalance * tokensForMarketing / totalTokensToSwap;
        uint256 ethForDev= ethBalance * tokensForDev / totalTokensToSwap;
        uint256 ethForReward = ethBalance * tokensForReward / totalTokensToSwap;

        (success,) = address(DevWallet).call{value: ethForDev}("");
        (success,) = address(rewardWallet).call{value: ethForReward}("");
        (success,) = address(marketingWallet).call{value: ethForMarketing}("");

        if(tokensForLP / 2 > 0 && address(this).balance > 0)
            addLiquidity(tokensForLP / 2, address(this).balance);       // add liquidity
    }

    // Recovery functions for stuck native balances and accidentally sent ERC20 tokens

    // Function to recover stuck ETH from the contract address. Only callable by the owner
    function recoverContractETH() external onlyOwner {
        (bool success,) = address(msg.sender).call{value: address(this).balance}("Stuck ETH balance from contract address recovered");
        require(success, "Failed. Either caller is not the owner or address is not the contract address");
    }

    // Function to recover stuck or accidentaly sent ERC20 tokens from the contract
    function recoverERC20Token(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success){
    return ERC20(tokenAddress).transfer(msg.sender, tokens);
    }
}