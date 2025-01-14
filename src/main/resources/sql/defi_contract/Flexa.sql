INSERT INTO defi_contracts
(contract_name, contract_address, primary_category, secondary_category,
	source_code,
	source_code_tree,
	source_code_scan_result)
VALUES('Amp', '0xff20817765cb7f73d4bde2e66e067e58d11095c2', '交易功能类', '支付',
$$
/**
 *Submitted for verification at Etherscan.io on 2020-08-28
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.6.10;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Ownable is a contract the provides contract ownership functionality, including a two-
 * phase transfer.
 */
contract Ownable {
    address private _owner;
    address private _authorizedNewOwner;

    /**
     * @notice Emitted when the owner authorizes ownership transfer to a new address
     * @param authorizedAddress New owner address
     */
    event OwnershipTransferAuthorization(address indexed authorizedAddress);

    /**
     * @notice Emitted when the authorized address assumed ownership
     * @param oldValue Old owner
     * @param newValue New owner
     */
    event OwnerUpdate(address indexed oldValue, address indexed newValue);

    /**
     * @notice Sets the owner to the sender / contract creator
     */
    constructor() internal {
        _owner = msg.sender;
    }

    /**
     * @notice Retrieves the owner of the contract
     * @return The contract owner
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @notice Retrieves the authorized new owner of the contract
     * @return The authorized new contract owner
     */
    function authorizedNewOwner() public view returns (address) {
        return _authorizedNewOwner;
    }

    /**
     * @notice Authorizes the transfer of ownership from owner to the provided address.
     * NOTE: No transfer will occur unless authorizedAddress calls assumeOwnership().
     * This authorization may be removed by another call to this function authorizing the zero
     * address.
     * @param _authorizedAddress The address authorized to become the new owner
     */
    function authorizeOwnershipTransfer(address _authorizedAddress) external {
        require(msg.sender == _owner, "Invalid sender");

        _authorizedNewOwner = _authorizedAddress;

        emit OwnershipTransferAuthorization(_authorizedNewOwner);
    }

    /**
     * @notice Transfers ownership of this contract to the _authorizedNewOwner
     * @dev Error invalid sender.
     */
    function assumeOwnership() external {
        require(msg.sender == _authorizedNewOwner, "Invalid sender");

        address oldValue = _owner;
        _owner = _authorizedNewOwner;
        _authorizedNewOwner = address(0);

        emit OwnerUpdate(oldValue, _owner);
    }
}

abstract contract ERC1820Registry {
    function setInterfaceImplementer(
        address _addr,
        bytes32 _interfaceHash,
        address _implementer
    ) external virtual;

    function getInterfaceImplementer(address _addr, bytes32 _interfaceHash)
        external
        virtual
        view
        returns (address);

    function setManager(address _addr, address _newManager) external virtual;

    function getManager(address _addr) public virtual view returns (address);
}

/// Base client to interact with the registry.
contract ERC1820Client {
    ERC1820Registry constant ERC1820REGISTRY = ERC1820Registry(
        0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24
    );

    function setInterfaceImplementation(
        string memory _interfaceLabel,
        address _implementation
    ) internal {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
        ERC1820REGISTRY.setInterfaceImplementer(
            address(this),
            interfaceHash,
            _implementation
        );
    }

    function interfaceAddr(address addr, string memory _interfaceLabel)
        internal
        view
        returns (address)
    {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
        return ERC1820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
    }

    function delegateManagement(address _newManager) internal {
        ERC1820REGISTRY.setManager(address(this), _newManager);
    }
}

contract ERC1820Implementer {
    /**
     * @dev ERC1820 well defined magic value indicating the contract has
     * registered with the ERC1820Registry that it can implement an interface.
     */
    bytes32 constant ERC1820_ACCEPT_MAGIC = keccak256(
        abi.encodePacked("ERC1820_ACCEPT_MAGIC")
    );

    /**
     * @dev Mapping of interface name keccak256 hashes for which this contract
     * implements the interface.
     * @dev Only settable internally.
     */
    mapping(bytes32 => bool) internal _interfaceHashes;

    /**
     * @notice Indicates whether the contract implements the interface `_interfaceHash`
     * for the address `_addr`.
     * @param _interfaceHash keccak256 hash of the name of the interface.
     * @return ERC1820_ACCEPT_MAGIC only if the contract implements `ìnterfaceHash`
     * for the address `_addr`.
     * @dev In this implementation, the `_addr` (the address for which the
     * contract will implement the interface) is always `address(this)`.
     */
    function canImplementInterfaceForAddress(
        bytes32 _interfaceHash,
        address // Comments to avoid compilation warnings for unused variables. /*addr*/
    ) external view returns (bytes32) {
        if (_interfaceHashes[_interfaceHash]) {
            return ERC1820_ACCEPT_MAGIC;
        } else {
            return "";
        }
    }

    /**
     * @notice Internally set the fact this contract implements the interface
     * identified by `_interfaceLabel`
     * @param _interfaceLabel String representation of the interface.
     */
    function _setInterface(string memory _interfaceLabel) internal {
        _interfaceHashes[keccak256(abi.encodePacked(_interfaceLabel))] = true;
    }
}

/**
 * @title IAmpTokensSender
 * @dev IAmpTokensSender token transfer hook interface
 */
interface IAmpTokensSender {
    /**
     * @dev Report if the transfer will succeed from the pespective of the
     * token sender
     */
    function canTransfer(
        bytes4 functionSig,
        bytes32 partition,
        address operator,
        address from,
        address to,
        uint256 value,
        bytes calldata data,
        bytes calldata operatorData
    ) external view returns (bool);

    /**
     * @dev Hook executed upon a transfer on behalf of the sender
     */
    function tokensToTransfer(
        bytes4 functionSig,
        bytes32 partition,
        address operator,
        address from,
        address to,
        uint256 value,
        bytes calldata data,
        bytes calldata operatorData
    ) external;
}

/**
 * @title IAmpTokensRecipient
 * @dev IAmpTokensRecipient token transfer hook interface
 */
interface IAmpTokensRecipient {
    /**
     * @dev Report if the recipient will successfully receive the tokens
     */
    function canReceive(
        bytes4 functionSig,
        bytes32 partition,
        address operator,
        address from,
        address to,
        uint256 value,
        bytes calldata data,
        bytes calldata operatorData
    ) external view returns (bool);

    /**
     * @dev Hook executed upon a transfer to the recipient
     */
    function tokensReceived(
        bytes4 functionSig,
        bytes32 partition,
        address operator,
        address from,
        address to,
        uint256 value,
        bytes calldata data,
        bytes calldata operatorData
    ) external;
}

/**
 * @notice Partition strategy validator hooks for Amp
 */
interface IAmpPartitionStrategyValidator {
    function tokensFromPartitionToValidate(
        bytes4 _functionSig,
        bytes32 _partition,
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes calldata _data,
        bytes calldata _operatorData
    ) external;

    function tokensToPartitionToValidate(
        bytes4 _functionSig,
        bytes32 _partition,
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes calldata _data,
        bytes calldata _operatorData
    ) external;

    function isOperatorForPartitionScope(
        bytes32 _partition,
        address _operator,
        address _tokenHolder
    ) external view returns (bool);
}

/**
 * @title PartitionUtils
 * @notice Partition related helper functions.
 */

library PartitionUtils {
    bytes32 public constant CHANGE_PARTITION_FLAG = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    /**
     * @notice Retrieve the destination partition from the 'data' field.
     * A partition change is requested ONLY when 'data' starts with the flag:
     *
     *   0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
     *
     * When the flag is detected, the destination partition is extracted from the
     * 32 bytes following the flag.
     * @param _data Information attached to the transfer. Will contain the
     * destination partition if a change is requested.
     * @param _fallbackPartition Partition value to return if a partition change
     * is not requested in the `_data`.
     * @return toPartition Destination partition. If the `_data` does not contain
     * the prefix and bytes32 partition in the first 64 bytes, the method will
     * return the provided `_fromPartition`.
     */
    function _getDestinationPartition(bytes memory _data, bytes32 _fallbackPartition)
        internal
        pure
        returns (bytes32)
    {
        if (_data.length < 64) {
            return _fallbackPartition;
        }

        (bytes32 flag, bytes32 toPartition) = abi.decode(_data, (bytes32, bytes32));
        if (flag == CHANGE_PARTITION_FLAG) {
            return toPartition;
        }

        return _fallbackPartition;
    }

    /**
     * @notice Helper to get the strategy identifying prefix from the `_partition`.
     * @param _partition Partition to get the prefix for.
     * @return 4 byte partition strategy prefix.
     */
    function _getPartitionPrefix(bytes32 _partition) internal pure returns (bytes4) {
        return bytes4(_partition);
    }

    /**
     * @notice Helper method to split the partition into the prefix, sub partition
     * and partition owner components.
     * @param _partition The partition to split into parts.
     * @return The 4 byte partition prefix, 8 byte sub partition, and final 20
     * bytes representing an address.
     */
    function _splitPartition(bytes32 _partition)
        internal
        pure
        returns (
            bytes4,
            bytes8,
            address
        )
    {
        bytes4 prefix = bytes4(_partition);
        bytes8 subPartition = bytes8(_partition << 32);
        address addressPart = address(uint160(uint256(_partition)));
        return (prefix, subPartition, addressPart);
    }

    /**
     * @notice Helper method to get a partition strategy ERC1820 interface name
     * based on partition prefix.
     * @param _prefix 4 byte partition prefix.
     * @dev Each 4 byte prefix has a unique interface name so that an individual
     * hook implementation can be set for each prefix.
     */
    function _getPartitionStrategyValidatorIName(bytes4 _prefix)
        internal
        pure
        returns (string memory)
    {
        return string(abi.encodePacked("AmpPartitionStrategyValidator", _prefix));
    }
}

/**
 * @title ErrorCodes
 * @notice Amp error codes.
 */
contract ErrorCodes {
    string internal EC_50_TRANSFER_FAILURE = "50";
    string internal EC_51_TRANSFER_SUCCESS = "51";
    string internal EC_52_INSUFFICIENT_BALANCE = "52";
    string internal EC_53_INSUFFICIENT_ALLOWANCE = "53";

    string internal EC_56_INVALID_SENDER = "56";
    string internal EC_57_INVALID_RECEIVER = "57";
    string internal EC_58_INVALID_OPERATOR = "58";

    string internal EC_59_INSUFFICIENT_RIGHTS = "59";

    string internal EC_5A_INVALID_SWAP_TOKEN_ADDRESS = "5A";
    string internal EC_5B_INVALID_VALUE_0 = "5B";
    string internal EC_5C_ADDRESS_CONFLICT = "5C";
    string internal EC_5D_PARTITION_RESERVED = "5D";
    string internal EC_5E_PARTITION_PREFIX_CONFLICT = "5E";
    string internal EC_5F_INVALID_PARTITION_PREFIX_0 = "5F";
    string internal EC_60_SWAP_TRANSFER_FAILURE = "60";
}

interface ISwapToken {
    function allowance(address owner, address spender)
        external
        view
        returns (uint256 remaining);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool success);
}

/**
 * @title Amp
 * @notice Amp is an ERC20 compatible collateral token designed to support
 * multiple classes of collateralization systems.
 * @dev The Amp token contract includes the following features:
 *
 * Partitions
 *   Tokens can be segmented within a given address by "partition", which in
 *   pracice is a 32 byte identifier. These partitions can have unique
 *   permissions globally, through the using of partition strategies, and
 *   locally, on a per address basis. The ability to create the sub-segments
 *   of tokens and assign special behavior gives collateral managers
 *   flexibility in how they are implemented.
 *
 * Operators
 *   Inspired by ERC777, Amp allows token holders to assign "operators" on
 *   all (or any number of partitions) of their tokens. Operators are allowed
 *   to execute transfers on behalf of token owners without the need to use the
 *   ERC20 "allowance" semantics.
 *
 * Transfers with Data
 *   Inspired by ERC777, Amp transfers can include arbitrary data, as well as
 *   operator data. This data can be used to change the partition of tokens,
 *   be used by collateral manager hooks to validate a transfer, be propagated
 *   via event to an off chain system, etc.
 *
 * Token Transfer Hooks on Send and Receive
 *   Inspired by ERC777, Amp uses the ERC1820 Registry to allow collateral
 *   manager implementations to register hooks to be called upon sending to
 *   or transferring from the collateral manager's address or, using partition
 *   strategies, owned partition space. The hook implementations can be used
 *   to validate transfer properties, gate transfers, emit custom events,
 *   update local state, etc.
 *
 * Collateral Management Partition Strategies
 *   Amp is able to define certain sets of partitions, identified by a 4 byte
 *   prefix, that will allow special, custom logic to be executed when transfers
 *   are made to or from those partitions. This opens up the possibility of
 *   entire classes of collateral management systems that would not be possible
 *   without it.
 *
 * These features give collateral manager implementers flexibility while
 * providing a consistent, "collateral-in-place", interface for interacting
 * with collateral systems directly through the Amp contract.
 */
