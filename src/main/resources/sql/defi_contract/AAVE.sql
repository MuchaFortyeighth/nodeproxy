INSERT INTO defi_contracts
(contract_name, contract_address, primary_category, secondary_category,
	source_code,
	source_code_tree,
	source_code_scan_result)
VALUES('AAVE', '0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9', '金融功能类', '借贷',
$$
// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.10;

import {ERC20} from "../open-zeppelin/ERC20.sol";
import {ITransferHook} from "../interfaces/ITransferHook.sol";
import {VersionedInitializable} from "../utils/VersionedInitializable.sol";


/**
* @notice implementation of the AAVE token contract
* @author Aave
*/
contract AaveToken is ERC20, VersionedInitializable {

    /// @dev snapshot of a value on a specific block, used for balances
    struct Snapshot {
        uint128 blockNumber;
        uint128 value;
    }

    string internal constant NAME = "Aave Token";
    string internal constant SYMBOL = "AAVE";
    uint8 internal constant DECIMALS = 18;

    /// @dev the amount being distributed for the LEND -> AAVE migration
    uint256 internal constant MIGRATION_AMOUNT = 13000000 ether;

    /// @dev the amount being distributed for the PSI and PEI
    uint256 internal constant DISTRIBUTION_AMOUNT = 3000000 ether;

    uint256 public constant REVISION = 1;

    /// @dev owner => next valid nonce to submit with permit()
    mapping (address => uint256) public _nonces;

    mapping (address => mapping (uint256 => Snapshot)) public _snapshots;

    mapping (address => uint256) public _countsSnapshots;

    /// @dev reference to the Aave governance contract to call (if initialized) on _beforeTokenTransfer
    /// !!! IMPORTANT The Aave governance is considered a trustable contract, being its responsibility
    /// to control all potential reentrancies by calling back the AaveToken
    ITransferHook public _aaveGovernance;

    bytes32 public DOMAIN_SEPARATOR;
    bytes public constant EIP712_REVISION = bytes("1");
    bytes32 internal constant EIP712_DOMAIN = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    event SnapshotDone(address owner, uint128 oldValue, uint128 newValue);

    constructor() ERC20(NAME, SYMBOL) public {}

    /**
    * @dev initializes the contract upon assignment to the InitializableAdminUpgradeabilityProxy
    * @param migrator the address of the LEND -> AAVE migration contract
    * @param distributor the address of the AAVE distribution contract
    */
    function initialize(
        address migrator,
        address distributor,
        ITransferHook aaveGovernance
    ) external initializer {

        uint256 chainId;

        //solium-disable-next-line
        assembly {
            chainId := chainid()
        }

        DOMAIN_SEPARATOR = keccak256(abi.encode(
            EIP712_DOMAIN,
            keccak256(bytes(NAME)),
            keccak256(EIP712_REVISION),
            chainId,
            address(this)
        ));
        _name = NAME;
        _symbol = SYMBOL;
        _setupDecimals(DECIMALS);
        _aaveGovernance = aaveGovernance;
        _mint(migrator, MIGRATION_AMOUNT);
        _mint(distributor, DISTRIBUTION_AMOUNT);
    }

    /**
    * @dev implements the permit function as for https://github.com/ethereum/EIPs/blob/8a34d644aacf0f9f8f00815307fd7dd5da07655f/EIPS/eip-2612.md
    * @param owner the owner of the funds
    * @param spender the spender
    * @param value the amount
    * @param deadline the deadline timestamp, type(uint256).max for no deadline
    * @param v signature param
    * @param s signature param
    * @param r signature param
    */

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        require(owner != address(0), "INVALID_OWNER");
        //solium-disable-next-line
        require(block.timestamp <= deadline, "INVALID_EXPIRATION");
        uint256 currentValidNonce = _nonces[owner];
        bytes32 digest = keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    DOMAIN_SEPARATOR,
                    keccak256(
                        abi.encode(PERMIT_TYPEHASH, owner, spender, value, currentValidNonce, deadline))
                    )
        );

        require(owner == ecrecover(digest, v, r, s), "INVALID_SIGNATURE");
        _nonces[owner] = currentValidNonce.add(1);
        _approve(owner, spender, value);
    }

    /**
    * @dev returns the revision of the implementation contract
    */
    function getRevision() internal pure override returns (uint256) {
        return REVISION;
    }

    /**
    * @dev Writes a snapshot for an owner of tokens
    * @param owner The owner of the tokens
    * @param oldValue The value before the operation that is gonna be executed after the snapshot
    * @param newValue The value after the operation
    */
    function _writeSnapshot(address owner, uint128 oldValue, uint128 newValue) internal {
        uint128 currentBlock = uint128(block.number);

        uint256 ownerCountOfSnapshots = _countsSnapshots[owner];
        mapping (uint256 => Snapshot) storage snapshotsOwner = _snapshots[owner];

        // Doing multiple operations in the same block
        if (ownerCountOfSnapshots != 0 && snapshotsOwner[ownerCountOfSnapshots.sub(1)].blockNumber == currentBlock) {
            snapshotsOwner[ownerCountOfSnapshots.sub(1)].value = newValue;
        } else {
            snapshotsOwner[ownerCountOfSnapshots] = Snapshot(currentBlock, newValue);
            _countsSnapshots[owner] = ownerCountOfSnapshots.add(1);
        }

        emit SnapshotDone(owner, oldValue, newValue);
    }

    /**
    * @dev Writes a snapshot before any operation involving transfer of value: _transfer, _mint and _burn
    * - On _transfer, it writes snapshots for both "from" and "to"
    * - On _mint, only for _to
    * - On _burn, only for _from
    * @param from the from address
    * @param to the to address
    * @param amount the amount to transfer
    */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        if (from == to) {
            return;
        }

        if (from != address(0)) {
            uint256 fromBalance = balanceOf(from);
            _writeSnapshot(from, uint128(fromBalance), uint128(fromBalance.sub(amount)));
        }
        if (to != address(0)) {
            uint256 toBalance = balanceOf(to);
            _writeSnapshot(to, uint128(toBalance), uint128(toBalance.add(amount)));
        }

        // caching the aave governance address to avoid multiple state loads
        ITransferHook aaveGovernance = _aaveGovernance;
        if (aaveGovernance != ITransferHook(0)) {
            aaveGovernance.onTransfer(from, to, amount);
        }
    }
}
$$,
$$
{
    "name": "SourceUnit",
    "attributes": {
        "absolutePath": "mainnet/0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9/contracts/token/AaveToken.sol",
        "exportedSymbols": "{'AaveToken': [1315]}",
        "id": 1316,
        "license": "agpl-3.0",
        "src": "37:6665:6"
    },
    "children": [
        {
            "name": "PragmaDirective",
            "attributes": {
                "id": 881,
                "literals": [
                    "solidity",
                    "0.6",
                    ".10"
                ],
                "src": "37:23:6"
            },
            "children": []
        },
        {
            "name": "ImportDirective",
            "attributes": {
                "absolutePath": "mainnet/0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9/contracts/open-zeppelin/ERC20.sol",
                "file": "../open-zeppelin/ERC20.sol",
                "id": 883,
                "scope": 1316,
                "sourceUnit": 684,
                "src": "62:49:6",
                "symbolAliases": [
                    {
                        "foreign": {
                            "argumentTypes": null,
                            "id": 882,
                            "name": "ERC20",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": null,
                            "src": "70:5:6",
                            "typeDescriptions": {
                                "typeIdentifier": null,
                                "typeString": null
                            }
                        },
                        "local": null
                    }
                ],
                "unitAlias": ""
            },
            "children": []
        },
        {
            "name": "ImportDirective",
            "attributes": {
                "absolutePath": "mainnet/0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9/contracts/interfaces/ITransferHook.sol",
                "file": "../interfaces/ITransferHook.sol",
                "id": 885,
                "scope": 1316,
                "sourceUnit": 90,
                "src": "112:62:6",
                "symbolAliases": [
                    {
                        "foreign": {
                            "argumentTypes": null,
                            "id": 884,
                            "name": "ITransferHook",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": null,
                            "src": "120:13:6",
                            "typeDescriptions": {
                                "typeIdentifier": null,
                                "typeString": null
                            }
                        },
                        "local": null
                    }
                ],
                "unitAlias": ""
            },
            "children": []
        },
        {
            "name": "ImportDirective",
            "attributes": {
                "absolutePath": "mainnet/0x7fc66500c84a76ad7e9c93437bfc5ac33e2ddae9/contracts/utils/VersionedInitializable.sol",
                "file": "../utils/VersionedInitializable.sol",
                "id": 887,
                "scope": 1316,
                "sourceUnit": 1355,
                "src": "175:75:6",
                "symbolAliases": [
                    {
                        "foreign": {
                            "argumentTypes": null,
                            "id": 886,
                            "name": "VersionedInitializable",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "referencedDeclaration": null,
                            "src": "183:22:6",
                            "typeDescriptions": {
                                "typeIdentifier": null,
                                "typeString": null
                            }
                        },
                        "local": null
                    }
                ],
                "unitAlias": ""
            },
            "children": []
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
                            "id": 889,
                            "name": "ERC20",
                            "nodeType": "UserDefinedTypeName",
                            "referencedDeclaration": 683,
                            "src": "349:5:6",
                            "typeDescriptions": {
                                "typeIdentifier": "t_contract$_ERC20_$683",
                                "typeString": "contract ERC20"
                            }
                        },
                        "id": 890,
                        "nodeType": "InheritanceSpecifier",
                        "src": "349:5:6"
                    },
                    {
                        "arguments": null,
                        "baseName": {
                            "contractScope": null,
                            "id": 891,
                            "name": "VersionedInitializable",
                            "nodeType": "UserDefinedTypeName",
                            "referencedDeclaration": 1354,
                            "src": "356:22:6",
                            "typeDescriptions": {
                                "typeIdentifier": "t_contract$_VersionedInitializable_$1354",
                                "typeString": "contract VersionedInitializable"
                            }
                        },
                        "id": 892,
                        "nodeType": "InheritanceSpecifier",
                        "src": "356:22:6"
                    }
                ],
                "contractDependencies": [
                    77,
                    176,
                    683,
                    1354
                ],
                "contractKind": "contract",
                "documentation": "{'id': 888, 'nodeType': 'StructuredDocumentation', 'src': '253:73:6', 'text': ' @notice implementation of the AAVE token contract\\n @author Aave'}",
                "fullyImplemented": true,
                "id": 1315,
                "linearizedBaseContracts": [
                    1315,
                    1354,
                    683,
                    77,
                    176
                ],
                "name": "AaveToken",
                "scope": 1316,
                "src": "327:6375:6"
            },
            "children": [
                {
                    "name": "StructDefinition",
                    "attributes": {
                        "canonicalName": "AaveToken.Snapshot",
                        "id": 897,
                        "members": [
                            {
                                "constant": false,
                                "id": 894,
                                "mutability": "mutable",
                                "name": "blockNumber",
                                "nodeType": "VariableDeclaration",
                                "overrides": null,
                                "scope": 897,
                                "src": "484:19:6",
                                "stateVariable": false,
                                "storageLocation": "default",
                                "typeDescriptions": {
                                    "typeIdentifier": "t_uint128",
                                    "typeString": "uint128"
                                },
                                "typeName": {
                                    "id": 893,
                                    "name": "uint128",
                                    "nodeType": "ElementaryTypeName",
                                    "src": "484:7:6",
                                    "typeDescriptions": {
                                        "typeIdentifier": "t_uint128",
                                        "typeString": "uint128"
                                    }
                                },
                                "value": null,
                                "visibility": "internal"
                            },
                            {
                                "constant": false,
                                "id": 896,
                                "mutability": "mutable",
                                "name": "value",
                                "nodeType": "VariableDeclaration",
                                "overrides": null,
                                "scope": 897,
                                "src": "513:13:6",
                                "stateVariable": false,
                                "storageLocation": "default",
                                "typeDescriptions": {
                                    "typeIdentifier": "t_uint128",
                                    "typeString": "uint128"
                                },
                                "typeName": {
                                    "id": 895,
                                    "name": "uint128",
                                    "nodeType": "ElementaryTypeName",
                                    "src": "513:7:6",
                                    "typeDescriptions": {
                                        "typeIdentifier": "t_uint128",
                                        "typeString": "uint128"
                                    }
                                },
                                "value": null,
                                "visibility": "internal"
                            }
                        ],
                        "name": "Snapshot",
                        "scope": 1315,
                        "src": "458:75:6",
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "id": 900,
                        "mutability": "constant",
                        "name": "NAME",
                        "overrides": null,
                        "scope": 1315,
                        "src": "539:44:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}",
                        "typeName": "{'id': 898, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '539:6:6', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '4161766520546f6b656e', 'id': 899, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '571:12:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c79ca22c0992a4cca3636d52362fc61ce7d8001b81a7b225d701c42fb0636f32', 'typeString': 'literal_string \"Aave Token\"'}, 'value': 'Aave Token'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "id": 903,
                        "mutability": "constant",
                        "name": "SYMBOL",
                        "overrides": null,
                        "scope": 1315,
                        "src": "589:40:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}",
                        "typeName": "{'id': 901, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '589:6:6', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '41415645', 'id': 902, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '623:6:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_de46fbfa339d54cd65b79d8320a7a53c78177565c2aaf4c8b13eed7865e7cfc8', 'typeString': 'literal_string \"AAVE\"'}, 'value': 'AAVE'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "id": 906,
                        "mutability": "constant",
                        "name": "DECIMALS",
                        "overrides": null,
                        "scope": 1315,
                        "src": "635:37:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_uint8', 'typeString': 'uint8'}",
                        "typeName": "{'id': 904, 'name': 'uint8', 'nodeType': 'ElementaryTypeName', 'src': '635:5:6', 'typeDescriptions': {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3138', 'id': 905, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '670:2:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_18_by_1', 'typeString': 'int_const 18'}, 'value': '18'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 907, 'nodeType': 'StructuredDocumentation', 'src': '679:68:6', 'text': '@dev the amount being distributed for the LEND -> AAVE migration'}",
                        "id": 910,
                        "mutability": "constant",
                        "name": "MIGRATION_AMOUNT",
                        "overrides": null,
                        "scope": 1315,
                        "src": "752:59:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}",
                        "typeName": "{'id': 908, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '752:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '3133303030303030', 'id': 909, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '797:14:6', 'subdenomination': 'ether', 'typeDescriptions': {'typeIdentifier': 't_rational_13000000000000000000000000_by_1', 'typeString': 'int_const 13000000000000000000000000'}, 'value': '13000000'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "documentation": "{'id': 911, 'nodeType': 'StructuredDocumentation', 'src': '818:57:6', 'text': '@dev the amount being distributed for the PSI and PEI'}",
                        "id": 914,
                        "mutability": "constant",
                        "name": "DISTRIBUTION_AMOUNT",
                        "overrides": null,
                        "scope": 1315,
                        "src": "880:61:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}",
                        "typeName": "{'id': 912, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '880:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '33303030303030', 'id': 913, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '928:13:6', 'subdenomination': 'ether', 'typeDescriptions': {'typeIdentifier': 't_rational_3000000000000000000000000_by_1', 'typeString': 'int_const 3000000000000000000000000'}, 'value': '3000000'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "functionSelector": "dde43cba",
                        "id": 917,
                        "mutability": "constant",
                        "name": "REVISION",
                        "overrides": null,
                        "scope": 1315,
                        "src": "948:36:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}",
                        "typeName": "{'id': 915, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '948:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}",
                        "value": "{'argumentTypes': None, 'hexValue': '31', 'id': 916, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '983:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}",
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 918, 'nodeType': 'StructuredDocumentation', 'src': '991:58:6', 'text': '@dev owner => next valid nonce to submit with permit()'}",
                        "functionSelector": "b9844d8d",
                        "id": 922,
                        "mutability": "mutable",
                        "name": "_nonces",
                        "overrides": null,
                        "scope": 1315,
                        "src": "1054:43:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}",
                        "typeName": "{'id': 921, 'keyType': {'id': 919, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '1063:7:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '1054:28:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}, 'valueType': {'id': 920, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1074:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}}",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "functionSelector": "2acbf823",
                        "id": 928,
                        "mutability": "mutable",
                        "name": "_snapshots",
                        "overrides": null,
                        "scope": 1315,
                        "src": "1104:68:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$_$', 'typeString': 'mapping(address => mapping(uint256 => struct AaveToken.Snapshot))'}",
                        "typeName": "{'id': 927, 'keyType': {'id': 923, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '1113:7:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '1104:50:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$_$', 'typeString': 'mapping(address => mapping(uint256 => struct AaveToken.Snapshot))'}, 'valueType': {'id': 926, 'keyType': {'id': 924, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1133:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Mapping', 'src': '1124:29:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$', 'typeString': 'mapping(uint256 => struct AaveToken.Snapshot)'}, 'valueType': {'contractScope': None, 'id': 925, 'name': 'Snapshot', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 897, 'src': '1144:8:6', 'typeDescriptions': {'typeIdentifier': 't_struct$_Snapshot_$897_storage_ptr', 'typeString': 'struct AaveToken.Snapshot'}}}}",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "functionSelector": "8779588c",
                        "id": 932,
                        "mutability": "mutable",
                        "name": "_countsSnapshots",
                        "overrides": null,
                        "scope": 1315,
                        "src": "1179:52:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}",
                        "typeName": "{'id': 931, 'keyType': {'id': 929, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '1188:7:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Mapping', 'src': '1179:28:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}, 'valueType': {'id': 930, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1199:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}}",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "documentation": "{'id': 933, 'nodeType': 'StructuredDocumentation', 'src': '1238:278:6', 'text': '@dev reference to the Aave governance contract to call (if initialized) on _beforeTokenTransfer\\n !!! IMPORTANT The Aave governance is considered a trustable contract, being its responsibility\\n to control all potential reentrancies by calling back the AaveToken'}",
                        "functionSelector": "c3863ada",
                        "id": 935,
                        "mutability": "mutable",
                        "name": "_aaveGovernance",
                        "overrides": null,
                        "scope": 1315,
                        "src": "1521:36:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}",
                        "typeName": "{'contractScope': None, 'id': 934, 'name': 'ITransferHook', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 89, 'src': '1521:13:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "functionSelector": "3644e515",
                        "id": 937,
                        "mutability": "mutable",
                        "name": "DOMAIN_SEPARATOR",
                        "overrides": null,
                        "scope": 1315,
                        "src": "1564:31:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}",
                        "typeName": "{'id': 936, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '1564:7:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "functionSelector": "78160376",
                        "id": 943,
                        "mutability": "constant",
                        "name": "EIP712_REVISION",
                        "overrides": null,
                        "scope": 1315,
                        "src": "1601:50:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}",
                        "typeName": "{'id': 938, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '1601:5:6', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}",
                        "value": "{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '31', 'id': 941, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1647:3:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_c89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6', 'typeString': 'literal_string \"1\"'}, 'value': '1'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_c89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6', 'typeString': 'literal_string \"1\"'}], 'id': 940, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '1641:5:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_bytes_storage_ptr_$', 'typeString': 'type(bytes storage pointer)'}, 'typeName': {'id': 939, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '1641:5:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 942, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1641:10:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}",
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "id": 948,
                        "mutability": "constant",
                        "name": "EIP712_DOMAIN",
                        "overrides": null,
                        "scope": 1315,
                        "src": "1657:137:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}",
                        "typeName": "{'id': 944, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '1657:7:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}",
                        "value": "{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '454950373132446f6d61696e28737472696e67206e616d652c737472696e672076657273696f6e2c75696e7432353620636861696e49642c6164647265737320766572696679696e67436f6e747261637429', 'id': 946, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1709:84:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f', 'typeString': 'literal_string \"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)\"'}, 'value': 'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f', 'typeString': 'literal_string \"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)\"'}], 'id': 945, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '1699:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 947, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1699:95:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "functionSelector": "30adf81f",
                        "id": 953,
                        "mutability": "constant",
                        "name": "PERMIT_TYPEHASH",
                        "overrides": null,
                        "scope": 1315,
                        "src": "1800:137:6",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}",
                        "typeName": "{'id': 949, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '1800:7:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}",
                        "value": "{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '5065726d69742861646472657373206f776e65722c61646472657373207370656e6465722c75696e743235362076616c75652c75696e74323536206e6f6e63652c75696e7432353620646561646c696e6529', 'id': 951, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1852:84:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9', 'typeString': 'literal_string \"Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)\"'}, 'value': 'Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9', 'typeString': 'literal_string \"Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)\"'}], 'id': 950, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '1842:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 952, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1842:95:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}",
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "EventDefinition",
                    "attributes": {
                        "anonymous": false,
                        "documentation": null,
                        "id": 961,
                        "name": "SnapshotDone",
                        "parameters": "{'id': 960, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 955, 'indexed': False, 'mutability': 'mutable', 'name': 'owner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 961, 'src': '1963:13:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 954, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '1963:7:6', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 957, 'indexed': False, 'mutability': 'mutable', 'name': 'oldValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 961, 'src': '1978:16:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, 'typeName': {'id': 956, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '1978:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 959, 'indexed': False, 'mutability': 'mutable', 'name': 'newValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 961, 'src': '1996:16:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, 'typeName': {'id': 958, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '1996:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'value': None, 'visibility': 'internal'}], 'src': '1962:51:6'}",
                        "src": "1944:70:6"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 968, 'nodeType': 'Block', 'src': '2061:2:6', 'statements': []}",
                        "documentation": null,
                        "id": 969,
                        "implemented": true,
                        "kind": "constructor",
                        "modifiers": [
                            {
                                "arguments": [
                                    {
                                        "argumentTypes": null,
                                        "id": 964,
                                        "name": "NAME",
                                        "nodeType": "Identifier",
                                        "overloadedDeclarations": [],
                                        "referencedDeclaration": 900,
                                        "src": "2040:4:6",
                                        "typeDescriptions": {
                                            "typeIdentifier": "t_string_memory_ptr",
                                            "typeString": "string memory"
                                        }
                                    },
                                    {
                                        "argumentTypes": null,
                                        "id": 965,
                                        "name": "SYMBOL",
                                        "nodeType": "Identifier",
                                        "overloadedDeclarations": [],
                                        "referencedDeclaration": 903,
                                        "src": "2046:6:6",
                                        "typeDescriptions": {
                                            "typeIdentifier": "t_string_memory_ptr",
                                            "typeString": "string memory"
                                        }
                                    }
                                ],
                                "id": 966,
                                "modifierName": {
                                    "argumentTypes": null,
                                    "id": 963,
                                    "name": "ERC20",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 683,
                                    "src": "2034:5:6",
                                    "typeDescriptions": {
                                        "typeIdentifier": "t_type$_t_contract$_ERC20_$683_$",
                                        "typeString": "type(contract ERC20)"
                                    }
                                },
                                "nodeType": "ModifierInvocation",
                                "src": "2034:19:6"
                            }
                        ],
                        "name": "",
                        "overrides": null,
                        "parameters": "{'id': 962, 'nodeType': 'ParameterList', 'parameters': [], 'src': '2031:2:6'}",
                        "returnParameters": "{'id': 967, 'nodeType': 'ParameterList', 'parameters': [], 'src': '2061:0:6'}",
                        "scope": 1315,
                        "src": "2020:43:6",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1034, 'nodeType': 'Block', 'src': '2465:559:6', 'statements': [{'assignments': [982], 'declarations': [{'constant': False, 'id': 982, 'mutability': 'mutable', 'name': 'chainId', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1034, 'src': '2476:15:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 981, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '2476:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 983, 'initialValue': None, 'nodeType': 'VariableDeclarationStatement', 'src': '2476:15:6'}, {'AST': {'nodeType': 'YulBlock', 'src': '2546:44:6', 'statements': [{'nodeType': 'YulAssignment', 'src': '2560:20:6', 'value': {'arguments': [], 'functionName': {'name': 'chainid', 'nodeType': 'YulIdentifier', 'src': '2571:7:6'}, 'nodeType': 'YulFunctionCall', 'src': '2571:9:6'}, 'variableNames': [{'name': 'chainId', 'nodeType': 'YulIdentifier', 'src': '2560:7:6'}]}]}, 'evmVersion': 'istanbul', 'externalReferences': [{'declaration': 982, 'isOffset': False, 'isSlot': False, 'src': '2560:7:6', 'valueSize': 1}], 'id': 984, 'nodeType': 'InlineAssembly', 'src': '2537:53:6'}, {'expression': {'argumentTypes': None, 'id': 1006, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 985, 'name': 'DOMAIN_SEPARATOR', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 937, 'src': '2600:16:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 989, 'name': 'EIP712_DOMAIN', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 948, 'src': '2653:13:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 993, 'name': 'NAME', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 900, 'src': '2696:4:6', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 992, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '2690:5:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_bytes_storage_ptr_$', 'typeString': 'type(bytes storage pointer)'}, 'typeName': {'id': 991, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '2690:5:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 994, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2690:11:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 990, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '2680:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 995, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2680:22:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 997, 'name': 'EIP712_REVISION', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 943, 'src': '2726:15:6', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 996, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '2716:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 998, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2716:26:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 999, 'name': 'chainId', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 982, 'src': '2756:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1002, 'name': 'this', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -28, 'src': '2785:4:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_AaveToken_$1315', 'typeString': 'contract AaveToken'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_AaveToken_$1315', 'typeString': 'contract AaveToken'}], 'id': 1001, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '2777:7:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 1000, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '2777:7:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1003, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2777:13:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'argumentTypes': None, 'id': 987, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '2629:3:6', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 988, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encode', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '2629:10:6', 'typeDescriptions': {'typeIdentifier': 't_function_abiencode_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 1004, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2629:171:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 986, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '2619:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 1005, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2619:182:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'src': '2600:201:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'id': 1007, 'nodeType': 'ExpressionStatement', 'src': '2600:201:6'}, {'expression': {'argumentTypes': None, 'id': 1010, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 1008, 'name': '_name', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 207, 'src': '2811:5:6', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 1009, 'name': 'NAME', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 900, 'src': '2819:4:6', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'src': '2811:12:6', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'id': 1011, 'nodeType': 'ExpressionStatement', 'src': '2811:12:6'}, {'expression': {'argumentTypes': None, 'id': 1014, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 1012, 'name': '_symbol', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 209, 'src': '2833:7:6', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 1013, 'name': 'SYMBOL', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 903, 'src': '2843:6:6', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'src': '2833:16:6', 'typeDescriptions': {'typeIdentifier': 't_string_storage', 'typeString': 'string storage ref'}}, 'id': 1015, 'nodeType': 'ExpressionStatement', 'src': '2833:16:6'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1017, 'name': 'DECIMALS', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 906, 'src': '2874:8:6', 'typeDescriptions': {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint8', 'typeString': 'uint8'}], 'id': 1016, 'name': '_setupDecimals', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 671, 'src': '2859:14:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_uint8_$returns$__$', 'typeString': 'function (uint8)'}}, 'id': 1018, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2859:24:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1019, 'nodeType': 'ExpressionStatement', 'src': '2859:24:6'}, {'expression': {'argumentTypes': None, 'id': 1022, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'id': 1020, 'name': '_aaveGovernance', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 935, 'src': '2893:15:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 1021, 'name': 'aaveGovernance', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 976, 'src': '2911:14:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}, 'src': '2893:32:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}, 'id': 1023, 'nodeType': 'ExpressionStatement', 'src': '2893:32:6'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1025, 'name': 'migrator', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 972, 'src': '2941:8:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1026, 'name': 'MIGRATION_AMOUNT', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 910, 'src': '2951:16:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1024, 'name': '_mint', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 559, 'src': '2935:5:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (address,uint256)'}}, 'id': 1027, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2935:33:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1028, 'nodeType': 'ExpressionStatement', 'src': '2935:33:6'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1030, 'name': 'distributor', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 974, 'src': '2984:11:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1031, 'name': 'DISTRIBUTION_AMOUNT', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 914, 'src': '2997:19:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1029, 'name': '_mint', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 559, 'src': '2978:5:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (address,uint256)'}}, 'id': 1032, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2978:39:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1033, 'nodeType': 'ExpressionStatement', 'src': '2978:39:6'}]}",
                        "documentation": "{'id': 970, 'nodeType': 'StructuredDocumentation', 'src': '2069:251:6', 'text': ' @dev initializes the contract upon assignment to the InitializableAdminUpgradeabilityProxy\\n @param migrator the address of the LEND -> AAVE migration contract\\n @param distributor the address of the AAVE distribution contract'}",
                        "functionSelector": "c0c53b8b",
                        "id": 1035,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [
                            {
                                "arguments": null,
                                "id": 979,
                                "modifierName": {
                                    "argumentTypes": null,
                                    "id": 978,
                                    "name": "initializer",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 1343,
                                    "src": "2453:11:6",
                                    "typeDescriptions": {
                                        "typeIdentifier": "t_modifier$__$",
                                        "typeString": "modifier ()"
                                    }
                                },
                                "nodeType": "ModifierInvocation",
                                "src": "2453:11:6"
                            }
                        ],
                        "name": "initialize",
                        "overrides": null,
                        "parameters": "{'id': 977, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 972, 'mutability': 'mutable', 'name': 'migrator', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1035, 'src': '2354:16:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 971, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '2354:7:6', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 974, 'mutability': 'mutable', 'name': 'distributor', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1035, 'src': '2380:19:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 973, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '2380:7:6', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 976, 'mutability': 'mutable', 'name': 'aaveGovernance', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1035, 'src': '2409:28:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}, 'typeName': {'contractScope': None, 'id': 975, 'name': 'ITransferHook', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 89, 'src': '2409:13:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}, 'value': None, 'visibility': 'internal'}], 'src': '2344:99:6'}",
                        "returnParameters": "{'id': 980, 'nodeType': 'ParameterList', 'parameters': [], 'src': '2465:0:6'}",
                        "scope": 1315,
                        "src": "2325:699:6",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1125, 'nodeType': 'Block', 'src': '3652:694:6', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1059, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1054, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1038, 'src': '3670:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 1057, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3687:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 1056, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '3679:7:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 1055, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '3679:7:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1058, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3679:10:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '3670:19:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'hexValue': '494e56414c49445f4f574e4552', 'id': 1060, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3691:15:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_a30e2b4f22d955e30086ae3aef0adfd87eec9d0d3f055d6aa9af61f522dda886', 'typeString': 'literal_string \"INVALID_OWNER\"'}, 'value': 'INVALID_OWNER'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_a30e2b4f22d955e30086ae3aef0adfd87eec9d0d3f055d6aa9af61f522dda886', 'typeString': 'literal_string \"INVALID_OWNER\"'}], 'id': 1053, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '3662:7:6', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1061, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3662:45:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1062, 'nodeType': 'ExpressionStatement', 'src': '3662:45:6'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 1067, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1064, 'name': 'block', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -4, 'src': '3760:5:6', 'typeDescriptions': {'typeIdentifier': 't_magic_block', 'typeString': 'block'}}, 'id': 1065, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'timestamp', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '3760:15:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '<=', 'rightExpression': {'argumentTypes': None, 'id': 1066, 'name': 'deadline', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1044, 'src': '3779:8:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '3760:27:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'hexValue': '494e56414c49445f45585049524154494f4e', 'id': 1068, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3789:20:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_9fe3e5cf49f72bf8a6a8455c3e990f8479f5dfa09ac808886f330a39b0029c2d', 'typeString': 'literal_string \"INVALID_EXPIRATION\"'}, 'value': 'INVALID_EXPIRATION'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_9fe3e5cf49f72bf8a6a8455c3e990f8479f5dfa09ac808886f330a39b0029c2d', 'typeString': 'literal_string \"INVALID_EXPIRATION\"'}], 'id': 1063, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '3752:7:6', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1069, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3752:58:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1070, 'nodeType': 'ExpressionStatement', 'src': '3752:58:6'}, {'assignments': [1072], 'declarations': [{'constant': False, 'id': 1072, 'mutability': 'mutable', 'name': 'currentValidNonce', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1125, 'src': '3820:25:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1071, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3820:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 1076, 'initialValue': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1073, 'name': '_nonces', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 922, 'src': '3848:7:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1075, 'indexExpression': {'argumentTypes': None, 'id': 1074, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1038, 'src': '3856:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '3848:14:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '3820:42:6'}, {'assignments': [1078], 'declarations': [{'constant': False, 'id': 1078, 'mutability': 'mutable', 'name': 'digest', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1125, 'src': '3872:14:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1077, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '3872:7:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'id': 1097, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '1901', 'id': 1082, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3954:10:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_301a50b291d33ce1e8e9064e3f6a6c51d902ec22892b50d58abf6357c6a45541', 'typeString': 'literal_string \"\\x19\\x01\"'}, 'value': '\\x19\\x01'}, {'argumentTypes': None, 'id': 1083, 'name': 'DOMAIN_SEPARATOR', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 937, 'src': '3986:16:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1087, 'name': 'PERMIT_TYPEHASH', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 953, 'src': '4070:15:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 1088, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1038, 'src': '4087:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1089, 'name': 'spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1040, 'src': '4094:7:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1090, 'name': 'value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1042, 'src': '4103:5:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 1091, 'name': 'currentValidNonce', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1072, 'src': '4110:17:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'argumentTypes': None, 'id': 1092, 'name': 'deadline', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1044, 'src': '4129:8:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'id': 1085, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '4059:3:6', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 1086, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encode', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '4059:10:6', 'typeDescriptions': {'typeIdentifier': 't_function_abiencode_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 1093, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4059:79:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 1084, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '4024:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 1094, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4024:115:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_301a50b291d33ce1e8e9064e3f6a6c51d902ec22892b50d58abf6357c6a45541', 'typeString': 'literal_string \"\\x19\\x01\"'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'argumentTypes': None, 'id': 1080, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '3916:3:6', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 1081, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '3916:16:6', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 1095, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3916:245:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 1079, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -8, 'src': '3889:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 1096, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3889:282:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '3872:299:6'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1106, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1099, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1038, 'src': '4190:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1101, 'name': 'digest', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1078, 'src': '4209:6:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 1102, 'name': 'v', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1046, 'src': '4217:1:6', 'typeDescriptions': {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}}, {'argumentTypes': None, 'id': 1103, 'name': 'r', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1048, 'src': '4220:1:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'argumentTypes': None, 'id': 1104, 'name': 's', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1050, 'src': '4223:1:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 1100, 'name': 'ecrecover', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -6, 'src': '4199:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_ecrecover_pure$_t_bytes32_$_t_uint8_$_t_bytes32_$_t_bytes32_$returns$_t_address_$', 'typeString': 'function (bytes32,uint8,bytes32,bytes32) pure returns (address)'}}, 'id': 1105, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4199:26:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '4190:35:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'argumentTypes': None, 'hexValue': '494e56414c49445f5349474e4154555245', 'id': 1107, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '4227:19:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_stringliteral_5e2e9eaa2d734966dea0900deacd15b20129fbce05255d633a3ce5ebca181b88', 'typeString': 'literal_string \"INVALID_SIGNATURE\"'}, 'value': 'INVALID_SIGNATURE'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_5e2e9eaa2d734966dea0900deacd15b20129fbce05255d633a3ce5ebca181b88', 'typeString': 'literal_string \"INVALID_SIGNATURE\"'}], 'id': 1098, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '4182:7:6', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 1108, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4182:65:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1109, 'nodeType': 'ExpressionStatement', 'src': '4182:65:6'}, {'expression': {'argumentTypes': None, 'id': 1117, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1110, 'name': '_nonces', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 922, 'src': '4257:7:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1112, 'indexExpression': {'argumentTypes': None, 'id': 1111, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1038, 'src': '4265:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '4257:14:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '31', 'id': 1115, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '4296:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}], 'expression': {'argumentTypes': None, 'id': 1113, 'name': 'currentValidNonce', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1072, 'src': '4274:17:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1114, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'add', 'nodeType': 'MemberAccess', 'referencedDeclaration': 712, 'src': '4274:21:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1116, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4274:24:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '4257:41:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1118, 'nodeType': 'ExpressionStatement', 'src': '4257:41:6'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1120, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1038, 'src': '4317:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1121, 'name': 'spender', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1040, 'src': '4324:7:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1122, 'name': 'value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1042, 'src': '4333:5:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1119, 'name': '_approve', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 660, 'src': '4308:8:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (address,address,uint256)'}}, 'id': 1123, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4308:31:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1124, 'nodeType': 'ExpressionStatement', 'src': '4308:31:6'}]}",
                        "documentation": "{'id': 1036, 'nodeType': 'StructuredDocumentation', 'src': '3030:433:6', 'text': ' @dev implements the permit function as for https://github.com/ethereum/EIPs/blob/8a34d644aacf0f9f8f00815307fd7dd5da07655f/EIPS/eip-2612.md\\n @param owner the owner of the funds\\n @param spender the spender\\n @param value the amount\\n @param deadline the deadline timestamp, type(uint256).max for no deadline\\n @param v signature param\\n @param s signature param\\n @param r signature param'}",
                        "functionSelector": "d505accf",
                        "id": 1126,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "permit",
                        "overrides": null,
                        "parameters": "{'id': 1051, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1038, 'mutability': 'mutable', 'name': 'owner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1126, 'src': '3494:13:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1037, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '3494:7:6', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1040, 'mutability': 'mutable', 'name': 'spender', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1126, 'src': '3517:15:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1039, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '3517:7:6', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1042, 'mutability': 'mutable', 'name': 'value', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1126, 'src': '3542:13:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1041, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3542:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1044, 'mutability': 'mutable', 'name': 'deadline', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1126, 'src': '3565:16:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1043, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '3565:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1046, 'mutability': 'mutable', 'name': 'v', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1126, 'src': '3591:7:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}, 'typeName': {'id': 1045, 'name': 'uint8', 'nodeType': 'ElementaryTypeName', 'src': '3591:5:6', 'typeDescriptions': {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1048, 'mutability': 'mutable', 'name': 'r', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1126, 'src': '3608:9:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1047, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '3608:7:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1050, 'mutability': 'mutable', 'name': 's', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1126, 'src': '3627:9:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 1049, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '3627:7:6', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'value': None, 'visibility': 'internal'}], 'src': '3484:158:6'}",
                        "returnParameters": "{'id': 1052, 'nodeType': 'ParameterList', 'parameters': [], 'src': '3652:0:6'}",
                        "scope": 1315,
                        "src": "3469:877:6",
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
                            1349
                        ],
                        "body": "{'id': 1135, 'nodeType': 'Block', 'src': '4494:32:6', 'statements': [{'expression': {'argumentTypes': None, 'id': 1133, 'name': 'REVISION', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 917, 'src': '4511:8:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 1132, 'id': 1134, 'nodeType': 'Return', 'src': '4504:15:6'}]}",
                        "documentation": "{'id': 1127, 'nodeType': 'StructuredDocumentation', 'src': '4352:73:6', 'text': ' @dev returns the revision of the implementation contract'}",
                        "id": 1136,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getRevision",
                        "overrides": "{'id': 1129, 'nodeType': 'OverrideSpecifier', 'overrides': [], 'src': '4467:8:6'}",
                        "parameters": "{'id': 1128, 'nodeType': 'ParameterList', 'parameters': [], 'src': '4450:2:6'}",
                        "returnParameters": "{'id': 1132, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1131, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1136, 'src': '4485:7:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1130, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '4485:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '4484:9:6'}",
                        "scope": 1315,
                        "src": "4430:96:6",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 1218, 'nodeType': 'Block', 'src': '4876:694:6', 'statements': [{'assignments': [1147], 'declarations': [{'constant': False, 'id': 1147, 'mutability': 'mutable', 'name': 'currentBlock', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1218, 'src': '4886:20:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, 'typeName': {'id': 1146, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '4886:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'value': None, 'visibility': 'internal'}], 'id': 1153, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'expression': {'argumentTypes': None, 'id': 1150, 'name': 'block', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -4, 'src': '4917:5:6', 'typeDescriptions': {'typeIdentifier': 't_magic_block', 'typeString': 'block'}}, 'id': 1151, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'number', 'nodeType': 'MemberAccess', 'referencedDeclaration': None, 'src': '4917:12:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1149, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '4909:7:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_uint128_$', 'typeString': 'type(uint128)'}, 'typeName': {'id': 1148, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '4909:7:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1152, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4909:21:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '4886:44:6'}, {'assignments': [1155], 'declarations': [{'constant': False, 'id': 1155, 'mutability': 'mutable', 'name': 'ownerCountOfSnapshots', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1218, 'src': '4941:29:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1154, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '4941:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 1159, 'initialValue': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1156, 'name': '_countsSnapshots', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 932, 'src': '4973:16:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1158, 'indexExpression': {'argumentTypes': None, 'id': 1157, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1139, 'src': '4990:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '4973:23:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '4941:55:6'}, {'assignments': [1163], 'declarations': [{'constant': False, 'id': 1163, 'mutability': 'mutable', 'name': 'snapshotsOwner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1218, 'src': '5006:52:6', 'stateVariable': False, 'storageLocation': 'storage', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$', 'typeString': 'mapping(uint256 => struct AaveToken.Snapshot)'}, 'typeName': {'id': 1162, 'keyType': {'id': 1160, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '5015:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Mapping', 'src': '5006:29:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$', 'typeString': 'mapping(uint256 => struct AaveToken.Snapshot)'}, 'valueType': {'contractScope': None, 'id': 1161, 'name': 'Snapshot', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 897, 'src': '5026:8:6', 'typeDescriptions': {'typeIdentifier': 't_struct$_Snapshot_$897_storage_ptr', 'typeString': 'struct AaveToken.Snapshot'}}}, 'value': None, 'visibility': 'internal'}], 'id': 1167, 'initialValue': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1164, 'name': '_snapshots', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 928, 'src': '5061:10:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$_$', 'typeString': 'mapping(address => mapping(uint256 => struct AaveToken.Snapshot storage ref))'}}, 'id': 1166, 'indexExpression': {'argumentTypes': None, 'id': 1165, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1139, 'src': '5072:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '5061:17:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$', 'typeString': 'mapping(uint256 => struct AaveToken.Snapshot storage ref)'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '5006:72:6'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'id': 1180, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 1170, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1168, 'name': 'ownerCountOfSnapshots', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1155, 'src': '5148:21:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'hexValue': '30', 'id': 1169, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '5173:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '5148:26:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'nodeType': 'BinaryOperation', 'operator': '&&', 'rightExpression': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, 'id': 1179, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1171, 'name': 'snapshotsOwner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1163, 'src': '5178:14:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$', 'typeString': 'mapping(uint256 => struct AaveToken.Snapshot storage ref)'}}, 'id': 1176, 'indexExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '31', 'id': 1174, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '5219:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}], 'expression': {'argumentTypes': None, 'id': 1172, 'name': 'ownerCountOfSnapshots', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1155, 'src': '5193:21:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1173, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sub', 'nodeType': 'MemberAccess', 'referencedDeclaration': 729, 'src': '5193:25:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1175, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '5193:28:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '5178:44:6', 'typeDescriptions': {'typeIdentifier': 't_struct$_Snapshot_$897_storage', 'typeString': 'struct AaveToken.Snapshot storage ref'}}, 'id': 1177, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'memberName': 'blockNumber', 'nodeType': 'MemberAccess', 'referencedDeclaration': 894, 'src': '5178:56:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'id': 1178, 'name': 'currentBlock', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1147, 'src': '5238:12:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'src': '5178:72:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'src': '5148:102:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': {'id': 1210, 'nodeType': 'Block', 'src': '5344:165:6', 'statements': [{'expression': {'argumentTypes': None, 'id': 1199, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1192, 'name': 'snapshotsOwner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1163, 'src': '5358:14:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$', 'typeString': 'mapping(uint256 => struct AaveToken.Snapshot storage ref)'}}, 'id': 1194, 'indexExpression': {'argumentTypes': None, 'id': 1193, 'name': 'ownerCountOfSnapshots', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1155, 'src': '5373:21:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '5358:37:6', 'typeDescriptions': {'typeIdentifier': 't_struct$_Snapshot_$897_storage', 'typeString': 'struct AaveToken.Snapshot storage ref'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1196, 'name': 'currentBlock', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1147, 'src': '5407:12:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, {'argumentTypes': None, 'id': 1197, 'name': 'newValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1143, 'src': '5421:8:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}], 'id': 1195, 'name': 'Snapshot', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 897, 'src': '5398:8:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_struct$_Snapshot_$897_storage_ptr_$', 'typeString': 'type(struct AaveToken.Snapshot storage pointer)'}}, 'id': 1198, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'structConstructorCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '5398:32:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_struct$_Snapshot_$897_memory_ptr', 'typeString': 'struct AaveToken.Snapshot memory'}}, 'src': '5358:72:6', 'typeDescriptions': {'typeIdentifier': 't_struct$_Snapshot_$897_storage', 'typeString': 'struct AaveToken.Snapshot storage ref'}}, 'id': 1200, 'nodeType': 'ExpressionStatement', 'src': '5358:72:6'}, {'expression': {'argumentTypes': None, 'id': 1208, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1201, 'name': '_countsSnapshots', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 932, 'src': '5444:16:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_address_$_t_uint256_$', 'typeString': 'mapping(address => uint256)'}}, 'id': 1203, 'indexExpression': {'argumentTypes': None, 'id': 1202, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1139, 'src': '5461:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'nodeType': 'IndexAccess', 'src': '5444:23:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '31', 'id': 1206, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '5496:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}], 'expression': {'argumentTypes': None, 'id': 1204, 'name': 'ownerCountOfSnapshots', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1155, 'src': '5470:21:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1205, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'add', 'nodeType': 'MemberAccess', 'referencedDeclaration': 712, 'src': '5470:25:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1207, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '5470:28:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'src': '5444:54:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1209, 'nodeType': 'ExpressionStatement', 'src': '5444:54:6'}]}, 'id': 1211, 'nodeType': 'IfStatement', 'src': '5144:365:6', 'trueBody': {'id': 1191, 'nodeType': 'Block', 'src': '5252:86:6', 'statements': [{'expression': {'argumentTypes': None, 'id': 1189, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'argumentTypes': None, 'expression': {'argumentTypes': None, 'baseExpression': {'argumentTypes': None, 'id': 1181, 'name': 'snapshotsOwner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1163, 'src': '5266:14:6', 'typeDescriptions': {'typeIdentifier': 't_mapping$_t_uint256_$_t_struct$_Snapshot_$897_storage_$', 'typeString': 'mapping(uint256 => struct AaveToken.Snapshot storage ref)'}}, 'id': 1186, 'indexExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '31', 'id': 1184, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '5307:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}, 'value': '1'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_1_by_1', 'typeString': 'int_const 1'}], 'expression': {'argumentTypes': None, 'id': 1182, 'name': 'ownerCountOfSnapshots', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1155, 'src': '5281:21:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1183, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sub', 'nodeType': 'MemberAccess', 'referencedDeclaration': 729, 'src': '5281:25:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1185, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '5281:28:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': False, 'nodeType': 'IndexAccess', 'src': '5266:44:6', 'typeDescriptions': {'typeIdentifier': 't_struct$_Snapshot_$897_storage', 'typeString': 'struct AaveToken.Snapshot storage ref'}}, 'id': 1187, 'isConstant': False, 'isLValue': True, 'isPure': False, 'lValueRequested': True, 'memberName': 'value', 'nodeType': 'MemberAccess', 'referencedDeclaration': 896, 'src': '5266:50:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'argumentTypes': None, 'id': 1188, 'name': 'newValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1143, 'src': '5319:8:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'src': '5266:61:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'id': 1190, 'nodeType': 'ExpressionStatement', 'src': '5266:61:6'}]}}, {'eventCall': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1213, 'name': 'owner', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1139, 'src': '5537:5:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1214, 'name': 'oldValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1141, 'src': '5544:8:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, {'argumentTypes': None, 'id': 1215, 'name': 'newValue', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1143, 'src': '5554:8:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}], 'id': 1212, 'name': 'SnapshotDone', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 961, 'src': '5524:12:6', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_uint128_$_t_uint128_$returns$__$', 'typeString': 'function (address,uint128,uint128)'}}, 'id': 1216, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '5524:39:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1217, 'nodeType': 'EmitStatement', 'src': '5519:44:6'}]}",
                        "documentation": "{'id': 1137, 'nodeType': 'StructuredDocumentation', 'src': '4532:255:6', 'text': ' @dev Writes a snapshot for an owner of tokens\\n @param owner The owner of the tokens\\n @param oldValue The value before the operation that is gonna be executed after the snapshot\\n @param newValue The value after the operation'}",
                        "id": 1219,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_writeSnapshot",
                        "overrides": null,
                        "parameters": "{'id': 1144, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1139, 'mutability': 'mutable', 'name': 'owner', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1219, 'src': '4816:13:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1138, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '4816:7:6', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1141, 'mutability': 'mutable', 'name': 'oldValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1219, 'src': '4831:16:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, 'typeName': {'id': 1140, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '4831:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1143, 'mutability': 'mutable', 'name': 'newValue', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1219, 'src': '4849:16:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, 'typeName': {'id': 1142, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '4849:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, 'value': None, 'visibility': 'internal'}], 'src': '4815:51:6'}",
                        "returnParameters": "{'id': 1145, 'nodeType': 'ParameterList', 'parameters': [], 'src': '4876:0:6'}",
                        "scope": 1315,
                        "src": "4792:778:6",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "baseFunctions": [
                            682
                        ],
                        "body": "{'id': 1313, 'nodeType': 'Block', 'src': '6027:673:6', 'statements': [{'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1232, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1230, 'name': 'from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1222, 'src': '6041:4:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'argumentTypes': None, 'id': 1231, 'name': 'to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1224, 'src': '6049:2:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '6041:10:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 1235, 'nodeType': 'IfStatement', 'src': '6037:47:6', 'trueBody': {'id': 1234, 'nodeType': 'Block', 'src': '6053:31:6', 'statements': [{'expression': None, 'functionReturnParameters': 1229, 'id': 1233, 'nodeType': 'Return', 'src': '6067:7:6'}]}}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1241, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1236, 'name': 'from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1222, 'src': '6098:4:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 1239, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '6114:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 1238, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '6106:7:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 1237, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '6106:7:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1240, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6106:10:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '6098:18:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 1264, 'nodeType': 'IfStatement', 'src': '6094:176:6', 'trueBody': {'id': 1263, 'nodeType': 'Block', 'src': '6118:152:6', 'statements': [{'assignments': [1243], 'declarations': [{'constant': False, 'id': 1243, 'mutability': 'mutable', 'name': 'fromBalance', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1263, 'src': '6132:19:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1242, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '6132:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 1247, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1245, 'name': 'from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1222, 'src': '6164:4:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 1244, 'name': 'balanceOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 283, 'src': '6154:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$returns$_t_uint256_$', 'typeString': 'function (address) view returns (uint256)'}}, 'id': 1246, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6154:15:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '6132:37:6'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1249, 'name': 'from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1222, 'src': '6198:4:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1252, 'name': 'fromBalance', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1243, 'src': '6212:11:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1251, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '6204:7:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_uint128_$', 'typeString': 'type(uint128)'}, 'typeName': {'id': 1250, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '6204:7:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1253, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6204:20:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1258, 'name': 'amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1226, 'src': '6250:6:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'id': 1256, 'name': 'fromBalance', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1243, 'src': '6234:11:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1257, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sub', 'nodeType': 'MemberAccess', 'referencedDeclaration': 729, 'src': '6234:15:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1259, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6234:23:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1255, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '6226:7:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_uint128_$', 'typeString': 'type(uint128)'}, 'typeName': {'id': 1254, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '6226:7:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1260, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6226:32:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}], 'id': 1248, 'name': '_writeSnapshot', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1219, 'src': '6183:14:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_uint128_$_t_uint128_$returns$__$', 'typeString': 'function (address,uint128,uint128)'}}, 'id': 1261, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6183:76:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1262, 'nodeType': 'ExpressionStatement', 'src': '6183:76:6'}]}}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 1270, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1265, 'name': 'to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1224, 'src': '6283:2:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 1268, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '6297:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 1267, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '6289:7:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 1266, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '6289:7:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1269, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6289:10:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '6283:16:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 1293, 'nodeType': 'IfStatement', 'src': '6279:164:6', 'trueBody': {'id': 1292, 'nodeType': 'Block', 'src': '6301:142:6', 'statements': [{'assignments': [1272], 'declarations': [{'constant': False, 'id': 1272, 'mutability': 'mutable', 'name': 'toBalance', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1292, 'src': '6315:17:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1271, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '6315:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'id': 1276, 'initialValue': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1274, 'name': 'to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1224, 'src': '6345:2:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 1273, 'name': 'balanceOf', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 283, 'src': '6335:9:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_address_$returns$_t_uint256_$', 'typeString': 'function (address) view returns (uint256)'}}, 'id': 1275, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6335:13:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '6315:33:6'}, {'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1278, 'name': 'to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1224, 'src': '6377:2:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1281, 'name': 'toBalance', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1272, 'src': '6389:9:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1280, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '6381:7:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_uint128_$', 'typeString': 'type(uint128)'}, 'typeName': {'id': 1279, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '6381:7:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1282, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6381:18:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}, {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1287, 'name': 'amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1226, 'src': '6423:6:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'id': 1285, 'name': 'toBalance', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1272, 'src': '6409:9:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'id': 1286, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'add', 'nodeType': 'MemberAccess', 'referencedDeclaration': 712, 'src': '6409:13:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_pure$_t_uint256_$_t_uint256_$returns$_t_uint256_$bound_to$_t_uint256_$', 'typeString': 'function (uint256,uint256) pure returns (uint256)'}}, 'id': 1288, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6409:21:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'id': 1284, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '6401:7:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_uint128_$', 'typeString': 'type(uint128)'}, 'typeName': {'id': 1283, 'name': 'uint128', 'nodeType': 'ElementaryTypeName', 'src': '6401:7:6', 'typeDescriptions': {'typeIdentifier': None, 'typeString': None}}}, 'id': 1289, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6401:30:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}, {'typeIdentifier': 't_uint128', 'typeString': 'uint128'}], 'id': 1277, 'name': '_writeSnapshot', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1219, 'src': '6362:14:6', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_uint128_$_t_uint128_$returns$__$', 'typeString': 'function (address,uint128,uint128)'}}, 'id': 1290, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6362:70:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1291, 'nodeType': 'ExpressionStatement', 'src': '6362:70:6'}]}}, {'assignments': [1295], 'declarations': [{'constant': False, 'id': 1295, 'mutability': 'mutable', 'name': 'aaveGovernance', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1313, 'src': '6530:28:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}, 'typeName': {'contractScope': None, 'id': 1294, 'name': 'ITransferHook', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 89, 'src': '6530:13:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}, 'value': None, 'visibility': 'internal'}], 'id': 1297, 'initialValue': {'argumentTypes': None, 'id': 1296, 'name': '_aaveGovernance', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 935, 'src': '6561:15:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '6530:46:6'}, {'condition': {'argumentTypes': None, 'commonType': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}, 'id': 1302, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'argumentTypes': None, 'id': 1298, 'name': 'aaveGovernance', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1295, 'src': '6590:14:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'hexValue': '30', 'id': 1300, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '6622:1:6', 'subdenomination': None, 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 1299, 'name': 'ITransferHook', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 89, 'src': '6608:13:6', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_ITransferHook_$89_$', 'typeString': 'type(contract ITransferHook)'}}, 'id': 1301, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6608:16:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}, 'src': '6590:34:6', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'falseBody': None, 'id': 1312, 'nodeType': 'IfStatement', 'src': '6586:108:6', 'trueBody': {'id': 1311, 'nodeType': 'Block', 'src': '6626:68:6', 'statements': [{'expression': {'argumentTypes': None, 'arguments': [{'argumentTypes': None, 'id': 1306, 'name': 'from', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1222, 'src': '6666:4:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1307, 'name': 'to', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1224, 'src': '6672:2:6', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'argumentTypes': None, 'id': 1308, 'name': 'amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1226, 'src': '6676:6:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'argumentTypes': None, 'id': 1303, 'name': 'aaveGovernance', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 1295, 'src': '6640:14:6', 'typeDescriptions': {'typeIdentifier': 't_contract$_ITransferHook_$89', 'typeString': 'contract ITransferHook'}}, 'id': 1305, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'onTransfer', 'nodeType': 'MemberAccess', 'referencedDeclaration': 88, 'src': '6640:25:6', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_address_$_t_address_$_t_uint256_$returns$__$', 'typeString': 'function (address,address,uint256) external'}}, 'id': 1309, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6640:43:6', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 1310, 'nodeType': 'ExpressionStatement', 'src': '6640:43:6'}]}}]}",
                        "documentation": "{'id': 1220, 'nodeType': 'StructuredDocumentation', 'src': '5576:356:6', 'text': ' @dev Writes a snapshot before any operation involving transfer of value: _transfer, _mint and _burn\\n - On _transfer, it writes snapshots for both \"from\" and \"to\"\\n - On _mint, only for _to\\n - On _burn, only for _from\\n @param from the from address\\n @param to the to address\\n @param amount the amount to transfer'}",
                        "id": 1314,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "_beforeTokenTransfer",
                        "overrides": "{'id': 1228, 'nodeType': 'OverrideSpecifier', 'overrides': [], 'src': '6018:8:6'}",
                        "parameters": "{'id': 1227, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 1222, 'mutability': 'mutable', 'name': 'from', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1314, 'src': '5967:12:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1221, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '5967:7:6', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1224, 'mutability': 'mutable', 'name': 'to', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1314, 'src': '5981:10:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 1223, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '5981:7:6', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'value': None, 'visibility': 'internal'}, {'constant': False, 'id': 1226, 'mutability': 'mutable', 'name': 'amount', 'nodeType': 'VariableDeclaration', 'overrides': None, 'scope': 1314, 'src': '5993:14:6', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 1225, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '5993:7:6', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'value': None, 'visibility': 'internal'}], 'src': '5966:42:6'}",
                        "returnParameters": "{'id': 1229, 'nodeType': 'ParameterList', 'parameters': [], 'src': '6027:0:6'}",
                        "scope": 1315,
                        "src": "5937:763:6",
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