contract Amp is IERC20, ERC1820Client, ERC1820Implementer, ErrorCodes, Ownable {
    using SafeMath for uint256;

    /**************************************************************************/
    /********************** ERC1820 Interface Constants ***********************/

    /**
     * @dev AmpToken interface label.
     */
    string internal constant AMP_INTERFACE_NAME = "AmpToken";

    /**
     * @dev ERC20Token interface label.
     */
    string internal constant ERC20_INTERFACE_NAME = "ERC20Token";

    /**
     * @dev AmpTokensSender interface label.
     */
    string internal constant AMP_TOKENS_SENDER = "AmpTokensSender";

    /**
     * @dev AmpTokensRecipient interface label.
     */
    string internal constant AMP_TOKENS_RECIPIENT = "AmpTokensRecipient";

    /**
     * @dev AmpTokensChecker interface label.
     */
    string internal constant AMP_TOKENS_CHECKER = "AmpTokensChecker";

    /**************************************************************************/
    /*************************** Token properties *****************************/

    /**
     * @dev Token name (Amp).
     */
    string internal _name;

    /**
     * @dev Token symbol (AMP).
     */
    string internal _symbol;

    /**
     * @dev Total minted supply of token. This will increase comensurately with
     * successful swaps of the swap token.
     */
    uint256 internal _totalSupply;

    /**
     * @dev The granularity of the token. Hard coded to 1.
     */
    uint256 internal constant _granularity = 1;

    /**************************************************************************/
    /***************************** Token mappings *****************************/

    /**
     * @dev Mapping from tokenHolder to balance. This reflects the balance
     * across all partitions of an address.
     */
    mapping(address => uint256) internal _balances;

    /**************************************************************************/
    /************************** Partition mappings ****************************/

    /**
     * @dev List of active partitions. This list reflects all partitions that
     * have tokens assigned to them.
     */
    bytes32[] internal _totalPartitions;

    /**
     * @dev Mapping from partition to their index.
     */
    mapping(bytes32 => uint256) internal _indexOfTotalPartitions;

    /**
     * @dev Mapping from partition to global balance of corresponding partition.
     */
    mapping(bytes32 => uint256) public totalSupplyByPartition;

    /**
     * @dev Mapping from tokenHolder to their partitions.
     */
    mapping(address => bytes32[]) internal _partitionsOf;

    /**
     * @dev Mapping from (tokenHolder, partition) to their index.
     */
    mapping(address => mapping(bytes32 => uint256)) internal _indexOfPartitionsOf;

    /**
     * @dev Mapping from (tokenHolder, partition) to balance of corresponding
     * partition.
     */
    mapping(address => mapping(bytes32 => uint256)) internal _balanceOfByPartition;

    /**
     * @notice Default partition of the token.
     * @dev All ERC20 operations operate solely on this partition.
     */
    bytes32
        public constant defaultPartition = 0x0000000000000000000000000000000000000000000000000000000000000000;

    /**
     * @dev Zero partition prefix. Parititions with this prefix can not have
     * a strategy assigned, and partitions with a different prefix must have one.
     */
    bytes4 internal constant ZERO_PREFIX = 0x00000000;

    /**************************************************************************/
    /***************************** Operator mappings **************************/

    /**
     * @dev Mapping from (tokenHolder, operator) to authorized status. This is
     * specific to the token holder.
     */
    mapping(address => mapping(address => bool)) internal _authorizedOperator;

    /**************************************************************************/
    /********************** Partition operator mappings ***********************/

    /**
     * @dev Mapping from (partition, tokenHolder, spender) to allowed value.
     * This is specific to the token holder.
     */
    mapping(bytes32 => mapping(address => mapping(address => uint256)))
        internal _allowedByPartition;

    /**
     * @dev Mapping from (tokenHolder, partition, operator) to 'approved for
     * partition' status. This is specific to the token holder.
     */
    mapping(address => mapping(bytes32 => mapping(address => bool)))
        internal _authorizedOperatorByPartition;

    /**************************************************************************/
    /********************** Collateral Manager mappings ***********************/
    /**
     * @notice Collection of registered collateral managers.
     */
    address[] public collateralManagers;
    /**
     * @dev Mapping of collateral manager addresses to registration status.
     */
    mapping(address => bool) internal _isCollateralManager;

    /**************************************************************************/
    /********************* Partition Strategy mappings ************************/

    /**
     * @notice Collection of reserved partition strategies.
     */
    bytes4[] public partitionStrategies;

    /**
     * @dev Mapping of partition strategy flag to registration status.
     */
    mapping(bytes4 => bool) internal _isPartitionStrategy;

    /**************************************************************************/
    /***************************** Swap storage *******************************/

    /**
     * @notice Swap token address. Immutable.
     */
    ISwapToken public swapToken;

    /**
     * @notice Swap token graveyard address.
     * @dev This is the address that the incoming swapped tokens will be
     * forwarded to upon successfully minting Amp.
     */
    address
        public constant swapTokenGraveyard = 0x000000000000000000000000000000000000dEaD;

    /**************************************************************************/
    /** EVENTS ****************************************************************/
    /**************************************************************************/

    /**************************************************************************/
    /**************************** Transfer Events *****************************/

    /**
     * @notice Emitted when a transfer has been successfully completed.
     * @param fromPartition The partition the tokens were transfered from.
     * @param operator The address that initiated the transfer.
     * @param from The address the tokens were transferred from.
     * @param to The address the tokens were transferred to.
     * @param value The amount of tokens transferred.
     * @param data Additional metadata included with the transfer. Can include
     * the partition the tokens were transferred to (if different than
     * `fromPartition`).
     * @param operatorData Additional metadata included with the transfer on
     * behalf of the operator.
     */
    event TransferByPartition(
        bytes32 indexed fromPartition,
        address operator,
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data,
        bytes operatorData
    );

    /**
     * @notice Emitted when a transfer has been successfully completed and the
     * tokens that were transferred have changed partitions.
     * @param fromPartition The partition the tokens were transfered from.
     * @param toPartition The partition the tokens were transfered to.
     * @param value The amount of tokens transferred.
     */
    event ChangedPartition(
        bytes32 indexed fromPartition,
        bytes32 indexed toPartition,
        uint256 value
    );

    /**************************************************************************/
    /**************************** Operator Events *****************************/

    /**
     * @notice Emitted when a token holder specifies an amount of tokens in a
     * a partition that an operator can transfer.
     * @param partition The partition of the tokens the holder has authorized the
     * operator to transfer from.
     * @param owner The token holder.
     * @param spender The operator the `owner` has authorized the allowance for.
     */
    event ApprovalByPartition(
        bytes32 indexed partition,
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @notice Emitted when a token holder has authorized an operator for their
     * tokens.
     * @dev This event applies to the token holder address across all partitions.
     * @param operator The address that was authorized to transfer tokens on
     * behalf of the `tokenHolder`.
     * @param tokenHolder The address that authorized the `operator` to transfer
     * their tokens.
     */
    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);

    /**
     * @notice Emitted when a token holder has de-authorized an operator from
     * transferring their tokens.
     * @dev This event applies to the token holder address across all partitions.
     * @param operator The address that was de-authorized from transferring tokens
     * on behalf of the `tokenHolder`.
     * @param tokenHolder The address that revoked the `operator`'s permission
     * to transfer their tokens.
     */
    event RevokedOperator(address indexed operator, address indexed tokenHolder);

    /**
     * @notice Emitted when a token holder has authorized an operator to transfer
     * their tokens of one partition.
     * @param partition The partition the `operator` is allowed to transfer
     * tokens from.
     * @param operator The address that was authorized to transfer tokens on
     * behalf of the `tokenHolder`.
     * @param tokenHolder The address that authorized the `operator` to transfer
     * their tokens in `partition`.
     */
    event AuthorizedOperatorByPartition(
        bytes32 indexed partition,
        address indexed operator,
        address indexed tokenHolder
    );

    /**
     * @notice Emitted when a token holder has de-authorized an operator from
     * transferring their tokens from a specific partition.
     * @param partition The partition the `operator` is no longer allowed to
     * transfer tokens from on behalf of the `tokenHolder`.
     * @param operator The address that was de-authorized from transferring
     * tokens on behalf of the `tokenHolder`.
     * @param tokenHolder The address that revoked the `operator`'s permission
     * to transfer their tokens from `partition`.
     */
    event RevokedOperatorByPartition(
        bytes32 indexed partition,
        address indexed operator,
        address indexed tokenHolder
    );

    /**************************************************************************/
    /********************** Collateral Manager Events *************************/

    /**
     * @notice Emitted when a collateral manager has been registered.
     * @param collateralManager The address of the collateral manager.
     */
    event CollateralManagerRegistered(address collateralManager);

    /**************************************************************************/
    /*********************** Partition Strategy Events ************************/

    /**
     * @notice Emitted when a new partition strategy validator is set.
     * @param flag The 4 byte prefix of the partitions that the stratgy affects.
     * @param name The name of the partition strategy.
     * @param implementation The address of the partition strategy hook
     * implementation.
     */
    event PartitionStrategySet(bytes4 flag, string name, address indexed implementation);

    // ************** Mint & Swap **************

    /**
     * @notice Emitted when tokens are minted as a result of a token swap
     * @param operator Address that executed the swap that resulted in tokens being minted
     * @param to Address that received the newly minted tokens.
     * @param value Amount of tokens minted
     * @param data Empty bytes, required for interface compatibility
     */
    event Minted(address indexed operator, address indexed to, uint256 value, bytes data);

    /**
     * @notice Indicates tokens swapped for Amp.
     * @dev The tokens that are swapped for Amp will be transferred to a
     * graveyard address that is for all practical purposes inaccessible.
     * @param operator Address that executed the swap.
     * @param from Address that the tokens were swapped from, and Amp minted for.
     * @param value Amount of tokens swapped into Amp.
     */
    event Swap(address indexed operator, address indexed from, uint256 value);

    /**************************************************************************/
    /** CONSTRUCTOR ***********************************************************/
    /**************************************************************************/

    /**
     * @notice Initialize Amp, initialize the default partition, and register the
     * contract implementation in the global ERC1820Registry.
     * @param _swapTokenAddress_ The address of the ERC20 token that is set to be
     * swappable for Amp.
     * @param _name_ Name of the token.
     * @param _symbol_ Symbol of the token.
     */
    constructor(
        address _swapTokenAddress_,
        string memory _name_,
        string memory _symbol_
    ) public {
        // "Swap token cannot be 0 address"
        require(_swapTokenAddress_ != address(0), EC_5A_INVALID_SWAP_TOKEN_ADDRESS);
        swapToken = ISwapToken(_swapTokenAddress_);

        _name = _name_;
        _symbol = _symbol_;
        _totalSupply = 0;

        // Add the default partition to the total partitions on deploy
        _addPartitionToTotalPartitions(defaultPartition);

        // Register contract in ERC1820 registry
        ERC1820Client.setInterfaceImplementation(AMP_INTERFACE_NAME, address(this));
        ERC1820Client.setInterfaceImplementation(ERC20_INTERFACE_NAME, address(this));

        // Indicate token verifies Amp and ERC20 interfaces
        ERC1820Implementer._setInterface(AMP_INTERFACE_NAME);
        ERC1820Implementer._setInterface(ERC20_INTERFACE_NAME);
    }

    /**************************************************************************/
    /** EXTERNAL FUNCTIONS (ERC20) ********************************************/
    /**************************************************************************/

    /**
     * @notice Get the total number of issued tokens.
     * @return Total supply of tokens currently in circulation.
     */
    function totalSupply() external override view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @notice Get the balance of the account with address `_tokenHolder`.
     * @dev This returns the balance of the holder across all partitions. Note
     * that due to other functionality in Amp, this figure should not be used
     * as the arbiter of the amount a token holder will successfully be able to
     * send via the ERC20 compatible `transfer` method. In order to get that
     * figure, use `balanceOfByParition` and to get the balance of the default
     * partition.
     * @param _tokenHolder Address for which the balance is returned.
     * @return Amount of token held by `_tokenHolder` in the default partition.
     */
    function balanceOf(address _tokenHolder) external override view returns (uint256) {
        return _balances[_tokenHolder];
    }

    /**
     * @notice Transfer token for a specified address.
     * @dev This method is for ERC20 compatibility, and only affects the
     * balance of the `msg.sender` address's default partition.
     * @param _to The address to transfer to.
     * @param _value The value to be transferred.
     * @return A boolean that indicates if the operation was successful.
     */
    function transfer(address _to, uint256 _value) external override returns (bool) {
        _transferByDefaultPartition(msg.sender, msg.sender, _to, _value, "");
        return true;
    }

    /**
     * @notice Transfer tokens from one address to another.
     * @dev This method is for ERC20 compatibility, and only affects the
     * balance and allowance of the `_from` address's default partition.
     * @param _from The address which you want to transfer tokens from.
     * @param _to The address which you want to transfer to.
     * @param _value The amount of tokens to be transferred.
     * @return A boolean that indicates if the operation was successful.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override returns (bool) {
        _transferByDefaultPartition(msg.sender, _from, _to, _value, "");
        return true;
    }

    /**
     * @notice Check the value of tokens that an owner allowed to a spender.
     * @dev This method is for ERC20 compatibility, and only affects the
     * allowance of the `msg.sender`'s default partition.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the value of tokens still available for the
     * spender.
     */
    function allowance(address _owner, address _spender)
        external
        override
        view
        returns (uint256)
    {
        return _allowedByPartition[defaultPartition][_owner][_spender];
    }

    /**
     * @notice Approve the passed address to spend the specified amount of
     * tokens from the default partition on behalf of 'msg.sender'.
     * @dev This method is for ERC20 compatibility, and only affects the
     * allowance of the `msg.sender`'s default partition.
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     * @return A boolean that indicates if the operation was successful.
     */
    function approve(address _spender, uint256 _value) external override returns (bool) {
        _approveByPartition(defaultPartition, msg.sender, _spender, _value);
        return true;
    }

    /**
     * @notice Atomically increases the allowance granted to `_spender` by the
     * for caller.
     * @dev This is an alternative to {approve} that can be used as a mitigation
     * problems described in {IERC20-approve}.
     * Emits an {Approval} event indicating the updated allowance.
     * Requirements:
     * - `_spender` cannot be the zero address.
     * @dev This method is for ERC20 compatibility, and only affects the
     * allowance of the `msg.sender`'s default partition.
     * @param _spender Operator allowed to transfer the tokens
     * @param _addedValue Additional amount of the `msg.sender`s tokens `_spender`
     * is allowed to transfer
     * @return 'true' is successful, 'false' otherwise
     */
    function increaseAllowance(address _spender, uint256 _addedValue)
        external
        returns (bool)
    {
        _approveByPartition(
            defaultPartition,
            msg.sender,
            _spender,
            _allowedByPartition[defaultPartition][msg.sender][_spender].add(_addedValue)
        );
        return true;
    }

    /**
     * @notice Atomically decreases the allowance granted to `_spender` by the
     * caller.
     * @dev This is an alternative to {approve} that can be used as a mitigation
     * for bugs caused by reentrancy.
     * Emits an {Approval} event indicating the updated allowance.
     * Requirements:
     * - `_spender` cannot be the zero address.
     * - `_spender` must have allowance for the caller of at least
     * `_subtractedValue`.
     * @dev This method is for ERC20 compatibility, and only affects the
     * allowance of the `msg.sender`'s default partition.
     * @param _spender Operator allowed to transfer the tokens
     * @param _subtractedValue Amount of the `msg.sender`s tokens `_spender`
     * is no longer allowed to transfer
     * @return 'true' is successful, 'false' otherwise
     */
    function decreaseAllowance(address _spender, uint256 _subtractedValue)
        external
        returns (bool)
    {
        _approveByPartition(
            defaultPartition,
            msg.sender,
            _spender,
            _allowedByPartition[defaultPartition][msg.sender][_spender].sub(
                _subtractedValue
            )
        );
        return true;
    }

    /**************************************************************************/
    /** EXTERNAL FUNCTIONS (AMP) **********************************************/
    /**************************************************************************/

    /******************************** Swap  ***********************************/

    /**
     * @notice Swap tokens to mint AMP.
     * @dev Requires `_from` to have given allowance of swap token to contract.
     * Otherwise will throw error code 53 (Insuffient Allowance).
     * @param _from Token holder to execute the swap for.
     */
    function swap(address _from) public {
        uint256 amount = swapToken.allowance(_from, address(this));
        require(amount > 0, EC_53_INSUFFICIENT_ALLOWANCE);

        require(
            swapToken.transferFrom(_from, swapTokenGraveyard, amount),
            EC_60_SWAP_TRANSFER_FAILURE
        );

        _mint(msg.sender, _from, amount);

        emit Swap(msg.sender, _from, amount);
    }

    /**************************************************************************/
    /************************** Holder information ****************************/

    /**
     * @notice Get balance of a tokenholder for a specific partition.
     * @param _partition Name of the partition.
     * @param _tokenHolder Address for which the balance is returned.
     * @return Amount of token of partition `_partition` held by `_tokenHolder` in the token contract.
     */
    function balanceOfByPartition(bytes32 _partition, address _tokenHolder)
        external
        view
        returns (uint256)
    {
        return _balanceOfByPartition[_tokenHolder][_partition];
    }

    /**
     * @notice Get partitions index of a token holder.
     * @param _tokenHolder Address for which the partitions index are returned.
     * @return Array of partitions index of '_tokenHolder'.
     */
    function partitionsOf(address _tokenHolder) external view returns (bytes32[] memory) {
        return _partitionsOf[_tokenHolder];
    }

    /**************************************************************************/
    /************************** Advanced Transfers ****************************/

    /**
     * @notice Transfer tokens from a specific partition on behalf of a token
     * holder, optionally changing the parittion and optionally including
     * arbitrary data with the transfer.
     * @dev This can be used to transfer an address's own tokens, or transfer
     * a different addresses tokens by specifying the `_from` param. If
     * attempting to transfer from a different address than `msg.sender`, the
     * `msg.sender` will need to be an operator or have enough allowance for the
     * `_partition` of the `_from` address.
     * @param _partition Name of the partition to transfer from.
     * @param _from Token holder.
     * @param _to Token recipient.
     * @param _value Number of tokens to transfer.
     * @param _data Information attached to the transfer. Will contain the
     * destination partition (if changing partitions).
     * @param _operatorData Information attached to the transfer, by the operator.
     * @return Destination partition.
     */
    function transferByPartition(
        bytes32 _partition,
        address _from,
        address _to,
        uint256 _value,
        bytes calldata _data,
        bytes calldata _operatorData
    ) external returns (bytes32) {
        return
            _transferByPartition(
                _partition,
                msg.sender,
                _from,
                _to,
                _value,
                _data,
                _operatorData
            );
    }

    /**************************************************************************/
    /************************** Operator Management ***************************/

    /**
     * @notice Set a third party operator address as an operator of 'msg.sender'
     * to transfer and redeem tokens on its behalf.
     * @dev The msg.sender is always an operator for itself, and does not need to
     * be explicitly added.
     * @param _operator Address to set as an operator for 'msg.sender'.
     */
    function authorizeOperator(address _operator) external {
        require(_operator != msg.sender, EC_58_INVALID_OPERATOR);

        _authorizedOperator[msg.sender][_operator] = true;
        emit AuthorizedOperator(_operator, msg.sender);
    }

    /**
     * @notice Remove the right of the operator address to be an operator for
     * 'msg.sender' and to transfer and redeem tokens on its behalf.
     * @dev The msg.sender is always an operator for itself, and cannot be
     * removed.
     * @param _operator Address to rescind as an operator for 'msg.sender'.
     */
    function revokeOperator(address _operator) external {
        require(_operator != msg.sender, EC_58_INVALID_OPERATOR);

        _authorizedOperator[msg.sender][_operator] = false;
        emit RevokedOperator(_operator, msg.sender);
    }

    /**
     * @notice Set `_operator` as an operator for 'msg.sender' for a given partition.
     * @dev The msg.sender is always an operator for itself, and does not need to
     * be explicitly added to a partition.
     * @param _partition Name of the partition.
     * @param _operator Address to set as an operator for 'msg.sender'.
     */
    function authorizeOperatorByPartition(bytes32 _partition, address _operator)
        external
    {
        require(_operator != msg.sender, EC_58_INVALID_OPERATOR);

        _authorizedOperatorByPartition[msg.sender][_partition][_operator] = true;
        emit AuthorizedOperatorByPartition(_partition, _operator, msg.sender);
    }

    /**
     * @notice Remove the right of the operator address to be an operator on a
     * given partition for 'msg.sender' and to transfer and redeem tokens on its
     * behalf.
     * @dev The msg.sender is always an operator for itself, and cannot be
     * removed from a partition.
     * @param _partition Name of the partition.
     * @param _operator Address to rescind as an operator on given partition for
     * 'msg.sender'.
     */
    function revokeOperatorByPartition(bytes32 _partition, address _operator) external {
        require(_operator != msg.sender, EC_58_INVALID_OPERATOR);

        _authorizedOperatorByPartition[msg.sender][_partition][_operator] = false;
        emit RevokedOperatorByPartition(_partition, _operator, msg.sender);
    }

    /**************************************************************************/
    /************************** Operator Information **************************/
    /**
     * @notice Indicate whether the `_operator` address is an operator of the
     * `_tokenHolder` address.
     * @dev An operator in this case is an operator across all of the partitions
     * of the `msg.sender` address.
     * @param _operator Address which may be an operator of `_tokenHolder`.
     * @param _tokenHolder Address of a token holder which may have the
     * `_operator` address as an operator.
     * @return 'true' if operator is an operator of 'tokenHolder' and 'false'
     * otherwise.
     */
    function isOperator(address _operator, address _tokenHolder)
        external
        view
        returns (bool)
    {
        return _isOperator(_operator, _tokenHolder);
    }

    /**
     * @notice Indicate whether the operator address is an operator of the
     * `_tokenHolder` address for the given partition.
     * @param _partition Name of the partition.
     * @param _operator Address which may be an operator of tokenHolder for the
     * given partition.
     * @param _tokenHolder Address of a token holder which may have the
     * `_operator` address as an operator for the given partition.
     * @return 'true' if 'operator' is an operator of `_tokenHolder` for
     * partition '_partition' and 'false' otherwise.
     */
    function isOperatorForPartition(
        bytes32 _partition,
        address _operator,
        address _tokenHolder
    ) external view returns (bool) {
        return _isOperatorForPartition(_partition, _operator, _tokenHolder);
    }

    /**
     * @notice Indicate when the `_operator` address is an operator of the
     * `_collateralManager` address for the given partition.
     * @dev This method is the same as `isOperatorForPartition`, except that it
     * also requires the address that `_operator` is being checked for MUST be
     * a registered collateral manager, and this method will not execute
     * partition strategy operator check hooks.
     * @param _partition Name of the partition.
     * @param _operator Address which may be an operator of `_collateralManager`
     * for the given partition.
     * @param _collateralManager Address of a collateral manager which may have
     * the `_operator` address as an operator for the given partition.
     */
    function isOperatorForCollateralManager(
        bytes32 _partition,
        address _operator,
        address _collateralManager
    ) external view returns (bool) {
        return
            _isCollateralManager[_collateralManager] &&
            (_isOperator(_operator, _collateralManager) ||
                _authorizedOperatorByPartition[_collateralManager][_partition][_operator]);
    }

    /**************************************************************************/
    /***************************** Token metadata *****************************/
    /**
     * @notice Get the name of the token (Amp).
     * @return Name of the token.
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @notice Get the symbol of the token (AMP).
     * @return Symbol of the token.
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @notice Get the number of decimals of the token.
     * @dev Hard coded to 18.
     * @return The number of decimals of the token (18).
     */
    function decimals() external pure returns (uint8) {
        return uint8(18);
    }

    /**
     * @notice Get the smallest part of the token that’s not divisible.
     * @dev Hard coded to 1.
     * @return The smallest non-divisible part of the token.
     */
    function granularity() external pure returns (uint256) {
        return _granularity;
    }

    /**
     * @notice Get list of existing partitions.
     * @return Array of all exisiting partitions.
     */
    function totalPartitions() external view returns (bytes32[] memory) {
        return _totalPartitions;
    }

    /************************************************************************************************/
    /******************************** Partition Token Allowances ************************************/
    /**
     * @notice Check the value of tokens that an owner allowed to a spender.
     * @param _partition Name of the partition.
     * @param _owner The address which owns the tokens.
     * @param _spender The address which will spend the tokens.
     * @return The value of tokens still for the spender to transfer.
     */
    function allowanceByPartition(
        bytes32 _partition,
        address _owner,
        address _spender
    ) external view returns (uint256) {
        return _allowedByPartition[_partition][_owner][_spender];
    }

    /**
     * @notice Approve the `_spender` address to spend the specified amount of
     * tokens in `_partition` on behalf of 'msg.sender'.
     * @param _partition Name of the partition.
     * @param _spender The address which will spend the tokens.
     * @param _value The amount of tokens to be tokens.
     * @return A boolean that indicates if the operation was successful.
     */
    function approveByPartition(
        bytes32 _partition,
        address _spender,
        uint256 _value
    ) external returns (bool) {
        _approveByPartition(_partition, msg.sender, _spender, _value);
        return true;
    }

    /**
     * @notice Atomically increases the allowance granted to `_spender` by the
     * caller.
     * @dev This is an alternative to {approveByPartition} that can be used as
     * a mitigation for bugs caused by reentrancy.
     * Emits an {ApprovalByPartition} event indicating the updated allowance.
     * Requirements:
     * - `_spender` cannot be the zero address.
     * @param _partition Name of the partition.
     * @param _spender Operator allowed to transfer the tokens
     * @param _addedValue Additional amount of the `msg.sender`s tokens `_spender`
     * is allowed to transfer
     * @return 'true' is successful, 'false' otherwise
     */
    function increaseAllowanceByPartition(
        bytes32 _partition,
        address _spender,
        uint256 _addedValue
    ) external returns (bool) {
        _approveByPartition(
            _partition,
            msg.sender,
            _spender,
            _allowedByPartition[_partition][msg.sender][_spender].add(_addedValue)
        );
        return true;
    }

    /**
     * @notice Atomically decreases the allowance granted to `_spender` by the
     * caller.
     * @dev This is an alternative to {approveByPartition} that can be used as
     * a mitigation for bugs caused by reentrancy.
     * Emits an {ApprovalByPartition} event indicating the updated allowance.
     * Requirements:
     * - `_spender` cannot be the zero address.
     * - `_spender` must have allowance for the caller of at least
     * `_subtractedValue`.
     * @param _spender Operator allowed to transfer the tokens
     * @param _subtractedValue Amount of the `msg.sender`s tokens `_spender` is
     * no longer allowed to transfer
     * @return 'true' is successful, 'false' otherwise
     */
    function decreaseAllowanceByPartition(
        bytes32 _partition,
        address _spender,
        uint256 _subtractedValue
    ) external returns (bool) {
        // TOOD: Figure out if safe math will panic below 0
        _approveByPartition(
            _partition,
            msg.sender,
            _spender,
            _allowedByPartition[_partition][msg.sender][_spender].sub(_subtractedValue)
        );
        return true;
    }

    /**************************************************************************/
    /************************ Collateral Manager Admin ************************/

    /**
     * @notice Allow a collateral manager to self-register.
     * @dev Error 0x5c.
     */
    function registerCollateralManager() external {
        // Short circuit a double registry
        require(!_isCollateralManager[msg.sender], EC_5C_ADDRESS_CONFLICT);

        collateralManagers.push(msg.sender);
        _isCollateralManager[msg.sender] = true;

        emit CollateralManagerRegistered(msg.sender);
    }

    /**
     * @notice Get the status of a collateral manager.
     * @param _collateralManager The address of the collateral mananger in question.
     * @return 'true' if `_collateralManager` has self registered, 'false'
     * otherwise.
     */
    function isCollateralManager(address _collateralManager)
        external
        view
        returns (bool)
    {
        return _isCollateralManager[_collateralManager];
    }

    /**************************************************************************/
    /************************ Partition Strategy Admin ************************/
    /**
     * @notice Sets an implementation for a partition strategy identified by prefix.
     * @dev This is an administration method, callable only by the owner of the
     * Amp contract.
     * @param _prefix The 4 byte partition prefix the strategy applies to.
     * @param _implementation The address of the implementation of the strategy hooks.
     */
    function setPartitionStrategy(bytes4 _prefix, address _implementation) external {
        require(msg.sender == owner(), EC_56_INVALID_SENDER);
        require(!_isPartitionStrategy[_prefix], EC_5E_PARTITION_PREFIX_CONFLICT);
        require(_prefix != ZERO_PREFIX, EC_5F_INVALID_PARTITION_PREFIX_0);

        string memory iname = PartitionUtils._getPartitionStrategyValidatorIName(_prefix);

        ERC1820Client.setInterfaceImplementation(iname, _implementation);
        partitionStrategies.push(_prefix);
        _isPartitionStrategy[_prefix] = true;

        emit PartitionStrategySet(_prefix, iname, _implementation);
    }

    /**
     * @notice Return if a partition strategy has been reserved and has an
     * implementation registered.
     * @param _prefix The partition strategy identifier.
     * @return 'true' if the strategy has been registered, 'false' if not.
     */
    function isPartitionStrategy(bytes4 _prefix) external view returns (bool) {
        return _isPartitionStrategy[_prefix];
    }

    /**************************************************************************/
    /*************************** INTERNAL FUNCTIONS ***************************/
    /**************************************************************************/

    /**************************************************************************/
    /**************************** Token Transfers *****************************/

    /**
     * @dev Transfer tokens from a specific partition.
     * @param _fromPartition Partition of the tokens to transfer.
     * @param _operator The address performing the transfer.
     * @param _from Token holder.
     * @param _to Token recipient.
     * @param _value Number of tokens to transfer.
     * @param _data Information attached to the transfer. Contains the destination
     * partition if a partition change is requested.
     * @param _operatorData Information attached to the transfer, by the operator
     * (if any).
     * @return Destination partition.
     */
    function _transferByPartition(
        bytes32 _fromPartition,
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data,
        bytes memory _operatorData
    ) internal returns (bytes32) {
        require(_to != address(0), EC_57_INVALID_RECEIVER);

        // If the `_operator` is attempting to transfer from a different `_from`
        // address, first check that they have the requisite operator or
        // allowance permissions.
        if (_from != _operator) {
            require(
                _isOperatorForPartition(_fromPartition, _operator, _from) ||
                    (_value <= _allowedByPartition[_fromPartition][_from][_operator]),
                EC_53_INSUFFICIENT_ALLOWANCE
            );

            // If the sender has an allowance for the partition, that should
            // be decremented
            if (_allowedByPartition[_fromPartition][_from][_operator] >= _value) {
                _allowedByPartition[_fromPartition][_from][msg
                    .sender] = _allowedByPartition[_fromPartition][_from][_operator].sub(
                    _value
                );
            } else {
                _allowedByPartition[_fromPartition][_from][_operator] = 0;
            }
        }

        _callPreTransferHooks(
            _fromPartition,
            _operator,
            _from,
            _to,
            _value,
            _data,
            _operatorData
        );

        require(
            _balanceOfByPartition[_from][_fromPartition] >= _value,
            EC_52_INSUFFICIENT_BALANCE
        );

        bytes32 toPartition = PartitionUtils._getDestinationPartition(
            _data,
            _fromPartition
        );

        _removeTokenFromPartition(_from, _fromPartition, _value);
        _addTokenToPartition(_to, toPartition, _value);
        _callPostTransferHooks(
            toPartition,
            _operator,
            _from,
            _to,
            _value,
            _data,
            _operatorData
        );

        emit Transfer(_from, _to, _value);
        emit TransferByPartition(
            _fromPartition,
            _operator,
            _from,
            _to,
            _value,
            _data,
            _operatorData
        );

        if (toPartition != _fromPartition) {
            emit ChangedPartition(_fromPartition, toPartition, _value);
        }

        return toPartition;
    }

    /**
     * @notice Transfer tokens from default partitions.
     * @dev Used as a helper method for ERC20 compatibility.
     * @param _operator The address performing the transfer.
     * @param _from Token holder.
     * @param _to Token recipient.
     * @param _value Number of tokens to transfer.
     * @param _data Information attached to the transfer, and intended for the
     * token holder (`_from`). Should contain the destination partition if
     * changing partitions.
     */
    function _transferByDefaultPartition(
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data
    ) internal {
        _transferByPartition(defaultPartition, _operator, _from, _to, _value, _data, "");
    }

    /**
     * @dev Remove a token from a specific partition.
     * @param _from Token holder.
     * @param _partition Name of the partition.
     * @param _value Number of tokens to transfer.
     */
    function _removeTokenFromPartition(
        address _from,
        bytes32 _partition,
        uint256 _value
    ) internal {
        if (_value == 0) {
            return;
        }

        _balances[_from] = _balances[_from].sub(_value);

        _balanceOfByPartition[_from][_partition] = _balanceOfByPartition[_from][_partition]
            .sub(_value);
        totalSupplyByPartition[_partition] = totalSupplyByPartition[_partition].sub(
            _value
        );

        // If the total supply is zero, finds and deletes the partition.
        // Do not delete the _defaultPartition from totalPartitions.
        if (totalSupplyByPartition[_partition] == 0 && _partition != defaultPartition) {
            _removePartitionFromTotalPartitions(_partition);
        }

        // If the balance of the TokenHolder's partition is zero, finds and
        // deletes the partition.
        if (_balanceOfByPartition[_from][_partition] == 0) {
            uint256 index = _indexOfPartitionsOf[_from][_partition];

            if (index == 0) {
                return;
            }

            // move the last item into the index being vacated
            bytes32 lastValue = _partitionsOf[_from][_partitionsOf[_from].length - 1];
            _partitionsOf[_from][index - 1] = lastValue; // adjust for 1-based indexing
            _indexOfPartitionsOf[_from][lastValue] = index;

            _partitionsOf[_from].pop();
            _indexOfPartitionsOf[_from][_partition] = 0;
        }
    }

    /**
     * @dev Add a token to a specific partition.
     * @param _to Token recipient.
     * @param _partition Name of the partition.
     * @param _value Number of tokens to transfer.
     */
    function _addTokenToPartition(
        address _to,
        bytes32 _partition,
        uint256 _value
    ) internal {
        if (_value == 0) {
            return;
        }

        _balances[_to] = _balances[_to].add(_value);

        if (_indexOfPartitionsOf[_to][_partition] == 0) {
            _partitionsOf[_to].push(_partition);
            _indexOfPartitionsOf[_to][_partition] = _partitionsOf[_to].length;
        }
        _balanceOfByPartition[_to][_partition] = _balanceOfByPartition[_to][_partition]
            .add(_value);

        if (_indexOfTotalPartitions[_partition] == 0) {
            _addPartitionToTotalPartitions(_partition);
        }
        totalSupplyByPartition[_partition] = totalSupplyByPartition[_partition].add(
            _value
        );
    }

    /**
     * @dev Add a partition to the total partitions collection.
     * @param _partition Name of the partition.
     */
    function _addPartitionToTotalPartitions(bytes32 _partition) internal {
        _totalPartitions.push(_partition);
        _indexOfTotalPartitions[_partition] = _totalPartitions.length;
    }

    /**
     * @dev Remove a partition to the total partitions collection.
     * @param _partition Name of the partition.
     */
    function _removePartitionFromTotalPartitions(bytes32 _partition) internal {
        uint256 index = _indexOfTotalPartitions[_partition];

        if (index == 0) {
            return;
        }

        // move the last item into the index being vacated
        bytes32 lastValue = _totalPartitions[_totalPartitions.length - 1];
        _totalPartitions[index - 1] = lastValue; // adjust for 1-based indexing
        _indexOfTotalPartitions[lastValue] = index;

        _totalPartitions.pop();
        _indexOfTotalPartitions[_partition] = 0;
    }

    /**************************************************************************/
    /********************************* Hooks **********************************/
    /**
     * @notice Check for and call the 'AmpTokensSender' hook on the sender address
     * (`_from`), and, if `_fromPartition` is within the scope of a strategy,
     * check for and call the 'AmpPartitionStrategy.tokensFromPartitionToTransfer'
     * hook for the strategy.
     * @param _fromPartition Name of the partition to transfer tokens from.
     * @param _operator Address which triggered the balance decrease (through
     * transfer).
     * @param _from Token holder.
     * @param _to Token recipient for a transfer.
     * @param _value Number of tokens the token holder balance is decreased by.
     * @param _data Extra information, pertaining to the `_from` address.
     * @param _operatorData Extra information, attached by the operator (if any).
     */
    function _callPreTransferHooks(
        bytes32 _fromPartition,
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data,
        bytes memory _operatorData
    ) internal {
        address senderImplementation;
        senderImplementation = interfaceAddr(_from, AMP_TOKENS_SENDER);
        if (senderImplementation != address(0)) {
            IAmpTokensSender(senderImplementation).tokensToTransfer(
                msg.sig,
                _fromPartition,
                _operator,
                _from,
                _to,
                _value,
                _data,
                _operatorData
            );
        }

        // Used to ensure that hooks implemented by a collateral manager to validate
        // transfers from it's owned partitions are called
        bytes4 fromPartitionPrefix = PartitionUtils._getPartitionPrefix(_fromPartition);
        if (_isPartitionStrategy[fromPartitionPrefix]) {
            address fromPartitionValidatorImplementation;
            fromPartitionValidatorImplementation = interfaceAddr(
                address(this),
                PartitionUtils._getPartitionStrategyValidatorIName(fromPartitionPrefix)
            );
            if (fromPartitionValidatorImplementation != address(0)) {
                IAmpPartitionStrategyValidator(fromPartitionValidatorImplementation)
                    .tokensFromPartitionToValidate(
                    msg.sig,
                    _fromPartition,
                    _operator,
                    _from,
                    _to,
                    _value,
                    _data,
                    _operatorData
                );
            }
        }
    }

    /**
     * @dev Check for 'AmpTokensRecipient' hook on the recipient and call it.
     * @param _toPartition Name of the partition the tokens were transferred to.
     * @param _operator Address which triggered the balance increase (through
     * transfer or mint).
     * @param _from Token holder for a transfer (0x when mint).
     * @param _to Token recipient.
     * @param _value Number of tokens the recipient balance is increased by.
     * @param _data Extra information related to the token holder (`_from`).
     * @param _operatorData Extra information attached by the operator (if any).
     */
    function _callPostTransferHooks(
        bytes32 _toPartition,
        address _operator,
        address _from,
        address _to,
        uint256 _value,
        bytes memory _data,
        bytes memory _operatorData
    ) internal {
        bytes4 toPartitionPrefix = PartitionUtils._getPartitionPrefix(_toPartition);
        if (_isPartitionStrategy[toPartitionPrefix]) {
            address partitionManagerImplementation;
            partitionManagerImplementation = interfaceAddr(
                address(this),
                PartitionUtils._getPartitionStrategyValidatorIName(toPartitionPrefix)
            );
            if (partitionManagerImplementation != address(0)) {
                IAmpPartitionStrategyValidator(partitionManagerImplementation)
                    .tokensToPartitionToValidate(
                    msg.sig,
                    _toPartition,
                    _operator,
                    _from,
                    _to,
                    _value,
                    _data,
                    _operatorData
                );
            }
        } else {
            require(toPartitionPrefix == ZERO_PREFIX, EC_5D_PARTITION_RESERVED);
        }

        address recipientImplementation;
        recipientImplementation = interfaceAddr(_to, AMP_TOKENS_RECIPIENT);

        if (recipientImplementation != address(0)) {
            IAmpTokensRecipient(recipientImplementation).tokensReceived(
                msg.sig,
                _toPartition,
                _operator,
                _from,
                _to,
                _value,
                _data,
                _operatorData
            );
        }
    }

    /**************************************************************************/
    /******************************* Allowance ********************************/
    /**
     * @notice Approve the `_spender` address to spend the specified amount of
     * tokens in `_partition` on behalf of 'msg.sender'.
     * @param _partition Name of the partition.
     * @param _tokenHolder Owner of the tokens.
     * @param _spender The address which will spend the tokens.
     * @param _amount The amount of tokens to be tokens.
     */
    function _approveByPartition(
        bytes32 _partition,
        address _tokenHolder,
        address _spender,
        uint256 _amount
    ) internal {
        require(_tokenHolder != address(0), EC_56_INVALID_SENDER);
        require(_spender != address(0), EC_58_INVALID_OPERATOR);

        _allowedByPartition[_partition][_tokenHolder][_spender] = _amount;
        emit ApprovalByPartition(_partition, _tokenHolder, _spender, _amount);

        if (_partition == defaultPartition) {
            emit Approval(_tokenHolder, _spender, _amount);
        }
    }

    /**************************************************************************/
    /************************** Operator Information **************************/
    /**
     * @dev Indicate whether the operator address is an operator of the
     * tokenHolder address. An operator in this case is an operator across all
     * partitions of the `msg.sender` address.
     * @param _operator Address which may be an operator of '_tokenHolder'.
     * @param _tokenHolder Address of a token holder which may have the '_operator'
     * address as an operator.
     * @return 'true' if `_operator` is an operator of `_tokenHolder` and 'false'
     * otherwise.
     */
    function _isOperator(address _operator, address _tokenHolder)
        internal
        view
        returns (bool)
    {
        return (_operator == _tokenHolder ||
            _authorizedOperator[_tokenHolder][_operator]);
    }

    /**
     * @dev Indicate whether the operator address is an operator of the
     * tokenHolder address for the given partition.
     * @param _partition Name of the partition.
     * @param _operator Address which may be an operator of tokenHolder for the
     * given partition.
     * @param _tokenHolder Address of a token holder which may have the operator
     * address as an operator for the given partition.
     * @return 'true' if 'operator' is an operator of 'tokenHolder' for partition
     * `_partition` and 'false' otherwise.
     */
    function _isOperatorForPartition(
        bytes32 _partition,
        address _operator,
        address _tokenHolder
    ) internal view returns (bool) {
        return (_isOperator(_operator, _tokenHolder) ||
            _authorizedOperatorByPartition[_tokenHolder][_partition][_operator] ||
            _callPartitionStrategyOperatorHook(_partition, _operator, _tokenHolder));
    }

    /**
     * @notice Check if the `_partition` is within the scope of a strategy, and
     * call it's isOperatorForPartitionScope hook if so.
     * @dev This allows implicit granting of operatorByPartition permissions
     * based on the partition being used being of a strategy.
     * @param _partition The partition to check.
     * @param _operator The address to check if is an operator for `_tokenHolder`.
     * @param _tokenHolder The address to validate that `_operator` is an
     * operator for.
     */
    function _callPartitionStrategyOperatorHook(
        bytes32 _partition,
        address _operator,
        address _tokenHolder
    ) internal view returns (bool) {
        bytes4 prefix = PartitionUtils._getPartitionPrefix(_partition);

        if (!_isPartitionStrategy[prefix]) {
            return false;
        }

        address strategyValidatorImplementation;
        strategyValidatorImplementation = interfaceAddr(
            address(this),
            PartitionUtils._getPartitionStrategyValidatorIName(prefix)
        );
        if (strategyValidatorImplementation != address(0)) {
            return
                IAmpPartitionStrategyValidator(strategyValidatorImplementation)
                    .isOperatorForPartitionScope(_partition, _operator, _tokenHolder);
        }

        // Not a partition format that imbues special operator rules
        return false;
    }

    /**************************************************************************/
    /******************************** Minting *********************************/
    /**
     * @notice Perform the minting of tokens.
     * @dev The tokens will be minted on behalf of the `_to` address, and will be
     * minted to the address's default partition.
     * @param _operator Address which triggered the issuance.
     * @param _to Token recipient.
     * @param _value Number of tokens issued.
     */
    function _mint(
        address _operator,
        address _to,
        uint256 _value
    ) internal {
        require(_to != address(0), EC_57_INVALID_RECEIVER);

        _totalSupply = _totalSupply.add(_value);
        _addTokenToPartition(_to, defaultPartition, _value);
        _callPostTransferHooks(
            defaultPartition,
            _operator,
            address(0),
            _to,
            _value,
            "",
            ""
        );

        emit Minted(_operator, _to, _value, "");
        emit Transfer(address(0), _to, _value);
        emit TransferByPartition(bytes32(0), _operator, address(0), _to, _value, "", "");
    }
}
$$,
$$
{
    "name": "SourceUnit",
    "attributes": {
        "absolutePath": "mainnet/0xff20817765cb7f73d4bde2e66e067e58d11095c2/Amp.sol",
        "exportedSymbols": "{'Amp': [2935], 'ERC1820Client': [482], 'ERC1820Implementer': [536], 'ERC1820Registry': [406], 'ErrorCodes': [848], 'IAmpPartitionStrategyValidator': [675], 'IAmpTokensRecipient': [624], 'IAmpTokensSender': [580], 'IERC20': [271], 'ISwapToken': [869], 'Ownable': [373], 'PartitionUtils': [801], 'SafeMath': [195]}",
        "id": 2936,
        "license": "MIT",
        "src": "35:80171:0"
    },
    "children": [
        {
            "name": "PragmaDirective",
            "attributes": {
                "id": 1,
                "literals": [
                    "solidity",
                    "0.6",
                    ".10"
                ],
                "src": "35:23:0"
            },
            "children": []
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "library",
                "documentation": "{'id': 2, 'nodeType': 'StructuredDocumentation', 'src': '62:575:0', 'text': \" @dev Wrappers over Solidity's arithmetic operations with added overflow\\n checks.\\n Arithmetic operations in Solidity wrap on overflow. This can easily result\\n in bugs, because programmers usually assume that an overflow raises an\\n error, which is the standard behavior in high level programming languages.\\n `SafeMath` restores this intuition by reverting the transaction when an\\n operation overflows.\\n Using this library instead of the unchecked operations eliminates an entire\\n class of bugs, so it's recommended to use it always.\"}",
                "fullyImplemented": true,
                "id": 195,
                "linearizedBaseContracts": [
                    195
                ],
                "name": "SafeMath",
                "scope": 2936,
                "src": "639:4722:0"
            },
            "children": [
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 27, 'nodeType': 'Block', 'src': '961:114:0', 'statements': [{'assignments': [13], 'declarations': [{'constant': False, 'id': 13, 'mutability': 'mutable', 'name': 'c', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 27, 'src': '972:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 12, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '972:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 17, 'initialValue': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 16, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 14, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 5, 'src': '984:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '+', 'rightExpression': {'argumentTypes': None, 'id': 15, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 7, 'src': '988:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '984:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '972:17:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 21, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 19, 'name': 'c', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '1008:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '>=', 'rightExpression': {'argumentTypes': None, 'id': 20, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 5, 'src': '1013:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '1008:6:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'hexValue': '536166654d6174683a206164646974696f6e206f766572666c6f77', 'id': 22, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1016:29:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a', 'typeString': 'literal_string \"SafeMath: addition overflow\"'}, 'value': 'SafeMath: addition overflow'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_30cc447bcc13b3e22b45cef0dd9b0b514842d836dd9b6eb384e20dedfb47723a', 'typeString': 'literal_string \"SafeMath: addition overflow\"'}], 'id': 18, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '1000:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 23, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1000:46:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 24, 'nodeType': 'ExpressionStatement', 'src': '1000:46:0'}, {'expression': {'argumentTypes': None, 'id': 25, 'name': 'c', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '1066:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 11, 'id': 26, 'nodeType': 'Return', 'src': '1059:8:0'}]}",
                        "documentation": "{'id': 3, 'nodeType': 'StructuredDocumentation', 'src': '663:225:0', 'text': \" @dev Returns the addition of two unsigned integers, reverting on\\n overflow.\\n Counterpart to Solidity's `+` operator.\\n Requirements:\\n - Addition cannot overflow.\"}",
                        "id": 28,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "add",
                        "overrides": null,
                        "parameters": "{'id': 8, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 5, 'mutability': 'mutable', 'name': 'a', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 28, 'src': '907:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 4, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '907:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 7, 'mutability': 'mutable', 'name': 'b', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 28, 'src': '918:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 6, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '918:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '906:22:0'}",
                        "returnParameters": "{'id': 11, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 10, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 28, 'src': '952:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 9, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '952:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '951:9:0'}",
                        "scope": 195,
                        "src": "894:181:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 44, 'nodeType': 'Block', 'src': '1417:69:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 39, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 31, 'src': '1439:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 40, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 33, 'src': '1442:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'hexValue': '536166654d6174683a207375627472616374696f6e206f766572666c6f77', 'id': 41, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1445:32:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862', 'typeString': 'literal_string \"SafeMath: subtraction overflow\"'}, 'value': 'SafeMath: subtraction overflow'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_stringliteral_50b058e9b5320e58880d88223c9801cd9eecdcf90323d5c2318bc1b6b916e862', 'typeString': 'literal_string \"SafeMath: subtraction overflow\"'}], 'id': 38, 'name': 'sub', 'nodeType': 'Identifier', 'overloadedDeclarations': [45, 73], 'referencedDeclaration': 73, 'src': '1435:3:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$_t_string_memory_ptr_$returns$_t_uint256_$', 'typeString': 'function (uint256,uint256,string memory) pure returns (uint256)'}}, 'id': 42, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1435:43:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 37, 'id': 43, 'nodeType': 'Return', 'src': '1428:50:0'}]}",
                        "documentation": "{'id': 29, 'nodeType': 'StructuredDocumentation', 'src': '1083:261:0', 'text': \" @dev Returns the subtraction of two unsigned integers, reverting on\\n overflow (when the result is negative).\\n Counterpart to Solidity's `-` operator.\\n Requirements:\\n - Subtraction cannot overflow.\"}",
                        "id": 45,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "sub",
                        "overrides": null,
                        "parameters": "{'id': 34, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 31, 'mutability': 'mutable', 'name': 'a', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 45, 'src': '1363:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 30, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1363:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 33, 'mutability': 'mutable', 'name': 'b', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 45, 'src': '1374:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 32, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1374:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '1362:22:0'}",
                        "returnParameters": "{'id': 37, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 36, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 45, 'src': '1408:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 35, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1408:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '1407:9:0'}",
                        "scope": 195,
                        "src": "1350:136:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 72, 'nodeType': 'Block', 'src': '1876:97:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 60, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 58, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 50, 'src': '1895:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '<=', 'rightExpression': {'argumentTypes': None, 'id': 59, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 48, 'src': '1900:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '1895:6:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 61, 'name': 'errorMessage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 52, 'src': '1903:12:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 57, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '1887:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 62, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1887:29:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 63, 'nodeType': 'ExpressionStatement', 'src': '1887:29:0'}, {'assignments': [65], 'declarations': [{'constant': False, 'id': 65, 'mutability': 'mutable', 'name': 'c', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 72, 'src': '1927:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 64, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1927:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 69, 'initialValue': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 68, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 66, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 48, 'src': '1939:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '-', 'rightExpression': {'argumentTypes': None, 'id': 67, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 50, 'src': '1943:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '1939:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '1927:17:0'}, {'expression': {'argumentTypes': None, 'id': 70, 'name': 'c', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 65, 'src': '1964:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 56, 'id': 71, 'nodeType': 'Return', 'src': '1957:8:0'}]}",
                        "documentation": "{'id': 46, 'nodeType': 'StructuredDocumentation', 'src': '1494:281:0', 'text': \" @dev Returns the subtraction of two unsigned integers, reverting with custom message on\\n overflow (when the result is negative).\\n Counterpart to Solidity's `-` operator.\\n Requirements:\\n - Subtraction cannot overflow.\"}",
                        "id": 73,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "sub",
                        "overrides": null,
                        "parameters": "{'id': 53, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 48, 'mutability': 'mutable', 'name': 'a', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 73, 'src': '1794:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 47, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1794:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 50, 'mutability': 'mutable', 'name': 'b', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 73, 'src': '1805:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 49, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1805:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 52, 'mutability': 'mutable', 'name': 'errorMessage', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 73, 'src': '1816:26:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 51, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '1816:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'src': '1793:50:0'}",
                        "returnParameters": "{'id': 56, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 55, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 73, 'src': '1867:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 54, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1867:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '1866:9:0'}",
                        "scope": 195,
                        "src": "1781:192:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 107, 'nodeType': 'Block', 'src': '2291:404:0', 'statements': [{'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 85, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 83, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 76, 'src': '2527:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 84, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2532:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '2527:6:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 89, 'nodeType': 'IfStatement', 'src': '2523:47:0', 'trueBody': {'id': 88, 'nodeType': 'Block', 'src': '2535:35:0', 'statements': [{'expression': {'argumentTypes': None, 'hexValue': '30', 'id': 86, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2557:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'functionReturnParameters': 82, 'id': 87, 'nodeType': 'Return', 'src': '2550:8:0'}]}}, {'assignments': [91], 'declarations': [{'constant': False, 'id': 91, 'mutability': 'mutable', 'name': 'c', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 107, 'src': '2582:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 90, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '2582:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 95, 'initialValue': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 94, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 92, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 76, 'src': '2594:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '*', 'rightExpression': {'argumentTypes': None, 'id': 93, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 78, 'src': '2598:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '2594:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '2582:17:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 101, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 99, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 97, 'name': 'c', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 91, 'src': '2618:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '/', 'rightExpression': {'argumentTypes': None, 'id': 98, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 76, 'src': '2622:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '2618:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'id': 100, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 78, 'src': '2627:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '2618:10:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'hexValue': '536166654d6174683a206d756c7469706c69636174696f6e206f766572666c6f77', 'id': 102, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2630:35:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3', 'typeString': 'literal_string \"SafeMath: multiplication overflow\"'}, 'value': 'SafeMath: multiplication overflow'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_9113bb53c2876a3805b2c9242029423fc540a728243ce887ab24c82cf119fba3', 'typeString': 'literal_string \"SafeMath: multiplication overflow\"'}], 'id': 96, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '2610:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 103, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2610:56:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 104, 'nodeType': 'ExpressionStatement', 'src': '2610:56:0'}, {'expression': {'argumentTypes': None, 'id': 105, 'name': 'c', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 91, 'src': '2686:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 82, 'id': 106, 'nodeType': 'Return', 'src': '2679:8:0'}]}",
                        "documentation": "{'id': 74, 'nodeType': 'StructuredDocumentation', 'src': '1981:237:0', 'text': \" @dev Returns the multiplication of two unsigned integers, reverting on\\n overflow.\\n Counterpart to Solidity's `*` operator.\\n Requirements:\\n - Multiplication cannot overflow.\"}",
                        "id": 108,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "mul",
                        "overrides": null,
                        "parameters": "{'id': 79, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 76, 'mutability': 'mutable', 'name': 'a', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 108, 'src': '2237:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 75, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '2237:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 78, 'mutability': 'mutable', 'name': 'b', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 108, 'src': '2248:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 77, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '2248:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '2236:22:0'}",
                        "returnParameters": "{'id': 82, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 81, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 108, 'src': '2282:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 80, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '2282:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '2281:9:0'}",
                        "scope": 195,
                        "src": "2224:471:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 124, 'nodeType': 'Block', 'src': '3230:65:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 119, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 111, 'src': '3252:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 120, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 113, 'src': '3255:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'hexValue': '536166654d6174683a206469766973696f6e206279207a65726f', 'id': 121, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3258:28:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_5b7cc70dda4dc2143e5adb63bd5d1f349504f461dbdfd9bc76fac1f8ca6d019f', 'typeString': 'literal_string \"SafeMath: division by zero\"'}, 'value': 'SafeMath: division by zero'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_stringliteral_5b7cc70dda4dc2143e5adb63bd5d1f349504f461dbdfd9bc76fac1f8ca6d019f', 'typeString': 'literal_string \"SafeMath: division by zero\"'}], 'id': 118, 'name': 'div', 'nodeType': 'Identifier', 'overloadedDeclarations': [125, 153], 'referencedDeclaration': 153, 'src': '3248:3:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$_t_string_memory_ptr_$returns$_t_uint256_$', 'typeString': 'function (uint256,uint256,string memory) pure returns (uint256)'}}, 'id': 122, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3248:39:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 117, 'id': 123, 'nodeType': 'Return', 'src': '3241:46:0'}]}",
                        "documentation": "{'id': 109, 'nodeType': 'StructuredDocumentation', 'src': '2703:454:0', 'text': \" @dev Returns the integer division of two unsigned integers. Reverts on\\n division by zero. The result is rounded towards zero.\\n Counterpart to Solidity's `/` operator. Note: this function uses a\\n `revert` opcode (which leaves remaining gas untouched) while Solidity\\n uses an invalid opcode to revert (consuming all remaining gas).\\n Requirements:\\n - The divisor cannot be zero.\"}",
                        "id": 125,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "div",
                        "overrides": null,
                        "parameters": "{'id': 114, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 111, 'mutability': 'mutable', 'name': 'a', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 125, 'src': '3176:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 110, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3176:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 113, 'mutability': 'mutable', 'name': 'b', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 125, 'src': '3187:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 112, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3187:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '3175:22:0'}",
                        "returnParameters": "{'id': 117, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 116, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 125, 'src': '3221:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 115, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3221:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '3220:9:0'}",
                        "scope": 195,
                        "src": "3163:132:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 152, 'nodeType': 'Block', 'src': '3878:250:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 140, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 138, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 130, 'src': '3964:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '>', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 139, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3968:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '3964:5:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 141, 'name': 'errorMessage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 132, 'src': '3971:12:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 137, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '3956:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 142, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3956:28:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 143, 'nodeType': 'ExpressionStatement', 'src': '3956:28:0'}, {'assignments': [145], 'declarations': [{'constant': False, 'id': 145, 'mutability': 'mutable', 'name': 'c', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 152, 'src': '3995:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 144, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3995:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 149, 'initialValue': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 148, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 146, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 128, 'src': '4007:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '/', 'rightExpression': {'argumentTypes': None, 'id': 147, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 130, 'src': '4011:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '4007:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '3995:17:0'}, {'expression': {'argumentTypes': None, 'id': 150, 'name': 'c', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 145, 'src': '4119:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 136, 'id': 151, 'nodeType': 'Return', 'src': '4112:8:0'}]}",
                        "documentation": "{'id': 126, 'nodeType': 'StructuredDocumentation', 'src': '3303:474:0', 'text': \" @dev Returns the integer division of two unsigned integers. Reverts with custom message on\\n division by zero. The result is rounded towards zero.\\n Counterpart to Solidity's `/` operator. Note: this function uses a\\n `revert` opcode (which leaves remaining gas untouched) while Solidity\\n uses an invalid opcode to revert (consuming all remaining gas).\\n Requirements:\\n - The divisor cannot be zero.\"}",
                        "id": 153,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "div",
                        "overrides": null,
                        "parameters": "{'id': 133, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 128, 'mutability': 'mutable', 'name': 'a', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 153, 'src': '3796:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 127, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3796:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 130, 'mutability': 'mutable', 'name': 'b', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 153, 'src': '3807:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 129, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3807:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 132, 'mutability': 'mutable', 'name': 'errorMessage', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 153, 'src': '3818:26:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 131, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '3818:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'src': '3795:50:0'}",
                        "returnParameters": "{'id': 136, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 135, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 153, 'src': '3869:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 134, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3869:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '3868:9:0'}",
                        "scope": 195,
                        "src": "3783:345:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 169, 'nodeType': 'Block', 'src': '4652:63:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 164, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 156, 'src': '4674:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 165, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 158, 'src': '4677:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'hexValue': '536166654d6174683a206d6f64756c6f206279207a65726f', 'id': 166, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '4680:26:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_726e51f7b81fce0a68f5f214f445e275313b20b1633f08ce954ee39abf8d7832', 'typeString': 'literal_string \"SafeMath: modulo by zero\"'}, 'value': 'SafeMath: modulo by zero'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_stringliteral_726e51f7b81fce0a68f5f214f445e275313b20b1633f08ce954ee39abf8d7832', 'typeString': 'literal_string \"SafeMath: modulo by zero\"'}], 'id': 163, 'name': 'mod', 'nodeType': 'Identifier', 'overloadedDeclarations': [170, 194], 'referencedDeclaration': 194, 'src': '4670:3:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$_t_string_memory_ptr_$returns$_t_uint256_$', 'typeString': 'function (uint256,uint256,string memory) pure returns (uint256)'}}, 'id': 167, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4670:37:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 162, 'id': 168, 'nodeType': 'Return', 'src': '4663:44:0'}]}",
                        "documentation": "{'id': 154, 'nodeType': 'StructuredDocumentation', 'src': '4136:443:0', 'text': \" @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\\n Reverts when dividing by zero.\\n Counterpart to Solidity's `%` operator. This function uses a `revert`\\n opcode (which leaves remaining gas untouched) while Solidity uses an\\n invalid opcode to revert (consuming all remaining gas).\\n Requirements:\\n - The divisor cannot be zero.\"}",
                        "id": 170,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "mod",
                        "overrides": null,
                        "parameters": "{'id': 159, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 156, 'mutability': 'mutable', 'name': 'a', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 170, 'src': '4598:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 155, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '4598:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 158, 'mutability': 'mutable', 'name': 'b', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 170, 'src': '4609:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 157, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '4609:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '4597:22:0'}",
                        "returnParameters": "{'id': 162, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 161, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 170, 'src': '4643:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 160, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '4643:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '4642:9:0'}",
                        "scope": 195,
                        "src": "4585:130:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 193, 'nodeType': 'Block', 'src': '5287:71:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 185, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 183, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 175, 'src': '5306:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 184, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '5311:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '5306:6:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 186, 'name': 'errorMessage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 177, 'src': '5314:12:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 182, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '5298:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 187, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '5298:29:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 188, 'nodeType': 'ExpressionStatement', 'src': '5298:29:0'}, {'expression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 191, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 189, 'name': 'a', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 173, 'src': '5345:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '%', 'rightExpression': {'argumentTypes': None, 'id': 190, 'name': 'b', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 175, 'src': '5349:1:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '5345:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 181, 'id': 192, 'nodeType': 'Return', 'src': '5338:12:0'}]}",
                        "documentation": "{'id': 171, 'nodeType': 'StructuredDocumentation', 'src': '4723:463:0', 'text': \" @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),\\n Reverts with custom message when dividing by zero.\\n Counterpart to Solidity's `%` operator. This function uses a `revert`\\n opcode (which leaves remaining gas untouched) while Solidity uses an\\n invalid opcode to revert (consuming all remaining gas).\\n Requirements:\\n - The divisor cannot be zero.\"}",
                        "id": 194,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "mod",
                        "overrides": null,
                        "parameters": "{'id': 178, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 173, 'mutability': 'mutable', 'name': 'a', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 194, 'src': '5205:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 172, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '5205:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 175, 'mutability': 'mutable', 'name': 'b', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 194, 'src': '5216:9:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 174, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '5216:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 177, 'mutability': 'mutable', 'name': 'errorMessage', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 194, 'src': '5227:26:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 176, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '5227:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'src': '5204:50:0'}",
                        "returnParameters": "{'id': 181, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 180, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 194, 'src': '5278:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 179, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '5278:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '5277:9:0'}",
                        "scope": 195,
                        "src": "5192:166:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "interface",
                "documentation": "{'id': 196, 'nodeType': 'StructuredDocumentation', 'src': '5365:72:0', 'text': ' @dev Interface of the ERC20 standard as defined in the EIP.'}",
                "fullyImplemented": false,
                "id": 271,
                "linearizedBaseContracts": [
                    271
                ],
                "name": "IERC20",
                "scope": 2936,
                "src": "5439:2635:0"
            },
            "children": [
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 197, 'nodeType': 'StructuredDocumentation', 'src': '5463:68:0', 'text': ' @dev Returns the amount of tokens in existence.'}",
                        "functionSelector": "18160ddd",
                        "id": 202,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "totalSupply",
                        "overrides": null,
                        "parameters": "{'id': 198, 'nodeType': 'ParameterList', 'parameters': [], 'src': '5557:2:0'}",
                        "returnParameters": "{'id': 201, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 200, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 202, 'src': '5583:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 199, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '5583:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '5582:9:0'}",
                        "scope": 271,
                        "src": "5537:55:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 203, 'nodeType': 'StructuredDocumentation', 'src': '5600:74:0', 'text': ' @dev Returns the amount of tokens owned by `account`.'}",
                        "functionSelector": "70a08231",
                        "id": 210,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "balanceOf",
                        "overrides": null,
                        "parameters": "{'id': 206, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 205, 'mutability': 'mutable', 'name': 'account', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 210, 'src': '5699:15:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 204, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '5699:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '5698:17:0'}",
                        "returnParameters": "{'id': 209, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 208, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 210, 'src': '5739:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 207, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '5739:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '5738:9:0'}",
                        "scope": 271,
                        "src": "5680:68:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 211, 'nodeType': 'StructuredDocumentation', 'src': '5756:215:0', 'text': \" @dev Moves `amount` tokens from the caller's account to `recipient`.\\n Returns a boolean value indicating whether the operation succeeded.\\n Emits a {Transfer} event.\"}",
                        "functionSelector": "a9059cbb",
                        "id": 220,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "transfer",
                        "overrides": null,
                        "parameters": "{'id': 216, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 213, 'mutability': 'mutable', 'name': 'recipient', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 220, 'src': '5995:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 212, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '5995:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 215, 'mutability': 'mutable', 'name': 'amount', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 220, 'src': '6014:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 214, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '6014:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '5994:35:0'}",
                        "returnParameters": "{'id': 219, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 218, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 220, 'src': '6048:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 217, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '6048:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '6047:6:0'}",
                        "scope": 271,
                        "src": "5977:77:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 221, 'nodeType': 'StructuredDocumentation', 'src': '6062:270:0', 'text': ' @dev Returns the remaining number of tokens that `spender` will be\\n allowed to spend on behalf of `owner` through {transferFrom}. This is\\n zero by default.\\n This value changes when {approve} or {transferFrom} are called.'}",
                        "functionSelector": "dd62ed3e",
                        "id": 230,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "allowance",
                        "overrides": null,
                        "parameters": "{'id': 226, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 223, 'mutability': 'mutable', 'name': 'owner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 230, 'src': '6357:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 222, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '6357:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 225, 'mutability': 'mutable', 'name': 'spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 230, 'src': '6372:15:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 224, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '6372:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '6356:32:0'}",
                        "returnParameters": "{'id': 229, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 228, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 230, 'src': '6412:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 227, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '6412:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '6411:9:0'}",
                        "scope": 271,
                        "src": "6338:83:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 231, 'nodeType': 'StructuredDocumentation', 'src': '6429:655:0', 'text': \" @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\\n Returns a boolean value indicating whether the operation succeeded.\\n IMPORTANT: Beware that changing an allowance with this method brings the risk\\n that someone may use both the old and the new allowance by unfortunate\\n transaction ordering. One possible solution to mitigate this race\\n condition is to first reduce the spender's allowance to 0 and set the\\n desired value afterwards:\\n https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\\n Emits an {Approval} event.\"}",
                        "functionSelector": "095ea7b3",
                        "id": 240,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "approve",
                        "overrides": null,
                        "parameters": "{'id': 236, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 233, 'mutability': 'mutable', 'name': 'spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 240, 'src': '7107:15:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 232, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '7107:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 235, 'mutability': 'mutable', 'name': 'amount', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 240, 'src': '7124:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 234, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '7124:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '7106:33:0'}",
                        "returnParameters": "{'id': 239, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 238, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 240, 'src': '7158:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 237, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '7158:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '7157:6:0'}",
                        "scope": 271,
                        "src": "7090:74:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 241, 'nodeType': 'StructuredDocumentation', 'src': '7172:304:0', 'text': \" @dev Moves `amount` tokens from `sender` to `recipient` using the\\n allowance mechanism. `amount` is then deducted from the caller's\\n allowance.\\n Returns a boolean value indicating whether the operation succeeded.\\n Emits a {Transfer} event.\"}",
                        "functionSelector": "23b872dd",
                        "id": 252,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "transferFrom",
                        "overrides": null,
                        "parameters": "{'id': 248, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 243, 'mutability': 'mutable', 'name': 'sender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 252, 'src': '7504:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 242, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '7504:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 245, 'mutability': 'mutable', 'name': 'recipient', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 252, 'src': '7520:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 244, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '7520:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 247, 'mutability': 'mutable', 'name': 'amount', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 252, 'src': '7539:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 246, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '7539:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '7503:51:0'}",
                        "returnParameters": "{'id': 251, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 250, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 252, 'src': '7573:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 249, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '7573:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '7572:6:0'}",
                        "scope": 271,
                        "src": "7482:97:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 253, 'nodeType': 'StructuredDocumentation', 'src': '7587:163:0', 'text': ' @dev Emitted when `value` tokens are moved from one account (`from`) to\\n another (`to`).\\n Note that `value` may be zero.'}",
                        "id": 261,
                        "name": "Transfer",
                        "parameters": "{'id': 260, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 255, 'indexed': True, 'mutability': 'mutable', 'name': 'from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 261, 'src': '7771:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 254, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '7771:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 257, 'indexed': True, 'mutability': 'mutable', 'name': 'to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 261, 'src': '7793:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 256, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '7793:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 259, 'indexed': False, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 261, 'src': '7813:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 258, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '7813:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '7770:57:0'}",
                        "src": "7756:72:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 262, 'nodeType': 'StructuredDocumentation', 'src': '7836:151:0', 'text': ' @dev Emitted when the allowance of a `spender` for an `owner` is set by\\n a call to {approve}. `value` is the new allowance.'}",
                        "id": 270,
                        "name": "Approval",
                        "parameters": "{'id': 269, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 264, 'indexed': True, 'mutability': 'mutable', 'name': 'owner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 270, 'src': '8008:21:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 263, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '8008:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 266, 'indexed': True, 'mutability': 'mutable', 'name': 'spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 270, 'src': '8031:23:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 265, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '8031:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 268, 'indexed': False, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 270, 'src': '8056:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 267, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '8056:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '8007:63:0'}",
                        "src": "7993:78:0"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "contract",
                "documentation": "{'id': 272, 'nodeType': 'StructuredDocumentation', 'src': '8078:125:0', 'text': ' @title Ownable is a contract the provides contract ownership functionality, including a two-\\n phase transfer.'}",
                "fullyImplemented": true,
                "id": 373,
                "linearizedBaseContracts": [
                    373
                ],
                "name": "Ownable",
                "scope": 2936,
                "src": "8205:2232:0"
            },
            "children": [
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 274,
                        "mutability": "mutable",
                        "name": "_owner",
                        "overrides": null,
                        "scope": 373,
                        "src": "8229:22:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_address', 'typeString': 'address'}",
                        "typeName": "{'id': 273, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '8229:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}",
                        "value": null,
                        "visibility": "private"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 276,
                        "mutability": "mutable",
                        "name": "_authorizedNewOwner",
                        "overrides": null,
                        "scope": 373,
                        "src": "8258:35:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_address', 'typeString': 'address'}",
                        "typeName": "{'id': 275, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '8258:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}",
                        "value": null,
                        "visibility": "private"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 277, 'nodeType': 'StructuredDocumentation', 'src': '8302:149:0', 'text': ' @notice Emitted when the owner authorizes ownership transfer to a new address\\n @param authorizedAddress New owner address'}",
                        "id": 281,
                        "name": "OwnershipTransferAuthorization",
                        "parameters": "{'id': 280, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 279, 'indexed': True, 'mutability': 'mutable', 'name': 'authorizedAddress', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 281, 'src': '8494:33:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 278, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '8494:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '8493:35:0'}",
                        "src": "8457:72:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 282, 'nodeType': 'StructuredDocumentation', 'src': '8537:150:0', 'text': ' @notice Emitted when the authorized address assumed ownership\\n @param oldValue Old owner\\n @param newValue New owner'}",
                        "id": 288,
                        "name": "OwnerUpdate",
                        "parameters": "{'id': 287, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 284, 'indexed': True, 'mutability': 'mutable', 'name': 'oldValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 288, 'src': '8711:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 283, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '8711:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 286, 'indexed': True, 'mutability': 'mutable', 'name': 'newValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 288, 'src': '8737:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 285, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '8737:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '8710:52:0'}",
                        "src": "8693:70:0"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 297, 'nodeType': 'Block', 'src': '8876:38:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 295, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 292, 'name': '_owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 274, 'src': '8887:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 293, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '8896:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 294, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '8896:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '8887:19:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 296, 'nodeType': 'ExpressionStatement', 'src': '8887:19:0'}]}",
                        "documentation": "{'id': 289, 'nodeType': 'StructuredDocumentation', 'src': '8771:76:0', 'text': ' @notice Sets the owner to the sender / contract creator'}",
                        "id": 298,
                        "implemented": true,
                        "kind": "constructor",
                        "modifiers": [],
                        "name": "",
                        "overrides": null,
                        "parameters": "{'id': 290, 'nodeType': 'ParameterList', 'parameters': [], 'src': '8864:2:0'}",
                        "returnParameters": "{'id': 291, 'nodeType': 'ParameterList', 'parameters': [], 'src': '8876:0:0'}",
                        "scope": 373,
                        "src": "8853:61:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 306, 'nodeType': 'Block', 'src': '9074:32:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 304, 'name': '_owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 274, 'src': '9092:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'functionReturnParameters': 303, 'id': 305, 'nodeType': 'Return', 'src': '9085:13:0'}]}",
                        "documentation": "{'id': 299, 'nodeType': 'StructuredDocumentation', 'src': '8922:99:0', 'text': ' @notice Retrieves the owner of the contract\\n @return The contract owner'}",
                        "functionSelector": "8da5cb5b",
                        "id": 307,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "owner",
                        "overrides": null,
                        "parameters": "{'id': 300, 'nodeType': 'ParameterList', 'parameters': [], 'src': '9041:2:0'}",
                        "returnParameters": "{'id': 303, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 302, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 307, 'src': '9065:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 301, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '9065:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '9064:9:0'}",
                        "scope": 373,
                        "src": "9027:79:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 315, 'nodeType': 'Block', 'src': '9309:45:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 313, 'name': '_authorizedNewOwner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 276, 'src': '9327:19:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'functionReturnParameters': 312, 'id': 314, 'nodeType': 'Return', 'src': '9320:26:0'}]}",
                        "documentation": "{'id': 308, 'nodeType': 'StructuredDocumentation', 'src': '9114:129:0', 'text': ' @notice Retrieves the authorized new owner of the contract\\n @return The authorized new contract owner'}",
                        "functionSelector": "5481eed3",
                        "id": 316,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "authorizedNewOwner",
                        "overrides": null,
                        "parameters": "{'id': 309, 'nodeType': 'ParameterList', 'parameters': [], 'src': '9276:2:0'}",
                        "returnParameters": "{'id': 312, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 311, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 316, 'src': '9300:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 310, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '9300:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '9299:9:0'}",
                        "scope": 373,
                        "src": "9249:105:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 338, 'nodeType': 'Block', 'src': '9823:188:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 326, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 323, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '9842:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 324, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '9842:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'id': 325, 'name': '_owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 274, 'src': '9856:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '9842:20:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'hexValue': '496e76616c69642073656e646572', 'id': 327, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '9864:16:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_691168f418fc5a4f61166421198b5a4bea266021eef8bf76cd53f1653d7b7ec0', 'typeString': 'literal_string \"Invalid sender\"'}, 'value': 'Invalid sender'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_691168f418fc5a4f61166421198b5a4bea266021eef8bf76cd53f1653d7b7ec0', 'typeString': 'literal_string \"Invalid sender\"'}], 'id': 322, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '9834:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 328, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '9834:47:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 329, 'nodeType': 'ExpressionStatement', 'src': '9834:47:0'}, {'expression': {'argumentTypes': None, 'id': 332, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 330, 'name': '_authorizedNewOwner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 276, 'src': '9894:19:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 331, 'name': '_authorizedAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 319, 'src': '9916:18:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '9894:40:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 333, 'nodeType': 'ExpressionStatement', 'src': '9894:40:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 335, 'name': '_authorizedNewOwner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 276, 'src': '9983:19:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 334, 'name': 'OwnershipTransferAuthorization', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 281, 'src': '9952:30:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$returns$__$', 'typeString': 'function (address)'}}, 'id': 336, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '9952:51:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 337, 'nodeType': 'EmitStatement', 'src': '9947:56:0'}]}",
                        "documentation": "{'id': 317, 'nodeType': 'StructuredDocumentation', 'src': '9362:382:0', 'text': ' @notice Authorizes the transfer of ownership from owner to the provided address.\\n NOTE: No transfer will occur unless authorizedAddress calls assumeOwnership().\\n This authorization may be removed by another call to this function authorizing the zero\\n address.\\n @param _authorizedAddress The address authorized to become the new owner'}",
                        "functionSelector": "87f4427e",
                        "id": 339,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "authorizeOwnershipTransfer",
                        "overrides": null,
                        "parameters": "{'id': 320, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 319, 'mutability': 'mutable', 'name': '_authorizedAddress', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 339, 'src': '9786:26:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 318, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '9786:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '9785:28:0'}",
                        "returnParameters": "{'id': 321, 'nodeType': 'ParameterList', 'parameters': [], 'src': '9823:0:0'}",
                        "scope": 373,
                        "src": "9750:261:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 371, 'nodeType': 'Block', 'src': '10188:246:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 347, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 344, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '10207:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 345, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '10207:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'id': 346, 'name': '_authorizedNewOwner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 276, 'src': '10221:19:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '10207:33:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'hexValue': '496e76616c69642073656e646572', 'id': 348, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '10242:16:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_691168f418fc5a4f61166421198b5a4bea266021eef8bf76cd53f1653d7b7ec0', 'typeString': 'literal_string \"Invalid sender\"'}, 'value': 'Invalid sender'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_691168f418fc5a4f61166421198b5a4bea266021eef8bf76cd53f1653d7b7ec0', 'typeString': 'literal_string \"Invalid sender\"'}], 'id': 343, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '10199:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 349, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '10199:60:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 350, 'nodeType': 'ExpressionStatement', 'src': '10199:60:0'}, {'assignments': [352], 'declarations': [{'constant': False, 'id': 352, 'mutability': 'mutable', 'name': 'oldValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 371, 'src': '10272:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 351, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10272:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'id': 354, 'initialValue': {'argumentTypes': None, 'id': 353, 'name': '_owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 274, 'src': '10291:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '10272:25:0'}, {'expression': {'argumentTypes': None, 'id': 357, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 355, 'name': '_owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 274, 'src': '10308:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 356, 'name': '_authorizedNewOwner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 276, 'src': '10317:19:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '10308:28:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 358, 'nodeType': 'ExpressionStatement', 'src': '10308:28:0'}, {'expression': {'argumentTypes': None, 'id': 364, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 359, 'name': '_authorizedNewOwner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 276, 'src': '10347:19:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 362, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '10377:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 361, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '10369:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 360, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10369:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 363, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '10369:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '10347:32:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 365, 'nodeType': 'ExpressionStatement', 'src': '10347:32:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 367, 'name': 'oldValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 352, 'src': '10409:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 368, 'name': '_owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 274, 'src': '10419:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 366, 'name': 'OwnerUpdate', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 288, 'src': '10397:11:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$returns$__$', 'typeString': 'function (address,address)'}}, 'id': 369, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '10397:29:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 370, 'nodeType': 'EmitStatement', 'src': '10392:34:0'}]}",
                        "documentation": "{'id': 340, 'nodeType': 'StructuredDocumentation', 'src': '10019:127:0', 'text': ' @notice Transfers ownership of this contract to the _authorizedNewOwner\\n @dev Error invalid sender.'}",
                        "functionSelector": "a2c1cae2",
                        "id": 372,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "assumeOwnership",
                        "overrides": null,
                        "parameters": "{'id': 341, 'nodeType': 'ParameterList', 'parameters': [], 'src': '10176:2:0'}",
                        "returnParameters": "{'id': 342, 'nodeType': 'ParameterList', 'parameters': [], 'src': '10188:0:0'}",
                        "scope": 373,
                        "src": "10152:282:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": true,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "contract",
                "documentation": null,
                "fullyImplemented": false,
                "id": 406,
                "linearizedBaseContracts": [
                    406
                ],
                "name": "ERC1820Registry",
                "scope": 2936,
                "src": "10441:507:0"
            },
            "children": [
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": null,
                        "functionSelector": "29965a1d",
                        "id": 382,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setInterfaceImplementer",
                        "overrides": null,
                        "parameters": "{'id': 380, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 375, 'mutability': 'mutable', 'name': '_addr', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 382, 'src': '10525:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 374, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10525:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 377, 'mutability': 'mutable', 'name': '_interfaceHash', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 382, 'src': '10549:22:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 376, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '10549:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 379, 'mutability': 'mutable', 'name': '_implementer', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 382, 'src': '10582:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 378, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10582:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '10514:95:0'}",
                        "returnParameters": "{'id': 381, 'nodeType': 'ParameterList', 'parameters': [], 'src': '10626:0:0'}",
                        "scope": 406,
                        "src": "10482:145:0",
                        "stateMutability": "nonpayable",
                        "virtual": true,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": null,
                        "functionSelector": "aabbb8ca",
                        "id": 391,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getInterfaceImplementer",
                        "overrides": null,
                        "parameters": "{'id': 387, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 384, 'mutability': 'mutable', 'name': '_addr', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 391, 'src': '10668:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 383, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10668:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 386, 'mutability': 'mutable', 'name': '_interfaceHash', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 391, 'src': '10683:22:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 385, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '10683:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '10667:39:0'}",
                        "returnParameters": "{'id': 390, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 389, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 391, 'src': '10774:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 388, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10774:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '10773:9:0'}",
                        "scope": 406,
                        "src": "10635:148:0",
                        "stateMutability": "view",
                        "virtual": true,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": null,
                        "functionSelector": "5df8122f",
                        "id": 398,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setManager",
                        "overrides": null,
                        "parameters": "{'id': 396, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 393, 'mutability': 'mutable', 'name': '_addr', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 398, 'src': '10811:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 392, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10811:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 395, 'mutability': 'mutable', 'name': '_newManager', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 398, 'src': '10826:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 394, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10826:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '10810:36:0'}",
                        "returnParameters": "{'id': 397, 'nodeType': 'ParameterList', 'parameters': [], 'src': '10863:0:0'}",
                        "scope": 406,
                        "src": "10791:73:0",
                        "stateMutability": "nonpayable",
                        "virtual": true,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": null,
                        "functionSelector": "3d584063",
                        "id": 405,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getManager",
                        "overrides": null,
                        "parameters": "{'id': 401, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 400, 'mutability': 'mutable', 'name': '_addr', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 405, 'src': '10892:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 399, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10892:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '10891:15:0'}",
                        "returnParameters": "{'id': 404, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 403, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 405, 'src': '10936:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 402, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '10936:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '10935:9:0'}",
                        "scope": 406,
                        "src": "10872:73:0",
                        "stateMutability": "view",
                        "virtual": true,
                        "visibility": "public"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "contract",
                "documentation": "{'id': 407, 'nodeType': 'StructuredDocumentation', 'src': '10952:48:0', 'text': 'Base client to interact with the registry.'}",
                "fullyImplemented": true,
                "id": 482,
                "linearizedBaseContracts": [
                    482
                ],
                "name": "ERC1820Client",
                "scope": 2936,
                "src": "11000:964:0"
            },
            "children": [
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "id": 412,
                        "mutability": "constant",
                        "name": "ERC1820REGISTRY",
                        "overrides": null,
                        "scope": 482,
                        "src": "11030:118:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_contract$_ERC1820Registry_$406', 'typeString': 'contract ERC1820Registry'}",
                        "typeName": "{'contractScope': None, 'id': 408, 'name': 'ERC1820Registry', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 406, 'src': '11030:15:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ERC1820Registry_$406', 'typeString': 'contract ERC1820Registry'}}",
                        "value": "{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '307831383230613442373631384264453731446365386364633733614142364339353930356661443234', 'id': 410, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '11099:42:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, 'value': '0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}], 'id': 409, 'name': 'ERC1820Registry', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 406, 'src': '11073:15:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_ERC1820Registry_$406_$', 'typeString': 'type(contract ERC1820Registry)'}}, 'id': 411, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11073:75:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_ERC1820Registry_$406', 'typeString': 'contract ERC1820Registry'}}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 439, 'nodeType': 'Block', 'src': '11283:234:0', 'statements': [{'assignments': [420], 'declarations': [{'constant': False, 'id': 420, 'mutability': 'mutable', 'name': 'interfaceHash', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 439, 'src': '11294:21:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 419, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '11294:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'id': 427, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 424, 'name': '_interfaceLabel', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 414, 'src': '11345:15:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'expression': {'argumentTypes': None, 'id': 422, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '11328:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 423, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '11328:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 425, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11328:33:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 421, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '11318:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 426, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11318:44:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '11294:68:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 433, 'name': 'this', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -28, 'src': '11435:4:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ERC1820Client_$482', 'typeString': 'contract ERC1820Client'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_ERC1820Client_$482', 'typeString': 'contract ERC1820Client'}], 'id': 432, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '11427:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 431, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '11427:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 434, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11427:13:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 435, 'name': 'interfaceHash', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 420, 'src': '11455:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 436, 'name': '_implementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 416, 'src': '11483:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'argumentTypes': None, 'id': 428, 'name': 'ERC1820REGISTRY', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 412, 'src': '11373:15:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ERC1820Registry_$406', 'typeString': 'contract ERC1820Registry'}}, 'id': 430, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setInterfaceImplementer', 'nodeType': 'MemberAccess', 'referencedDeclaration': 382, 'src': '11373:39:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_address_$_t_bytes32_$_t_address_$returns$__$', 'typeString': 'function (address,bytes32,address) external'}}, 'id': 437, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11373:136:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 438, 'nodeType': 'ExpressionStatement', 'src': '11373:136:0'}]}",
                        "documentation": null,
                        "id": 440,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setInterfaceImplementation",
                        "overrides": null,
                        "parameters": "{'id': 417, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 414, 'mutability': 'mutable', 'name': '_interfaceLabel', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 440, 'src': '11203:29:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 413, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '11203:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 416, 'mutability': 'mutable', 'name': '_implementation', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 440, 'src': '11243:23:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 415, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '11243:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '11192:81:0'}",
                        "returnParameters": "{'id': 418, 'nodeType': 'ParameterList', 'parameters': [], 'src': '11283:0:0'}",
                        "scope": 482,
                        "src": "11157:360:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 464, 'nodeType': 'Block', 'src': '11657:165:0', 'statements': [{'assignments': [450], 'declarations': [{'constant': False, 'id': 450, 'mutability': 'mutable', 'name': 'interfaceHash', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 464, 'src': '11668:21:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 449, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '11668:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'id': 457, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 454, 'name': '_interfaceLabel', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 444, 'src': '11719:15:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'expression': {'argumentTypes': None, 'id': 452, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '11702:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 453, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '11702:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 455, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11702:33:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 451, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '11692:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 456, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11692:44:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '11668:68:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 460, 'name': 'addr', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 442, 'src': '11794:4:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 461, 'name': 'interfaceHash', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 450, 'src': '11800:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'argumentTypes': None, 'id': 458, 'name': 'ERC1820REGISTRY', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 412, 'src': '11754:15:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ERC1820Registry_$406', 'typeString': 'contract ERC1820Registry'}}, 'id': 459, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'getInterfaceImplementer', 'nodeType': 'MemberAccess', 'referencedDeclaration': 391, 'src': '11754:39:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_address_$_t_bytes32_$returns$_t_address_$', 'typeString': 'function (address,bytes32) view external returns (address)'}}, 'id': 462, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11754:60:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'functionReturnParameters': 448, 'id': 463, 'nodeType': 'Return', 'src': '11747:67:0'}]}",
                        "documentation": null,
                        "id": 465,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "interfaceAddr",
                        "overrides": null,
                        "parameters": "{'id': 445, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 442, 'mutability': 'mutable', 'name': 'addr', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 465, 'src': '11548:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 441, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '11548:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 444, 'mutability': 'mutable', 'name': '_interfaceLabel', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 465, 'src': '11562:29:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 443, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '11562:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'src': '11547:45:0'}",
                        "returnParameters": "{'id': 448, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 447, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 465, 'src': '11643:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 446, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '11643:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '11642:9:0'}",
                        "scope": 482,
                        "src": "11525:297:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 480, 'nodeType': 'Block', 'src': '11888:73:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 475, 'name': 'this', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -28, 'src': '11934:4:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ERC1820Client_$482', 'typeString': 'contract ERC1820Client'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_ERC1820Client_$482', 'typeString': 'contract ERC1820Client'}], 'id': 474, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '11926:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 473, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '11926:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 476, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11926:13:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 477, 'name': '_newManager', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 467, 'src': '11941:11:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'argumentTypes': None, 'id': 470, 'name': 'ERC1820REGISTRY', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 412, 'src': '11899:15:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ERC1820Registry_$406', 'typeString': 'contract ERC1820Registry'}}, 'id': 472, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setManager', 'nodeType': 'MemberAccess', 'referencedDeclaration': 398, 'src': '11899:26:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_address_$_t_address_$returns$__$', 'typeString': 'function (address,address) external'}}, 'id': 478, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '11899:54:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 479, 'nodeType': 'ExpressionStatement', 'src': '11899:54:0'}]}",
                        "documentation": null,
                        "id": 481,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "delegateManagement",
                        "overrides": null,
                        "parameters": "{'id': 468, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 467, 'mutability': 'mutable', 'name': '_newManager', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 481, 'src': '11858:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 466, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '11858:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '11857:21:0'}",
                        "returnParameters": "{'id': 469, 'nodeType': 'ParameterList', 'parameters': [], 'src': '11888:0:0'}",
                        "scope": 482,
                        "src": "11830:131:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "contract",
                "documentation": null,
                "fullyImplemented": true,
                "id": 536,
                "linearizedBaseContracts": [
                    536
                ],
                "name": "ERC1820Implementer",
                "scope": 2936,
                "src": "11968:1763:0"
            },
            "children": [
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 483, 'nodeType': 'StructuredDocumentation', 'src': '12003:166:0', 'text': ' @dev ERC1820 well defined magic value indicating the contract has\\n registered with the ERC1820Registry that it can implement an interface.'}",
                        "id": 491,
                        "mutability": "constant",
                        "name": "ERC1820_ACCEPT_MAGIC",
                        "overrides": null,
                        "scope": 536,
                        "src": "12175:107:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}",
                        "typeName": "{'id': 484, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '12175:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}",
                        "value": "{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '455243313832305f4143434550545f4d41474943', 'id': 488, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '12252:22:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_a2ef4600d742022d532d4747cb3547474667d6f13804902513b2ec01c848f4b4', 'typeString': 'literal_string \"ERC1820_ACCEPT_MAGIC\"'}, 'value': 'ERC1820_ACCEPT_MAGIC'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_a2ef4600d742022d532d4747cb3547474667d6f13804902513b2ec01c848f4b4', 'typeString': 'literal_string \"ERC1820_ACCEPT_MAGIC\"'}], 'expression': {'argumentTypes': None, 'id': 486, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '12235:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 487, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '12235:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 489, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '12235:40:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 485, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '12215:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 490, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '12215:67:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 492, 'nodeType': 'StructuredDocumentation', 'src': '12291:165:0', 'text': ' @dev Mapping of interface name keccak256 hashes for which this contract\\n implements the interface.\\n @dev Only settable internally.'}",
                        "id": 496,
                        "mutability": "mutable",
                        "name": "_interfaceHashes",
                        "overrides": null,
                        "scope": 536,
                        "src": "12462:50:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_bytes32_$_t_bool_$', 'typeString': 'mapping(bytes32 => bool)'}",
                        "typeName": "{'id': 495, 'keyType': {'id': 493, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '12470:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Mapping', 'src': '12462:24:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_bool_$', 'typeString': 'mapping(bytes32 => bool)'}, 'valueType': {'id': 494, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '12481:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 516, 'nodeType': 'Block', 'src': '13209:152:0', 'statements': [{'condition': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 506, 'name': '_interfaceHashes', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 496, 'src': '13224:16:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_bool_$', 'typeString': 'mapping(bytes32 => bool)'}}, 'id': 508, 'indexExpression': {'argumentTypes': None, 'id': 507, 'name': '_interfaceHash', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 499, 'src': '13241:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '13224:32:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': {'id': 514, 'nodeType': 'Block', 'src': '13318:36:0', 'statements': [{'expression': {'argumentTypes': None, 'hexValue': '', 'id': 512, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '13340:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, 'value': ''}, 'functionReturnParameters': 505, 'id': 513, 'nodeType': 'Return', 'src': '13333:9:0'}]}, 'id': 515, 'nodeType': 'IfStatement', 'src': '13220:134:0', 'trueBody': {'id': 511, 'nodeType': 'Block', 'src': '13258:54:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 509, 'name': 'ERC1820_ACCEPT_MAGIC', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 491, 'src': '13280:20:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'functionReturnParameters': 505, 'id': 510, 'nodeType': 'Return', 'src': '13273:27:0'}]}}]}",
                        "documentation": "{'id': 497, 'nodeType': 'StructuredDocumentation', 'src': '12521:478:0', 'text': ' @notice Indicates whether the contract implements the interface `_interfaceHash`\\n for the address `_addr`.\\n @param _interfaceHash keccak256 hash of the name of the interface.\\n @return ERC1820_ACCEPT_MAGIC only if the contract implements `\u77dbnterfaceHash`\\n for the address `_addr`.\\n @dev In this implementation, the `_addr` (the address for which the\\n contract will implement the interface) is always `address(this)`.'}",
                        "functionSelector": "249cb3fa",
                        "id": 517,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "canImplementInterfaceForAddress",
                        "overrides": null,
                        "parameters": "{'id': 502, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 499, 'mutability': 'mutable', 'name': '_interfaceHash', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 517, 'src': '13056:22:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 498, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '13056:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 501, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 517, 'src': '13089:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 500, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '13089:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '13045:131:0'}",
                        "returnParameters": "{'id': 505, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 504, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 517, 'src': '13200:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 503, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '13200:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '13199:9:0'}",
                        "scope": 536,
                        "src": "13005:356:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 534, 'nodeType': 'Block', 'src': '13640:88:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 532, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 523, 'name': '_interfaceHashes', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 496, 'src': '13651:16:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_bool_$', 'typeString': 'mapping(bytes32 => bool)'}}, 'id': 530, 'indexExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 527, 'name': '_interfaceLabel', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 520, 'src': '13695:15:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'expression': {'argumentTypes': None, 'id': 525, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '13678:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 526, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '13678:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 528, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '13678:33:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 524, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '13668:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 529, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '13668:44:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '13651:62:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '74727565', 'id': 531, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '13716:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'src': '13651:69:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'id': 533, 'nodeType': 'ExpressionStatement', 'src': '13651:69:0'}]}",
                        "documentation": "{'id': 518, 'nodeType': 'StructuredDocumentation', 'src': '13369:202:0', 'text': ' @notice Internally set the fact this contract implements the interface\\n identified by `_interfaceLabel`\\n @param _interfaceLabel String representation of the interface.'}",
                        "id": 535,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_setInterface",
                        "overrides": null,
                        "parameters": "{'id': 521, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 520, 'mutability': 'mutable', 'name': '_interfaceLabel', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 535, 'src': '13600:29:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 519, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '13600:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'src': '13599:31:0'}",
                        "returnParameters": "{'id': 522, 'nodeType': 'ParameterList', 'parameters': [], 'src': '13640:0:0'}",
                        "scope": 536,
                        "src": "13577:151:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "interface",
                "documentation": "{'id': 537, 'nodeType': 'StructuredDocumentation', 'src': '13735:92:0', 'text': ' @title IAmpTokensSender\\n @dev IAmpTokensSender token transfer hook interface'}",
                "fullyImplemented": false,
                "id": 580,
                "linearizedBaseContracts": [
                    580
                ],
                "name": "IAmpTokensSender",
                "scope": 2936,
                "src": "13829:784:0"
            },
            "children": [
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 538, 'nodeType': 'StructuredDocumentation', 'src': '13863:109:0', 'text': ' @dev Report if the transfer will succeed from the pespective of the\\n token sender'}",
                        "functionSelector": "34c34180",
                        "id": 559,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "canTransfer",
                        "overrides": null,
                        "parameters": "{'id': 555, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 540, 'mutability': 'mutable', 'name': 'functionSig', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 559, 'src': '14009:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 539, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '14009:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 542, 'mutability': 'mutable', 'name': 'partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 559, 'src': '14038:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 541, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '14038:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 544, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 559, 'src': '14066:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 543, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '14066:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 546, 'mutability': 'mutable', 'name': 'from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 559, 'src': '14093:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 545, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '14093:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 548, 'mutability': 'mutable', 'name': 'to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 559, 'src': '14116:10:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 547, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '14116:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 550, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 559, 'src': '14137:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 549, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '14137:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 552, 'mutability': 'mutable', 'name': 'data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 559, 'src': '14161:19:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 551, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '14161:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 554, 'mutability': 'mutable', 'name': 'operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 559, 'src': '14191:27:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 553, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '14191:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '13998:227:0'}",
                        "returnParameters": "{'id': 558, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 557, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 559, 'src': '14249:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 556, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '14249:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '14248:6:0'}",
                        "scope": 580,
                        "src": "13978:277:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 560, 'nodeType': 'StructuredDocumentation', 'src': '14263:79:0', 'text': ' @dev Hook executed upon a transfer on behalf of the sender'}",
                        "functionSelector": "ec3bb288",
                        "id": 579,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "tokensToTransfer",
                        "overrides": null,
                        "parameters": "{'id': 577, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 562, 'mutability': 'mutable', 'name': 'functionSig', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 579, 'src': '14384:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 561, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '14384:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 564, 'mutability': 'mutable', 'name': 'partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 579, 'src': '14413:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 563, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '14413:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 566, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 579, 'src': '14441:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 565, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '14441:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 568, 'mutability': 'mutable', 'name': 'from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 579, 'src': '14468:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 567, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '14468:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 570, 'mutability': 'mutable', 'name': 'to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 579, 'src': '14491:10:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 569, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '14491:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 572, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 579, 'src': '14512:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 571, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '14512:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 574, 'mutability': 'mutable', 'name': 'data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 579, 'src': '14536:19:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 573, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '14536:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 576, 'mutability': 'mutable', 'name': 'operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 579, 'src': '14566:27:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 575, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '14566:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '14373:227:0'}",
                        "returnParameters": "{'id': 578, 'nodeType': 'ParameterList', 'parameters': [], 'src': '14609:0:0'}",
                        "scope": 580,
                        "src": "14348:262:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "interface",
                "documentation": "{'id': 581, 'nodeType': 'StructuredDocumentation', 'src': '14617:98:0', 'text': ' @title IAmpTokensRecipient\\n @dev IAmpTokensRecipient token transfer hook interface'}",
                "fullyImplemented": false,
                "id": 624,
                "linearizedBaseContracts": [
                    624
                ],
                "name": "IAmpTokensRecipient",
                "scope": 2936,
                "src": "14717:754:0"
            },
            "children": [
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 582, 'nodeType': 'StructuredDocumentation', 'src': '14754:86:0', 'text': ' @dev Report if the recipient will successfully receive the tokens'}",
                        "functionSelector": "30e4cfba",
                        "id": 603,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "canReceive",
                        "overrides": null,
                        "parameters": "{'id': 599, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 584, 'mutability': 'mutable', 'name': 'functionSig', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 603, 'src': '14876:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 583, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '14876:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 586, 'mutability': 'mutable', 'name': 'partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 603, 'src': '14905:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 585, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '14905:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 588, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 603, 'src': '14933:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 587, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '14933:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 590, 'mutability': 'mutable', 'name': 'from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 603, 'src': '14960:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 589, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '14960:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 592, 'mutability': 'mutable', 'name': 'to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 603, 'src': '14983:10:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 591, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '14983:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 594, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 603, 'src': '15004:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 593, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '15004:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 596, 'mutability': 'mutable', 'name': 'data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 603, 'src': '15028:19:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 595, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '15028:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 598, 'mutability': 'mutable', 'name': 'operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 603, 'src': '15058:27:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 597, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '15058:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '14865:227:0'}",
                        "returnParameters": "{'id': 602, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 601, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 603, 'src': '15116:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 600, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '15116:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '15115:6:0'}",
                        "scope": 624,
                        "src": "14846:276:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": "{'id': 604, 'nodeType': 'StructuredDocumentation', 'src': '15130:72:0', 'text': ' @dev Hook executed upon a transfer to the recipient'}",
                        "functionSelector": "8240ef48",
                        "id": 623,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "tokensReceived",
                        "overrides": null,
                        "parameters": "{'id': 621, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 606, 'mutability': 'mutable', 'name': 'functionSig', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 623, 'src': '15242:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 605, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '15242:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 608, 'mutability': 'mutable', 'name': 'partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 623, 'src': '15271:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 607, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '15271:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 610, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 623, 'src': '15299:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 609, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '15299:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 612, 'mutability': 'mutable', 'name': 'from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 623, 'src': '15326:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 611, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '15326:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 614, 'mutability': 'mutable', 'name': 'to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 623, 'src': '15349:10:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 613, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '15349:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 616, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 623, 'src': '15370:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 615, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '15370:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 618, 'mutability': 'mutable', 'name': 'data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 623, 'src': '15394:19:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 617, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '15394:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 620, 'mutability': 'mutable', 'name': 'operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 623, 'src': '15424:27:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 619, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '15424:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '15231:227:0'}",
                        "returnParameters": "{'id': 622, 'nodeType': 'ParameterList', 'parameters': [], 'src': '15467:0:0'}",
                        "scope": 624,
                        "src": "15208:260:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "interface",
                "documentation": "{'id': 625, 'nodeType': 'StructuredDocumentation', 'src': '15475:63:0', 'text': ' @notice Partition strategy validator hooks for Amp'}",
                "fullyImplemented": false,
                "id": 675,
                "linearizedBaseContracts": [
                    675
                ],
                "name": "IAmpPartitionStrategyValidator",
                "scope": 2936,
                "src": "15540:792:0"
            },
            "children": [
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": null,
                        "functionSelector": "dc86ad7a",
                        "id": 644,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "tokensFromPartitionToValidate",
                        "overrides": null,
                        "parameters": "{'id': 642, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 627, 'mutability': 'mutable', 'name': '_functionSig', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 644, 'src': '15637:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 626, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '15637:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 629, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 644, 'src': '15667:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 628, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '15667:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 631, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 644, 'src': '15696:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 630, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '15696:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 633, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 644, 'src': '15724:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 632, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '15724:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 635, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 644, 'src': '15748:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 634, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '15748:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 637, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 644, 'src': '15770:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 636, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '15770:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 639, 'mutability': 'mutable', 'name': '_data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 644, 'src': '15795:20:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 638, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '15795:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 641, 'mutability': 'mutable', 'name': '_operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 644, 'src': '15826:28:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 640, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '15826:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '15626:235:0'}",
                        "returnParameters": "{'id': 643, 'nodeType': 'ParameterList', 'parameters': [], 'src': '15870:0:0'}",
                        "scope": 675,
                        "src": "15588:283:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": null,
                        "functionSelector": "b3c46f42",
                        "id": 663,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "tokensToPartitionToValidate",
                        "overrides": null,
                        "parameters": "{'id': 661, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 646, 'mutability': 'mutable', 'name': '_functionSig', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 663, 'src': '15926:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 645, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '15926:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 648, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 663, 'src': '15956:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 647, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '15956:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 650, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 663, 'src': '15985:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 649, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '15985:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 652, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 663, 'src': '16013:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 651, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '16013:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 654, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 663, 'src': '16037:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 653, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '16037:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 656, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 663, 'src': '16059:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 655, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '16059:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 658, 'mutability': 'mutable', 'name': '_data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 663, 'src': '16084:20:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 657, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '16084:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 660, 'mutability': 'mutable', 'name': '_operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 663, 'src': '16115:28:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 659, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '16115:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '15915:235:0'}",
                        "returnParameters": "{'id': 662, 'nodeType': 'ParameterList', 'parameters': [], 'src': '16159:0:0'}",
                        "scope": 675,
                        "src": "15879:281:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": null,
                        "functionSelector": "3f0413df",
                        "id": 674,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "isOperatorForPartitionScope",
                        "overrides": null,
                        "parameters": "{'id': 670, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 665, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 674, 'src': '16215:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 664, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '16215:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 667, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 674, 'src': '16244:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 666, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '16244:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 669, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 674, 'src': '16272:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 668, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '16272:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '16204:95:0'}",
                        "returnParameters": "{'id': 673, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 672, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 674, 'src': '16323:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 671, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '16323:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '16322:6:0'}",
                        "scope": 675,
                        "src": "16168:161:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "library",
                "documentation": "{'id': 676, 'nodeType': 'StructuredDocumentation', 'src': '16336:82:0', 'text': ' @title PartitionUtils\\n @notice Partition related helper functions.'}",
                "fullyImplemented": true,
                "id": 801,
                "linearizedBaseContracts": [
                    801
                ],
                "name": "PartitionUtils",
                "scope": 2936,
                "src": "16422:3092:0"
            },
            "children": [
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "functionSelector": "ff121cce",
                        "id": 679,
                        "mutability": "constant",
                        "name": "CHANGE_PARTITION_FLAG",
                        "overrides": null,
                        "scope": 801,
                        "src": "16452:114:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}",
                        "typeName": "{'id': 677, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '16452:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '307866666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666', 'id': 678, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '16500:66:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_115792089237316195423570985008687907853269984665640564039457584007913129639935_by_1', 'typeString': 'int_const 1157...(70 digits omitted)...9935'}, 'value': '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'}",
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 720, 'nodeType': 'Block', 'src': '17569:309:0', 'statements': [{'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 692, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 689, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 682, 'src': '17584:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, 'id': 690, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'length', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '17584:12:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '<', 'rightExpression': {'argumentTypes': None, 'hexValue': '3634', 'id': 691, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '17599:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_64_by_1', 'typeString': 'int_const 64'}, 'value': '64'}, 'src': '17584:17:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 696, 'nodeType': 'IfStatement', 'src': '17580:75:0', 'trueBody': {'id': 695, 'nodeType': 'Block', 'src': '17603:52:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 693, 'name': '_fallbackPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 684, 'src': '17625:18:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'functionReturnParameters': 688, 'id': 694, 'nodeType': 'Return', 'src': '17618:25:0'}]}}, {'assignments': [698, 700], 'declarations': [{'constant': False, 'id': 698, 'mutability': 'mutable', 'name': 'flag', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 720, 'src': '17668:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 697, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '17668:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 700, 'mutability': 'mutable', 'name': 'toPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 720, 'src': '17682:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 699, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '17682:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'id': 710, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 703, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 682, 'src': '17716:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'components': [{'argumentTypes': None, 'id': 705, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '17724:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_bytes32_$', 'typeString': 'type(bytes32)'}, 'typeName': {'id': 704, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '17724:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, {'argumentTypes': None, 'id': 707, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '17733:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_bytes32_$', 'typeString': 'type(bytes32)'}, 'typeName': {'id': 706, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '17733:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}], 'id': 708, 'isConstant': False, 'isInlineArray': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'TupleExpression', 'src': '17723:18:0', 'typeDescriptions': {'typeIdentifier': 't_tuple$_t_type$_t_bytes32_$_$_t_type$_t_bytes32_$_$', 'typeString': 'tuple(type(bytes32),type(bytes32))'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_tuple$_t_type$_t_bytes32_$_$_t_type$_t_bytes32_$_$', 'typeString': 'tuple(type(bytes32),type(bytes32))'}], 'expression': {'argumentTypes': None, 'id': 701, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '17705:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 702, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'decode', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '17705:10:0', 'typeDescriptions': {'typeIdentifier': 't_function_abidecode_pure$__$returns$__$', 'typeString': 'function () pure'}}, 'id': 709, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '17705:37:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$_t_bytes32_$_t_bytes32_$', 'typeString': 'tuple(bytes32,bytes32)'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '17667:75:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'id': 713, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 711, 'name': 'flag', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 698, 'src': '17757:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'id': 712, 'name': 'CHANGE_PARTITION_FLAG', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 679, 'src': '17765:21:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'src': '17757:29:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 717, 'nodeType': 'IfStatement', 'src': '17753:80:0', 'trueBody': {'id': 716, 'nodeType': 'Block', 'src': '17788:45:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 714, 'name': 'toPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 700, 'src': '17810:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'functionReturnParameters': 688, 'id': 715, 'nodeType': 'Return', 'src': '17803:18:0'}]}}, {'expression': {'argumentTypes': None, 'id': 718, 'name': '_fallbackPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 684, 'src': '17852:18:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'functionReturnParameters': 688, 'id': 719, 'nodeType': 'Return', 'src': '17845:25:0'}]}",
                        "documentation": "{'id': 680, 'nodeType': 'StructuredDocumentation', 'src': '16575:842:0', 'text': \" @notice Retrieve the destination partition from the 'data' field.\\n A partition change is requested ONLY when 'data' starts with the flag:\\n   0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff\\n When the flag is detected, the destination partition is extracted from the\\n 32 bytes following the flag.\\n @param _data Information attached to the transfer. Will contain the\\n destination partition if a change is requested.\\n @param _fallbackPartition Partition value to return if a partition change\\n is not requested in the `_data`.\\n @return toPartition Destination partition. If the `_data` does not contain\\n the prefix and bytes32 partition in the first 64 bytes, the method will\\n return the provided `_fromPartition`.\"}",
                        "id": 721,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_getDestinationPartition",
                        "overrides": null,
                        "parameters": "{'id': 685, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 682, 'mutability': 'mutable', 'name': '_data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 721, 'src': '17457:18:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 681, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '17457:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 684, 'mutability': 'mutable', 'name': '_fallbackPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 721, 'src': '17477:26:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 683, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '17477:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '17456:48:0'}",
                        "returnParameters": "{'id': 688, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 687, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 721, 'src': '17555:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 686, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '17555:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '17554:9:0'}",
                        "scope": 801,
                        "src": "17423:455:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 734, 'nodeType': 'Block', 'src': '18178:44:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 731, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 724, 'src': '18203:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 730, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '18196:6:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_bytes4_$', 'typeString': 'type(bytes4)'}, 'typeName': {'id': 729, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '18196:6:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 732, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '18196:18:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'functionReturnParameters': 728, 'id': 733, 'nodeType': 'Return', 'src': '18189:25:0'}]}",
                        "documentation": "{'id': 722, 'nodeType': 'StructuredDocumentation', 'src': '17886:206:0', 'text': ' @notice Helper to get the strategy identifying prefix from the `_partition`.\\n @param _partition Partition to get the prefix for.\\n @return 4 byte partition strategy prefix.'}",
                        "id": 735,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_getPartitionPrefix",
                        "overrides": null,
                        "parameters": "{'id': 725, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 724, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 735, 'src': '18127:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 723, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '18127:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '18126:20:0'}",
                        "returnParameters": "{'id': 728, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 727, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 735, 'src': '18170:6:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 726, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '18170:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}], 'src': '18169:8:0'}",
                        "scope": 801,
                        "src": "18098:124:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 781, 'nodeType': 'Block', 'src': '18727:233:0', 'statements': [{'assignments': [748], 'declarations': [{'constant': False, 'id': 748, 'mutability': 'mutable', 'name': 'prefix', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 781, 'src': '18738:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 747, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '18738:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}], 'id': 753, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 751, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 738, 'src': '18761:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 750, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '18754:6:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_bytes4_$', 'typeString': 'type(bytes4)'}, 'typeName': {'id': 749, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '18754:6:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 752, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '18754:18:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '18738:34:0'}, {'assignments': [755], 'declarations': [{'constant': False, 'id': 755, 'mutability': 'mutable', 'name': 'subPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 781, 'src': '18783:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes8', 'typeString': 'bytes8'}, 'typeName': {'id': 754, 'name': 'bytes8', 'nodeType': 'ElementaryTypeName', 'src': '18783:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes8', 'typeString': 'bytes8'}}, 'value': None, 'visibility': 'internal'}], 'id': 762, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'id': 760, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 758, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 738, 'src': '18812:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'BinaryOperation', 'operator': '<<', 'rightExpression': {'argumentTypes': None, 'hexValue': '3332', 'id': 759, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '18826:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_32_by_1', 'typeString': 'int_const 32'}, 'value': '32'}, 'src': '18812:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 757, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '18805:6:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_bytes8_$', 'typeString': 'type(bytes8)'}, 'typeName': {'id': 756, 'name': 'bytes8', 'nodeType': 'ElementaryTypeName', 'src': '18805:6:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 761, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '18805:24:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes8', 'typeString': 'bytes8'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '18783:46:0'}, {'assignments': [764], 'declarations': [{'constant': False, 'id': 764, 'mutability': 'mutable', 'name': 'addressPart', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 781, 'src': '18840:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 763, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '18840:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'id': 775, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 771, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 738, 'src': '18886:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 770, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '18878:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_uint256_$', 'typeString': 'type(uint256)'}, 'typeName': {'id': 769, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '18878:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 772, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '18878:19:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 768, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '18870:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_uint160_$', 'typeString': 'type(uint160)'}, 'typeName': {'id': 767, 'name': 'uint160', 'nodeType': 'ElementaryTypeName', 'src': '18870:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 773, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '18870:28:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint160', 'typeString': 'uint160'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint160', 'typeString': 'uint160'}], 'id': 766, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '18862:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 765, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '18862:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 774, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '18862:37:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '18840:59:0'}, {'expression': {'argumentTypes': None, 'components': [{'argumentTypes': None, 'id': 776, 'name': 'prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 748, 'src': '18918:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, {'argumentTypes': None, 'id': 777, 'name': 'subPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 755, 'src': '18926:12:0', 'typeDescriptions': {'typeIdentifier': 't_bytes8', 'typeString': 'bytes8'}}, {'argumentTypes': None, 'id': 778, 'name': 'addressPart', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 764, 'src': '18940:11:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'id': 779, 'isConstant': False, 'isInlineArray': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'nodeType': 'TupleExpression', 'src': '18917:35:0', 'typeDescriptions': {'typeIdentifier': 't_tuple$_t_bytes4_$_t_bytes8_$_t_address_$', 'typeString': 'tuple(bytes4,bytes8,address)'}}, 'functionReturnParameters': 746, 'id': 780, 'nodeType': 'Return', 'src': '18910:42:0'}]}",
                        "documentation": "{'id': 736, 'nodeType': 'StructuredDocumentation', 'src': '18230:316:0', 'text': ' @notice Helper method to split the partition into the prefix, sub partition\\n and partition owner components.\\n @param _partition The partition to split into parts.\\n @return The 4 byte partition prefix, 8 byte sub partition, and final 20\\n bytes representing an address.'}",
                        "id": 782,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_splitPartition",
                        "overrides": null,
                        "parameters": "{'id': 739, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 738, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 782, 'src': '18577:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 737, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '18577:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '18576:20:0'}",
                        "returnParameters": "{'id': 746, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 741, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 782, 'src': '18661:6:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 740, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '18661:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 743, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 782, 'src': '18682:6:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes8', 'typeString': 'bytes8'}, 'typeName': {'id': 742, 'name': 'bytes8', 'nodeType': 'ElementaryTypeName', 'src': '18682:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes8', 'typeString': 'bytes8'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 745, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 782, 'src': '18703:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 744, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '18703:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '18646:75:0'}",
                        "scope": 801,
                        "src": "18552:408:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 799, 'nodeType': 'Block', 'src': '19419:92:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '416d70506172746974696f6e537472617465677956616c696461746f72', 'id': 794, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '19461:31:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_f1c3d0da6da8c39cb1647b4c252f65e5df8d5691889f882b93c56e450c9f97fc', 'typeString': 'literal_string \"AmpPartitionStrategyValidator\"'}, 'value': 'AmpPartitionStrategyValidator'}, {'argumentTypes': None, 'id': 795, 'name': '_prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 785, 'src': '19494:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_f1c3d0da6da8c39cb1647b4c252f65e5df8d5691889f882b93c56e450c9f97fc', 'typeString': 'literal_string \"AmpPartitionStrategyValidator\"'}, {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}], 'expression': {'argumentTypes': None, 'id': 792, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '19444:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 793, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '19444:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 796, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '19444:58:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 791, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '19437:6:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_string_storage_ptr_$', 'typeString': 'type(string storage pointer)'}, 'typeName': {'id': 790, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19437:6:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 797, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '19437:66:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'functionReturnParameters': 789, 'id': 798, 'nodeType': 'Return', 'src': '19430:73:0'}]}",
                        "documentation": "{'id': 783, 'nodeType': 'StructuredDocumentation', 'src': '18968:314:0', 'text': ' @notice Helper method to get a partition strategy ERC1820 interface name\\n based on partition prefix.\\n @param _prefix 4 byte partition prefix.\\n @dev Each 4 byte prefix has a unique interface name so that an individual\\n hook implementation can be set for each prefix.'}",
                        "id": 800,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_getPartitionStrategyValidatorIName",
                        "overrides": null,
                        "parameters": "{'id': 786, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 785, 'mutability': 'mutable', 'name': '_prefix', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 800, 'src': '19333:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 784, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '19333:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}], 'src': '19332:16:0'}",
                        "returnParameters": "{'id': 789, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 788, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 800, 'src': '19399:13:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 787, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19399:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'src': '19398:15:0'}",
                        "scope": 801,
                        "src": "19288:223:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "contract",
                "documentation": "{'id': 802, 'nodeType': 'StructuredDocumentation', 'src': '19518:59:0', 'text': ' @title ErrorCodes\\n @notice Amp error codes.'}",
                "fullyImplemented": true,
                "id": 848,
                "linearizedBaseContracts": [
                    848
                ],
                "name": "ErrorCodes",
                "scope": 2936,
                "src": "19579:856:0"
            },
            "children": [
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 805,
                        "mutability": "mutable",
                        "name": "EC_50_TRANSFER_FAILURE",
                        "overrides": null,
                        "scope": 848,
                        "src": "19606:45:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 803, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19606:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3530', 'id': 804, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '19647:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_215d56ac8bbcf4ec574772ebea743ba30ac9d1c5e1b1ff899e5de1045f5df803', 'typeString': 'literal_string \"50\"'}, 'value': '50'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 808,
                        "mutability": "mutable",
                        "name": "EC_51_TRANSFER_SUCCESS",
                        "overrides": null,
                        "scope": 848,
                        "src": "19658:45:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 806, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19658:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3531', 'id': 807, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '19699:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_f928ede1c39c5595ff22fe845412ee05a93eeaa584f8ef0c46b5eeb14cb99ec8', 'typeString': 'literal_string \"51\"'}, 'value': '51'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 811,
                        "mutability": "mutable",
                        "name": "EC_52_INSUFFICIENT_BALANCE",
                        "overrides": null,
                        "scope": 848,
                        "src": "19710:49:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 809, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19710:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3532', 'id': 810, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '19755:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_cd41b8bf8f20f7ad95d96d948a315af225b219053fc98a80aee13063b692b681', 'typeString': 'literal_string \"52\"'}, 'value': '52'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 814,
                        "mutability": "mutable",
                        "name": "EC_53_INSUFFICIENT_ALLOWANCE",
                        "overrides": null,
                        "scope": 848,
                        "src": "19766:51:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 812, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19766:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3533', 'id': 813, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '19813:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_bbd48b257be1b8216d144ef9be5734f8d11697959c9e0f7768bec89db74a63a3', 'typeString': 'literal_string \"53\"'}, 'value': '53'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 817,
                        "mutability": "mutable",
                        "name": "EC_56_INVALID_SENDER",
                        "overrides": null,
                        "scope": 848,
                        "src": "19826:43:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 815, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19826:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3536', 'id': 816, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '19865:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_32da71dbd53bc029835bc5ecdd3e688035cc92bb61b1811d1685e67ba974e19f', 'typeString': 'literal_string \"56\"'}, 'value': '56'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 820,
                        "mutability": "mutable",
                        "name": "EC_57_INVALID_RECEIVER",
                        "overrides": null,
                        "scope": 848,
                        "src": "19876:45:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 818, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19876:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3537', 'id': 819, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '19917:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_e921da22f871c25c63f06c1365385cbb26397f64f79055cdbab32187a9377d16', 'typeString': 'literal_string \"57\"'}, 'value': '57'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 823,
                        "mutability": "mutable",
                        "name": "EC_58_INVALID_OPERATOR",
                        "overrides": null,
                        "scope": 848,
                        "src": "19928:45:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 821, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19928:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3538', 'id': 822, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '19969:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_59d26ca75eb04b47ab1bca5d789d02e4d0cf9ff8cb49c9041caeeeab4eccafbf', 'typeString': 'literal_string \"58\"'}, 'value': '58'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 826,
                        "mutability": "mutable",
                        "name": "EC_59_INSUFFICIENT_RIGHTS",
                        "overrides": null,
                        "scope": 848,
                        "src": "19982:48:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 824, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '19982:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3539', 'id': 825, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '20026:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_dec29173c70f4e70086d64e09cb72b415f3d6a1843817cff62483903f0e12f62', 'typeString': 'literal_string \"59\"'}, 'value': '59'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 829,
                        "mutability": "mutable",
                        "name": "EC_5A_INVALID_SWAP_TOKEN_ADDRESS",
                        "overrides": null,
                        "scope": 848,
                        "src": "20039:55:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 827, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '20039:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3541', 'id': 828, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '20090:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_4c9d4ed457a38dc618485bacd35956baa5c6e94afe7ea6138fc2e66ea74e3beb', 'typeString': 'literal_string \"5A\"'}, 'value': '5A'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 832,
                        "mutability": "mutable",
                        "name": "EC_5B_INVALID_VALUE_0",
                        "overrides": null,
                        "scope": 848,
                        "src": "20101:44:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 830, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '20101:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3542', 'id': 831, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '20141:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_f23a4e466542f4f5e544ecaccc76728716a966b127cd8e31013125456c21bd26', 'typeString': 'literal_string \"5B\"'}, 'value': '5B'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 835,
                        "mutability": "mutable",
                        "name": "EC_5C_ADDRESS_CONFLICT",
                        "overrides": null,
                        "scope": 848,
                        "src": "20152:45:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 833, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '20152:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3543', 'id': 834, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '20193:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_1674e07001cb7823dcbe9c0386f588a3b93ccd03e8b5f49152a661d134eb99a2', 'typeString': 'literal_string \"5C\"'}, 'value': '5C'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 838,
                        "mutability": "mutable",
                        "name": "EC_5D_PARTITION_RESERVED",
                        "overrides": null,
                        "scope": 848,
                        "src": "20204:47:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 836, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '20204:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3544', 'id': 837, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '20247:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_ac79423b73adfe2016230b02f1a9e8c92e9d17637113aeecd8e13aa784b40c47', 'typeString': 'literal_string \"5D\"'}, 'value': '5D'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 841,
                        "mutability": "mutable",
                        "name": "EC_5E_PARTITION_PREFIX_CONFLICT",
                        "overrides": null,
                        "scope": 848,
                        "src": "20258:54:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 839, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '20258:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3545', 'id': 840, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '20308:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_aec1bf744840770edc3c279c8f2ccb6236008c351af3b76319365644ca18746d', 'typeString': 'literal_string \"5E\"'}, 'value': '5E'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 844,
                        "mutability": "mutable",
                        "name": "EC_5F_INVALID_PARTITION_PREFIX_0",
                        "overrides": null,
                        "scope": 848,
                        "src": "20319:55:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 842, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '20319:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3546', 'id': 843, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '20370:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5a4bd4f356ff914758209576810b2aafa4f221e8077efa1f7279daf88da66d1', 'typeString': 'literal_string \"5F\"'}, 'value': '5F'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 847,
                        "mutability": "mutable",
                        "name": "EC_60_SWAP_TRANSFER_FAILURE",
                        "overrides": null,
                        "scope": 848,
                        "src": "20381:50:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 845, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '20381:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3630', 'id': 846, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '20427:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_7446b42d7fe1689ec32fc1ca65129d9f21f1979742315d34500a6886f6986bea', 'typeString': 'literal_string \"60\"'}, 'value': '60'}",
                        "visibility": "internal"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "interface",
                "documentation": null,
                "fullyImplemented": false,
                "id": 869,
                "linearizedBaseContracts": [
                    869
                ],
                "name": "ISwapToken",
                "scope": 2936,
                "src": "20439:288:0"
            },
            "children": [
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": null,
                        "functionSelector": "dd62ed3e",
                        "id": 857,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "allowance",
                        "overrides": null,
                        "parameters": "{'id': 853, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 850, 'mutability': 'mutable', 'name': 'owner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 857, 'src': '20486:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 849, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '20486:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 852, 'mutability': 'mutable', 'name': 'spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 857, 'src': '20501:15:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 851, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '20501:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '20485:32:0'}",
                        "returnParameters": "{'id': 856, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 855, 'mutability': 'mutable', 'name': 'remaining', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 857, 'src': '20568:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 854, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '20568:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '20567:19:0'}",
                        "scope": 869,
                        "src": "20467:120:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": null,
                        "documentation": null,
                        "functionSelector": "23b872dd",
                        "id": 868,
                        "implemented": false,
                        "kind": "function",
                        "modifiers": [],
                        "name": "transferFrom",
                        "overrides": null,
                        "parameters": "{'id': 864, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 859, 'mutability': 'mutable', 'name': 'from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 868, 'src': '20627:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 858, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '20627:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 861, 'mutability': 'mutable', 'name': 'to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 868, 'src': '20650:10:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 860, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '20650:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 863, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 868, 'src': '20671:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 862, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '20671:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '20616:75:0'}",
                        "returnParameters": "{'id': 867, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 866, 'mutability': 'mutable', 'name': 'success', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 868, 'src': '20710:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 865, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '20710:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '20709:14:0'}",
                        "scope": 869,
                        "src": "20595:129:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                }
            ]
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": false,
                "baseContracts": [
                    {
                        "arguments": null,
                        "baseName": {
                            "contractScope": null,
                            "id": 871,
                            "name": "IERC20",
                            "nodeType": "UserDefinedTypeName",
                            "referencedDeclaration": 271,
                            "src": "23074:6:0",
                            "typeDescriptions": {
                                "typeIdentifier": "t_contract$_IERC20_$271",
                                "typeString": "contract IERC20"
                            }
                        },
                        "id": 872,
                        "nodeType": "InheritanceSpecifier",
                        "src": "23074:6:0"
                    },
                    {
                        "arguments": null,
                        "baseName": {
                            "contractScope": null,
                            "id": 873,
                            "name": "ERC1820Client",
                            "nodeType": "UserDefinedTypeName",
                            "referencedDeclaration": 482,
                            "src": "23082:13:0",
                            "typeDescriptions": {
                                "typeIdentifier": "t_contract$_ERC1820Client_$482",
                                "typeString": "contract ERC1820Client"
                            }
                        },
                        "id": 874,
                        "nodeType": "InheritanceSpecifier",
                        "src": "23082:13:0"
                    },
                    {
                        "arguments": null,
                        "baseName": {
                            "contractScope": null,
                            "id": 875,
                            "name": "ERC1820Implementer",
                            "nodeType": "UserDefinedTypeName",
                            "referencedDeclaration": 536,
                            "src": "23097:18:0",
                            "typeDescriptions": {
                                "typeIdentifier": "t_contract$_ERC1820Implementer_$536",
                                "typeString": "contract ERC1820Implementer"
                            }
                        },
                        "id": 876,
                        "nodeType": "InheritanceSpecifier",
                        "src": "23097:18:0"
                    },
                    {
                        "arguments": null,
                        "baseName": {
                            "contractScope": null,
                            "id": 877,
                            "name": "ErrorCodes",
                            "nodeType": "UserDefinedTypeName",
                            "referencedDeclaration": 848,
                            "src": "23117:10:0",
                            "typeDescriptions": {
                                "typeIdentifier": "t_contract$_ErrorCodes_$848",
                                "typeString": "contract ErrorCodes"
                            }
                        },
                        "id": 878,
                        "nodeType": "InheritanceSpecifier",
                        "src": "23117:10:0"
                    },
                    {
                        "arguments": null,
                        "baseName": {
                            "contractScope": null,
                            "id": 879,
                            "name": "Ownable",
                            "nodeType": "UserDefinedTypeName",
                            "referencedDeclaration": 373,
                            "src": "23129:7:0",
                            "typeDescriptions": {
                                "typeIdentifier": "t_contract$_Ownable_$373",
                                "typeString": "contract Ownable"
                            }
                        },
                        "id": 880,
                        "nodeType": "InheritanceSpecifier",
                        "src": "23129:7:0"
                    }
                ],
                "contractDependencies": [
                    271,
                    373,
                    482,
                    536,
                    848
                ],
                "contractKind": "contract",
                "documentation": "{'id': 870, 'nodeType': 'StructuredDocumentation', 'src': '20731:2325:0', 'text': ' @title Amp\\n @notice Amp is an ERC20 compatible collateral token designed to support\\n multiple classes of collateralization systems.\\n @dev The Amp token contract includes the following features:\\n Partitions\\n   Tokens can be segmented within a given address by \"partition\", which in\\n   pracice is a 32 byte identifier. These partitions can have unique\\n   permissions globally, through the using of partition strategies, and\\n   locally, on a per address basis. The ability to create the sub-segments\\n   of tokens and assign special behavior gives collateral managers\\n   flexibility in how they are implemented.\\n Operators\\n   Inspired by ERC777, Amp allows token holders to assign \"operators\" on\\n   all (or any number of partitions) of their tokens. Operators are allowed\\n   to execute transfers on behalf of token owners without the need to use the\\n   ERC20 \"allowance\" semantics.\\n Transfers with Data\\n   Inspired by ERC777, Amp transfers can include arbitrary data, as well as\\n   operator data. This data can be used to change the partition of tokens,\\n   be used by collateral manager hooks to validate a transfer, be propagated\\n   via event to an off chain system, etc.\\n Token Transfer Hooks on Send and Receive\\n   Inspired by ERC777, Amp uses the ERC1820 Registry to allow collateral\\n   manager implementations to register hooks to be called upon sending to\\n   or transferring from the collateral manager\\'s address or, using partition\\n   strategies, owned partition space. The hook implementations can be used\\n   to validate transfer properties, gate transfers, emit custom events,\\n   update local state, etc.\\n Collateral Management Partition Strategies\\n   Amp is able to define certain sets of partitions, identified by a 4 byte\\n   prefix, that will allow special, custom logic to be executed when transfers\\n   are made to or from those partitions. This opens up the possibility of\\n   entire classes of collateral management systems that would not be possible\\n   without it.\\n These features give collateral manager implementers flexibility while\\n providing a consistent, \"collateral-in-place\", interface for interacting\\n with collateral systems directly through the Amp contract.'}",
                "fullyImplemented": true,
                "id": 2935,
                "linearizedBaseContracts": [
                    2935,
                    373,
                    848,
                    536,
                    482,
                    271
                ],
                "name": "Amp",
                "scope": 2936,
                "src": "23058:57148:0"
            },
            "children": [
                {
                    "name": "UsingForDirective",
                    "attributes": {
                        "id": 883,
                        "libraryName": "{'contractScope': None, 'id': 881, 'name': 'SafeMath', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 195, 'src': '23150:8:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_SafeMath_$195', 'typeString': 'library SafeMath'}}",
                        "src": "23144:27:0",
                        "typeName": "{'id': 882, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '23163:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 884, 'nodeType': 'StructuredDocumentation', 'src': '23345:51:0', 'text': ' @dev AmpToken interface label.'}",
                        "id": 887,
                        "mutability": "constant",
                        "name": "AMP_INTERFACE_NAME",
                        "overrides": null,
                        "scope": 2935,
                        "src": "23402:56:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}",
                        "typeName": "{'id': 885, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '23402:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '416d70546f6b656e', 'id': 886, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '23448:10:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_3d0242d3e5548aaa8c3dc6b925e4464988e06d3670738710304c77fc0e9cc208', 'typeString': 'literal_string \"AmpToken\"'}, 'value': 'AmpToken'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 888, 'nodeType': 'StructuredDocumentation', 'src': '23467:53:0', 'text': ' @dev ERC20Token interface label.'}",
                        "id": 891,
                        "mutability": "constant",
                        "name": "ERC20_INTERFACE_NAME",
                        "overrides": null,
                        "scope": 2935,
                        "src": "23526:60:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}",
                        "typeName": "{'id': 889, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '23526:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '4552433230546f6b656e', 'id': 890, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '23574:12:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_aea199e31a596269b42cdafd93407f14436db6e4cad65417994c2eb37381e05a', 'typeString': 'literal_string \"ERC20Token\"'}, 'value': 'ERC20Token'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 892, 'nodeType': 'StructuredDocumentation', 'src': '23595:58:0', 'text': ' @dev AmpTokensSender interface label.'}",
                        "id": 895,
                        "mutability": "constant",
                        "name": "AMP_TOKENS_SENDER",
                        "overrides": null,
                        "scope": 2935,
                        "src": "23659:62:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}",
                        "typeName": "{'id': 893, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '23659:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '416d70546f6b656e7353656e646572', 'id': 894, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '23704:17:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_60881b58a7ad1ebd3bc0e92b8277996363a67ded0f43bd95d11c320bab72b5a4', 'typeString': 'literal_string \"AmpTokensSender\"'}, 'value': 'AmpTokensSender'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 896, 'nodeType': 'StructuredDocumentation', 'src': '23730:61:0', 'text': ' @dev AmpTokensRecipient interface label.'}",
                        "id": 899,
                        "mutability": "constant",
                        "name": "AMP_TOKENS_RECIPIENT",
                        "overrides": null,
                        "scope": 2935,
                        "src": "23797:68:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}",
                        "typeName": "{'id': 897, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '23797:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '416d70546f6b656e73526563697069656e74', 'id': 898, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '23845:20:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_fa352d6368bbc643bcf9d528ffaba5dd3e826137bc42f935045c6c227bd4c72a', 'typeString': 'literal_string \"AmpTokensRecipient\"'}, 'value': 'AmpTokensRecipient'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 900, 'nodeType': 'StructuredDocumentation', 'src': '23874:59:0', 'text': ' @dev AmpTokensChecker interface label.'}",
                        "id": 903,
                        "mutability": "constant",
                        "name": "AMP_TOKENS_CHECKER",
                        "overrides": null,
                        "scope": 2935,
                        "src": "23939:64:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}",
                        "typeName": "{'id': 901, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '23939:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '416d70546f6b656e73436865636b6572', 'id': 902, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '23985:18:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_748e7af0e78c4b1a9602a43db105557133fae6679cc332b040b0399781b9f00a', 'typeString': 'literal_string \"AmpTokensChecker\"'}, 'value': 'AmpTokensChecker'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 904, 'nodeType': 'StructuredDocumentation', 'src': '24178:43:0', 'text': ' @dev Token name (Amp).'}",
                        "id": 906,
                        "mutability": "mutable",
                        "name": "_name",
                        "overrides": null,
                        "scope": 2935,
                        "src": "24227:21:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 905, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '24227:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 907, 'nodeType': 'StructuredDocumentation', 'src': '24257:45:0', 'text': ' @dev Token symbol (AMP).'}",
                        "id": 909,
                        "mutability": "mutable",
                        "name": "_symbol",
                        "overrides": null,
                        "scope": 2935,
                        "src": "24308:23:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_storage', 'typeString': 'string'}",
                        "typeName": "{'id': 908, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '24308:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 910, 'nodeType': 'StructuredDocumentation', 'src': '24340:137:0', 'text': ' @dev Total minted supply of token. This will increase comensurately with\\n successful swaps of the swap token.'}",
                        "id": 912,
                        "mutability": "mutable",
                        "name": "_totalSupply",
                        "overrides": null,
                        "scope": 2935,
                        "src": "24483:29:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}",
                        "typeName": "{'id': 911, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '24483:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 913, 'nodeType': 'StructuredDocumentation', 'src': '24521:72:0', 'text': ' @dev The granularity of the token. Hard coded to 1.'}",
                        "id": 916,
                        "mutability": "constant",
                        "name": "_granularity",
                        "overrides": null,
                        "scope": 2935,
                        "src": "24599:42:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}",
                        "typeName": "{'id': 914, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '24599:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '31', 'id': 915, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '24640:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 917, 'nodeType': 'StructuredDocumentation', 'src': '24816:133:0', 'text': ' @dev Mapping from tokenHolder to balance. This reflects the balance\\n across all partitions of an address.'}",
                        "id": 921,
                        "mutability": "mutable",
                        "name": "_balances",
                        "overrides": null,
                        "scope": 2935,
                        "src": "24955:46:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}",
                        "typeName": "{'id': 920, 'keyType': {'id': 918, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '24963:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '24955:27:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}, 'valueType': {'id': 919, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '24974:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 922, 'nodeType': 'StructuredDocumentation', 'src': '25176:129:0', 'text': ' @dev List of active partitions. This list reflects all partitions that\\n have tokens assigned to them.'}",
                        "id": 925,
                        "mutability": "mutable",
                        "name": "_totalPartitions",
                        "overrides": null,
                        "scope": 2935,
                        "src": "25311:35:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[]'}",
                        "typeName": "{'baseType': {'id': 923, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '25311:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'id': 924, 'length': None, 'nodeType': 'ArrayTypeName', 'src': '25311:9:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage_ptr', 'typeString': 'bytes32[]'}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 926, 'nodeType': 'StructuredDocumentation', 'src': '25355:64:0', 'text': ' @dev Mapping from partition to their index.'}",
                        "id": 930,
                        "mutability": "mutable",
                        "name": "_indexOfTotalPartitions",
                        "overrides": null,
                        "scope": 2935,
                        "src": "25425:60:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}",
                        "typeName": "{'id': 929, 'keyType': {'id': 927, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '25433:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Mapping', 'src': '25425:27:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}, 'valueType': {'id': 928, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '25444:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 931, 'nodeType': 'StructuredDocumentation', 'src': '25494:94:0', 'text': ' @dev Mapping from partition to global balance of corresponding partition.'}",
                        "functionSelector": "a26734dc",
                        "id": 935,
                        "mutability": "mutable",
                        "name": "totalSupplyByPartition",
                        "overrides": null,
                        "scope": 2935,
                        "src": "25594:57:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}",
                        "typeName": "{'id': 934, 'keyType': {'id': 932, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '25602:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Mapping', 'src': '25594:27:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}, 'valueType': {'id': 933, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '25613:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}}",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 936, 'nodeType': 'StructuredDocumentation', 'src': '25660:71:0', 'text': ' @dev Mapping from tokenHolder to their partitions.'}",
                        "id": 941,
                        "mutability": "mutable",
                        "name": "_partitionsOf",
                        "overrides": null,
                        "scope": 2935,
                        "src": "25737:52:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_array$_t_bytes32_$dyn_storage_$', 'typeString': 'mapping(address => bytes32[])'}",
                        "typeName": "{'id': 940, 'keyType': {'id': 937, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '25745:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '25737:29:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_array$_t_bytes32_$dyn_storage_$', 'typeString': 'mapping(address => bytes32[])'}, 'valueType': {'baseType': {'id': 938, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '25756:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'id': 939, 'length': None, 'nodeType': 'ArrayTypeName', 'src': '25756:9:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage_ptr', 'typeString': 'bytes32[]'}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 942, 'nodeType': 'StructuredDocumentation', 'src': '25798:79:0', 'text': ' @dev Mapping from (tokenHolder, partition) to their index.'}",
                        "id": 948,
                        "mutability": "mutable",
                        "name": "_indexOfPartitionsOf",
                        "overrides": null,
                        "scope": 2935,
                        "src": "25883:77:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}",
                        "typeName": "{'id': 947, 'keyType': {'id': 943, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '25891:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '25883:47:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}, 'valueType': {'id': 946, 'keyType': {'id': 944, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '25910:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Mapping', 'src': '25902:27:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}, 'valueType': {'id': 945, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '25921:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 949, 'nodeType': 'StructuredDocumentation', 'src': '25969:110:0', 'text': ' @dev Mapping from (tokenHolder, partition) to balance of corresponding\\n partition.'}",
                        "id": 955,
                        "mutability": "mutable",
                        "name": "_balanceOfByPartition",
                        "overrides": null,
                        "scope": 2935,
                        "src": "26085:78:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}",
                        "typeName": "{'id': 954, 'keyType': {'id': 950, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '26093:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '26085:47:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}, 'valueType': {'id': 953, 'keyType': {'id': 951, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '26112:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Mapping', 'src': '26104:27:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}, 'valueType': {'id': 952, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '26123:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 956, 'nodeType': 'StructuredDocumentation', 'src': '26172:128:0', 'text': ' @notice Default partition of the token.\\n @dev All ERC20 operations operate solely on this partition.'}",
                        "functionSelector": "7e3a262d",
                        "id": 959,
                        "mutability": "constant",
                        "name": "defaultPartition",
                        "overrides": null,
                        "scope": 2935,
                        "src": "26306:118:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}",
                        "typeName": "{'id': 957, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '26306:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '307830303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030', 'id': 958, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '26358:66:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0x0000000000000000000000000000000000000000000000000000000000000000'}",
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 960, 'nodeType': 'StructuredDocumentation', 'src': '26433:173:0', 'text': ' @dev Zero partition prefix. Parititions with this prefix can not have\\n a strategy assigned, and partitions with a different prefix must have one.'}",
                        "id": 963,
                        "mutability": "constant",
                        "name": "ZERO_PREFIX",
                        "overrides": null,
                        "scope": 2935,
                        "src": "26612:49:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}",
                        "typeName": "{'id': 961, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '26612:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '30783030303030303030', 'id': 962, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '26651:10:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0x00000000'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 964, 'nodeType': 'StructuredDocumentation', 'src': '26836:130:0', 'text': ' @dev Mapping from (tokenHolder, operator) to authorized status. This is\\n specific to the token holder.'}",
                        "id": 970,
                        "mutability": "mutable",
                        "name": "_authorizedOperator",
                        "overrides": null,
                        "scope": 2935,
                        "src": "26972:73:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(address => mapping(address => bool))'}",
                        "typeName": "{'id': 969, 'keyType': {'id': 965, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '26980:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '26972:44:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(address => mapping(address => bool))'}, 'valueType': {'id': 968, 'keyType': {'id': 966, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '26999:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '26991:24:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}, 'valueType': {'id': 967, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '27010:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 971, 'nodeType': 'StructuredDocumentation', 'src': '27220:136:0', 'text': ' @dev Mapping from (partition, tokenHolder, spender) to allowed value.\\n This is specific to the token holder.'}",
                        "id": 979,
                        "mutability": "mutable",
                        "name": "_allowedByPartition",
                        "overrides": null,
                        "scope": 2935,
                        "src": "27362:105:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}",
                        "typeName": "{'id': 978, 'keyType': {'id': 972, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '27370:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Mapping', 'src': '27362:67:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}, 'valueType': {'id': 977, 'keyType': {'id': 973, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '27389:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '27381:47:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}, 'valueType': {'id': 976, 'keyType': {'id': 974, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '27408:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '27400:27:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}, 'valueType': {'id': 975, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '27419:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 980, 'nodeType': 'StructuredDocumentation', 'src': '27476:155:0', 'text': \" @dev Mapping from (tokenHolder, partition, operator) to 'approved for\\n partition' status. This is specific to the token holder.\"}",
                        "id": 988,
                        "mutability": "mutable",
                        "name": "_authorizedOperatorByPartition",
                        "overrides": null,
                        "scope": 2935,
                        "src": "27637:113:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$_$', 'typeString': 'mapping(address => mapping(bytes32 => mapping(address => bool)))'}",
                        "typeName": "{'id': 987, 'keyType': {'id': 981, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '27645:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '27637:64:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$_$', 'typeString': 'mapping(address => mapping(bytes32 => mapping(address => bool)))'}, 'valueType': {'id': 986, 'keyType': {'id': 982, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '27664:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Mapping', 'src': '27656:44:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(bytes32 => mapping(address => bool))'}, 'valueType': {'id': 985, 'keyType': {'id': 983, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '27683:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '27675:24:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}, 'valueType': {'id': 984, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '27694:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 989, 'nodeType': 'StructuredDocumentation', 'src': '27923:74:0', 'text': ' @notice Collection of registered collateral managers.'}",
                        "functionSelector": "814435af",
                        "id": 992,
                        "mutability": "mutable",
                        "name": "collateralManagers",
                        "overrides": null,
                        "scope": 2935,
                        "src": "28003:35:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_array$_t_address_$dyn_storage', 'typeString': 'address[]'}",
                        "typeName": "{'baseType': {'id': 990, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '28003:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 991, 'length': None, 'nodeType': 'ArrayTypeName', 'src': '28003:9:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_address_$dyn_storage_ptr', 'typeString': 'address[]'}}",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 993, 'nodeType': 'StructuredDocumentation', 'src': '28045:89:0', 'text': ' @dev Mapping of collateral manager addresses to registration status.'}",
                        "id": 997,
                        "mutability": "mutable",
                        "name": "_isCollateralManager",
                        "overrides": null,
                        "scope": 2935,
                        "src": "28140:54:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}",
                        "typeName": "{'id': 996, 'keyType': {'id': 994, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '28148:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '28140:24:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}, 'valueType': {'id': 995, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '28159:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 998, 'nodeType': 'StructuredDocumentation', 'src': '28369:73:0', 'text': ' @notice Collection of reserved partition strategies.'}",
                        "functionSelector": "75deca02",
                        "id": 1001,
                        "mutability": "mutable",
                        "name": "partitionStrategies",
                        "overrides": null,
                        "scope": 2935,
                        "src": "28448:35:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_array$_t_bytes4_$dyn_storage', 'typeString': 'bytes4[]'}",
                        "typeName": "{'baseType': {'id': 999, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '28448:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'id': 1000, 'length': None, 'nodeType': 'ArrayTypeName', 'src': '28448:8:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes4_$dyn_storage_ptr', 'typeString': 'bytes4[]'}}",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 1002, 'nodeType': 'StructuredDocumentation', 'src': '28492:84:0', 'text': ' @dev Mapping of partition strategy flag to registration status.'}",
                        "id": 1006,
                        "mutability": "mutable",
                        "name": "_isPartitionStrategy",
                        "overrides": null,
                        "scope": 2935,
                        "src": "28582:53:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_bytes4_$_t_bool_$', 'typeString': 'mapping(bytes4 => bool)'}",
                        "typeName": "{'id': 1005, 'keyType': {'id': 1003, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '28590:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'nodeType': 'Mapping', 'src': '28582:23:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes4_$_t_bool_$', 'typeString': 'mapping(bytes4 => bool)'}, 'valueType': {'id': 1004, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '28600:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}}",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 1007, 'nodeType': 'StructuredDocumentation', 'src': '28810:59:0', 'text': ' @notice Swap token address. Immutable.'}",
                        "functionSelector": "dc73e49c",
                        "id": 1009,
                        "mutability": "mutable",
                        "name": "swapToken",
                        "overrides": null,
                        "scope": 2935,
                        "src": "28875:27:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_contract$_ISwapToken_$869', 'typeString': 'contract ISwapToken'}",
                        "typeName": "{'contractScope': None, 'id': 1008, 'name': 'ISwapToken', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 869, 'src': '28875:10:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ISwapToken_$869', 'typeString': 'contract ISwapToken'}}",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 1010, 'nodeType': 'StructuredDocumentation', 'src': '28911:184:0', 'text': ' @notice Swap token graveyard address.\\n @dev This is the address that the incoming swapped tokens will be\\n forwarded to upon successfully minting Amp.'}",
                        "functionSelector": "a0cf6b84",
                        "id": 1013,
                        "mutability": "constant",
                        "name": "swapTokenGraveyard",
                        "overrides": null,
                        "scope": 2935,
                        "src": "29101:96:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_address', 'typeString': 'address'}",
                        "typeName": "{'id': 1011, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '29101:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '307830303030303030303030303030303030303030303030303030303030303030303030303064456144', 'id': 1012, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '29155:42:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, 'value': '0x000000000000000000000000000000000000dEaD'}",
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1014, 'nodeType': 'StructuredDocumentation', 'src': '29620:697:0', 'text': ' @notice Emitted when a transfer has been successfully completed.\\n @param fromPartition The partition the tokens were transfered from.\\n @param operator The address that initiated the transfer.\\n @param from The address the tokens were transferred from.\\n @param to The address the tokens were transferred to.\\n @param value The amount of tokens transferred.\\n @param data Additional metadata included with the transfer. Can include\\n the partition the tokens were transferred to (if different than\\n `fromPartition`).\\n @param operatorData Additional metadata included with the transfer on\\n behalf of the operator.'}",
                        "id": 1030,
                        "name": "TransferByPartition",
                        "parameters": "{'id': 1029, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1016, 'indexed': True, 'mutability': 'mutable', 'name': 'fromPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1030, 'src': '30359:29:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1015, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '30359:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1018, 'indexed': False, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1030, 'src': '30399:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1017, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '30399:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1020, 'indexed': True, 'mutability': 'mutable', 'name': 'from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1030, 'src': '30426:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1019, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '30426:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1022, 'indexed': True, 'mutability': 'mutable', 'name': 'to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1030, 'src': '30457:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1021, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '30457:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1024, 'indexed': False, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1030, 'src': '30486:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1023, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '30486:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1026, 'indexed': False, 'mutability': 'mutable', 'name': 'data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1030, 'src': '30510:10:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 1025, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '30510:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1028, 'indexed': False, 'mutability': 'mutable', 'name': 'operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1030, 'src': '30531:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 1027, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '30531:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '30348:208:0'}",
                        "src": "30323:234:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1031, 'nodeType': 'StructuredDocumentation', 'src': '30565:357:0', 'text': ' @notice Emitted when a transfer has been successfully completed and the\\n tokens that were transferred have changed partitions.\\n @param fromPartition The partition the tokens were transfered from.\\n @param toPartition The partition the tokens were transfered to.\\n @param value The amount of tokens transferred.'}",
                        "id": 1039,
                        "name": "ChangedPartition",
                        "parameters": "{'id': 1038, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1033, 'indexed': True, 'mutability': 'mutable', 'name': 'fromPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1039, 'src': '30961:29:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1032, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '30961:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1035, 'indexed': True, 'mutability': 'mutable', 'name': 'toPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1039, 'src': '31001:27:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1034, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '31001:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1037, 'indexed': False, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1039, 'src': '31039:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1036, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '31039:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '30950:109:0'}",
                        "src": "30928:132:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1040, 'nodeType': 'StructuredDocumentation', 'src': '31234:381:0', 'text': ' @notice Emitted when a token holder specifies an amount of tokens in a\\n a partition that an operator can transfer.\\n @param partition The partition of the tokens the holder has authorized the\\n operator to transfer from.\\n @param owner The token holder.\\n @param spender The operator the `owner` has authorized the allowance for.'}",
                        "id": 1050,
                        "name": "ApprovalByPartition",
                        "parameters": "{'id': 1049, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1042, 'indexed': True, 'mutability': 'mutable', 'name': 'partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1050, 'src': '31657:25:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1041, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '31657:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1044, 'indexed': True, 'mutability': 'mutable', 'name': 'owner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1050, 'src': '31693:21:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1043, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '31693:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1046, 'indexed': True, 'mutability': 'mutable', 'name': 'spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1050, 'src': '31725:23:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1045, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '31725:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1048, 'indexed': False, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1050, 'src': '31759:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1047, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '31759:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '31646:133:0'}",
                        "src": "31621:159:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1051, 'nodeType': 'StructuredDocumentation', 'src': '31788:411:0', 'text': ' @notice Emitted when a token holder has authorized an operator for their\\n tokens.\\n @dev This event applies to the token holder address across all partitions.\\n @param operator The address that was authorized to transfer tokens on\\n behalf of the `tokenHolder`.\\n @param tokenHolder The address that authorized the `operator` to transfer\\n their tokens.'}",
                        "id": 1057,
                        "name": "AuthorizedOperator",
                        "parameters": "{'id': 1056, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1053, 'indexed': True, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1057, 'src': '32230:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1052, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '32230:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1055, 'indexed': True, 'mutability': 'mutable', 'name': 'tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1057, 'src': '32256:27:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1054, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '32256:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '32229:55:0'}",
                        "src": "32205:80:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1058, 'nodeType': 'StructuredDocumentation', 'src': '32293:447:0', 'text': \" @notice Emitted when a token holder has de-authorized an operator from\\n transferring their tokens.\\n @dev This event applies to the token holder address across all partitions.\\n @param operator The address that was de-authorized from transferring tokens\\n on behalf of the `tokenHolder`.\\n @param tokenHolder The address that revoked the `operator`'s permission\\n to transfer their tokens.\"}",
                        "id": 1064,
                        "name": "RevokedOperator",
                        "parameters": "{'id': 1063, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1060, 'indexed': True, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1064, 'src': '32768:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1059, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '32768:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1062, 'indexed': True, 'mutability': 'mutable', 'name': 'tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1064, 'src': '32794:27:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1061, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '32794:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '32767:55:0'}",
                        "src": "32746:77:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1065, 'nodeType': 'StructuredDocumentation', 'src': '32831:466:0', 'text': ' @notice Emitted when a token holder has authorized an operator to transfer\\n their tokens of one partition.\\n @param partition The partition the `operator` is allowed to transfer\\n tokens from.\\n @param operator The address that was authorized to transfer tokens on\\n behalf of the `tokenHolder`.\\n @param tokenHolder The address that authorized the `operator` to transfer\\n their tokens in `partition`.'}",
                        "id": 1073,
                        "name": "AuthorizedOperatorByPartition",
                        "parameters": "{'id': 1072, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1067, 'indexed': True, 'mutability': 'mutable', 'name': 'partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1073, 'src': '33349:25:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1066, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '33349:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1069, 'indexed': True, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1073, 'src': '33385:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1068, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '33385:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1071, 'indexed': True, 'mutability': 'mutable', 'name': 'tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1073, 'src': '33420:27:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1070, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '33420:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '33338:116:0'}",
                        "src": "33303:152:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1074, 'nodeType': 'StructuredDocumentation', 'src': '33463:546:0', 'text': \" @notice Emitted when a token holder has de-authorized an operator from\\n transferring their tokens from a specific partition.\\n @param partition The partition the `operator` is no longer allowed to\\n transfer tokens from on behalf of the `tokenHolder`.\\n @param operator The address that was de-authorized from transferring\\n tokens on behalf of the `tokenHolder`.\\n @param tokenHolder The address that revoked the `operator`'s permission\\n to transfer their tokens from `partition`.\"}",
                        "id": 1082,
                        "name": "RevokedOperatorByPartition",
                        "parameters": "{'id': 1081, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1076, 'indexed': True, 'mutability': 'mutable', 'name': 'partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1082, 'src': '34058:25:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1075, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '34058:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1078, 'indexed': True, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1082, 'src': '34094:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1077, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '34094:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1080, 'indexed': True, 'mutability': 'mutable', 'name': 'tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1082, 'src': '34129:27:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1079, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '34129:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '34047:116:0'}",
                        "src": "34015:149:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1083, 'nodeType': 'StructuredDocumentation', 'src': '34338:155:0', 'text': ' @notice Emitted when a collateral manager has been registered.\\n @param collateralManager The address of the collateral manager.'}",
                        "id": 1087,
                        "name": "CollateralManagerRegistered",
                        "parameters": "{'id': 1086, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1085, 'indexed': False, 'mutability': 'mutable', 'name': 'collateralManager', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1087, 'src': '34533:25:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1084, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '34533:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '34532:27:0'}",
                        "src": "34499:61:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1088, 'nodeType': 'StructuredDocumentation', 'src': '34734:319:0', 'text': ' @notice Emitted when a new partition strategy validator is set.\\n @param flag The 4 byte prefix of the partitions that the stratgy affects.\\n @param name The name of the partition strategy.\\n @param implementation The address of the partition strategy hook\\n implementation.'}",
                        "id": 1096,
                        "name": "PartitionStrategySet",
                        "parameters": "{'id': 1095, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1090, 'indexed': False, 'mutability': 'mutable', 'name': 'flag', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1096, 'src': '35086:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 1089, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '35086:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1092, 'indexed': False, 'mutability': 'mutable', 'name': 'name', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1096, 'src': '35099:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 1091, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '35099:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1094, 'indexed': True, 'mutability': 'mutable', 'name': 'implementation', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1096, 'src': '35112:30:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1093, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '35112:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '35085:58:0'}",
                        "src": "35059:85:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1097, 'nodeType': 'StructuredDocumentation', 'src': '35204:359:0', 'text': ' @notice Emitted when tokens are minted as a result of a token swap\\n @param operator Address that executed the swap that resulted in tokens being minted\\n @param to Address that received the newly minted tokens.\\n @param value Amount of tokens minted\\n @param data Empty bytes, required for interface compatibility'}",
                        "id": 1107,
                        "name": "Minted",
                        "parameters": "{'id': 1106, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1099, 'indexed': True, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1107, 'src': '35582:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1098, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '35582:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1101, 'indexed': True, 'mutability': 'mutable', 'name': 'to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1107, 'src': '35608:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1100, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '35608:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1103, 'indexed': False, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1107, 'src': '35628:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1102, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '35628:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1105, 'indexed': False, 'mutability': 'mutable', 'name': 'data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1107, 'src': '35643:10:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 1104, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '35643:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '35581:73:0'}",
                        "src": "35569:86:0"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": "{'id': 1108, 'nodeType': 'StructuredDocumentation', 'src': '35663:406:0', 'text': ' @notice Indicates tokens swapped for Amp.\\n @dev The tokens that are swapped for Amp will be transferred to a\\n graveyard address that is for all practical purposes inaccessible.\\n @param operator Address that executed the swap.\\n @param from Address that the tokens were swapped from, and Amp minted for.\\n @param value Amount of tokens swapped into Amp.'}",
                        "id": 1116,
                        "name": "Swap",
                        "parameters": "{'id': 1115, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1110, 'indexed': True, 'mutability': 'mutable', 'name': 'operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1116, 'src': '36086:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1109, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '36086:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1112, 'indexed': True, 'mutability': 'mutable', 'name': 'from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1116, 'src': '36112:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1111, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '36112:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1114, 'indexed': False, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1116, 'src': '36134:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1113, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '36134:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '36085:63:0'}",
                        "src": "36075:74:0"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1190, 'nodeType': 'Block', 'src': '36892:825:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1132, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1127, 'name': '_swapTokenAddress_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1119, 'src': '36956:18:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 1130, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '36986:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 1129, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '36978:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 1128, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '36978:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1131, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '36978:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '36956:32:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1133, 'name': 'EC_5A_INVALID_SWAP_TOKEN_ADDRESS', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 829, 'src': '36990:32:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1126, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '36948:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1134, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '36948:75:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1135, 'nodeType': 'ExpressionStatement', 'src': '36948:75:0'}, {'expression': {'argumentTypes': None, 'id': 1140, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 1136, 'name': 'swapToken', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1009, 'src': '37034:9:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ISwapToken_$869', 'typeString': 'contract ISwapToken'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1138, 'name': '_swapTokenAddress_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1119, 'src': '37057:18:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 1137, 'name': 'ISwapToken', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 869, 'src': '37046:10:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_ISwapToken_$869_$', 'typeString': 'type(contract ISwapToken)'}}, 'id': 1139, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '37046:30:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_ISwapToken_$869', 'typeString': 'contract ISwapToken'}}, 'src': '37034:42:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ISwapToken_$869', 'typeString': 'contract ISwapToken'}}, 'id': 1141, 'nodeType': 'ExpressionStatement', 'src': '37034:42:0'}, {'expression': {'argumentTypes': None, 'id': 1144, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 1142, 'name': '_name', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 906, 'src': '37089:5:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 1143, 'name': '_name_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1121, 'src': '37097:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'src': '37089:14:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'id': 1145, 'nodeType': 'ExpressionStatement', 'src': '37089:14:0'}, {'expression': {'argumentTypes': None, 'id': 1148, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 1146, 'name': '_symbol', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 909, 'src': '37114:7:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 1147, 'name': '_symbol_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1123, 'src': '37124:8:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'src': '37114:18:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'id': 1149, 'nodeType': 'ExpressionStatement', 'src': '37114:18:0'}, {'expression': {'argumentTypes': None, 'id': 1152, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 1150, 'name': '_totalSupply', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 912, 'src': '37143:12:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '30', 'id': 1151, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '37158:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '37143:16:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1153, 'nodeType': 'ExpressionStatement', 'src': '37143:16:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1155, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '37275:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 1154, 'name': '_addPartitionToTotalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2409, 'src': '37244:30:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32)'}}, 'id': 1156, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '37244:48:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1157, 'nodeType': 'ExpressionStatement', 'src': '37244:48:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1161, 'name': 'AMP_INTERFACE_NAME', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 887, 'src': '37396:18:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1164, 'name': 'this', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -28, 'src': '37424:4:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}], 'id': 1163, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '37416:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 1162, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '37416:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1165, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '37416:13:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'argumentTypes': None, 'id': 1158, 'name': 'ERC1820Client', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 482, 'src': '37355:13:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_ERC1820Client_$482_$', 'typeString': 'type(contract ERC1820Client)'}}, 'id': 1160, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setInterfaceImplementation', 'nodeType': 'MemberAccess', 'referencedDeclaration': 440, 'src': '37355:40:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_string_memory_ptr_$_t_address_$returns$__$', 'typeString': 'function (string memory,address)'}}, 'id': 1166, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '37355:75:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1167, 'nodeType': 'ExpressionStatement', 'src': '37355:75:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1171, 'name': 'ERC20_INTERFACE_NAME', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 891, 'src': '37482:20:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1174, 'name': 'this', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -28, 'src': '37512:4:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}], 'id': 1173, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '37504:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 1172, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '37504:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1175, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '37504:13:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'argumentTypes': None, 'id': 1168, 'name': 'ERC1820Client', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 482, 'src': '37441:13:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_ERC1820Client_$482_$', 'typeString': 'type(contract ERC1820Client)'}}, 'id': 1170, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setInterfaceImplementation', 'nodeType': 'MemberAccess', 'referencedDeclaration': 440, 'src': '37441:40:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_string_memory_ptr_$_t_address_$returns$__$', 'typeString': 'function (string memory,address)'}}, 'id': 1176, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '37441:77:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1177, 'nodeType': 'ExpressionStatement', 'src': '37441:77:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1181, 'name': 'AMP_INTERFACE_NAME', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 887, 'src': '37625:18:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'expression': {'argumentTypes': None, 'id': 1178, 'name': 'ERC1820Implementer', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 536, 'src': '37592:18:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_ERC1820Implementer_$536_$', 'typeString': 'type(contract ERC1820Implementer)'}}, 'id': 1180, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_setInterface', 'nodeType': 'MemberAccess', 'referencedDeclaration': 535, 'src': '37592:32:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (string memory)'}}, 'id': 1182, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '37592:52:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1183, 'nodeType': 'ExpressionStatement', 'src': '37592:52:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1187, 'name': 'ERC20_INTERFACE_NAME', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 891, 'src': '37688:20:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'expression': {'argumentTypes': None, 'id': 1184, 'name': 'ERC1820Implementer', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 536, 'src': '37655:18:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_ERC1820Implementer_$536_$', 'typeString': 'type(contract ERC1820Implementer)'}}, 'id': 1186, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_setInterface', 'nodeType': 'MemberAccess', 'referencedDeclaration': 535, 'src': '37655:32:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (string memory)'}}, 'id': 1188, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '37655:54:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1189, 'nodeType': 'ExpressionStatement', 'src': '37655:54:0'}]}",
                        "documentation": "{'id': 1117, 'nodeType': 'StructuredDocumentation', 'src': '36405:354:0', 'text': ' @notice Initialize Amp, initialize the default partition, and register the\\n contract implementation in the global ERC1820Registry.\\n @param _swapTokenAddress_ The address of the ERC20 token that is set to be\\n swappable for Amp.\\n @param _name_ Name of the token.\\n @param _symbol_ Symbol of the token.'}",
                        "id": 1191,
                        "implemented": true,
                        "kind": "constructor",
                        "modifiers": [],
                        "name": "",
                        "overrides": null,
                        "parameters": "{'id': 1124, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1119, 'mutability': 'mutable', 'name': '_swapTokenAddress_', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1191, 'src': '36787:26:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1118, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '36787:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1121, 'mutability': 'mutable', 'name': '_name_', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1191, 'src': '36824:20:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 1120, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '36824:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1123, 'mutability': 'mutable', 'name': '_symbol_', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1191, 'src': '36855:22:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 1122, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '36855:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'src': '36776:108:0'}",
                        "returnParameters": "{'id': 1125, 'nodeType': 'ParameterList', 'parameters': [], 'src': '36892:0:0'}",
                        "scope": 2935,
                        "src": "36765:952:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "baseFunctions": [
                            202
                        ],
                        "body": "{'id': 1200, 'nodeType': 'Block', 'src': '38175:38:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 1198, 'name': '_totalSupply', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 912, 'src': '38193:12:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 1197, 'id': 1199, 'nodeType': 'Return', 'src': '38186:19:0'}]}",
                        "documentation": "{'id': 1192, 'nodeType': 'StructuredDocumentation', 'src': '37973:132:0', 'text': ' @notice Get the total number of issued tokens.\\n @return Total supply of tokens currently in circulation.'}",
                        "functionSelector": "18160ddd",
                        "id": 1201,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "totalSupply",
                        "overrides": "{'id': 1194, 'nodeType': 'OverrideSpecifier', 'overrides': [], 'src': '38143:8:0'}",
                        "parameters": "{'id': 1193, 'nodeType': 'ParameterList', 'parameters': [], 'src': '38131:2:0'}",
                        "returnParameters": "{'id': 1197, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1196, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1201, 'src': '38166:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1195, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '38166:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '38165:9:0'}",
                        "scope": 2935,
                        "src": "38111:102:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "baseFunctions": [
                            210
                        ],
                        "body": "{'id': 1214, 'nodeType': 'Block', 'src': '38966:49:0', 'statements': [{'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1210, 'name': '_balances', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 921, 'src': '38984:9:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1212, 'indexExpression': {'argumentTypes': None, 'id': 1211, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1204, 'src': '38994:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '38984:23:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 1209, 'id': 1213, 'nodeType': 'Return', 'src': '38977:30:0'}]}",
                        "documentation": "{'id': 1202, 'nodeType': 'StructuredDocumentation', 'src': '38221:657:0', 'text': ' @notice Get the balance of the account with address `_tokenHolder`.\\n @dev This returns the balance of the holder across all partitions. Note\\n that due to other functionality in Amp, this figure should not be used\\n as the arbiter of the amount a token holder will successfully be able to\\n send via the ERC20 compatible `transfer` method. In order to get that\\n figure, use `balanceOfByParition` and to get the balance of the default\\n partition.\\n @param _tokenHolder Address for which the balance is returned.\\n @return Amount of token held by `_tokenHolder` in the default partition.'}",
                        "functionSelector": "70a08231",
                        "id": 1215,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "balanceOf",
                        "overrides": "{'id': 1206, 'nodeType': 'OverrideSpecifier', 'overrides': [], 'src': '38934:8:0'}",
                        "parameters": "{'id': 1205, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1204, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1215, 'src': '38903:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1203, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '38903:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '38902:22:0'}",
                        "returnParameters": "{'id': 1209, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1208, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1215, 'src': '38957:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1207, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '38957:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '38956:9:0'}",
                        "scope": 2935,
                        "src": "38884:131:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "baseFunctions": [
                            220
                        ],
                        "body": "{'id': 1238, 'nodeType': 'Block', 'src': '39488:109:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1227, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '39527:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1228, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '39527:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1229, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '39539:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1230, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '39539:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1231, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1218, 'src': '39551:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1232, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1220, 'src': '39556:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'hexValue': '', 'id': 1233, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '39564:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, 'value': ''}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}], 'id': 1226, 'name': '_transferByDefaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2160, 'src': '39499:27:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (address,address,address,uint256,bytes memory)'}}, 'id': 1234, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '39499:68:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1235, 'nodeType': 'ExpressionStatement', 'src': '39499:68:0'}, {'expression': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1236, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '39585:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'functionReturnParameters': 1225, 'id': 1237, 'nodeType': 'Return', 'src': '39578:11:0'}]}",
                        "documentation": "{'id': 1216, 'nodeType': 'StructuredDocumentation', 'src': '39023:379:0', 'text': \" @notice Transfer token for a specified address.\\n @dev This method is for ERC20 compatibility, and only affects the\\n balance of the `msg.sender` address's default partition.\\n @param _to The address to transfer to.\\n @param _value The value to be transferred.\\n @return A boolean that indicates if the operation was successful.\"}",
                        "functionSelector": "a9059cbb",
                        "id": 1239,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "transfer",
                        "overrides": "{'id': 1222, 'nodeType': 'OverrideSpecifier', 'overrides': [], 'src': '39464:8:0'}",
                        "parameters": "{'id': 1221, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1218, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1239, 'src': '39426:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1217, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '39426:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1220, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1239, 'src': '39439:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1219, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '39439:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '39425:29:0'}",
                        "returnParameters": "{'id': 1225, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1224, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1239, 'src': '39482:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1223, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '39482:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '39481:6:0'}",
                        "scope": 2935,
                        "src": "39408:189:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "baseFunctions": [
                            252
                        ],
                        "body": "{'id': 1263, 'nodeType': 'Block', 'src': '40236:104:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1253, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '40275:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1254, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '40275:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1255, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1242, 'src': '40287:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1256, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1244, 'src': '40294:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1257, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1246, 'src': '40299:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'hexValue': '', 'id': 1258, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '40307:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, 'value': ''}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}], 'id': 1252, 'name': '_transferByDefaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2160, 'src': '40247:27:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (address,address,address,uint256,bytes memory)'}}, 'id': 1259, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '40247:63:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1260, 'nodeType': 'ExpressionStatement', 'src': '40247:63:0'}, {'expression': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1261, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '40328:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'functionReturnParameters': 1251, 'id': 1262, 'nodeType': 'Return', 'src': '40321:11:0'}]}",
                        "documentation": "{'id': 1240, 'nodeType': 'StructuredDocumentation', 'src': '39605:492:0', 'text': \" @notice Transfer tokens from one address to another.\\n @dev This method is for ERC20 compatibility, and only affects the\\n balance and allowance of the `_from` address's default partition.\\n @param _from The address which you want to transfer tokens from.\\n @param _to The address which you want to transfer to.\\n @param _value The amount of tokens to be transferred.\\n @return A boolean that indicates if the operation was successful.\"}",
                        "functionSelector": "23b872dd",
                        "id": 1264,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "transferFrom",
                        "overrides": "{'id': 1248, 'nodeType': 'OverrideSpecifier', 'overrides': [], 'src': '40212:8:0'}",
                        "parameters": "{'id': 1247, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1242, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1264, 'src': '40135:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1241, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '40135:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1244, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1264, 'src': '40159:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1243, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '40159:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1246, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1264, 'src': '40181:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1245, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '40181:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '40124:78:0'}",
                        "returnParameters": "{'id': 1251, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1250, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1264, 'src': '40230:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1249, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '40230:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '40229:6:0'}",
                        "scope": 2935,
                        "src": "40103:237:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "baseFunctions": [
                            230
                        ],
                        "body": "{'id': 1283, 'nodeType': 'Block', 'src': '40946:81:0', 'statements': [{'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1275, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '40964:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 1277, 'indexExpression': {'argumentTypes': None, 'id': 1276, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '40984:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '40964:37:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 1279, 'indexExpression': {'argumentTypes': None, 'id': 1278, 'name': '_owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1267, 'src': '41002:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '40964:45:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1281, 'indexExpression': {'argumentTypes': None, 'id': 1280, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1269, 'src': '41010:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '40964:55:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 1274, 'id': 1282, 'nodeType': 'Return', 'src': '40957:62:0'}]}",
                        "documentation": "{'id': 1265, 'nodeType': 'StructuredDocumentation', 'src': '40348:457:0', 'text': \" @notice Check the value of tokens that an owner allowed to a spender.\\n @dev This method is for ERC20 compatibility, and only affects the\\n allowance of the `msg.sender`'s default partition.\\n @param _owner address The address which owns the funds.\\n @param _spender address The address which will spend the funds.\\n @return A uint256 specifying the value of tokens still available for the\\n spender.\"}",
                        "functionSelector": "dd62ed3e",
                        "id": 1284,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "allowance",
                        "overrides": "{'id': 1271, 'nodeType': 'OverrideSpecifier', 'overrides': [], 'src': '40891:8:0'}",
                        "parameters": "{'id': 1270, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1267, 'mutability': 'mutable', 'name': '_owner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1284, 'src': '40830:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1266, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '40830:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1269, 'mutability': 'mutable', 'name': '_spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1284, 'src': '40846:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1268, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '40846:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '40829:34:0'}",
                        "returnParameters": "{'id': 1274, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1273, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1284, 'src': '40932:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1272, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '40932:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '40931:9:0'}",
                        "scope": 2935,
                        "src": "40811:216:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "baseFunctions": [
                            240
                        ],
                        "body": "{'id': 1305, 'nodeType': 'Block', 'src': '41609:108:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1296, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '41640:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1297, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '41658:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1298, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '41658:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1299, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1287, 'src': '41670:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1300, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1289, 'src': '41680:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1295, 'name': '_approveByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2737, 'src': '41620:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,address,address,uint256)'}}, 'id': 1301, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '41620:67:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1302, 'nodeType': 'ExpressionStatement', 'src': '41620:67:0'}, {'expression': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1303, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '41705:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'functionReturnParameters': 1294, 'id': 1304, 'nodeType': 'Return', 'src': '41698:11:0'}]}",
                        "documentation": "{'id': 1285, 'nodeType': 'StructuredDocumentation', 'src': '41035:484:0', 'text': \" @notice Approve the passed address to spend the specified amount of\\n tokens from the default partition on behalf of 'msg.sender'.\\n @dev This method is for ERC20 compatibility, and only affects the\\n allowance of the `msg.sender`'s default partition.\\n @param _spender The address which will spend the funds.\\n @param _value The amount of tokens to be spent.\\n @return A boolean that indicates if the operation was successful.\"}",
                        "functionSelector": "095ea7b3",
                        "id": 1306,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "approve",
                        "overrides": "{'id': 1291, 'nodeType': 'OverrideSpecifier', 'overrides': [], 'src': '41585:8:0'}",
                        "parameters": "{'id': 1290, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1287, 'mutability': 'mutable', 'name': '_spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1306, 'src': '41542:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1286, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '41542:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1289, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1306, 'src': '41560:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1288, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '41560:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '41541:34:0'}",
                        "returnParameters": "{'id': 1294, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1293, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1306, 'src': '41603:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1292, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '41603:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '41602:6:0'}",
                        "scope": 2935,
                        "src": "41525:192:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1336, 'nodeType': 'Block', 'src': '42593:241:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1317, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '42638:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1318, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '42669:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1319, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '42669:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1320, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1309, 'src': '42694:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1330, 'name': '_addedValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1311, 'src': '42781:11:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1321, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '42717:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 1323, 'indexExpression': {'argumentTypes': None, 'id': 1322, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '42737:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '42717:37:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 1326, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1324, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '42755:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1325, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '42755:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '42717:49:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1328, 'indexExpression': {'argumentTypes': None, 'id': 1327, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1309, 'src': '42767:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '42717:59:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1329, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'add', 'nodeType': 'MemberAccess', 'referencedDeclaration': 28, 'src': '42717:63:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1331, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '42717:76:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1316, 'name': '_approveByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2737, 'src': '42604:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,address,address,uint256)'}}, 'id': 1332, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '42604:200:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1333, 'nodeType': 'ExpressionStatement', 'src': '42604:200:0'}, {'expression': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1334, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '42822:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'functionReturnParameters': 1315, 'id': 1335, 'nodeType': 'Return', 'src': '42815:11:0'}]}",
                        "documentation": "{'id': 1307, 'nodeType': 'StructuredDocumentation', 'src': '41725:749:0', 'text': \" @notice Atomically increases the allowance granted to `_spender` by the\\n for caller.\\n @dev This is an alternative to {approve} that can be used as a mitigation\\n problems described in {IERC20-approve}.\\n Emits an {Approval} event indicating the updated allowance.\\n Requirements:\\n - `_spender` cannot be the zero address.\\n @dev This method is for ERC20 compatibility, and only affects the\\n allowance of the `msg.sender`'s default partition.\\n @param _spender Operator allowed to transfer the tokens\\n @param _addedValue Additional amount of the `msg.sender`s tokens `_spender`\\n is allowed to transfer\\n @return 'true' is successful, 'false' otherwise\"}",
                        "functionSelector": "39509351",
                        "id": 1337,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "increaseAllowance",
                        "overrides": null,
                        "parameters": "{'id': 1312, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1309, 'mutability': 'mutable', 'name': '_spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1337, 'src': '42507:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1308, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '42507:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1311, 'mutability': 'mutable', 'name': '_addedValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1337, 'src': '42525:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1310, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '42525:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '42506:39:0'}",
                        "returnParameters": "{'id': 1315, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1314, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1337, 'src': '42582:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1313, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '42582:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '42581:6:0'}",
                        "scope": 2935,
                        "src": "42480:354:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1367, 'nodeType': 'Block', 'src': '43802:278:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1348, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '43847:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1349, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '43878:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1350, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '43878:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1351, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1340, 'src': '43903:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1361, 'name': '_subtractedValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1342, 'src': '44008:16:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1352, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '43926:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 1354, 'indexExpression': {'argumentTypes': None, 'id': 1353, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '43946:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '43926:37:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 1357, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1355, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '43964:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1356, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '43964:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '43926:49:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1359, 'indexExpression': {'argumentTypes': None, 'id': 1358, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1340, 'src': '43976:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '43926:59:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1360, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sub', 'nodeType': 'MemberAccess', 'referencedDeclaration': 45, 'src': '43926:63:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1362, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '43926:113:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1347, 'name': '_approveByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2737, 'src': '43813:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,address,address,uint256)'}}, 'id': 1363, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '43813:237:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1364, 'nodeType': 'ExpressionStatement', 'src': '43813:237:0'}, {'expression': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1365, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '44068:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'functionReturnParameters': 1346, 'id': 1366, 'nodeType': 'Return', 'src': '44061:11:0'}]}",
                        "documentation": "{'id': 1338, 'nodeType': 'StructuredDocumentation', 'src': '42842:836:0', 'text': \" @notice Atomically decreases the allowance granted to `_spender` by the\\n caller.\\n @dev This is an alternative to {approve} that can be used as a mitigation\\n for bugs caused by reentrancy.\\n Emits an {Approval} event indicating the updated allowance.\\n Requirements:\\n - `_spender` cannot be the zero address.\\n - `_spender` must have allowance for the caller of at least\\n `_subtractedValue`.\\n @dev This method is for ERC20 compatibility, and only affects the\\n allowance of the `msg.sender`'s default partition.\\n @param _spender Operator allowed to transfer the tokens\\n @param _subtractedValue Amount of the `msg.sender`s tokens `_spender`\\n is no longer allowed to transfer\\n @return 'true' is successful, 'false' otherwise\"}",
                        "functionSelector": "a457c2d7",
                        "id": 1368,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "decreaseAllowance",
                        "overrides": null,
                        "parameters": "{'id': 1343, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1340, 'mutability': 'mutable', 'name': '_spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1368, 'src': '43711:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1339, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '43711:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1342, 'mutability': 'mutable', 'name': '_subtractedValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1368, 'src': '43729:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1341, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '43729:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '43710:44:0'}",
                        "returnParameters": "{'id': 1346, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1345, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1368, 'src': '43791:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1344, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '43791:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '43790:6:0'}",
                        "scope": 2935,
                        "src": "43684:396:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1416, 'nodeType': 'Block', 'src': '44722:376:0', 'statements': [{'assignments': [1375], 'declarations': [{'constant': False, 'id': 1375, 'mutability': 'mutable', 'name': 'amount', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1416, 'src': '44733:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1374, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '44733:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 1384, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1378, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1371, 'src': '44770:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1381, 'name': 'this', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -28, 'src': '44785:4:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}], 'id': 1380, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '44777:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 1379, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '44777:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1382, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '44777:13:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'argumentTypes': None, 'id': 1376, 'name': 'swapToken', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1009, 'src': '44750:9:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ISwapToken_$869', 'typeString': 'contract ISwapToken'}}, 'id': 1377, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'allowance', 'nodeType': 'MemberAccess', 'referencedDeclaration': 857, 'src': '44750:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_address_$_t_address_$returns$_t_uint256_$', 'typeString': 'function (address,address) view external returns (uint256)'}}, 'id': 1383, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '44750:41:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '44733:58:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 1388, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1386, 'name': 'amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1375, 'src': '44810:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '>', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 1387, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '44819:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '44810:10:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1389, 'name': 'EC_53_INSUFFICIENT_ALLOWANCE', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 814, 'src': '44822:28:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1385, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '44802:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1390, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '44802:49:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1391, 'nodeType': 'ExpressionStatement', 'src': '44802:49:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1395, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1371, 'src': '44909:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1396, 'name': 'swapTokenGraveyard', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1013, 'src': '44916:18:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1397, 'name': 'amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1375, 'src': '44936:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'id': 1393, 'name': 'swapToken', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1009, 'src': '44886:9:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_ISwapToken_$869', 'typeString': 'contract ISwapToken'}}, 'id': 1394, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'transferFrom', 'nodeType': 'MemberAccess', 'referencedDeclaration': 868, 'src': '44886:22:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_address_$_t_address_$_t_uint256_$returns$_t_bool_$', 'typeString': 'function (address,address,uint256) external returns (bool)'}}, 'id': 1398, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '44886:57:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1399, 'name': 'EC_60_SWAP_TRANSFER_FAILURE', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 847, 'src': '44958:27:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1392, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '44864:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1400, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '44864:132:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1401, 'nodeType': 'ExpressionStatement', 'src': '44864:132:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1403, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '45015:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1404, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '45015:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1405, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1371, 'src': '45027:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1406, 'name': 'amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1375, 'src': '45034:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1402, 'name': '_mint', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2934, 'src': '45009:5:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (address,address,uint256)'}}, 'id': 1407, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '45009:32:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1408, 'nodeType': 'ExpressionStatement', 'src': '45009:32:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1410, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '45064:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1411, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '45064:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1412, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1371, 'src': '45076:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1413, 'name': 'amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1375, 'src': '45083:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1409, 'name': 'Swap', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1116, 'src': '45059:4:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (address,address,uint256)'}}, 'id': 1414, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '45059:31:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1415, 'nodeType': 'EmitStatement', 'src': '45054:36:0'}]}",
                        "documentation": "{'id': 1369, 'nodeType': 'StructuredDocumentation', 'src': '44420:260:0', 'text': ' @notice Swap tokens to mint AMP.\\n @dev Requires `_from` to have given allowance of swap token to contract.\\n Otherwise will throw error code 53 (Insuffient Allowance).\\n @param _from Token holder to execute the swap for.'}",
                        "functionSelector": "03438dd0",
                        "id": 1417,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "swap",
                        "overrides": null,
                        "parameters": "{'id': 1372, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1371, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1417, 'src': '44700:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1370, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '44700:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '44699:15:0'}",
                        "returnParameters": "{'id': 1373, 'nodeType': 'ParameterList', 'parameters': [], 'src': '44722:0:0'}",
                        "scope": 2935,
                        "src": "44686:412:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1433, 'nodeType': 'Block', 'src': '45721:73:0', 'statements': [{'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1427, 'name': '_balanceOfByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 955, 'src': '45739:21:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 1429, 'indexExpression': {'argumentTypes': None, 'id': 1428, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1422, 'src': '45761:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '45739:35:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 1431, 'indexExpression': {'argumentTypes': None, 'id': 1430, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1420, 'src': '45775:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '45739:47:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 1426, 'id': 1432, 'nodeType': 'Return', 'src': '45732:54:0'}]}",
                        "documentation": "{'id': 1418, 'nodeType': 'StructuredDocumentation', 'src': '45272:307:0', 'text': ' @notice Get balance of a tokenholder for a specific partition.\\n @param _partition Name of the partition.\\n @param _tokenHolder Address for which the balance is returned.\\n @return Amount of token of partition `_partition` held by `_tokenHolder` in the token contract.'}",
                        "functionSelector": "30e82803",
                        "id": 1434,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "balanceOfByPartition",
                        "overrides": null,
                        "parameters": "{'id': 1423, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1420, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1434, 'src': '45615:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1419, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '45615:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1422, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1434, 'src': '45635:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1421, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '45635:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '45614:42:0'}",
                        "returnParameters": "{'id': 1426, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1425, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1434, 'src': '45707:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1424, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '45707:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '45706:9:0'}",
                        "scope": 2935,
                        "src": "45585:209:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1447, 'nodeType': 'Block', 'src': '46103:53:0', 'statements': [{'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1443, 'name': '_partitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 941, 'src': '46121:13:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_array$_t_bytes32_$dyn_storage_$', 'typeString': 'mapping(address => bytes32[] storage ref)'}}, 'id': 1445, 'indexExpression': {'argumentTypes': None, 'id': 1444, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1437, 'src': '46135:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '46121:27:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'functionReturnParameters': 1442, 'id': 1446, 'nodeType': 'Return', 'src': '46114:34:0'}]}",
                        "documentation": "{'id': 1435, 'nodeType': 'StructuredDocumentation', 'src': '45802:210:0', 'text': \" @notice Get partitions index of a token holder.\\n @param _tokenHolder Address for which the partitions index are returned.\\n @return Array of partitions index of '_tokenHolder'.\"}",
                        "functionSelector": "740ab8f4",
                        "id": 1448,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "partitionsOf",
                        "overrides": null,
                        "parameters": "{'id': 1438, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1437, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1448, 'src': '46040:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1436, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '46040:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '46039:22:0'}",
                        "returnParameters": "{'id': 1442, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1441, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1448, 'src': '46085:16:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_memory_ptr', 'typeString': 'bytes32[]'}, 'typeName': {'baseType': {'id': 1439, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '46085:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'id': 1440, 'length': None, 'nodeType': 'ArrayTypeName', 'src': '46085:9:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage_ptr', 'typeString': 'bytes32[]'}}, 'value': None, 'visibility': 'internal'}], 'src': '46084:18:0'}",
                        "scope": 2935,
                        "src": "46018:138:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1477, 'nodeType': 'Block', 'src': '47579:259:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1467, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1451, 'src': '47649:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1468, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '47678:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1469, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '47678:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1470, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1453, 'src': '47707:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1471, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1455, 'src': '47731:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1472, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1457, 'src': '47753:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 1473, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1459, 'src': '47778:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes calldata'}}, {'argumentTypes': None, 'id': 1474, 'name': '_operatorData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1461, 'src': '47802:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes calldata'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes calldata'}, {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes calldata'}], 'id': 1466, 'name': '_transferByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2135, 'src': '47610:20:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes32,address,address,address,uint256,bytes memory,bytes memory) returns (bytes32)'}}, 'id': 1475, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '47610:220:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'functionReturnParameters': 1465, 'id': 1476, 'nodeType': 'Return', 'src': '47590:240:0'}]}",
                        "documentation": "{'id': 1449, 'nodeType': 'StructuredDocumentation', 'src': '46330:1010:0', 'text': \" @notice Transfer tokens from a specific partition on behalf of a token\\n holder, optionally changing the parittion and optionally including\\n arbitrary data with the transfer.\\n @dev This can be used to transfer an address's own tokens, or transfer\\n a different addresses tokens by specifying the `_from` param. If\\n attempting to transfer from a different address than `msg.sender`, the\\n `msg.sender` will need to be an operator or have enough allowance for the\\n `_partition` of the `_from` address.\\n @param _partition Name of the partition to transfer from.\\n @param _from Token holder.\\n @param _to Token recipient.\\n @param _value Number of tokens to transfer.\\n @param _data Information attached to the transfer. Will contain the\\n destination partition (if changing partitions).\\n @param _operatorData Information attached to the transfer, by the operator.\\n @return Destination partition.\"}",
                        "functionSelector": "2036a94d",
                        "id": 1478,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "transferByPartition",
                        "overrides": null,
                        "parameters": "{'id': 1462, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1451, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1478, 'src': '47385:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1450, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '47385:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1453, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1478, 'src': '47414:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1452, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '47414:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1455, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1478, 'src': '47438:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1454, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '47438:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1457, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1478, 'src': '47460:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1456, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '47460:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1459, 'mutability': 'mutable', 'name': '_data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1478, 'src': '47485:20:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 1458, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '47485:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1461, 'mutability': 'mutable', 'name': '_operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1478, 'src': '47516:28:0', 'stateVariable': False, 'storageLocation': 'calldata', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 1460, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '47516:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '47374:177:0'}",
                        "returnParameters": "{'id': 1465, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1464, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1478, 'src': '47570:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1463, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '47570:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '47569:9:0'}",
                        "scope": 2935,
                        "src": "47346:492:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1507, 'nodeType': 'Block', 'src': '48405:194:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1488, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1485, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1481, 'src': '48424:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1486, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '48437:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1487, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '48437:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '48424:23:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1489, 'name': 'EC_58_INVALID_OPERATOR', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 823, 'src': '48449:22:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1484, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '48416:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1490, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '48416:56:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1491, 'nodeType': 'ExpressionStatement', 'src': '48416:56:0'}, {'expression': {'argumentTypes': None, 'id': 1499, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1492, 'name': '_authorizedOperator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 970, 'src': '48485:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(address => mapping(address => bool))'}}, 'id': 1496, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1493, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '48505:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1494, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '48505:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '48485:31:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 1497, 'indexExpression': {'argumentTypes': None, 'id': 1495, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1481, 'src': '48517:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '48485:42:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1498, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '48530:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'src': '48485:49:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'id': 1500, 'nodeType': 'ExpressionStatement', 'src': '48485:49:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1502, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1481, 'src': '48569:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1503, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '48580:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1504, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '48580:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}], 'id': 1501, 'name': 'AuthorizedOperator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1057, 'src': '48550:18:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$returns$__$', 'typeString': 'function (address,address)'}}, 'id': 1505, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '48550:41:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1506, 'nodeType': 'EmitStatement', 'src': '48545:46:0'}]}",
                        "documentation": "{'id': 1479, 'nodeType': 'StructuredDocumentation', 'src': '48012:332:0', 'text': \" @notice Set a third party operator address as an operator of 'msg.sender'\\n to transfer and redeem tokens on its behalf.\\n @dev The msg.sender is always an operator for itself, and does not need to\\n be explicitly added.\\n @param _operator Address to set as an operator for 'msg.sender'.\"}",
                        "functionSelector": "959b8c3f",
                        "id": 1508,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "authorizeOperator",
                        "overrides": null,
                        "parameters": "{'id': 1482, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1481, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1508, 'src': '48377:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1480, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '48377:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '48376:19:0'}",
                        "returnParameters": "{'id': 1483, 'nodeType': 'ParameterList', 'parameters': [], 'src': '48405:0:0'}",
                        "scope": 2935,
                        "src": "48350:249:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1537, 'nodeType': 'Block', 'src': '48996:192:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1518, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1515, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1511, 'src': '49015:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1516, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '49028:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1517, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '49028:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '49015:23:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1519, 'name': 'EC_58_INVALID_OPERATOR', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 823, 'src': '49040:22:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1514, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '49007:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1520, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '49007:56:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1521, 'nodeType': 'ExpressionStatement', 'src': '49007:56:0'}, {'expression': {'argumentTypes': None, 'id': 1529, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1522, 'name': '_authorizedOperator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 970, 'src': '49076:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(address => mapping(address => bool))'}}, 'id': 1526, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1523, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '49096:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1524, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '49096:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '49076:31:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 1527, 'indexExpression': {'argumentTypes': None, 'id': 1525, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1511, 'src': '49108:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '49076:42:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '66616c7365', 'id': 1528, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '49121:5:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'false'}, 'src': '49076:50:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'id': 1530, 'nodeType': 'ExpressionStatement', 'src': '49076:50:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1532, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1511, 'src': '49158:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1533, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '49169:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1534, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '49169:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}], 'id': 1531, 'name': 'RevokedOperator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1064, 'src': '49142:15:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$returns$__$', 'typeString': 'function (address,address)'}}, 'id': 1535, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '49142:38:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1536, 'nodeType': 'EmitStatement', 'src': '49137:43:0'}]}",
                        "documentation": "{'id': 1509, 'nodeType': 'StructuredDocumentation', 'src': '48607:331:0', 'text': \" @notice Remove the right of the operator address to be an operator for\\n 'msg.sender' and to transfer and redeem tokens on its behalf.\\n @dev The msg.sender is always an operator for itself, and cannot be\\n removed.\\n @param _operator Address to rescind as an operator for 'msg.sender'.\"}",
                        "functionSelector": "fad8b32a",
                        "id": 1538,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "revokeOperator",
                        "overrides": null,
                        "parameters": "{'id': 1512, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1511, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1538, 'src': '48968:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1510, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '48968:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '48967:19:0'}",
                        "returnParameters": "{'id': 1513, 'nodeType': 'ParameterList', 'parameters': [], 'src': '48996:0:0'}",
                        "scope": 2935,
                        "src": "48944:244:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1572, 'nodeType': 'Block', 'src': '49650:240:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1550, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1547, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1543, 'src': '49669:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1548, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '49682:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1549, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '49682:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '49669:23:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1551, 'name': 'EC_58_INVALID_OPERATOR', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 823, 'src': '49694:22:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1546, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '49661:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1552, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '49661:56:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1553, 'nodeType': 'ExpressionStatement', 'src': '49661:56:0'}, {'expression': {'argumentTypes': None, 'id': 1563, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1554, 'name': '_authorizedOperatorByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 988, 'src': '49730:30:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$_$', 'typeString': 'mapping(address => mapping(bytes32 => mapping(address => bool)))'}}, 'id': 1559, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1555, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '49761:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1556, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '49761:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '49730:42:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(bytes32 => mapping(address => bool))'}}, 'id': 1560, 'indexExpression': {'argumentTypes': None, 'id': 1557, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1541, 'src': '49773:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '49730:54:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 1561, 'indexExpression': {'argumentTypes': None, 'id': 1558, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1543, 'src': '49785:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '49730:65:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1562, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '49798:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'src': '49730:72:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'id': 1564, 'nodeType': 'ExpressionStatement', 'src': '49730:72:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1566, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1541, 'src': '49848:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 1567, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1543, 'src': '49860:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1568, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '49871:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1569, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '49871:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}], 'id': 1565, 'name': 'AuthorizedOperatorByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1073, 'src': '49818:29:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_bytes32_$_t_address_$_t_address_$returns$__$', 'typeString': 'function (bytes32,address,address)'}}, 'id': 1570, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '49818:64:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1571, 'nodeType': 'EmitStatement', 'src': '49813:69:0'}]}",
                        "documentation": "{'id': 1539, 'nodeType': 'StructuredDocumentation', 'src': '49196:348:0', 'text': \" @notice Set `_operator` as an operator for 'msg.sender' for a given partition.\\n @dev The msg.sender is always an operator for itself, and does not need to\\n be explicitly added to a partition.\\n @param _partition Name of the partition.\\n @param _operator Address to set as an operator for 'msg.sender'.\"}",
                        "functionSelector": "103ef9e1",
                        "id": 1573,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "authorizeOperatorByPartition",
                        "overrides": null,
                        "parameters": "{'id': 1544, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1541, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1573, 'src': '49588:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1540, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '49588:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1543, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1573, 'src': '49608:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1542, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '49608:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '49587:39:0'}",
                        "returnParameters": "{'id': 1545, 'nodeType': 'ParameterList', 'parameters': [], 'src': '49650:0:0'}",
                        "scope": 2935,
                        "src": "49550:340:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1607, 'nodeType': 'Block', 'src': '50440:238:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1585, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1582, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1578, 'src': '50459:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1583, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '50472:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1584, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '50472:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '50459:23:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1586, 'name': 'EC_58_INVALID_OPERATOR', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 823, 'src': '50484:22:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1581, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '50451:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1587, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '50451:56:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1588, 'nodeType': 'ExpressionStatement', 'src': '50451:56:0'}, {'expression': {'argumentTypes': None, 'id': 1598, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1589, 'name': '_authorizedOperatorByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 988, 'src': '50520:30:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$_$', 'typeString': 'mapping(address => mapping(bytes32 => mapping(address => bool)))'}}, 'id': 1594, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1590, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '50551:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1591, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '50551:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '50520:42:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(bytes32 => mapping(address => bool))'}}, 'id': 1595, 'indexExpression': {'argumentTypes': None, 'id': 1592, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1576, 'src': '50563:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '50520:54:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 1596, 'indexExpression': {'argumentTypes': None, 'id': 1593, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1578, 'src': '50575:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '50520:65:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '66616c7365', 'id': 1597, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '50588:5:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'false'}, 'src': '50520:73:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'id': 1599, 'nodeType': 'ExpressionStatement', 'src': '50520:73:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1601, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1576, 'src': '50636:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 1602, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1578, 'src': '50648:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1603, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '50659:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1604, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '50659:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}], 'id': 1600, 'name': 'RevokedOperatorByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1082, 'src': '50609:26:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_bytes32_$_t_address_$_t_address_$returns$__$', 'typeString': 'function (bytes32,address,address)'}}, 'id': 1605, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '50609:61:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1606, 'nodeType': 'EmitStatement', 'src': '50604:66:0'}]}",
                        "documentation": "{'id': 1574, 'nodeType': 'StructuredDocumentation', 'src': '49898:453:0', 'text': \" @notice Remove the right of the operator address to be an operator on a\\n given partition for 'msg.sender' and to transfer and redeem tokens on its\\n behalf.\\n @dev The msg.sender is always an operator for itself, and cannot be\\n removed from a partition.\\n @param _partition Name of the partition.\\n @param _operator Address to rescind as an operator on given partition for\\n 'msg.sender'.\"}",
                        "functionSelector": "168ecec5",
                        "id": 1608,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "revokeOperatorByPartition",
                        "overrides": null,
                        "parameters": "{'id': 1579, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1576, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1608, 'src': '50392:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1575, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '50392:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1578, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1608, 'src': '50412:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1577, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '50412:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '50391:39:0'}",
                        "returnParameters": "{'id': 1580, 'nodeType': 'ParameterList', 'parameters': [], 'src': '50440:0:0'}",
                        "scope": 2935,
                        "src": "50357:321:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1623, 'nodeType': 'Block', 'src': '51512:62:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1619, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1611, 'src': '51542:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1620, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1613, 'src': '51553:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 1618, 'name': '_isOperator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2759, 'src': '51530:11:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$_t_address_$returns$_t_bool_$', 'typeString': 'function (address,address) view returns (bool)'}}, 'id': 1621, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '51530:36:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'functionReturnParameters': 1617, 'id': 1622, 'nodeType': 'Return', 'src': '51523:43:0'}]}",
                        "documentation": "{'id': 1609, 'nodeType': 'StructuredDocumentation', 'src': '50850:534:0', 'text': \" @notice Indicate whether the `_operator` address is an operator of the\\n `_tokenHolder` address.\\n @dev An operator in this case is an operator across all of the partitions\\n of the `msg.sender` address.\\n @param _operator Address which may be an operator of `_tokenHolder`.\\n @param _tokenHolder Address of a token holder which may have the\\n `_operator` address as an operator.\\n @return 'true' if operator is an operator of 'tokenHolder' and 'false'\\n otherwise.\"}",
                        "functionSelector": "b6363cf2",
                        "id": 1624,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "isOperator",
                        "overrides": null,
                        "parameters": "{'id': 1614, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1611, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1624, 'src': '51410:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1610, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '51410:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1613, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1624, 'src': '51429:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1612, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '51429:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '51409:41:0'}",
                        "returnParameters": "{'id': 1617, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1616, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1624, 'src': '51501:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1615, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '51501:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '51500:6:0'}",
                        "scope": 2935,
                        "src": "51390:184:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1642, 'nodeType': 'Block', 'src': '52312:86:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1637, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1627, 'src': '52354:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 1638, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1629, 'src': '52366:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1639, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1631, 'src': '52377:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 1636, 'name': '_isOperatorForPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2792, 'src': '52330:23:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$_t_address_$_t_address_$returns$_t_bool_$', 'typeString': 'function (bytes32,address,address) view returns (bool)'}}, 'id': 1640, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '52330:60:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'functionReturnParameters': 1635, 'id': 1641, 'nodeType': 'Return', 'src': '52323:67:0'}]}",
                        "documentation": "{'id': 1625, 'nodeType': 'StructuredDocumentation', 'src': '51582:568:0', 'text': \" @notice Indicate whether the operator address is an operator of the\\n `_tokenHolder` address for the given partition.\\n @param _partition Name of the partition.\\n @param _operator Address which may be an operator of tokenHolder for the\\n given partition.\\n @param _tokenHolder Address of a token holder which may have the\\n `_operator` address as an operator for the given partition.\\n @return 'true' if 'operator' is an operator of `_tokenHolder` for\\n partition '_partition' and 'false' otherwise.\"}",
                        "functionSelector": "6d77cad6",
                        "id": 1643,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "isOperatorForPartition",
                        "overrides": null,
                        "parameters": "{'id': 1632, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1627, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1643, 'src': '52198:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1626, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '52198:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1629, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1643, 'src': '52227:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1628, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '52227:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1631, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1643, 'src': '52255:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1630, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '52255:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '52187:95:0'}",
                        "returnParameters": "{'id': 1635, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1634, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1643, 'src': '52306:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1633, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '52306:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '52305:6:0'}",
                        "scope": 2935,
                        "src": "52156:242:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1673, 'nodeType': 'Block', 'src': '53333:234:0', 'statements': [{'expression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'id': 1671, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1655, 'name': '_isCollateralManager', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 997, 'src': '53364:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 1657, 'indexExpression': {'argumentTypes': None, 'id': 1656, 'name': '_collateralManager', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1650, 'src': '53385:18:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '53364:40:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'BinaryOperation', 'operator': '&&', 'rightExpression': {'argumentTypes': None, 'components': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'id': 1669, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1659, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1648, 'src': '53434:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1660, 'name': '_collateralManager', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1650, 'src': '53445:18:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 1658, 'name': '_isOperator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2759, 'src': '53422:11:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$_t_address_$returns$_t_bool_$', 'typeString': 'function (address,address) view returns (bool)'}}, 'id': 1661, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '53422:42:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'BinaryOperation', 'operator': '||', 'rightExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1662, 'name': '_authorizedOperatorByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 988, 'src': '53485:30:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$_$', 'typeString': 'mapping(address => mapping(bytes32 => mapping(address => bool)))'}}, 'id': 1664, 'indexExpression': {'argumentTypes': None, 'id': 1663, 'name': '_collateralManager', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1650, 'src': '53516:18:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '53485:50:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(bytes32 => mapping(address => bool))'}}, 'id': 1666, 'indexExpression': {'argumentTypes': None, 'id': 1665, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1646, 'src': '53536:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '53485:62:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 1668, 'indexExpression': {'argumentTypes': None, 'id': 1667, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1648, 'src': '53548:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '53485:73:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'src': '53422:136:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}], 'id': 1670, 'isConstant': False, 'isInlineArray': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'nodeType': 'TupleExpression', 'src': '53421:138:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'src': '53364:195:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'functionReturnParameters': 1654, 'id': 1672, 'nodeType': 'Return', 'src': '53344:215:0'}]}",
                        "documentation": "{'id': 1644, 'nodeType': 'StructuredDocumentation', 'src': '52406:751:0', 'text': ' @notice Indicate when the `_operator` address is an operator of the\\n `_collateralManager` address for the given partition.\\n @dev This method is the same as `isOperatorForPartition`, except that it\\n also requires the address that `_operator` is being checked for MUST be\\n a registered collateral manager, and this method will not execute\\n partition strategy operator check hooks.\\n @param _partition Name of the partition.\\n @param _operator Address which may be an operator of `_collateralManager`\\n for the given partition.\\n @param _collateralManager Address of a collateral manager which may have\\n the `_operator` address as an operator for the given partition.'}",
                        "functionSelector": "aeb72e70",
                        "id": 1674,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "isOperatorForCollateralManager",
                        "overrides": null,
                        "parameters": "{'id': 1651, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1646, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1674, 'src': '53213:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1645, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '53213:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1648, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1674, 'src': '53242:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1647, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '53242:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1650, 'mutability': 'mutable', 'name': '_collateralManager', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1674, 'src': '53270:26:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1649, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '53270:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '53202:101:0'}",
                        "returnParameters": "{'id': 1654, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1653, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1674, 'src': '53327:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1652, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '53327:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '53326:6:0'}",
                        "scope": 2935,
                        "src": "53163:404:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1682, 'nodeType': 'Block', 'src': '53895:31:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 1680, 'name': '_name', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 906, 'src': '53913:5:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'functionReturnParameters': 1679, 'id': 1681, 'nodeType': 'Return', 'src': '53906:12:0'}]}",
                        "documentation": "{'id': 1675, 'nodeType': 'StructuredDocumentation', 'src': '53739:96:0', 'text': ' @notice Get the name of the token (Amp).\\n @return Name of the token.'}",
                        "functionSelector": "06fdde03",
                        "id": 1683,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "name",
                        "overrides": null,
                        "parameters": "{'id': 1676, 'nodeType': 'ParameterList', 'parameters': [], 'src': '53854:2:0'}",
                        "returnParameters": "{'id': 1679, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1678, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1683, 'src': '53880:13:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 1677, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '53880:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'src': '53879:15:0'}",
                        "scope": 2935,
                        "src": "53841:85:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1691, 'nodeType': 'Block', 'src': '54096:33:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 1689, 'name': '_symbol', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 909, 'src': '54114:7:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'functionReturnParameters': 1688, 'id': 1690, 'nodeType': 'Return', 'src': '54107:14:0'}]}",
                        "documentation": "{'id': 1684, 'nodeType': 'StructuredDocumentation', 'src': '53934:100:0', 'text': ' @notice Get the symbol of the token (AMP).\\n @return Symbol of the token.'}",
                        "functionSelector": "95d89b41",
                        "id": 1692,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "symbol",
                        "overrides": null,
                        "parameters": "{'id': 1685, 'nodeType': 'ParameterList', 'parameters': [], 'src': '54055:2:0'}",
                        "returnParameters": "{'id': 1688, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1687, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1692, 'src': '54081:13:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 1686, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '54081:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'src': '54080:15:0'}",
                        "scope": 2935,
                        "src": "54040:89:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1703, 'nodeType': 'Block', 'src': '54351:35:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '3138', 'id': 1700, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '54375:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_18_by_1', 'typeString': 'int_const 18'}, 'value': '18'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_18_by_1', 'typeString': 'int_const 18'}], 'id': 1699, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '54369:5:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_uint8_$', 'typeString': 'type(uint8)'}, 'typeName': {'id': 1698, 'name': 'uint8', 'nodeType': 'ElementaryTypeName', 'src': '54369:5:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1701, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '54369:9:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}}, 'functionReturnParameters': 1697, 'id': 1702, 'nodeType': 'Return', 'src': '54362:16:0'}]}",
                        "documentation": "{'id': 1693, 'nodeType': 'StructuredDocumentation', 'src': '54137:158:0', 'text': ' @notice Get the number of decimals of the token.\\n @dev Hard coded to 18.\\n @return The number of decimals of the token (18).'}",
                        "functionSelector": "313ce567",
                        "id": 1704,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "decimals",
                        "overrides": null,
                        "parameters": "{'id': 1694, 'nodeType': 'ParameterList', 'parameters': [], 'src': '54318:2:0'}",
                        "returnParameters": "{'id': 1697, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1696, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1704, 'src': '54344:5:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}, 'typeName': {'id': 1695, 'name': 'uint8', 'nodeType': 'ElementaryTypeName', 'src': '54344:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}}, 'value': None, 'visibility': 'internal'}], 'src': '54343:7:0'}",
                        "scope": 2935,
                        "src": "54301:85:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1712, 'nodeType': 'Block', 'src': '54634:38:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 1710, 'name': '_granularity', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 916, 'src': '54652:12:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 1709, 'id': 1711, 'nodeType': 'Return', 'src': '54645:19:0'}]}",
                        "documentation": "{'id': 1705, 'nodeType': 'StructuredDocumentation', 'src': '54394:179:0', 'text': ' @notice Get the smallest part of the token that\u9225\u6a9a not divisible.\\n @dev Hard coded to 1.\\n @return The smallest non-divisible part of the token.'}",
                        "functionSelector": "556f0dc7",
                        "id": 1713,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "granularity",
                        "overrides": null,
                        "parameters": "{'id': 1706, 'nodeType': 'ParameterList', 'parameters': [], 'src': '54599:2:0'}",
                        "returnParameters": "{'id': 1709, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1708, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1713, 'src': '54625:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1707, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '54625:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '54624:9:0'}",
                        "scope": 2935,
                        "src": "54579:93:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1722, 'nodeType': 'Block', 'src': '54866:42:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 1720, 'name': '_totalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 925, 'src': '54884:16:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'functionReturnParameters': 1719, 'id': 1721, 'nodeType': 'Return', 'src': '54877:23:0'}]}",
                        "documentation": "{'id': 1714, 'nodeType': 'StructuredDocumentation', 'src': '54680:112:0', 'text': ' @notice Get list of existing partitions.\\n @return Array of all exisiting partitions.'}",
                        "functionSelector": "69598efe",
                        "id": 1723,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "totalPartitions",
                        "overrides": null,
                        "parameters": "{'id': 1715, 'nodeType': 'ParameterList', 'parameters': [], 'src': '54822:2:0'}",
                        "returnParameters": "{'id': 1719, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1718, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1723, 'src': '54848:16:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_memory_ptr', 'typeString': 'bytes32[]'}, 'typeName': {'baseType': {'id': 1716, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '54848:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'id': 1717, 'length': None, 'nodeType': 'ArrayTypeName', 'src': '54848:9:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage_ptr', 'typeString': 'bytes32[]'}}, 'value': None, 'visibility': 'internal'}], 'src': '54847:18:0'}",
                        "scope": 2935,
                        "src": "54798:110:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1743, 'nodeType': 'Block', 'src': '55612:75:0', 'statements': [{'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1735, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '55630:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 1737, 'indexExpression': {'argumentTypes': None, 'id': 1736, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1726, 'src': '55650:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '55630:31:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 1739, 'indexExpression': {'argumentTypes': None, 'id': 1738, 'name': '_owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1728, 'src': '55662:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '55630:39:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1741, 'indexExpression': {'argumentTypes': None, 'id': 1740, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1730, 'src': '55670:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '55630:49:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 1734, 'id': 1742, 'nodeType': 'Return', 'src': '55623:56:0'}]}",
                        "documentation": "{'id': 1724, 'nodeType': 'StructuredDocumentation', 'src': '55124:332:0', 'text': ' @notice Check the value of tokens that an owner allowed to a spender.\\n @param _partition Name of the partition.\\n @param _owner The address which owns the tokens.\\n @param _spender The address which will spend the tokens.\\n @return The value of tokens still for the spender to transfer.'}",
                        "functionSelector": "17ec83ca",
                        "id": 1744,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "allowanceByPartition",
                        "overrides": null,
                        "parameters": "{'id': 1731, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1726, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1744, 'src': '55502:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1725, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '55502:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1728, 'mutability': 'mutable', 'name': '_owner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1744, 'src': '55531:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1727, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '55531:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1730, 'mutability': 'mutable', 'name': '_spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1744, 'src': '55556:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1729, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '55556:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '55491:88:0'}",
                        "returnParameters": "{'id': 1734, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1733, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1744, 'src': '55603:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1732, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '55603:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '55602:9:0'}",
                        "scope": 2935,
                        "src": "55462:225:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1766, 'nodeType': 'Block', 'src': '56236:102:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1757, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1747, 'src': '56267:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1758, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '56279:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1759, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '56279:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1760, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1749, 'src': '56291:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1761, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1751, 'src': '56301:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1756, 'name': '_approveByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2737, 'src': '56247:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,address,address,uint256)'}}, 'id': 1762, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '56247:61:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1763, 'nodeType': 'ExpressionStatement', 'src': '56247:61:0'}, {'expression': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1764, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '56326:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'functionReturnParameters': 1755, 'id': 1765, 'nodeType': 'Return', 'src': '56319:11:0'}]}",
                        "documentation": "{'id': 1745, 'nodeType': 'StructuredDocumentation', 'src': '55695:395:0', 'text': \" @notice Approve the `_spender` address to spend the specified amount of\\n tokens in `_partition` on behalf of 'msg.sender'.\\n @param _partition Name of the partition.\\n @param _spender The address which will spend the tokens.\\n @param _value The amount of tokens to be tokens.\\n @return A boolean that indicates if the operation was successful.\"}",
                        "functionSelector": "14d1e62f",
                        "id": 1767,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "approveByPartition",
                        "overrides": null,
                        "parameters": "{'id': 1752, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1747, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1767, 'src': '56134:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1746, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '56134:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1749, 'mutability': 'mutable', 'name': '_spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1767, 'src': '56163:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1748, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '56163:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1751, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1767, 'src': '56190:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1750, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '56190:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '56123:88:0'}",
                        "returnParameters": "{'id': 1755, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1754, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1767, 'src': '56230:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1753, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '56230:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '56229:6:0'}",
                        "scope": 2935,
                        "src": "56096:242:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1799, 'nodeType': 'Block', 'src': '57181:229:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1780, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1770, 'src': '57226:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1781, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '57251:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1782, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '57251:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1783, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1772, 'src': '57276:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1793, 'name': '_addedValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1774, 'src': '57357:11:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1784, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '57299:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 1786, 'indexExpression': {'argumentTypes': None, 'id': 1785, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1770, 'src': '57319:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '57299:31:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 1789, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1787, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '57331:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1788, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '57331:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '57299:43:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1791, 'indexExpression': {'argumentTypes': None, 'id': 1790, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1772, 'src': '57343:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '57299:53:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1792, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'add', 'nodeType': 'MemberAccess', 'referencedDeclaration': 28, 'src': '57299:57:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1794, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '57299:70:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1779, 'name': '_approveByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2737, 'src': '57192:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,address,address,uint256)'}}, 'id': 1795, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '57192:188:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1796, 'nodeType': 'ExpressionStatement', 'src': '57192:188:0'}, {'expression': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1797, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '57398:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'functionReturnParameters': 1778, 'id': 1798, 'nodeType': 'Return', 'src': '57391:11:0'}]}",
                        "documentation": "{'id': 1768, 'nodeType': 'StructuredDocumentation', 'src': '56346:674:0', 'text': \" @notice Atomically increases the allowance granted to `_spender` by the\\n caller.\\n @dev This is an alternative to {approveByPartition} that can be used as\\n a mitigation for bugs caused by reentrancy.\\n Emits an {ApprovalByPartition} event indicating the updated allowance.\\n Requirements:\\n - `_spender` cannot be the zero address.\\n @param _partition Name of the partition.\\n @param _spender Operator allowed to transfer the tokens\\n @param _addedValue Additional amount of the `msg.sender`s tokens `_spender`\\n is allowed to transfer\\n @return 'true' is successful, 'false' otherwise\"}",
                        "functionSelector": "c2f89a51",
                        "id": 1800,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "increaseAllowanceByPartition",
                        "overrides": null,
                        "parameters": "{'id': 1775, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1770, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1800, 'src': '57074:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1769, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '57074:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1772, 'mutability': 'mutable', 'name': '_spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1800, 'src': '57103:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1771, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '57103:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1774, 'mutability': 'mutable', 'name': '_addedValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1800, 'src': '57130:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1773, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '57130:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '57063:93:0'}",
                        "returnParameters": "{'id': 1778, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1777, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1800, 'src': '57175:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1776, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '57175:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '57174:6:0'}",
                        "scope": 2935,
                        "src": "57026:384:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1832, 'nodeType': 'Block', 'src': '58309:295:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1813, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1803, 'src': '58415:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1814, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '58440:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1815, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '58440:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 1816, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1805, 'src': '58465:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1826, 'name': '_subtractedValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1807, 'src': '58546:16:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1817, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '58488:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 1819, 'indexExpression': {'argumentTypes': None, 'id': 1818, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1803, 'src': '58508:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '58488:31:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 1822, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1820, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '58520:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1821, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '58520:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '58488:43:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1824, 'indexExpression': {'argumentTypes': None, 'id': 1823, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1805, 'src': '58532:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '58488:53:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1825, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sub', 'nodeType': 'MemberAccess', 'referencedDeclaration': 45, 'src': '58488:57:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1827, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '58488:75:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1812, 'name': '_approveByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2737, 'src': '58381:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,address,address,uint256)'}}, 'id': 1828, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '58381:193:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1829, 'nodeType': 'ExpressionStatement', 'src': '58381:193:0'}, {'expression': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1830, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '58592:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'functionReturnParameters': 1811, 'id': 1831, 'nodeType': 'Return', 'src': '58585:11:0'}]}",
                        "documentation": "{'id': 1801, 'nodeType': 'StructuredDocumentation', 'src': '57418:725:0', 'text': \" @notice Atomically decreases the allowance granted to `_spender` by the\\n caller.\\n @dev This is an alternative to {approveByPartition} that can be used as\\n a mitigation for bugs caused by reentrancy.\\n Emits an {ApprovalByPartition} event indicating the updated allowance.\\n Requirements:\\n - `_spender` cannot be the zero address.\\n - `_spender` must have allowance for the caller of at least\\n `_subtractedValue`.\\n @param _spender Operator allowed to transfer the tokens\\n @param _subtractedValue Amount of the `msg.sender`s tokens `_spender` is\\n no longer allowed to transfer\\n @return 'true' is successful, 'false' otherwise\"}",
                        "functionSelector": "1ff6442e",
                        "id": 1833,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "decreaseAllowanceByPartition",
                        "overrides": null,
                        "parameters": "{'id': 1808, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1803, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1833, 'src': '58197:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1802, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '58197:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1805, 'mutability': 'mutable', 'name': '_spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1833, 'src': '58226:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1804, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '58226:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1807, 'mutability': 'mutable', 'name': '_subtractedValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1833, 'src': '58253:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1806, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '58253:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '58186:98:0'}",
                        "returnParameters": "{'id': 1811, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1810, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1833, 'src': '58303:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1809, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '58303:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '58302:6:0'}",
                        "scope": 2935,
                        "src": "58149:455:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1865, 'nodeType': 'Block', 'src': '58928:284:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1842, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'nodeType': 'UnaryOperation', 'operator': '!', 'prefix': True, 'src': '58991:33:0', 'subExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1838, 'name': '_isCollateralManager', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 997, 'src': '58992:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 1841, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1839, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '59013:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1840, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '59013:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '58992:32:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1843, 'name': 'EC_5C_ADDRESS_CONFLICT', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 835, 'src': '59026:22:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1837, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '58983:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1844, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '58983:66:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1845, 'nodeType': 'ExpressionStatement', 'src': '58983:66:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1849, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '59086:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1850, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '59086:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}], 'expression': {'argumentTypes': None, 'id': 1846, 'name': 'collateralManagers', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 992, 'src': '59062:18:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_address_$dyn_storage', 'typeString': 'address[] storage ref'}}, 'id': 1848, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'push', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '59062:23:0', 'typeDescriptions': {'typeIdentifier': 't_function_arraypush_nonpayable$_t_address_$returns$__$', 'typeString': 'function (address)'}}, 'id': 1851, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '59062:35:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1852, 'nodeType': 'ExpressionStatement', 'src': '59062:35:0'}, {'expression': {'argumentTypes': None, 'id': 1858, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1853, 'name': '_isCollateralManager', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 997, 'src': '59108:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 1856, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1854, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '59129:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1855, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '59129:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '59108:32:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1857, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '59143:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'src': '59108:39:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'id': 1859, 'nodeType': 'ExpressionStatement', 'src': '59108:39:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1861, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '59193:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1862, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '59193:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}], 'id': 1860, 'name': 'CollateralManagerRegistered', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1087, 'src': '59165:27:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$returns$__$', 'typeString': 'function (address)'}}, 'id': 1863, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '59165:39:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1864, 'nodeType': 'EmitStatement', 'src': '59160:44:0'}]}",
                        "documentation": "{'id': 1834, 'nodeType': 'StructuredDocumentation', 'src': '58778:98:0', 'text': ' @notice Allow a collateral manager to self-register.\\n @dev Error 0x5c.'}",
                        "functionSelector": "b9d7b471",
                        "id": 1866,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "registerCollateralManager",
                        "overrides": null,
                        "parameters": "{'id': 1835, 'nodeType': 'ParameterList', 'parameters': [], 'src': '58916:2:0'}",
                        "returnParameters": "{'id': 1836, 'nodeType': 'ParameterList', 'parameters': [], 'src': '58928:0:0'}",
                        "scope": 2935,
                        "src": "58882:330:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1878, 'nodeType': 'Block', 'src': '59593:66:0', 'statements': [{'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1874, 'name': '_isCollateralManager', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 997, 'src': '59611:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 1876, 'indexExpression': {'argumentTypes': None, 'id': 1875, 'name': '_collateralManager', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1869, 'src': '59632:18:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '59611:40:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'functionReturnParameters': 1873, 'id': 1877, 'nodeType': 'Return', 'src': '59604:47:0'}]}",
                        "documentation": "{'id': 1867, 'nodeType': 'StructuredDocumentation', 'src': '59220:249:0', 'text': \" @notice Get the status of a collateral manager.\\n @param _collateralManager The address of the collateral mananger in question.\\n @return 'true' if `_collateralManager` has self registered, 'false'\\n otherwise.\"}",
                        "functionSelector": "0e0e923b",
                        "id": 1879,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "isCollateralManager",
                        "overrides": null,
                        "parameters": "{'id': 1870, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1869, 'mutability': 'mutable', 'name': '_collateralManager', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1879, 'src': '59504:26:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1868, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '59504:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '59503:28:0'}",
                        "returnParameters": "{'id': 1873, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1872, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1879, 'src': '59582:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1871, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '59582:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '59581:6:0'}",
                        "scope": 2935,
                        "src": "59475:184:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1943, 'nodeType': 'Block', 'src': '60282:563:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1892, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1888, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '60301:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 1889, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '60301:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'arguments': [], 'expression': {'argumentTypes': [], 'id': 1890, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 307, 'src': '60315:5:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$__$returns$_t_address_$', 'typeString': 'function () view returns (address)'}}, 'id': 1891, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '60315:7:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '60301:21:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1893, 'name': 'EC_56_INVALID_SENDER', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 817, 'src': '60324:20:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1887, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '60293:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1894, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '60293:52:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1895, 'nodeType': 'ExpressionStatement', 'src': '60293:52:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1900, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'nodeType': 'UnaryOperation', 'operator': '!', 'prefix': True, 'src': '60364:30:0', 'subExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1897, 'name': '_isPartitionStrategy', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1006, 'src': '60365:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes4_$_t_bool_$', 'typeString': 'mapping(bytes4 => bool)'}}, 'id': 1899, 'indexExpression': {'argumentTypes': None, 'id': 1898, 'name': '_prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1882, 'src': '60386:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '60365:29:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1901, 'name': 'EC_5E_PARTITION_PREFIX_CONFLICT', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 841, 'src': '60396:31:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1896, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '60356:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1902, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '60356:72:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1903, 'nodeType': 'ExpressionStatement', 'src': '60356:72:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'id': 1907, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1905, 'name': '_prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1882, 'src': '60447:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'id': 1906, 'name': 'ZERO_PREFIX', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 963, 'src': '60458:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'src': '60447:22:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1908, 'name': 'EC_5F_INVALID_PARTITION_PREFIX_0', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 844, 'src': '60471:32:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1904, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '60439:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1909, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '60439:65:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1910, 'nodeType': 'ExpressionStatement', 'src': '60439:65:0'}, {'assignments': [1912], 'declarations': [{'constant': False, 'id': 1912, 'mutability': 'mutable', 'name': 'iname', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1943, 'src': '60517:19:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 1911, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '60517:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'value': None, 'visibility': 'internal'}], 'id': 1917, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1915, 'name': '_prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1882, 'src': '60590:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}], 'expression': {'argumentTypes': None, 'id': 1913, 'name': 'PartitionUtils', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 801, 'src': '60539:14:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_PartitionUtils_$801_$', 'typeString': 'type(library PartitionUtils)'}}, 'id': 1914, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_getPartitionStrategyValidatorIName', 'nodeType': 'MemberAccess', 'referencedDeclaration': 800, 'src': '60539:50:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_bytes4_$returns$_t_string_memory_ptr_$', 'typeString': 'function (bytes4) pure returns (string memory)'}}, 'id': 1916, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '60539:59:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '60517:81:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1921, 'name': 'iname', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1912, 'src': '60652:5:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, {'argumentTypes': None, 'id': 1922, 'name': '_implementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1884, 'src': '60659:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'argumentTypes': None, 'id': 1918, 'name': 'ERC1820Client', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 482, 'src': '60611:13:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_ERC1820Client_$482_$', 'typeString': 'type(contract ERC1820Client)'}}, 'id': 1920, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setInterfaceImplementation', 'nodeType': 'MemberAccess', 'referencedDeclaration': 440, 'src': '60611:40:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_string_memory_ptr_$_t_address_$returns$__$', 'typeString': 'function (string memory,address)'}}, 'id': 1923, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '60611:64:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1924, 'nodeType': 'ExpressionStatement', 'src': '60611:64:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1928, 'name': '_prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1882, 'src': '60711:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}], 'expression': {'argumentTypes': None, 'id': 1925, 'name': 'partitionStrategies', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1001, 'src': '60686:19:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes4_$dyn_storage', 'typeString': 'bytes4[] storage ref'}}, 'id': 1927, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'push', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '60686:24:0', 'typeDescriptions': {'typeIdentifier': 't_function_arraypush_nonpayable$_t_bytes4_$returns$__$', 'typeString': 'function (bytes4)'}}, 'id': 1929, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '60686:33:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1930, 'nodeType': 'ExpressionStatement', 'src': '60686:33:0'}, {'expression': {'argumentTypes': None, 'id': 1935, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1931, 'name': '_isPartitionStrategy', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1006, 'src': '60730:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes4_$_t_bool_$', 'typeString': 'mapping(bytes4 => bool)'}}, 'id': 1933, 'indexExpression': {'argumentTypes': None, 'id': 1932, 'name': '_prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1882, 'src': '60751:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '60730:29:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '74727565', 'id': 1934, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '60762:4:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'true'}, 'src': '60730:36:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'id': 1936, 'nodeType': 'ExpressionStatement', 'src': '60730:36:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1938, 'name': '_prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1882, 'src': '60805:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, {'argumentTypes': None, 'id': 1939, 'name': 'iname', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1912, 'src': '60814:5:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, {'argumentTypes': None, 'id': 1940, 'name': '_implementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1884, 'src': '60821:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 1937, 'name': 'PartitionStrategySet', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1096, 'src': '60784:20:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_bytes4_$_t_string_memory_ptr_$_t_address_$returns$__$', 'typeString': 'function (bytes4,string memory,address)'}}, 'id': 1941, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '60784:53:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1942, 'nodeType': 'EmitStatement', 'src': '60779:58:0'}]}",
                        "documentation": "{'id': 1880, 'nodeType': 'StructuredDocumentation', 'src': '59831:365:0', 'text': ' @notice Sets an implementation for a partition strategy identified by prefix.\\n @dev This is an administration method, callable only by the owner of the\\n Amp contract.\\n @param _prefix The 4 byte partition prefix the strategy applies to.\\n @param _implementation The address of the implementation of the strategy hooks.'}",
                        "functionSelector": "e30834e0",
                        "id": 1944,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setPartitionStrategy",
                        "overrides": null,
                        "parameters": "{'id': 1885, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1882, 'mutability': 'mutable', 'name': '_prefix', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1944, 'src': '60232:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 1881, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '60232:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1884, 'mutability': 'mutable', 'name': '_implementation', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1944, 'src': '60248:23:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1883, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '60248:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '60231:41:0'}",
                        "returnParameters": "{'id': 1886, 'nodeType': 'ParameterList', 'parameters': [], 'src': '60282:0:0'}",
                        "scope": 2935,
                        "src": "60202:643:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1956, 'nodeType': 'Block', 'src': '61190:55:0', 'statements': [{'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1952, 'name': '_isPartitionStrategy', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1006, 'src': '61208:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes4_$_t_bool_$', 'typeString': 'mapping(bytes4 => bool)'}}, 'id': 1954, 'indexExpression': {'argumentTypes': None, 'id': 1953, 'name': '_prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1947, 'src': '61229:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '61208:29:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'functionReturnParameters': 1951, 'id': 1955, 'nodeType': 'Return', 'src': '61201:36:0'}]}",
                        "documentation": "{'id': 1945, 'nodeType': 'StructuredDocumentation', 'src': '60853:257:0', 'text': \" @notice Return if a partition strategy has been reserved and has an\\n implementation registered.\\n @param _prefix The partition strategy identifier.\\n @return 'true' if the strategy has been registered, 'false' if not.\"}",
                        "functionSelector": "900ff16d",
                        "id": 1957,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "isPartitionStrategy",
                        "overrides": null,
                        "parameters": "{'id': 1948, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1947, 'mutability': 'mutable', 'name': '_prefix', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1957, 'src': '61145:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 1946, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '61145:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}], 'src': '61144:16:0'}",
                        "returnParameters": "{'id': 1951, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1950, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1957, 'src': '61184:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 1949, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '61184:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '61183:6:0'}",
                        "scope": 2935,
                        "src": "61116:129:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2134, 'nodeType': 'Block', 'src': '62533:2291:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1983, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1978, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1966, 'src': '62552:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 1981, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '62567:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 1980, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '62559:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 1979, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '62559:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1982, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '62559:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '62552:17:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 1984, 'name': 'EC_57_INVALID_RECEIVER', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 820, 'src': '62571:22:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1977, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '62544:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1985, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '62544:50:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1986, 'nodeType': 'ExpressionStatement', 'src': '62544:50:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1989, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1987, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '62802:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'id': 1988, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1962, 'src': '62811:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '62802:18:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2053, 'nodeType': 'IfStatement', 'src': '62798:797:0', 'trueBody': {'id': 2052, 'nodeType': 'Block', 'src': '62822:773:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'id': 2006, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1992, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '62887:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 1993, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1962, 'src': '62903:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1994, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '62914:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 1991, 'name': '_isOperatorForPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2792, 'src': '62863:23:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$_t_address_$_t_address_$returns$_t_bool_$', 'typeString': 'function (bytes32,address,address) view returns (bool)'}}, 'id': 1995, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '62863:57:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'BinaryOperation', 'operator': '||', 'rightExpression': {'argumentTypes': None, 'components': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2004, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1996, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '62946:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '<=', 'rightExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1997, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '62956:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 1999, 'indexExpression': {'argumentTypes': None, 'id': 1998, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '62976:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '62956:35:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 2001, 'indexExpression': {'argumentTypes': None, 'id': 2000, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '62992:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '62956:42:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2003, 'indexExpression': {'argumentTypes': None, 'id': 2002, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1962, 'src': '62999:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '62956:53:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '62946:63:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}], 'id': 2005, 'isConstant': False, 'isInlineArray': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'nodeType': 'TupleExpression', 'src': '62945:65:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'src': '62863:147:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 2007, 'name': 'EC_53_INSUFFICIENT_ALLOWANCE', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 814, 'src': '63029:28:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 1990, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '62837:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 2008, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '62837:235:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2009, 'nodeType': 'ExpressionStatement', 'src': '62837:235:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2018, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2010, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '63202:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 2012, 'indexExpression': {'argumentTypes': None, 'id': 2011, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '63222:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63202:35:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 2014, 'indexExpression': {'argumentTypes': None, 'id': 2013, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '63238:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63202:42:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2016, 'indexExpression': {'argumentTypes': None, 'id': 2015, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1962, 'src': '63245:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63202:53:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '>=', 'rightExpression': {'argumentTypes': None, 'id': 2017, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '63259:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '63202:63:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': {'id': 2050, 'nodeType': 'Block', 'src': '63492:92:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 2048, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2040, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '63511:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 2044, 'indexExpression': {'argumentTypes': None, 'id': 2041, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '63531:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63511:35:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 2045, 'indexExpression': {'argumentTypes': None, 'id': 2042, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '63547:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63511:42:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2046, 'indexExpression': {'argumentTypes': None, 'id': 2043, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1962, 'src': '63554:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '63511:53:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '30', 'id': 2047, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '63567:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '63511:57:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2049, 'nodeType': 'ExpressionStatement', 'src': '63511:57:0'}]}, 'id': 2051, 'nodeType': 'IfStatement', 'src': '63198:386:0', 'trueBody': {'id': 2039, 'nodeType': 'Block', 'src': '63267:219:0', 'statements': [{'expression': {'argumentTypes': None, 'id': 2037, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2019, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '63286:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 2024, 'indexExpression': {'argumentTypes': None, 'id': 2020, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '63306:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63286:35:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 2025, 'indexExpression': {'argumentTypes': None, 'id': 2021, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '63322:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63286:42:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2026, 'indexExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 2022, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '63329:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 2023, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '63329:32:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '63286:76:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2035, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '63445:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2027, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '63365:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 2029, 'indexExpression': {'argumentTypes': None, 'id': 2028, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '63385:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63365:35:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 2031, 'indexExpression': {'argumentTypes': None, 'id': 2030, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '63401:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63365:42:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2033, 'indexExpression': {'argumentTypes': None, 'id': 2032, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1962, 'src': '63408:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63365:53:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2034, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sub', 'nodeType': 'MemberAccess', 'referencedDeclaration': 45, 'src': '63365:57:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 2036, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '63365:105:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '63286:184:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2038, 'nodeType': 'ExpressionStatement', 'src': '63286:184:0'}]}}]}}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2055, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '63643:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2056, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1962, 'src': '63672:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2057, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '63696:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2058, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1966, 'src': '63716:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2059, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '63734:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 2060, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1970, 'src': '63755:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'id': 2061, 'name': '_operatorData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1972, 'src': '63775:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 2054, 'name': '_callPreTransferHooks', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2565, 'src': '63607:21:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes32,address,address,address,uint256,bytes memory,bytes memory)'}}, 'id': 2062, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '63607:192:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2063, 'nodeType': 'ExpressionStatement', 'src': '63607:192:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2071, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2065, 'name': '_balanceOfByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 955, 'src': '63834:21:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2067, 'indexExpression': {'argumentTypes': None, 'id': 2066, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '63856:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63834:28:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2069, 'indexExpression': {'argumentTypes': None, 'id': 2068, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '63863:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '63834:44:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '>=', 'rightExpression': {'argumentTypes': None, 'id': 2070, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '63882:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '63834:54:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 2072, 'name': 'EC_52_INSUFFICIENT_BALANCE', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 811, 'src': '63903:26:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 2064, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '63812:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 2073, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '63812:128:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2074, 'nodeType': 'ExpressionStatement', 'src': '63812:128:0'}, {'assignments': [2076], 'declarations': [{'constant': False, 'id': 2076, 'mutability': 'mutable', 'name': 'toPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2134, 'src': '63953:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2075, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '63953:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'id': 2082, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2079, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1970, 'src': '64029:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'id': 2080, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '64049:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'argumentTypes': None, 'id': 2077, 'name': 'PartitionUtils', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 801, 'src': '63975:14:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_PartitionUtils_$801_$', 'typeString': 'type(library PartitionUtils)'}}, 'id': 2078, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_getDestinationPartition', 'nodeType': 'MemberAccess', 'referencedDeclaration': 721, 'src': '63975:39:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_bytes_memory_ptr_$_t_bytes32_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory,bytes32) pure returns (bytes32)'}}, 'id': 2081, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '63975:99:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '63953:121:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2084, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '64113:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2085, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '64120:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2086, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '64136:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 2083, 'name': '_removeTokenFromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2297, 'src': '64087:25:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_bytes32_$_t_uint256_$returns$__$', 'typeString': 'function (address,bytes32,uint256)'}}, 'id': 2087, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '64087:56:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2088, 'nodeType': 'ExpressionStatement', 'src': '64087:56:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2090, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1966, 'src': '64175:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2091, 'name': 'toPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2076, 'src': '64180:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2092, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '64193:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 2089, 'name': '_addTokenToPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2389, 'src': '64154:20:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_bytes32_$_t_uint256_$returns$__$', 'typeString': 'function (address,bytes32,uint256)'}}, 'id': 2093, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '64154:46:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2094, 'nodeType': 'ExpressionStatement', 'src': '64154:46:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2096, 'name': 'toPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2076, 'src': '64248:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2097, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1962, 'src': '64274:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2098, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '64298:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2099, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1966, 'src': '64318:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2100, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '64336:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 2101, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1970, 'src': '64357:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'id': 2102, 'name': '_operatorData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1972, 'src': '64377:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 2095, 'name': '_callPostTransferHooks', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2676, 'src': '64211:22:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes32,address,address,address,uint256,bytes memory,bytes memory)'}}, 'id': 2103, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '64211:190:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2104, 'nodeType': 'ExpressionStatement', 'src': '64211:190:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2106, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '64428:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2107, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1966, 'src': '64435:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2108, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '64440:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 2105, 'name': 'Transfer', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 261, 'src': '64419:8:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (address,address,uint256)'}}, 'id': 2109, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '64419:28:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2110, 'nodeType': 'EmitStatement', 'src': '64414:33:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2112, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '64497:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2113, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1962, 'src': '64526:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2114, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1964, 'src': '64550:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2115, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1966, 'src': '64570:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2116, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '64588:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 2117, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1970, 'src': '64609:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'id': 2118, 'name': '_operatorData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1972, 'src': '64629:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 2111, 'name': 'TransferByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1030, 'src': '64463:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes32,address,address,address,uint256,bytes memory,bytes memory)'}}, 'id': 2119, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '64463:190:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2120, 'nodeType': 'EmitStatement', 'src': '64458:195:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'id': 2123, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2121, 'name': 'toPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2076, 'src': '64670:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'id': 2122, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '64685:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'src': '64670:29:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2131, 'nodeType': 'IfStatement', 'src': '64666:120:0', 'trueBody': {'id': 2130, 'nodeType': 'Block', 'src': '64701:85:0', 'statements': [{'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2125, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1960, 'src': '64738:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2126, 'name': 'toPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2076, 'src': '64754:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2127, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1968, 'src': '64767:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 2124, 'name': 'ChangedPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1039, 'src': '64721:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_bytes32_$_t_bytes32_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,bytes32,uint256)'}}, 'id': 2128, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '64721:53:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2129, 'nodeType': 'EmitStatement', 'src': '64716:58:0'}]}}, {'expression': {'argumentTypes': None, 'id': 2132, 'name': 'toPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2076, 'src': '64805:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'functionReturnParameters': 1976, 'id': 2133, 'nodeType': 'Return', 'src': '64798:18:0'}]}",
                        "documentation": "{'id': 1958, 'nodeType': 'StructuredDocumentation', 'src': '61667:598:0', 'text': ' @dev Transfer tokens from a specific partition.\\n @param _fromPartition Partition of the tokens to transfer.\\n @param _operator The address performing the transfer.\\n @param _from Token holder.\\n @param _to Token recipient.\\n @param _value Number of tokens to transfer.\\n @param _data Information attached to the transfer. Contains the destination\\n partition if a partition change is requested.\\n @param _operatorData Information attached to the transfer, by the operator\\n (if any).\\n @return Destination partition.'}",
                        "id": 2135,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_transferByPartition",
                        "overrides": null,
                        "parameters": "{'id': 1973, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1960, 'mutability': 'mutable', 'name': '_fromPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2135, 'src': '62311:22:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1959, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '62311:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1962, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2135, 'src': '62344:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1961, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '62344:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1964, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2135, 'src': '62372:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1963, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '62372:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1966, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2135, 'src': '62396:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1965, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '62396:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1968, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2135, 'src': '62418:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1967, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '62418:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1970, 'mutability': 'mutable', 'name': '_data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2135, 'src': '62443:18:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 1969, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '62443:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1972, 'mutability': 'mutable', 'name': '_operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2135, 'src': '62472:26:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 1971, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '62472:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '62300:205:0'}",
                        "returnParameters": "{'id': 1976, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1975, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2135, 'src': '62524:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1974, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '62524:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '62523:9:0'}",
                        "scope": 2935,
                        "src": "62271:2553:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2159, 'nodeType': 'Block', 'src': '65520:99:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2150, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '65552:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2151, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2138, 'src': '65570:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2152, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2140, 'src': '65581:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2153, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2142, 'src': '65588:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2154, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2144, 'src': '65593:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 2155, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2146, 'src': '65601:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'hexValue': '', 'id': 2156, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '65608:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, 'value': ''}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}], 'id': 2149, 'name': '_transferByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2135, 'src': '65531:20:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes32,address,address,address,uint256,bytes memory,bytes memory) returns (bytes32)'}}, 'id': 2157, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '65531:80:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'id': 2158, 'nodeType': 'ExpressionStatement', 'src': '65531:80:0'}]}",
                        "documentation": "{'id': 2136, 'nodeType': 'StructuredDocumentation', 'src': '64832:501:0', 'text': ' @notice Transfer tokens from default partitions.\\n @dev Used as a helper method for ERC20 compatibility.\\n @param _operator The address performing the transfer.\\n @param _from Token holder.\\n @param _to Token recipient.\\n @param _value Number of tokens to transfer.\\n @param _data Information attached to the transfer, and intended for the\\n token holder (`_from`). Should contain the destination partition if\\n changing partitions.'}",
                        "id": 2160,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_transferByDefaultPartition",
                        "overrides": null,
                        "parameters": "{'id': 2147, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2138, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2160, 'src': '65386:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2137, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '65386:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2140, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2160, 'src': '65414:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2139, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '65414:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2142, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2160, 'src': '65438:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2141, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '65438:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2144, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2160, 'src': '65460:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 2143, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '65460:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2146, 'mutability': 'mutable', 'name': '_data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2160, 'src': '65485:18:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 2145, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '65485:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '65375:135:0'}",
                        "returnParameters": "{'id': 2148, 'nodeType': 'ParameterList', 'parameters': [], 'src': '65520:0:0'}",
                        "scope": 2935,
                        "src": "65339:280:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2296, 'nodeType': 'Block', 'src': '65965:1412:0', 'statements': [{'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2172, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2170, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2167, 'src': '65980:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 2171, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '65990:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '65980:11:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2175, 'nodeType': 'IfStatement', 'src': '65976:50:0', 'trueBody': {'id': 2174, 'nodeType': 'Block', 'src': '65993:33:0', 'statements': [{'expression': None, 'functionReturnParameters': 2169, 'id': 2173, 'nodeType': 'Return', 'src': '66008:7:0'}]}}, {'expression': {'argumentTypes': None, 'id': 2185, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2176, 'name': '_balances', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 921, 'src': '66038:9:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2178, 'indexExpression': {'argumentTypes': None, 'id': 2177, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '66048:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '66038:16:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2183, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2167, 'src': '66078:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2179, 'name': '_balances', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 921, 'src': '66057:9:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2181, 'indexExpression': {'argumentTypes': None, 'id': 2180, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '66067:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66057:16:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2182, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sub', 'nodeType': 'MemberAccess', 'referencedDeclaration': 45, 'src': '66057:20:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 2184, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '66057:28:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '66038:47:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2186, 'nodeType': 'ExpressionStatement', 'src': '66038:47:0'}, {'expression': {'argumentTypes': None, 'id': 2200, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2187, 'name': '_balanceOfByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 955, 'src': '66098:21:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2190, 'indexExpression': {'argumentTypes': None, 'id': 2188, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '66120:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66098:28:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2191, 'indexExpression': {'argumentTypes': None, 'id': 2189, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '66127:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '66098:40:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2198, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2167, 'src': '66200:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2192, 'name': '_balanceOfByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 955, 'src': '66141:21:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2194, 'indexExpression': {'argumentTypes': None, 'id': 2193, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '66163:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66141:28:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2196, 'indexExpression': {'argumentTypes': None, 'id': 2195, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '66170:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66141:40:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2197, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sub', 'nodeType': 'MemberAccess', 'referencedDeclaration': 45, 'src': '66141:58:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 2199, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '66141:66:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '66098:109:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2201, 'nodeType': 'ExpressionStatement', 'src': '66098:109:0'}, {'expression': {'argumentTypes': None, 'id': 2211, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2202, 'name': 'totalSupplyByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 935, 'src': '66218:22:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2204, 'indexExpression': {'argumentTypes': None, 'id': 2203, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '66241:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '66218:34:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2209, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2167, 'src': '66308:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2205, 'name': 'totalSupplyByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 935, 'src': '66255:22:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2207, 'indexExpression': {'argumentTypes': None, 'id': 2206, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '66278:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66255:34:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2208, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sub', 'nodeType': 'MemberAccess', 'referencedDeclaration': 45, 'src': '66255:38:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 2210, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '66255:70:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '66218:107:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2212, 'nodeType': 'ExpressionStatement', 'src': '66218:107:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'id': 2221, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2217, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2213, 'name': 'totalSupplyByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 935, 'src': '66486:22:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2215, 'indexExpression': {'argumentTypes': None, 'id': 2214, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '66509:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66486:34:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 2216, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '66524:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '66486:39:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'BinaryOperation', 'operator': '&&', 'rightExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'id': 2220, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2218, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '66529:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'id': 2219, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '66543:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'src': '66529:30:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'src': '66486:73:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2227, 'nodeType': 'IfStatement', 'src': '66482:153:0', 'trueBody': {'id': 2226, 'nodeType': 'Block', 'src': '66561:74:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2223, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '66612:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 2222, 'name': '_removePartitionFromTotalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2462, 'src': '66576:35:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32)'}}, 'id': 2224, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '66576:47:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2225, 'nodeType': 'ExpressionStatement', 'src': '66576:47:0'}]}}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2234, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2228, 'name': '_balanceOfByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 955, 'src': '66763:21:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2230, 'indexExpression': {'argumentTypes': None, 'id': 2229, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '66785:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66763:28:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2232, 'indexExpression': {'argumentTypes': None, 'id': 2231, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '66792:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66763:40:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 2233, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '66807:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '66763:45:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2295, 'nodeType': 'IfStatement', 'src': '66759:611:0', 'trueBody': {'id': 2294, 'nodeType': 'Block', 'src': '66810:560:0', 'statements': [{'assignments': [2236], 'declarations': [{'constant': False, 'id': 2236, 'mutability': 'mutable', 'name': 'index', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2294, 'src': '66825:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 2235, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '66825:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 2242, 'initialValue': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2237, 'name': '_indexOfPartitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 948, 'src': '66841:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2239, 'indexExpression': {'argumentTypes': None, 'id': 2238, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '66862:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66841:27:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2241, 'indexExpression': {'argumentTypes': None, 'id': 2240, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '66869:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '66841:39:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '66825:55:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2245, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2243, 'name': 'index', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2236, 'src': '66901:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 2244, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '66910:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '66901:10:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2248, 'nodeType': 'IfStatement', 'src': '66897:57:0', 'trueBody': {'id': 2247, 'nodeType': 'Block', 'src': '66913:41:0', 'statements': [{'expression': None, 'functionReturnParameters': 2169, 'id': 2246, 'nodeType': 'Return', 'src': '66932:7:0'}]}}, {'assignments': [2250], 'declarations': [{'constant': False, 'id': 2250, 'mutability': 'mutable', 'name': 'lastValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2294, 'src': '67034:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2249, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '67034:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'id': 2261, 'initialValue': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2251, 'name': '_partitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 941, 'src': '67054:13:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_array$_t_bytes32_$dyn_storage_$', 'typeString': 'mapping(address => bytes32[] storage ref)'}}, 'id': 2253, 'indexExpression': {'argumentTypes': None, 'id': 2252, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '67068:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67054:20:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2260, 'indexExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2259, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2254, 'name': '_partitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 941, 'src': '67075:13:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_array$_t_bytes32_$dyn_storage_$', 'typeString': 'mapping(address => bytes32[] storage ref)'}}, 'id': 2256, 'indexExpression': {'argumentTypes': None, 'id': 2255, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '67089:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67075:20:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2257, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'length', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '67075:27:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '-', 'rightExpression': {'argumentTypes': None, 'hexValue': '31', 'id': 2258, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '67105:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}, 'src': '67075:31:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67054:53:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '67034:73:0'}, {'expression': {'argumentTypes': None, 'id': 2270, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2262, 'name': '_partitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 941, 'src': '67122:13:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_array$_t_bytes32_$dyn_storage_$', 'typeString': 'mapping(address => bytes32[] storage ref)'}}, 'id': 2267, 'indexExpression': {'argumentTypes': None, 'id': 2263, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '67136:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67122:20:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2268, 'indexExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2266, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2264, 'name': 'index', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2236, 'src': '67143:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '-', 'rightExpression': {'argumentTypes': None, 'hexValue': '31', 'id': 2265, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '67151:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}, 'src': '67143:9:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '67122:31:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 2269, 'name': 'lastValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2250, 'src': '67156:9:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'src': '67122:43:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'id': 2271, 'nodeType': 'ExpressionStatement', 'src': '67122:43:0'}, {'expression': {'argumentTypes': None, 'id': 2278, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2272, 'name': '_indexOfPartitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 948, 'src': '67211:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2275, 'indexExpression': {'argumentTypes': None, 'id': 2273, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '67232:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67211:27:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2276, 'indexExpression': {'argumentTypes': None, 'id': 2274, 'name': 'lastValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2250, 'src': '67239:9:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '67211:38:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 2277, 'name': 'index', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2236, 'src': '67252:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '67211:46:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2279, 'nodeType': 'ExpressionStatement', 'src': '67211:46:0'}, {'expression': {'argumentTypes': None, 'arguments': [], 'expression': {'argumentTypes': [], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2280, 'name': '_partitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 941, 'src': '67274:13:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_array$_t_bytes32_$dyn_storage_$', 'typeString': 'mapping(address => bytes32[] storage ref)'}}, 'id': 2282, 'indexExpression': {'argumentTypes': None, 'id': 2281, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '67288:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67274:20:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2283, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'pop', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '67274:24:0', 'typeDescriptions': {'typeIdentifier': 't_function_arraypop_nonpayable$__$returns$__$', 'typeString': 'function ()'}}, 'id': 2284, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '67274:26:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2285, 'nodeType': 'ExpressionStatement', 'src': '67274:26:0'}, {'expression': {'argumentTypes': None, 'id': 2292, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2286, 'name': '_indexOfPartitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 948, 'src': '67315:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2289, 'indexExpression': {'argumentTypes': None, 'id': 2287, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2163, 'src': '67336:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67315:27:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2290, 'indexExpression': {'argumentTypes': None, 'id': 2288, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2165, 'src': '67343:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '67315:39:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '30', 'id': 2291, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '67357:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '67315:43:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2293, 'nodeType': 'ExpressionStatement', 'src': '67315:43:0'}]}}]}",
                        "documentation": "{'id': 2161, 'nodeType': 'StructuredDocumentation', 'src': '65627:203:0', 'text': ' @dev Remove a token from a specific partition.\\n @param _from Token holder.\\n @param _partition Name of the partition.\\n @param _value Number of tokens to transfer.'}",
                        "id": 2297,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_removeTokenFromPartition",
                        "overrides": null,
                        "parameters": "{'id': 2168, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2163, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2297, 'src': '65881:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2162, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '65881:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2165, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2297, 'src': '65905:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2164, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '65905:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2167, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2297, 'src': '65934:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 2166, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '65934:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '65870:85:0'}",
                        "returnParameters": "{'id': 2169, 'nodeType': 'ParameterList', 'parameters': [], 'src': '65965:0:0'}",
                        "scope": 2935,
                        "src": "65836:1541:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2388, 'nodeType': 'Block', 'src': '67712:687:0', 'statements': [{'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2309, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2307, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2304, 'src': '67727:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 2308, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '67737:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '67727:11:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2312, 'nodeType': 'IfStatement', 'src': '67723:50:0', 'trueBody': {'id': 2311, 'nodeType': 'Block', 'src': '67740:33:0', 'statements': [{'expression': None, 'functionReturnParameters': 2306, 'id': 2310, 'nodeType': 'Return', 'src': '67755:7:0'}]}}, {'expression': {'argumentTypes': None, 'id': 2322, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2313, 'name': '_balances', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 921, 'src': '67785:9:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2315, 'indexExpression': {'argumentTypes': None, 'id': 2314, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2300, 'src': '67795:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '67785:14:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2320, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2304, 'src': '67821:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2316, 'name': '_balances', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 921, 'src': '67802:9:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2318, 'indexExpression': {'argumentTypes': None, 'id': 2317, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2300, 'src': '67812:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67802:14:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2319, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'add', 'nodeType': 'MemberAccess', 'referencedDeclaration': 28, 'src': '67802:18:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 2321, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '67802:26:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '67785:43:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2323, 'nodeType': 'ExpressionStatement', 'src': '67785:43:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2330, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2324, 'name': '_indexOfPartitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 948, 'src': '67845:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2326, 'indexExpression': {'argumentTypes': None, 'id': 2325, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2300, 'src': '67866:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67845:25:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2328, 'indexExpression': {'argumentTypes': None, 'id': 2327, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2302, 'src': '67871:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67845:37:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 2329, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '67886:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '67845:42:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2350, 'nodeType': 'IfStatement', 'src': '67841:190:0', 'trueBody': {'id': 2349, 'nodeType': 'Block', 'src': '67889:142:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2335, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2302, 'src': '67928:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2331, 'name': '_partitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 941, 'src': '67904:13:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_array$_t_bytes32_$dyn_storage_$', 'typeString': 'mapping(address => bytes32[] storage ref)'}}, 'id': 2333, 'indexExpression': {'argumentTypes': None, 'id': 2332, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2300, 'src': '67918:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67904:18:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2334, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'push', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '67904:23:0', 'typeDescriptions': {'typeIdentifier': 't_function_arraypush_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32)'}}, 'id': 2336, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '67904:35:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2337, 'nodeType': 'ExpressionStatement', 'src': '67904:35:0'}, {'expression': {'argumentTypes': None, 'id': 2347, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2338, 'name': '_indexOfPartitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 948, 'src': '67954:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2341, 'indexExpression': {'argumentTypes': None, 'id': 2339, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2300, 'src': '67975:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67954:25:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2342, 'indexExpression': {'argumentTypes': None, 'id': 2340, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2302, 'src': '67980:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '67954:37:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2343, 'name': '_partitionsOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 941, 'src': '67994:13:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_array$_t_bytes32_$dyn_storage_$', 'typeString': 'mapping(address => bytes32[] storage ref)'}}, 'id': 2345, 'indexExpression': {'argumentTypes': None, 'id': 2344, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2300, 'src': '68008:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '67994:18:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2346, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'length', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '67994:25:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '67954:65:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2348, 'nodeType': 'ExpressionStatement', 'src': '67954:65:0'}]}}, {'expression': {'argumentTypes': None, 'id': 2364, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2351, 'name': '_balanceOfByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 955, 'src': '68041:21:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2354, 'indexExpression': {'argumentTypes': None, 'id': 2352, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2300, 'src': '68063:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '68041:26:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2355, 'indexExpression': {'argumentTypes': None, 'id': 2353, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2302, 'src': '68068:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '68041:38:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2362, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2304, 'src': '68139:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2356, 'name': '_balanceOfByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 955, 'src': '68082:21:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(bytes32 => uint256))'}}, 'id': 2358, 'indexExpression': {'argumentTypes': None, 'id': 2357, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2300, 'src': '68104:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '68082:26:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2360, 'indexExpression': {'argumentTypes': None, 'id': 2359, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2302, 'src': '68109:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '68082:38:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2361, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'add', 'nodeType': 'MemberAccess', 'referencedDeclaration': 28, 'src': '68082:56:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 2363, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '68082:64:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '68041:105:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2365, 'nodeType': 'ExpressionStatement', 'src': '68041:105:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2370, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2366, 'name': '_indexOfTotalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 930, 'src': '68163:23:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2368, 'indexExpression': {'argumentTypes': None, 'id': 2367, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2302, 'src': '68187:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '68163:35:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 2369, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '68202:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '68163:40:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2376, 'nodeType': 'IfStatement', 'src': '68159:115:0', 'trueBody': {'id': 2375, 'nodeType': 'Block', 'src': '68205:69:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2372, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2302, 'src': '68251:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 2371, 'name': '_addPartitionToTotalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2409, 'src': '68220:30:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32)'}}, 'id': 2373, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '68220:42:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2374, 'nodeType': 'ExpressionStatement', 'src': '68220:42:0'}]}}, {'expression': {'argumentTypes': None, 'id': 2386, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2377, 'name': 'totalSupplyByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 935, 'src': '68284:22:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2379, 'indexExpression': {'argumentTypes': None, 'id': 2378, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2302, 'src': '68307:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '68284:34:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2384, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2304, 'src': '68374:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2380, 'name': 'totalSupplyByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 935, 'src': '68321:22:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2382, 'indexExpression': {'argumentTypes': None, 'id': 2381, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2302, 'src': '68344:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '68321:34:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2383, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'add', 'nodeType': 'MemberAccess', 'referencedDeclaration': 28, 'src': '68321:38:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 2385, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '68321:70:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '68284:107:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2387, 'nodeType': 'ExpressionStatement', 'src': '68284:107:0'}]}",
                        "documentation": "{'id': 2298, 'nodeType': 'StructuredDocumentation', 'src': '67385:199:0', 'text': ' @dev Add a token to a specific partition.\\n @param _to Token recipient.\\n @param _partition Name of the partition.\\n @param _value Number of tokens to transfer.'}",
                        "id": 2389,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_addTokenToPartition",
                        "overrides": null,
                        "parameters": "{'id': 2305, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2300, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2389, 'src': '67630:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2299, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '67630:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2302, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2389, 'src': '67652:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2301, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '67652:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2304, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2389, 'src': '67681:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 2303, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '67681:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '67619:83:0'}",
                        "returnParameters": "{'id': 2306, 'nodeType': 'ParameterList', 'parameters': [], 'src': '67712:0:0'}",
                        "scope": 2935,
                        "src": "67590:809:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2408, 'nodeType': 'Block', 'src': '68608:124:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2398, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2392, 'src': '68641:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'argumentTypes': None, 'id': 2395, 'name': '_totalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 925, 'src': '68619:16:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2397, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'push', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '68619:21:0', 'typeDescriptions': {'typeIdentifier': 't_function_arraypush_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32)'}}, 'id': 2399, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '68619:33:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2400, 'nodeType': 'ExpressionStatement', 'src': '68619:33:0'}, {'expression': {'argumentTypes': None, 'id': 2406, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2401, 'name': '_indexOfTotalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 930, 'src': '68663:23:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2403, 'indexExpression': {'argumentTypes': None, 'id': 2402, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2392, 'src': '68687:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '68663:35:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 2404, 'name': '_totalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 925, 'src': '68701:16:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2405, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'length', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '68701:23:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '68663:61:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2407, 'nodeType': 'ExpressionStatement', 'src': '68663:61:0'}]}",
                        "documentation": "{'id': 2390, 'nodeType': 'StructuredDocumentation', 'src': '68407:126:0', 'text': ' @dev Add a partition to the total partitions collection.\\n @param _partition Name of the partition.'}",
                        "id": 2409,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_addPartitionToTotalPartitions",
                        "overrides": null,
                        "parameters": "{'id': 2393, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2392, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2409, 'src': '68579:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2391, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '68579:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '68578:20:0'}",
                        "returnParameters": "{'id': 2394, 'nodeType': 'ParameterList', 'parameters': [], 'src': '68608:0:0'}",
                        "scope": 2935,
                        "src": "68539:193:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2461, 'nodeType': 'Block', 'src': '68949:488:0', 'statements': [{'assignments': [2416], 'declarations': [{'constant': False, 'id': 2416, 'mutability': 'mutable', 'name': 'index', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2461, 'src': '68960:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 2415, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '68960:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 2420, 'initialValue': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2417, 'name': '_indexOfTotalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 930, 'src': '68976:23:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2419, 'indexExpression': {'argumentTypes': None, 'id': 2418, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2412, 'src': '69000:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '68976:35:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '68960:51:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2423, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2421, 'name': 'index', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2416, 'src': '69028:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 2422, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '69037:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '69028:10:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2426, 'nodeType': 'IfStatement', 'src': '69024:49:0', 'trueBody': {'id': 2425, 'nodeType': 'Block', 'src': '69040:33:0', 'statements': [{'expression': None, 'functionReturnParameters': 2414, 'id': 2424, 'nodeType': 'Return', 'src': '69055:7:0'}]}}, {'assignments': [2428], 'declarations': [{'constant': False, 'id': 2428, 'mutability': 'mutable', 'name': 'lastValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2461, 'src': '69145:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2427, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '69145:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'id': 2435, 'initialValue': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2429, 'name': '_totalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 925, 'src': '69165:16:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2434, 'indexExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2433, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 2430, 'name': '_totalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 925, 'src': '69182:16:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2431, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'length', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '69182:23:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '-', 'rightExpression': {'argumentTypes': None, 'hexValue': '31', 'id': 2432, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '69208:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}, 'src': '69182:27:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '69165:45:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '69145:65:0'}, {'expression': {'argumentTypes': None, 'id': 2442, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2436, 'name': '_totalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 925, 'src': '69221:16:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2440, 'indexExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 2439, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2437, 'name': 'index', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2416, 'src': '69238:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '-', 'rightExpression': {'argumentTypes': None, 'hexValue': '31', 'id': 2438, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '69246:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}, 'src': '69238:9:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '69221:27:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 2441, 'name': 'lastValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2428, 'src': '69251:9:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'src': '69221:39:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'id': 2443, 'nodeType': 'ExpressionStatement', 'src': '69221:39:0'}, {'expression': {'argumentTypes': None, 'id': 2448, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2444, 'name': '_indexOfTotalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 930, 'src': '69302:23:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2446, 'indexExpression': {'argumentTypes': None, 'id': 2445, 'name': 'lastValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2428, 'src': '69326:9:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '69302:34:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 2447, 'name': 'index', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2416, 'src': '69339:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '69302:42:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2449, 'nodeType': 'ExpressionStatement', 'src': '69302:42:0'}, {'expression': {'argumentTypes': None, 'arguments': [], 'expression': {'argumentTypes': [], 'expression': {'argumentTypes': None, 'id': 2450, 'name': '_totalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 925, 'src': '69357:16:0', 'typeDescriptions': {'typeIdentifier': 't_array$_t_bytes32_$dyn_storage', 'typeString': 'bytes32[] storage ref'}}, 'id': 2452, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'pop', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '69357:20:0', 'typeDescriptions': {'typeIdentifier': 't_function_arraypop_nonpayable$__$returns$__$', 'typeString': 'function ()'}}, 'id': 2453, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '69357:22:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2454, 'nodeType': 'ExpressionStatement', 'src': '69357:22:0'}, {'expression': {'argumentTypes': None, 'id': 2459, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2455, 'name': '_indexOfTotalPartitions', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 930, 'src': '69390:23:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_uint256_$', 'typeString': 'mapping(bytes32 => uint256)'}}, 'id': 2457, 'indexExpression': {'argumentTypes': None, 'id': 2456, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2412, 'src': '69414:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '69390:35:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'hexValue': '30', 'id': 2458, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '69428:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '69390:39:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2460, 'nodeType': 'ExpressionStatement', 'src': '69390:39:0'}]}",
                        "documentation": "{'id': 2410, 'nodeType': 'StructuredDocumentation', 'src': '68740:129:0', 'text': ' @dev Remove a partition to the total partitions collection.\\n @param _partition Name of the partition.'}",
                        "id": 2462,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_removePartitionFromTotalPartitions",
                        "overrides": null,
                        "parameters": "{'id': 2413, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2412, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2462, 'src': '68920:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2411, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '68920:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '68919:20:0'}",
                        "returnParameters": "{'id': 2414, 'nodeType': 'ParameterList', 'parameters': [], 'src': '68949:0:0'}",
                        "scope": 2935,
                        "src": "68875:562:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2564, 'nodeType': 'Block', 'src': '70650:1541:0', 'statements': [{'assignments': [2481], 'declarations': [{'constant': False, 'id': 2481, 'mutability': 'mutable', 'name': 'senderImplementation', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2564, 'src': '70661:28:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2480, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '70661:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'id': 2482, 'initialValue': None, 'nodeType': 'VariableDeclarationStatement', 'src': '70661:28:0'}, {'expression': {'argumentTypes': None, 'id': 2488, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 2483, 'name': 'senderImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2481, 'src': '70700:20:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2485, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2469, 'src': '70737:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2486, 'name': 'AMP_TOKENS_SENDER', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 895, 'src': '70744:17:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 2484, 'name': 'interfaceAddr', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 465, 'src': '70723:13:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$_t_string_memory_ptr_$returns$_t_address_$', 'typeString': 'function (address,string memory) view returns (address)'}}, 'id': 2487, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '70723:39:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '70700:62:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 2489, 'nodeType': 'ExpressionStatement', 'src': '70700:62:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 2495, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2490, 'name': 'senderImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2481, 'src': '70777:20:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2493, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '70809:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2492, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '70801:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2491, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '70801:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2494, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '70801:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '70777:34:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2512, 'nodeType': 'IfStatement', 'src': '70773:351:0', 'trueBody': {'id': 2511, 'nodeType': 'Block', 'src': '70813:311:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 2500, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '70902:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 2501, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sig', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '70902:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, {'argumentTypes': None, 'id': 2502, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2465, 'src': '70928:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2503, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2467, 'src': '70961:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2504, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2469, 'src': '70989:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2505, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2471, 'src': '71013:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2506, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2473, 'src': '71035:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 2507, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2475, 'src': '71060:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'id': 2508, 'name': '_operatorData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2477, 'src': '71084:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2497, 'name': 'senderImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2481, 'src': '70845:20:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 2496, 'name': 'IAmpTokensSender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 580, 'src': '70828:16:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_IAmpTokensSender_$580_$', 'typeString': 'type(contract IAmpTokensSender)'}}, 'id': 2498, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '70828:38:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_IAmpTokensSender_$580', 'typeString': 'contract IAmpTokensSender'}}, 'id': 2499, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'tokensToTransfer', 'nodeType': 'MemberAccess', 'referencedDeclaration': 579, 'src': '70828:55:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes4_$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes4,bytes32,address,address,address,uint256,bytes memory,bytes memory) external'}}, 'id': 2509, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '70828:284:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2510, 'nodeType': 'ExpressionStatement', 'src': '70828:284:0'}]}}, {'assignments': [2514], 'declarations': [{'constant': False, 'id': 2514, 'mutability': 'mutable', 'name': 'fromPartitionPrefix', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2564, 'src': '71282:26:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 2513, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '71282:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}], 'id': 2519, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2517, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2465, 'src': '71346:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'argumentTypes': None, 'id': 2515, 'name': 'PartitionUtils', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 801, 'src': '71311:14:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_PartitionUtils_$801_$', 'typeString': 'type(library PartitionUtils)'}}, 'id': 2516, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_getPartitionPrefix', 'nodeType': 'MemberAccess', 'referencedDeclaration': 735, 'src': '71311:34:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_bytes32_$returns$_t_bytes4_$', 'typeString': 'function (bytes32) pure returns (bytes4)'}}, 'id': 2518, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '71311:50:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '71282:79:0'}, {'condition': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2520, 'name': '_isPartitionStrategy', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1006, 'src': '71376:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes4_$_t_bool_$', 'typeString': 'mapping(bytes4 => bool)'}}, 'id': 2522, 'indexExpression': {'argumentTypes': None, 'id': 2521, 'name': 'fromPartitionPrefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2514, 'src': '71397:19:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '71376:41:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2563, 'nodeType': 'IfStatement', 'src': '71372:812:0', 'trueBody': {'id': 2562, 'nodeType': 'Block', 'src': '71419:765:0', 'statements': [{'assignments': [2524], 'declarations': [{'constant': False, 'id': 2524, 'mutability': 'mutable', 'name': 'fromPartitionValidatorImplementation', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2562, 'src': '71434:44:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2523, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '71434:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'id': 2525, 'initialValue': None, 'nodeType': 'VariableDeclarationStatement', 'src': '71434:44:0'}, {'expression': {'argumentTypes': None, 'id': 2537, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 2526, 'name': 'fromPartitionValidatorImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2524, 'src': '71493:36:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2530, 'name': 'this', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -28, 'src': '71572:4:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}], 'id': 2529, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '71564:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2528, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '71564:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2531, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '71564:13:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2534, 'name': 'fromPartitionPrefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2514, 'src': '71647:19:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}], 'expression': {'argumentTypes': None, 'id': 2532, 'name': 'PartitionUtils', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 801, 'src': '71596:14:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_PartitionUtils_$801_$', 'typeString': 'type(library PartitionUtils)'}}, 'id': 2533, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_getPartitionStrategyValidatorIName', 'nodeType': 'MemberAccess', 'referencedDeclaration': 800, 'src': '71596:50:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_bytes4_$returns$_t_string_memory_ptr_$', 'typeString': 'function (bytes4) pure returns (string memory)'}}, 'id': 2535, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '71596:71:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 2527, 'name': 'interfaceAddr', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 465, 'src': '71532:13:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$_t_string_memory_ptr_$returns$_t_address_$', 'typeString': 'function (address,string memory) view returns (address)'}}, 'id': 2536, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '71532:150:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '71493:189:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 2538, 'nodeType': 'ExpressionStatement', 'src': '71493:189:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 2544, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2539, 'name': 'fromPartitionValidatorImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2524, 'src': '71701:36:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2542, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '71749:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2541, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '71741:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2540, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '71741:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2543, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '71741:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '71701:50:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2561, 'nodeType': 'IfStatement', 'src': '71697:476:0', 'trueBody': {'id': 2560, 'nodeType': 'Block', 'src': '71753:420:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 2549, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '71915:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 2550, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sig', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '71915:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, {'argumentTypes': None, 'id': 2551, 'name': '_fromPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2465, 'src': '71945:14:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2552, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2467, 'src': '71982:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2553, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2469, 'src': '72014:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2554, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2471, 'src': '72042:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2555, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2473, 'src': '72068:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 2556, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2475, 'src': '72097:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'id': 2557, 'name': '_operatorData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2477, 'src': '72125:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2546, 'name': 'fromPartitionValidatorImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2524, 'src': '71803:36:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 2545, 'name': 'IAmpPartitionStrategyValidator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 675, 'src': '71772:30:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_IAmpPartitionStrategyValidator_$675_$', 'typeString': 'type(contract IAmpPartitionStrategyValidator)'}}, 'id': 2547, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '71772:68:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_IAmpPartitionStrategyValidator_$675', 'typeString': 'contract IAmpPartitionStrategyValidator'}}, 'id': 2548, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'tokensFromPartitionToValidate', 'nodeType': 'MemberAccess', 'referencedDeclaration': 644, 'src': '71772:120:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes4_$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes4,bytes32,address,address,address,uint256,bytes memory,bytes memory) external'}}, 'id': 2558, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '71772:385:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2559, 'nodeType': 'ExpressionStatement', 'src': '71772:385:0'}]}}]}}]}",
                        "documentation": "{'id': 2463, 'nodeType': 'StructuredDocumentation', 'src': '69609:790:0', 'text': \" @notice Check for and call the 'AmpTokensSender' hook on the sender address\\n (`_from`), and, if `_fromPartition` is within the scope of a strategy,\\n check for and call the 'AmpPartitionStrategy.tokensFromPartitionToTransfer'\\n hook for the strategy.\\n @param _fromPartition Name of the partition to transfer tokens from.\\n @param _operator Address which triggered the balance decrease (through\\n transfer).\\n @param _from Token holder.\\n @param _to Token recipient for a transfer.\\n @param _value Number of tokens the token holder balance is decreased by.\\n @param _data Extra information, pertaining to the `_from` address.\\n @param _operatorData Extra information, attached by the operator (if any).\"}",
                        "id": 2565,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_callPreTransferHooks",
                        "overrides": null,
                        "parameters": "{'id': 2478, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2465, 'mutability': 'mutable', 'name': '_fromPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2565, 'src': '70446:22:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2464, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '70446:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2467, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2565, 'src': '70479:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2466, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '70479:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2469, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2565, 'src': '70507:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2468, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '70507:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2471, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2565, 'src': '70531:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2470, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '70531:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2473, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2565, 'src': '70553:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 2472, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '70553:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2475, 'mutability': 'mutable', 'name': '_data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2565, 'src': '70578:18:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 2474, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '70578:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2477, 'mutability': 'mutable', 'name': '_operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2565, 'src': '70607:26:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 2476, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '70607:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '70435:205:0'}",
                        "returnParameters": "{'id': 2479, 'nodeType': 'ParameterList', 'parameters': [], 'src': '70650:0:0'}",
                        "scope": 2935,
                        "src": "70405:1786:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2675, 'nodeType': 'Block', 'src': '73067:1473:0', 'statements': [{'assignments': [2584], 'declarations': [{'constant': False, 'id': 2584, 'mutability': 'mutable', 'name': 'toPartitionPrefix', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2675, 'src': '73078:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 2583, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '73078:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}], 'id': 2589, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2587, 'name': '_toPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2568, 'src': '73140:12:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'argumentTypes': None, 'id': 2585, 'name': 'PartitionUtils', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 801, 'src': '73105:14:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_PartitionUtils_$801_$', 'typeString': 'type(library PartitionUtils)'}}, 'id': 2586, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_getPartitionPrefix', 'nodeType': 'MemberAccess', 'referencedDeclaration': 735, 'src': '73105:34:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_bytes32_$returns$_t_bytes4_$', 'typeString': 'function (bytes32) pure returns (bytes4)'}}, 'id': 2588, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '73105:48:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '73078:75:0'}, {'condition': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2590, 'name': '_isPartitionStrategy', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1006, 'src': '73168:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes4_$_t_bool_$', 'typeString': 'mapping(bytes4 => bool)'}}, 'id': 2592, 'indexExpression': {'argumentTypes': None, 'id': 2591, 'name': 'toPartitionPrefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2584, 'src': '73189:17:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '73168:39:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': {'id': 2640, 'nodeType': 'Block', 'src': '73950:94:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'id': 2636, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2634, 'name': 'toPartitionPrefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2584, 'src': '73973:17:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'id': 2635, 'name': 'ZERO_PREFIX', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 963, 'src': '73994:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'src': '73973:32:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 2637, 'name': 'EC_5D_PARTITION_RESERVED', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 838, 'src': '74007:24:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 2633, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '73965:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 2638, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '73965:67:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2639, 'nodeType': 'ExpressionStatement', 'src': '73965:67:0'}]}, 'id': 2641, 'nodeType': 'IfStatement', 'src': '73164:880:0', 'trueBody': {'id': 2632, 'nodeType': 'Block', 'src': '73209:735:0', 'statements': [{'assignments': [2594], 'declarations': [{'constant': False, 'id': 2594, 'mutability': 'mutable', 'name': 'partitionManagerImplementation', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2632, 'src': '73224:38:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2593, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '73224:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'id': 2595, 'initialValue': None, 'nodeType': 'VariableDeclarationStatement', 'src': '73224:38:0'}, {'expression': {'argumentTypes': None, 'id': 2607, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 2596, 'name': 'partitionManagerImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2594, 'src': '73277:30:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2600, 'name': 'this', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -28, 'src': '73350:4:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}], 'id': 2599, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '73342:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2598, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '73342:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2601, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '73342:13:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2604, 'name': 'toPartitionPrefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2584, 'src': '73425:17:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}], 'expression': {'argumentTypes': None, 'id': 2602, 'name': 'PartitionUtils', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 801, 'src': '73374:14:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_PartitionUtils_$801_$', 'typeString': 'type(library PartitionUtils)'}}, 'id': 2603, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_getPartitionStrategyValidatorIName', 'nodeType': 'MemberAccess', 'referencedDeclaration': 800, 'src': '73374:50:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_bytes4_$returns$_t_string_memory_ptr_$', 'typeString': 'function (bytes4) pure returns (string memory)'}}, 'id': 2605, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '73374:69:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 2597, 'name': 'interfaceAddr', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 465, 'src': '73310:13:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$_t_string_memory_ptr_$returns$_t_address_$', 'typeString': 'function (address,string memory) view returns (address)'}}, 'id': 2606, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '73310:148:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '73277:181:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 2608, 'nodeType': 'ExpressionStatement', 'src': '73277:181:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 2614, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2609, 'name': 'partitionManagerImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2594, 'src': '73477:30:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2612, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '73519:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2611, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '73511:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2610, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '73511:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2613, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '73511:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '73477:44:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2631, 'nodeType': 'IfStatement', 'src': '73473:460:0', 'trueBody': {'id': 2630, 'nodeType': 'Block', 'src': '73523:410:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 2619, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '73677:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 2620, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sig', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '73677:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, {'argumentTypes': None, 'id': 2621, 'name': '_toPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2568, 'src': '73707:12:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2622, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2570, 'src': '73742:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2623, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2572, 'src': '73774:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2624, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2574, 'src': '73802:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2625, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2576, 'src': '73828:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 2626, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2578, 'src': '73857:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'id': 2627, 'name': '_operatorData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2580, 'src': '73885:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2616, 'name': 'partitionManagerImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2594, 'src': '73573:30:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 2615, 'name': 'IAmpPartitionStrategyValidator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 675, 'src': '73542:30:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_IAmpPartitionStrategyValidator_$675_$', 'typeString': 'type(contract IAmpPartitionStrategyValidator)'}}, 'id': 2617, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '73542:62:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_IAmpPartitionStrategyValidator_$675', 'typeString': 'contract IAmpPartitionStrategyValidator'}}, 'id': 2618, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'tokensToPartitionToValidate', 'nodeType': 'MemberAccess', 'referencedDeclaration': 663, 'src': '73542:112:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes4_$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes4,bytes32,address,address,address,uint256,bytes memory,bytes memory) external'}}, 'id': 2628, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '73542:375:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2629, 'nodeType': 'ExpressionStatement', 'src': '73542:375:0'}]}}]}}, {'assignments': [2643], 'declarations': [{'constant': False, 'id': 2643, 'mutability': 'mutable', 'name': 'recipientImplementation', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2675, 'src': '74056:31:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2642, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '74056:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'id': 2644, 'initialValue': None, 'nodeType': 'VariableDeclarationStatement', 'src': '74056:31:0'}, {'expression': {'argumentTypes': None, 'id': 2650, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 2645, 'name': 'recipientImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2643, 'src': '74098:23:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2647, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2574, 'src': '74138:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2648, 'name': 'AMP_TOKENS_RECIPIENT', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 899, 'src': '74143:20:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 2646, 'name': 'interfaceAddr', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 465, 'src': '74124:13:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$_t_string_memory_ptr_$returns$_t_address_$', 'typeString': 'function (address,string memory) view returns (address)'}}, 'id': 2649, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '74124:40:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '74098:66:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 2651, 'nodeType': 'ExpressionStatement', 'src': '74098:66:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 2657, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2652, 'name': 'recipientImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2643, 'src': '74181:23:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2655, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '74216:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2654, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '74208:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2653, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '74208:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2656, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '74208:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '74181:37:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2674, 'nodeType': 'IfStatement', 'src': '74177:356:0', 'trueBody': {'id': 2673, 'nodeType': 'Block', 'src': '74220:313:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 2662, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '74313:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 2663, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sig', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '74313:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, {'argumentTypes': None, 'id': 2664, 'name': '_toPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2568, 'src': '74339:12:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2665, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2570, 'src': '74370:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2666, 'name': '_from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2572, 'src': '74398:5:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2667, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2574, 'src': '74422:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2668, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2576, 'src': '74444:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 2669, 'name': '_data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2578, 'src': '74469:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'argumentTypes': None, 'id': 2670, 'name': '_operatorData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2580, 'src': '74493:13:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2659, 'name': 'recipientImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2643, 'src': '74255:23:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 2658, 'name': 'IAmpTokensRecipient', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 624, 'src': '74235:19:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_IAmpTokensRecipient_$624_$', 'typeString': 'type(contract IAmpTokensRecipient)'}}, 'id': 2660, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '74235:44:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_IAmpTokensRecipient_$624', 'typeString': 'contract IAmpTokensRecipient'}}, 'id': 2661, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'tokensReceived', 'nodeType': 'MemberAccess', 'referencedDeclaration': 623, 'src': '74235:59:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes4_$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes4,bytes32,address,address,address,uint256,bytes memory,bytes memory) external'}}, 'id': 2671, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '74235:286:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2672, 'nodeType': 'ExpressionStatement', 'src': '74235:286:0'}]}}]}",
                        "documentation": "{'id': 2566, 'nodeType': 'StructuredDocumentation', 'src': '72199:618:0', 'text': \" @dev Check for 'AmpTokensRecipient' hook on the recipient and call it.\\n @param _toPartition Name of the partition the tokens were transferred to.\\n @param _operator Address which triggered the balance increase (through\\n transfer or mint).\\n @param _from Token holder for a transfer (0x when mint).\\n @param _to Token recipient.\\n @param _value Number of tokens the recipient balance is increased by.\\n @param _data Extra information related to the token holder (`_from`).\\n @param _operatorData Extra information attached by the operator (if any).\"}",
                        "id": 2676,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_callPostTransferHooks",
                        "overrides": null,
                        "parameters": "{'id': 2581, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2568, 'mutability': 'mutable', 'name': '_toPartition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2676, 'src': '72865:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2567, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '72865:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2570, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2676, 'src': '72896:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2569, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '72896:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2572, 'mutability': 'mutable', 'name': '_from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2676, 'src': '72924:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2571, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '72924:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2574, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2676, 'src': '72948:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2573, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '72948:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2576, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2676, 'src': '72970:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 2575, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '72970:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2578, 'mutability': 'mutable', 'name': '_data', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2676, 'src': '72995:18:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 2577, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '72995:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2580, 'mutability': 'mutable', 'name': '_operatorData', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2676, 'src': '73024:26:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 2579, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '73024:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'value': None, 'visibility': 'internal'}], 'src': '72854:203:0'}",
                        "returnParameters": "{'id': 2582, 'nodeType': 'ParameterList', 'parameters': [], 'src': '73067:0:0'}",
                        "scope": 2935,
                        "src": "72823:1717:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2736, 'nodeType': 'Block', 'src': '75247:421:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 2694, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2689, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2681, 'src': '75266:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2692, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '75290:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2691, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '75282:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2690, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '75282:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2693, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '75282:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '75266:26:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 2695, 'name': 'EC_56_INVALID_SENDER', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 817, 'src': '75294:20:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 2688, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '75258:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 2696, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '75258:57:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2697, 'nodeType': 'ExpressionStatement', 'src': '75258:57:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 2704, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2699, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2683, 'src': '75334:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2702, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '75354:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2701, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '75346:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2700, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '75346:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2703, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '75346:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '75334:22:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 2705, 'name': 'EC_58_INVALID_OPERATOR', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 823, 'src': '75358:22:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 2698, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '75326:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 2706, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '75326:55:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2707, 'nodeType': 'ExpressionStatement', 'src': '75326:55:0'}, {'expression': {'argumentTypes': None, 'id': 2716, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2708, 'name': '_allowedByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 979, 'src': '75394:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$_$', 'typeString': 'mapping(bytes32 => mapping(address => mapping(address => uint256)))'}}, 'id': 2712, 'indexExpression': {'argumentTypes': None, 'id': 2709, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2679, 'src': '75414:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '75394:31:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_uint256_$_$', 'typeString': 'mapping(address => mapping(address => uint256))'}}, 'id': 2713, 'indexExpression': {'argumentTypes': None, 'id': 2710, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2681, 'src': '75426:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '75394:45:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 2714, 'indexExpression': {'argumentTypes': None, 'id': 2711, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2683, 'src': '75440:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '75394:55:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 2715, 'name': '_amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2685, 'src': '75452:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '75394:65:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2717, 'nodeType': 'ExpressionStatement', 'src': '75394:65:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2719, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2679, 'src': '75495:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2720, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2681, 'src': '75507:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2721, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2683, 'src': '75521:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2722, 'name': '_amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2685, 'src': '75531:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 2718, 'name': 'ApprovalByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1050, 'src': '75475:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,address,address,uint256)'}}, 'id': 2723, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '75475:64:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2724, 'nodeType': 'EmitStatement', 'src': '75470:69:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'id': 2727, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2725, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2679, 'src': '75556:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'id': 2726, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '75570:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'src': '75556:30:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2735, 'nodeType': 'IfStatement', 'src': '75552:109:0', 'trueBody': {'id': 2734, 'nodeType': 'Block', 'src': '75588:73:0', 'statements': [{'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2729, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2681, 'src': '75617:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2730, 'name': '_spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2683, 'src': '75631:8:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2731, 'name': '_amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2685, 'src': '75641:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 2728, 'name': 'Approval', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 270, 'src': '75608:8:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (address,address,uint256)'}}, 'id': 2732, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '75608:41:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2733, 'nodeType': 'EmitStatement', 'src': '75603:46:0'}]}}]}",
                        "documentation": "{'id': 2677, 'nodeType': 'StructuredDocumentation', 'src': '74712:371:0', 'text': \" @notice Approve the `_spender` address to spend the specified amount of\\n tokens in `_partition` on behalf of 'msg.sender'.\\n @param _partition Name of the partition.\\n @param _tokenHolder Owner of the tokens.\\n @param _spender The address which will spend the tokens.\\n @param _amount The amount of tokens to be tokens.\"}",
                        "id": 2737,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_approveByPartition",
                        "overrides": null,
                        "parameters": "{'id': 2686, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2679, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2737, 'src': '75128:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2678, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '75128:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2681, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2737, 'src': '75157:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2680, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '75157:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2683, 'mutability': 'mutable', 'name': '_spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2737, 'src': '75188:16:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2682, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '75188:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2685, 'mutability': 'mutable', 'name': '_amount', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2737, 'src': '75215:15:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 2684, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '75215:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '75117:120:0'}",
                        "returnParameters": "{'id': 2687, 'nodeType': 'ParameterList', 'parameters': [], 'src': '75247:0:0'}",
                        "scope": 2935,
                        "src": "75089:579:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2758, 'nodeType': 'Block', 'src': '76478:114:0', 'statements': [{'expression': {'argumentTypes': None, 'components': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'id': 2755, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 2749, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2747, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2740, 'src': '76497:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'id': 2748, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2742, 'src': '76510:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '76497:25:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'BinaryOperation', 'operator': '||', 'rightExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2750, 'name': '_authorizedOperator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 970, 'src': '76539:19:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(address => mapping(address => bool))'}}, 'id': 2752, 'indexExpression': {'argumentTypes': None, 'id': 2751, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2742, 'src': '76559:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '76539:33:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 2754, 'indexExpression': {'argumentTypes': None, 'id': 2753, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2740, 'src': '76573:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '76539:44:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'src': '76497:86:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}], 'id': 2756, 'isConstant': False, 'isInlineArray': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'nodeType': 'TupleExpression', 'src': '76496:88:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'functionReturnParameters': 2746, 'id': 2757, 'nodeType': 'Return', 'src': '76489:95:0'}]}",
                        "documentation": "{'id': 2738, 'nodeType': 'StructuredDocumentation', 'src': '75840:509:0', 'text': \" @dev Indicate whether the operator address is an operator of the\\n tokenHolder address. An operator in this case is an operator across all\\n partitions of the `msg.sender` address.\\n @param _operator Address which may be an operator of '_tokenHolder'.\\n @param _tokenHolder Address of a token holder which may have the '_operator'\\n address as an operator.\\n @return 'true' if `_operator` is an operator of `_tokenHolder` and 'false'\\n otherwise.\"}",
                        "id": 2759,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_isOperator",
                        "overrides": null,
                        "parameters": "{'id': 2743, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2740, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2759, 'src': '76376:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2739, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '76376:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2742, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2759, 'src': '76395:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2741, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '76395:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '76375:41:0'}",
                        "returnParameters": "{'id': 2746, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2745, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2759, 'src': '76467:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 2744, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '76467:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '76466:6:0'}",
                        "scope": 2935,
                        "src": "76355:237:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2791, 'nodeType': 'Block', 'src': '77321:236:0', 'statements': [{'expression': {'argumentTypes': None, 'components': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'id': 2788, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'id': 2782, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2772, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2764, 'src': '77352:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2773, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2766, 'src': '77363:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 2771, 'name': '_isOperator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2759, 'src': '77340:11:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$_t_address_$returns$_t_bool_$', 'typeString': 'function (address,address) view returns (bool)'}}, 'id': 2774, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '77340:36:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'BinaryOperation', 'operator': '||', 'rightExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2775, 'name': '_authorizedOperatorByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 988, 'src': '77393:30:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$_$', 'typeString': 'mapping(address => mapping(bytes32 => mapping(address => bool)))'}}, 'id': 2777, 'indexExpression': {'argumentTypes': None, 'id': 2776, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2766, 'src': '77424:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '77393:44:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes32_$_t_mapping$_t_address_$_t_bool_$_$', 'typeString': 'mapping(bytes32 => mapping(address => bool))'}}, 'id': 2779, 'indexExpression': {'argumentTypes': None, 'id': 2778, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2762, 'src': '77438:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '77393:56:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_bool_$', 'typeString': 'mapping(address => bool)'}}, 'id': 2781, 'indexExpression': {'argumentTypes': None, 'id': 2780, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2764, 'src': '77450:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '77393:67:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'src': '77340:120:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'BinaryOperation', 'operator': '||', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2784, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2762, 'src': '77512:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2785, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2764, 'src': '77524:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2786, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2766, 'src': '77535:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 2783, 'name': '_callPartitionStrategyOperatorHook', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2855, 'src': '77477:34:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$_t_address_$_t_address_$returns$_t_bool_$', 'typeString': 'function (bytes32,address,address) view returns (bool)'}}, 'id': 2787, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '77477:71:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'src': '77340:208:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}], 'id': 2789, 'isConstant': False, 'isInlineArray': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'nodeType': 'TupleExpression', 'src': '77339:210:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'functionReturnParameters': 2770, 'id': 2790, 'nodeType': 'Return', 'src': '77332:217:0'}]}",
                        "documentation": "{'id': 2760, 'nodeType': 'StructuredDocumentation', 'src': '76600:558:0', 'text': \" @dev Indicate whether the operator address is an operator of the\\n tokenHolder address for the given partition.\\n @param _partition Name of the partition.\\n @param _operator Address which may be an operator of tokenHolder for the\\n given partition.\\n @param _tokenHolder Address of a token holder which may have the operator\\n address as an operator for the given partition.\\n @return 'true' if 'operator' is an operator of 'tokenHolder' for partition\\n `_partition` and 'false' otherwise.\"}",
                        "id": 2792,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_isOperatorForPartition",
                        "overrides": null,
                        "parameters": "{'id': 2767, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2762, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2792, 'src': '77207:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2761, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '77207:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2764, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2792, 'src': '77236:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2763, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '77236:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2766, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2792, 'src': '77264:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2765, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '77264:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '77196:95:0'}",
                        "returnParameters": "{'id': 2770, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2769, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2792, 'src': '77315:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 2768, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '77315:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '77314:6:0'}",
                        "scope": 2935,
                        "src": "77164:393:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2854, 'nodeType': 'Block', 'src': '78262:746:0', 'statements': [{'assignments': [2805], 'declarations': [{'constant': False, 'id': 2805, 'mutability': 'mutable', 'name': 'prefix', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2854, 'src': '78273:13:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}, 'typeName': {'id': 2804, 'name': 'bytes4', 'nodeType': 'ElementaryTypeName', 'src': '78273:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'value': None, 'visibility': 'internal'}], 'id': 2810, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2808, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2795, 'src': '78324:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'argumentTypes': None, 'id': 2806, 'name': 'PartitionUtils', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 801, 'src': '78289:14:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_PartitionUtils_$801_$', 'typeString': 'type(library PartitionUtils)'}}, 'id': 2807, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_getPartitionPrefix', 'nodeType': 'MemberAccess', 'referencedDeclaration': 735, 'src': '78289:34:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_bytes32_$returns$_t_bytes4_$', 'typeString': 'function (bytes32) pure returns (bytes4)'}}, 'id': 2809, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '78289:46:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '78273:62:0'}, {'condition': {'argumentTypes': None, 'id': 2814, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'nodeType': 'UnaryOperation', 'operator': '!', 'prefix': True, 'src': '78352:29:0', 'subExpression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 2811, 'name': '_isPartitionStrategy', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1006, 'src': '78353:20:0', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_bytes4_$_t_bool_$', 'typeString': 'mapping(bytes4 => bool)'}}, 'id': 2813, 'indexExpression': {'argumentTypes': None, 'id': 2812, 'name': 'prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2805, 'src': '78374:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '78353:28:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2818, 'nodeType': 'IfStatement', 'src': '78348:74:0', 'trueBody': {'id': 2817, 'nodeType': 'Block', 'src': '78383:39:0', 'statements': [{'expression': {'argumentTypes': None, 'hexValue': '66616c7365', 'id': 2815, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '78405:5:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'false'}, 'functionReturnParameters': 2803, 'id': 2816, 'nodeType': 'Return', 'src': '78398:12:0'}]}}, {'assignments': [2820], 'declarations': [{'constant': False, 'id': 2820, 'mutability': 'mutable', 'name': 'strategyValidatorImplementation', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2854, 'src': '78434:39:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2819, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '78434:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'id': 2821, 'initialValue': None, 'nodeType': 'VariableDeclarationStatement', 'src': '78434:39:0'}, {'expression': {'argumentTypes': None, 'id': 2833, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 2822, 'name': 'strategyValidatorImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2820, 'src': '78484:31:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2826, 'name': 'this', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -28, 'src': '78554:4:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_Amp_$2935', 'typeString': 'contract Amp'}], 'id': 2825, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '78546:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2824, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '78546:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2827, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '78546:13:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2830, 'name': 'prefix', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2805, 'src': '78625:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes4', 'typeString': 'bytes4'}], 'expression': {'argumentTypes': None, 'id': 2828, 'name': 'PartitionUtils', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 801, 'src': '78574:14:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_PartitionUtils_$801_$', 'typeString': 'type(library PartitionUtils)'}}, 'id': 2829, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': '_getPartitionStrategyValidatorIName', 'nodeType': 'MemberAccess', 'referencedDeclaration': 800, 'src': '78574:50:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_bytes4_$returns$_t_string_memory_ptr_$', 'typeString': 'function (bytes4) pure returns (string memory)'}}, 'id': 2831, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '78574:58:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 2823, 'name': 'interfaceAddr', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 465, 'src': '78518:13:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$_t_string_memory_ptr_$returns$_t_address_$', 'typeString': 'function (address,string memory) view returns (address)'}}, 'id': 2832, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '78518:125:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '78484:159:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 2834, 'nodeType': 'ExpressionStatement', 'src': '78484:159:0'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 2840, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2835, 'name': 'strategyValidatorImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2820, 'src': '78658:31:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2838, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '78701:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2837, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '78693:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2836, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '78693:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2839, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '78693:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '78658:45:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 2851, 'nodeType': 'IfStatement', 'src': '78654:252:0', 'trueBody': {'id': 2850, 'nodeType': 'Block', 'src': '78705:201:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2845, 'name': '_partition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2795, 'src': '78858:10:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2846, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2797, 'src': '78870:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2847, 'name': '_tokenHolder', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2799, 'src': '78881:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2842, 'name': 'strategyValidatorImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2820, 'src': '78775:31:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 2841, 'name': 'IAmpPartitionStrategyValidator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 675, 'src': '78744:30:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_IAmpPartitionStrategyValidator_$675_$', 'typeString': 'type(contract IAmpPartitionStrategyValidator)'}}, 'id': 2843, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '78744:63:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_IAmpPartitionStrategyValidator_$675', 'typeString': 'contract IAmpPartitionStrategyValidator'}}, 'id': 2844, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'isOperatorForPartitionScope', 'nodeType': 'MemberAccess', 'referencedDeclaration': 674, 'src': '78744:113:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_bytes32_$_t_address_$_t_address_$returns$_t_bool_$', 'typeString': 'function (bytes32,address,address) view external returns (bool)'}}, 'id': 2848, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '78744:150:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'functionReturnParameters': 2803, 'id': 2849, 'nodeType': 'Return', 'src': '78720:174:0'}]}}, {'expression': {'argumentTypes': None, 'hexValue': '66616c7365', 'id': 2852, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'bool', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '78995:5:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'value': 'false'}, 'functionReturnParameters': 2803, 'id': 2853, 'nodeType': 'Return', 'src': '78988:12:0'}]}",
                        "documentation": "{'id': 2793, 'nodeType': 'StructuredDocumentation', 'src': '77565:523:0', 'text': \" @notice Check if the `_partition` is within the scope of a strategy, and\\n call it's isOperatorForPartitionScope hook if so.\\n @dev This allows implicit granting of operatorByPartition permissions\\n based on the partition being used being of a strategy.\\n @param _partition The partition to check.\\n @param _operator The address to check if is an operator for `_tokenHolder`.\\n @param _tokenHolder The address to validate that `_operator` is an\\n operator for.\"}",
                        "id": 2855,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_callPartitionStrategyOperatorHook",
                        "overrides": null,
                        "parameters": "{'id': 2800, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2795, 'mutability': 'mutable', 'name': '_partition', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2855, 'src': '78148:18:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 2794, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '78148:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2797, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2855, 'src': '78177:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2796, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '78177:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2799, 'mutability': 'mutable', 'name': '_tokenHolder', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2855, 'src': '78205:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2798, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '78205:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}], 'src': '78137:95:0'}",
                        "returnParameters": "{'id': 2803, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2802, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2855, 'src': '78256:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 2801, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '78256:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'value': None, 'visibility': 'internal'}], 'src': '78255:6:0'}",
                        "scope": 2935,
                        "src": "78094:914:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 2933, 'nodeType': 'Block', 'src': '79631:572:0', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 2871, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 2866, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2860, 'src': '79650:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2869, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '79665:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2868, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '79657:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2867, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '79657:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2870, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '79657:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '79650:17:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'id': 2872, 'name': 'EC_57_INVALID_RECEIVER', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 820, 'src': '79669:22:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}], 'id': 2865, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '79642:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 2873, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '79642:50:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2874, 'nodeType': 'ExpressionStatement', 'src': '79642:50:0'}, {'expression': {'argumentTypes': None, 'id': 2880, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 2875, 'name': '_totalSupply', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 912, 'src': '79705:12:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2878, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2862, 'src': '79737:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'id': 2876, 'name': '_totalSupply', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 912, 'src': '79720:12:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2877, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'add', 'nodeType': 'MemberAccess', 'referencedDeclaration': 28, 'src': '79720:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 2879, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '79720:24:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '79705:39:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 2881, 'nodeType': 'ExpressionStatement', 'src': '79705:39:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2883, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2860, 'src': '79776:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2884, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '79781:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2885, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2862, 'src': '79799:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 2882, 'name': '_addTokenToPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2389, 'src': '79755:20:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_bytes32_$_t_uint256_$returns$__$', 'typeString': 'function (address,bytes32,uint256)'}}, 'id': 2886, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '79755:51:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2887, 'nodeType': 'ExpressionStatement', 'src': '79755:51:0'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2889, 'name': 'defaultPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 959, 'src': '79854:16:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2890, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2858, 'src': '79885:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2893, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '79917:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2892, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '79909:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2891, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '79909:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2894, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '79909:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 2895, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2860, 'src': '79934:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2896, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2862, 'src': '79952:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'hexValue': '', 'id': 2897, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '79973:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, 'value': ''}, {'argumentTypes': None, 'hexValue': '', 'id': 2898, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '79990:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, 'value': ''}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}], 'id': 2888, 'name': '_callPostTransferHooks', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2676, 'src': '79817:22:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes32,address,address,address,uint256,bytes memory,bytes memory)'}}, 'id': 2899, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '79817:186:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2900, 'nodeType': 'ExpressionStatement', 'src': '79817:186:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 2902, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2858, 'src': '80028:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2903, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2860, 'src': '80039:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2904, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2862, 'src': '80044:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'hexValue': '', 'id': 2905, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '80052:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, 'value': ''}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}], 'id': 2901, 'name': 'Minted', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1107, 'src': '80021:6:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (address,address,uint256,bytes memory)'}}, 'id': 2906, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '80021:34:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2907, 'nodeType': 'EmitStatement', 'src': '80016:39:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2911, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '80088:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2910, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '80080:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2909, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '80080:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2912, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '80080:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 2913, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2860, 'src': '80092:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2914, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2862, 'src': '80097:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 2908, 'name': 'Transfer', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 261, 'src': '80071:8:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (address,address,uint256)'}}, 'id': 2915, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '80071:33:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2916, 'nodeType': 'EmitStatement', 'src': '80066:38:0'}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2920, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '80148:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2919, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '80140:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_bytes32_$', 'typeString': 'type(bytes32)'}, 'typeName': {'id': 2918, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '80140:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2921, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '80140:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 2922, 'name': '_operator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2858, 'src': '80152:9:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 2925, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '80171:1:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 2924, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '80163:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 2923, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '80163:7:0', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 2926, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '80163:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'argumentTypes': None, 'id': 2927, 'name': '_to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2860, 'src': '80175:3:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 2928, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 2862, 'src': '80180:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'hexValue': '', 'id': 2929, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '80188:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, 'value': ''}, {'argumentTypes': None, 'hexValue': '', 'id': 2930, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '80192:2:0', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, 'value': ''}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}, {'typeIdentifier': 't_stringliteral_c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470', 'typeString': 'literal_string \"\"'}], 'id': 2917, 'name': 'TransferByPartition', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1030, 'src': '80120:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_bytes32_$_t_address_$_t_address_$_t_address_$_t_uint256_$_t_bytes_memory_ptr_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes32,address,address,address,uint256,bytes memory,bytes memory)'}}, 'id': 2931, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '80120:75:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 2932, 'nodeType': 'EmitStatement', 'src': '80115:80:0'}]}",
                        "documentation": "{'id': 2856, 'nodeType': 'StructuredDocumentation', 'src': '79180:339:0', 'text': \" @notice Perform the minting of tokens.\\n @dev The tokens will be minted on behalf of the `_to` address, and will be\\n minted to the address's default partition.\\n @param _operator Address which triggered the issuance.\\n @param _to Token recipient.\\n @param _value Number of tokens issued.\"}",
                        "id": 2934,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_mint",
                        "overrides": null,
                        "parameters": "{'id': 2863, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 2858, 'mutability': 'mutable', 'name': '_operator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2934, 'src': '79550:17:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2857, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '79550:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2860, 'mutability': 'mutable', 'name': '_to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2934, 'src': '79578:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 2859, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '79578:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 2862, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 2934, 'src': '79600:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 2861, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '79600:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '79539:82:0'}",
                        "returnParameters": "{'id': 2864, 'nodeType': 'ParameterList', 'parameters': [], 'src': '79631:0:0'}",
                        "scope": 2935,
                        "src": "79525:678:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                }
            ]
        }
    ]
}
$$,
''
);