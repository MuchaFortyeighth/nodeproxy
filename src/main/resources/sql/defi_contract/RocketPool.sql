INSERT INTO defi_contracts
(contract_name, contract_address, primary_category, secondary_category,
	source_code,
	source_code_tree,
	source_code_scan_result)
VALUES('Rocket Pool', '0xd33526068d116ce69f19a9ee46f0bd304f21a51f', '金融功能类', '流动性质押',
$$
/**
  *       .
  *      / \
  *     |.'.|
  *     |'.'|
  *   ,'|   |`.
  *  |,-'-|-'-.|
  *   __|_| |         _        _      _____           _
  *  | ___ \|        | |      | |    | ___ \         | |
  *  | |_/ /|__   ___| | _____| |_   | |_/ /__   ___ | |
  *  |    // _ \ / __| |/ / _ \ __|  |  __/ _ \ / _ \| |
  *  | |\ \ (_) | (__|   <  __/ |_   | | | (_) | (_) | |
  *  \_| \_\___/ \___|_|\_\___|\__|  \_|  \___/ \___/|_|
  * +---------------------------------------------------+
  * |    DECENTRALISED STAKING PROTOCOL FOR ETHEREUM    |
  * +---------------------------------------------------+
  *
  *  Rocket Pool is a first-of-its-kind Ethereum staking pool protocol, designed to
  *  be community-owned, decentralised, and trustless.
  *
  *  For more information about Rocket Pool, visit https://rocketpool.net
  *
  *  Authors: David Rugendyke, Jake Pospischil, Kane Wallmann, Darren Langley, Joe Clapis, Nick Doherty
  *
  */

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

import "../interface/RocketStorageInterface.sol";

/// @title Base settings / modifiers for each contract in Rocket Pool
/// @author David Rugendyke

abstract contract RocketBase {

    // Calculate using this as the base
    uint256 constant calcBase = 1 ether;

    // Version of the contract
    uint8 public version;

    // The main storage contract where primary persistant storage is maintained
    RocketStorageInterface rocketStorage = RocketStorageInterface(0);


    /*** Modifiers **********************************************************/

    /**
    * @dev Throws if called by any sender that doesn't match a Rocket Pool network contract
    */
    modifier onlyLatestNetworkContract() {
        require(getBool(keccak256(abi.encodePacked("contract.exists", msg.sender))), "Invalid or outdated network contract");
        _;
    }

    /**
    * @dev Throws if called by any sender that doesn't match one of the supplied contract or is the latest version of that contract
    */
    modifier onlyLatestContract(string memory _contractName, address _contractAddress) {
        require(_contractAddress == getAddress(keccak256(abi.encodePacked("contract.address", _contractName))), "Invalid or outdated contract");
        _;
    }

    /**
    * @dev Throws if called by any sender that isn't a registered node
    */
    modifier onlyRegisteredNode(address _nodeAddress) {
        require(getBool(keccak256(abi.encodePacked("node.exists", _nodeAddress))), "Invalid node");
        _;
    }

    /**
    * @dev Throws if called by any sender that isn't a trusted node DAO member
    */
    modifier onlyTrustedNode(address _nodeAddress) {
        require(getBool(keccak256(abi.encodePacked("dao.trustednodes.", "member", _nodeAddress))), "Invalid trusted node");
        _;
    }

    /**
    * @dev Throws if called by any sender that isn't a registered minipool
    */
    modifier onlyRegisteredMinipool(address _minipoolAddress) {
        require(getBool(keccak256(abi.encodePacked("minipool.exists", _minipoolAddress))), "Invalid minipool");
        _;
    }


    /**
    * @dev Throws if called by any account other than a guardian account (temporary account allowed access to settings before DAO is fully enabled)
    */
    modifier onlyGuardian() {
        require(msg.sender == rocketStorage.getGuardian(), "Account is not a temporary guardian");
        _;
    }




    /*** Methods **********************************************************/

    /// @dev Set the main Rocket Storage address
    constructor(RocketStorageInterface _rocketStorageAddress) {
        // Update the contract address
        rocketStorage = RocketStorageInterface(_rocketStorageAddress);
    }


    /// @dev Get the address of a network contract by name
    function getContractAddress(string memory _contractName) internal view returns (address) {
        // Get the current contract address
        address contractAddress = getAddress(keccak256(abi.encodePacked("contract.address", _contractName)));
        // Check it
        require(contractAddress != address(0x0), "Contract not found");
        // Return
        return contractAddress;
    }


    /// @dev Get the address of a network contract by name (returns address(0x0) instead of reverting if contract does not exist)
    function getContractAddressUnsafe(string memory _contractName) internal view returns (address) {
        // Get the current contract address
        address contractAddress = getAddress(keccak256(abi.encodePacked("contract.address", _contractName)));
        // Return
        return contractAddress;
    }


    /// @dev Get the name of a network contract by address
    function getContractName(address _contractAddress) internal view returns (string memory) {
        // Get the contract name
        string memory contractName = getString(keccak256(abi.encodePacked("contract.name", _contractAddress)));
        // Check it
        require(bytes(contractName).length > 0, "Contract not found");
        // Return
        return contractName;
    }

    /// @dev Get revert error message from a .call method
    function getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
        // If the _res length is less than 68, then the transaction failed silently (without a revert message)
        if (_returnData.length < 68) return "Transaction reverted silently";
        assembly {
            // Slice the sighash.
            _returnData := add(_returnData, 0x04)
        }
        return abi.decode(_returnData, (string)); // All that remains is the revert string
    }



    /*** Rocket Storage Methods ****************************************/

    // Note: Unused helpers have been removed to keep contract sizes down

    /// @dev Storage get methods
    function getAddress(bytes32 _key) internal view returns (address) { return rocketStorage.getAddress(_key); }
    function getUint(bytes32 _key) internal view returns (uint) { return rocketStorage.getUint(_key); }
    function getString(bytes32 _key) internal view returns (string memory) { return rocketStorage.getString(_key); }
    function getBytes(bytes32 _key) internal view returns (bytes memory) { return rocketStorage.getBytes(_key); }
    function getBool(bytes32 _key) internal view returns (bool) { return rocketStorage.getBool(_key); }
    function getInt(bytes32 _key) internal view returns (int) { return rocketStorage.getInt(_key); }
    function getBytes32(bytes32 _key) internal view returns (bytes32) { return rocketStorage.getBytes32(_key); }

    /// @dev Storage set methods
    function setAddress(bytes32 _key, address _value) internal { rocketStorage.setAddress(_key, _value); }
    function setUint(bytes32 _key, uint _value) internal { rocketStorage.setUint(_key, _value); }
    function setString(bytes32 _key, string memory _value) internal { rocketStorage.setString(_key, _value); }
    function setBytes(bytes32 _key, bytes memory _value) internal { rocketStorage.setBytes(_key, _value); }
    function setBool(bytes32 _key, bool _value) internal { rocketStorage.setBool(_key, _value); }
    function setInt(bytes32 _key, int _value) internal { rocketStorage.setInt(_key, _value); }
    function setBytes32(bytes32 _key, bytes32 _value) internal { rocketStorage.setBytes32(_key, _value); }

    /// @dev Storage delete methods
    function deleteAddress(bytes32 _key) internal { rocketStorage.deleteAddress(_key); }
    function deleteUint(bytes32 _key) internal { rocketStorage.deleteUint(_key); }
    function deleteString(bytes32 _key) internal { rocketStorage.deleteString(_key); }
    function deleteBytes(bytes32 _key) internal { rocketStorage.deleteBytes(_key); }
    function deleteBool(bytes32 _key) internal { rocketStorage.deleteBool(_key); }
    function deleteInt(bytes32 _key) internal { rocketStorage.deleteInt(_key); }
    function deleteBytes32(bytes32 _key) internal { rocketStorage.deleteBytes32(_key); }

    /// @dev Storage arithmetic methods
    function addUint(bytes32 _key, uint256 _amount) internal { rocketStorage.addUint(_key, _amount); }
    function subUint(bytes32 _key, uint256 _amount) internal { rocketStorage.subUint(_key, _amount); }
}
$$,
$$
{
    "name": "SourceUnit",
    "attributes": {
        "absolutePath": "mainnet/0xd33526068d116ce69f19a9ee46f0bd304f21a51f/contracts/contract/RocketBase.sol",
        "exportedSymbols": "{'RocketBase': [575], 'RocketStorageInterface': [771]}",
        "id": 576,
        "license": "GPL-3.0-only",
        "src": "944:7259:0"
    },
    "children": [
        {
            "name": "PragmaDirective",
            "attributes": {
                "id": 1,
                "literals": [
                    "solidity",
                    "0.7",
                    ".6"
                ],
                "src": "944:22:0"
            },
            "children": []
        },
        {
            "name": "ImportDirective",
            "attributes": {
                "absolutePath": "mainnet/0xd33526068d116ce69f19a9ee46f0bd304f21a51f/contracts/interface/RocketStorageInterface.sol",
                "file": "../interface/RocketStorageInterface.sol",
                "id": 2,
                "scope": 576,
                "sourceUnit": 772,
                "src": "1010:49:0",
                "symbolAliases": [],
                "unitAlias": ""
            },
            "children": []
        },
        {
            "name": "ContractDefinition",
            "attributes": {
                "abstract": true,
                "baseContracts": [],
                "contractDependencies": [],
                "contractKind": "contract",
                "documentation": "{'id': 3, 'nodeType': 'StructuredDocumentation', 'src': '1061:98:0', 'text': '@title Base settings / modifiers for each contract in Rocket Pool\\n @author David Rugendyke'}",
                "fullyImplemented": true,
                "id": 575,
                "linearizedBaseContracts": [
                    575
                ],
                "name": "RocketBase",
                "scope": 576,
                "src": "1160:7042:0"
            },
            "children": [
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": true,
                        "id": 6,
                        "mutability": "constant",
                        "name": "calcBase",
                        "scope": 575,
                        "src": "1236:35:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_uint256', 'typeString': 'uint256'}",
                        "typeName": "{'id': 4, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '1236:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}",
                        "value": "{'hexValue': '31', 'id': 5, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1264:7:0', 'subdenomination': 'ether', 'typeDescriptions': {'typeIdentifier': 't_rational_1000000000000000000_by_1', 'typeString': 'int_const 1000000000000000000'}, 'value': '1'}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "functionSelector": "54fd4d50",
                        "id": 8,
                        "mutability": "mutable",
                        "name": "version",
                        "scope": 575,
                        "src": "1309:20:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_uint8', 'typeString': 'uint8'}",
                        "typeName": "{'id': 7, 'name': 'uint8', 'nodeType': 'ElementaryTypeName', 'src': '1309:5:0', 'typeDescriptions': {'typeIdentifier': 't_uint8', 'typeString': 'uint8'}}",
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "VariableDeclaration",
                    "attributes": {
                        "constant": false,
                        "id": 13,
                        "mutability": "mutable",
                        "name": "rocketStorage",
                        "scope": 575,
                        "src": "1416:64:0",
                        "stateVariable": true,
                        "storageLocation": "default",
                        "typeDescriptions": "{'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}",
                        "typeName": "{'id': 9, 'name': 'RocketStorageInterface', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 771, 'src': '1416:22:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}",
                        "value": "{'arguments': [{'hexValue': '30', 'id': 11, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1478:1:0', 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 10, 'name': 'RocketStorageInterface', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 771, 'src': '1455:22:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_RocketStorageInterface_$771_$', 'typeString': 'type(contract RocketStorageInterface)'}}, 'id': 12, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1455:25:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}",
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "ModifierDefinition",
                    "attributes": {
                        "body": "{'id': 31, 'nodeType': 'Block', 'src': '1712:144:0', 'statements': [{'expression': {'arguments': [{'arguments': [{'arguments': [{'arguments': [{'hexValue': '636f6e74726163742e657869737473', 'id': 21, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1765:17:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_0bee25abf9dd4d7db1b6a26ed35c16c69cd61a59f46569898d3d99df8a574317', 'typeString': 'literal_string \"contract.exists\"'}, 'value': 'contract.exists'}, {'expression': {'id': 22, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967281, 'src': '1784:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 23, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'src': '1784:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_0bee25abf9dd4d7db1b6a26ed35c16c69cd61a59f46569898d3d99df8a574317', 'typeString': 'literal_string \"contract.exists\"'}, {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}], 'expression': {'id': 19, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967295, 'src': '1748:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 20, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'src': '1748:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 24, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1748:47:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 18, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967288, 'src': '1738:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 25, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1738:58:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 17, 'name': 'getBool', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 326, 'src': '1730:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$returns$_t_bool_$', 'typeString': 'function (bytes32) view returns (bool)'}}, 'id': 26, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1730:67:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '496e76616c6964206f72206f75746461746564206e6574776f726b20636f6e7472616374', 'id': 27, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1799:38:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_cb2cf0f14dfedb73bc71c01520de8792a75b3546fc7504f6ab31a7d8370e7022', 'typeString': 'literal_string \"Invalid or outdated network contract\"'}, 'value': 'Invalid or outdated network contract'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_cb2cf0f14dfedb73bc71c01520de8792a75b3546fc7504f6ab31a7d8370e7022', 'typeString': 'literal_string \"Invalid or outdated network contract\"'}], 'id': 16, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [4294967278, 4294967278], 'referencedDeclaration': 4294967278, 'src': '1722:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 28, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1722:116:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 29, 'nodeType': 'ExpressionStatement', 'src': '1722:116:0'}, {'id': 30, 'nodeType': 'PlaceholderStatement', 'src': '1848:1:0'}]}",
                        "documentation": "{'id': 14, 'nodeType': 'StructuredDocumentation', 'src': '1568:102:0', 'text': \" @dev Throws if called by any sender that doesn't match a Rocket Pool network contract\"}",
                        "id": 32,
                        "name": "onlyLatestNetworkContract",
                        "parameters": "{'id': 15, 'nodeType': 'ParameterList', 'parameters': [], 'src': '1709:2:0'}",
                        "src": "1675:181:0",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "ModifierDefinition",
                    "attributes": {
                        "body": "{'id': 55, 'nodeType': 'Block', 'src': '2092:163:0', 'statements': [{'expression': {'arguments': [{'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 50, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'id': 40, 'name': '_contractAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 37, 'src': '2110:16:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'arguments': [{'arguments': [{'arguments': [{'hexValue': '636f6e74726163742e61646472657373', 'id': 45, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2168:18:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_b86ec11852586a041fafc4775b679e5f136167d6f6d0dec7dace53c72fdac064', 'typeString': 'literal_string \"contract.address\"'}, 'value': 'contract.address'}, {'id': 46, 'name': '_contractName', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 35, 'src': '2188:13:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_b86ec11852586a041fafc4775b679e5f136167d6f6d0dec7dace53c72fdac064', 'typeString': 'literal_string \"contract.address\"'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'expression': {'id': 43, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967295, 'src': '2151:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 44, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'src': '2151:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 47, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2151:51:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 42, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967288, 'src': '2141:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 48, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2141:62:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 41, 'name': 'getAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 274, 'src': '2130:10:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$returns$_t_address_$', 'typeString': 'function (bytes32) view returns (address)'}}, 'id': 49, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2130:74:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '2110:94:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '496e76616c6964206f72206f7574646174656420636f6e7472616374', 'id': 51, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2206:30:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_aff477b840b853b741d421b2ae103cb2e5ee41dbe043e75bac75854e05b16ea9', 'typeString': 'literal_string \"Invalid or outdated contract\"'}, 'value': 'Invalid or outdated contract'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_aff477b840b853b741d421b2ae103cb2e5ee41dbe043e75bac75854e05b16ea9', 'typeString': 'literal_string \"Invalid or outdated contract\"'}], 'id': 39, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [4294967278, 4294967278], 'referencedDeclaration': 4294967278, 'src': '2102:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 52, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2102:135:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 53, 'nodeType': 'ExpressionStatement', 'src': '2102:135:0'}, {'id': 54, 'nodeType': 'PlaceholderStatement', 'src': '2247:1:0'}]}",
                        "documentation": "{'id': 33, 'nodeType': 'StructuredDocumentation', 'src': '1862:142:0', 'text': \" @dev Throws if called by any sender that doesn't match one of the supplied contract or is the latest version of that contract\"}",
                        "id": 56,
                        "name": "onlyLatestContract",
                        "parameters": "{'id': 38, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 35, 'mutability': 'mutable', 'name': '_contractName', 'nodeType': 'VariableDeclaration', 'scope': 56, 'src': '2037:27:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 34, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '2037:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'visibility': 'internal'}, {'constant': False, 'id': 37, 'mutability': 'mutable', 'name': '_contractAddress', 'nodeType': 'VariableDeclaration', 'scope': 56, 'src': '2066:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 36, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '2066:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '2036:55:0'}",
                        "src": "2009:246:0",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "ModifierDefinition",
                    "attributes": {
                        "body": "{'id': 75, 'nodeType': 'Block', 'src': '2397:118:0', 'statements': [{'expression': {'arguments': [{'arguments': [{'arguments': [{'arguments': [{'hexValue': '6e6f64652e657869737473', 'id': 66, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2450:13:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_38f57b39aac928fbdb2dc0952ac9f9153708c969bf7998911be3d476c210758c', 'typeString': 'literal_string \"node.exists\"'}, 'value': 'node.exists'}, {'id': 67, 'name': '_nodeAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 59, 'src': '2465:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_38f57b39aac928fbdb2dc0952ac9f9153708c969bf7998911be3d476c210758c', 'typeString': 'literal_string \"node.exists\"'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'id': 64, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967295, 'src': '2433:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 65, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'src': '2433:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 68, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2433:45:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 63, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967288, 'src': '2423:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 69, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2423:56:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 62, 'name': 'getBool', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 326, 'src': '2415:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$returns$_t_bool_$', 'typeString': 'function (bytes32) view returns (bool)'}}, 'id': 70, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2415:65:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '496e76616c6964206e6f6465', 'id': 71, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2482:14:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_9b7c9cc27585c69b551084e5acaac4419de51d75be2a46ac330f71f4af5e6b4e', 'typeString': 'literal_string \"Invalid node\"'}, 'value': 'Invalid node'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_9b7c9cc27585c69b551084e5acaac4419de51d75be2a46ac330f71f4af5e6b4e', 'typeString': 'literal_string \"Invalid node\"'}], 'id': 61, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [4294967278, 4294967278], 'referencedDeclaration': 4294967278, 'src': '2407:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 72, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2407:90:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 73, 'nodeType': 'ExpressionStatement', 'src': '2407:90:0'}, {'id': 74, 'nodeType': 'PlaceholderStatement', 'src': '2507:1:0'}]}",
                        "documentation": "{'id': 57, 'nodeType': 'StructuredDocumentation', 'src': '2261:81:0', 'text': \" @dev Throws if called by any sender that isn't a registered node\"}",
                        "id": 76,
                        "name": "onlyRegisteredNode",
                        "parameters": "{'id': 60, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 59, 'mutability': 'mutable', 'name': '_nodeAddress', 'nodeType': 'VariableDeclaration', 'scope': 76, 'src': '2375:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 58, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '2375:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '2374:22:0'}",
                        "src": "2347:168:0",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "ModifierDefinition",
                    "attributes": {
                        "body": "{'id': 96, 'nodeType': 'Block', 'src': '2662:142:0', 'statements': [{'expression': {'arguments': [{'arguments': [{'arguments': [{'arguments': [{'hexValue': '64616f2e747275737465646e6f6465732e', 'id': 86, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2715:19:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_d4585a309ba2c0b895356d6dfa55a1a4a1737d2e05c75cfa1c9f3f12e67535a5', 'typeString': 'literal_string \"dao.trustednodes.\"'}, 'value': 'dao.trustednodes.'}, {'hexValue': '6d656d626572', 'id': 87, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2736:8:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_14ceb1149cdab84b395151a21d3de6707dd76fff3e7bc4e018925a9986b7f72f', 'typeString': 'literal_string \"member\"'}, 'value': 'member'}, {'id': 88, 'name': '_nodeAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 79, 'src': '2746:12:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_d4585a309ba2c0b895356d6dfa55a1a4a1737d2e05c75cfa1c9f3f12e67535a5', 'typeString': 'literal_string \"dao.trustednodes.\"'}, {'typeIdentifier': 't_stringliteral_14ceb1149cdab84b395151a21d3de6707dd76fff3e7bc4e018925a9986b7f72f', 'typeString': 'literal_string \"member\"'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'id': 84, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967295, 'src': '2698:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 85, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'src': '2698:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 89, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2698:61:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 83, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967288, 'src': '2688:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 90, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2688:72:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 82, 'name': 'getBool', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 326, 'src': '2680:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$returns$_t_bool_$', 'typeString': 'function (bytes32) view returns (bool)'}}, 'id': 91, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2680:81:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '496e76616c69642074727573746564206e6f6465', 'id': 92, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '2763:22:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_0546953246979b0963a20f4183708a9aa7518cb3a5b766c08f6ae2bc2878a02a', 'typeString': 'literal_string \"Invalid trusted node\"'}, 'value': 'Invalid trusted node'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_0546953246979b0963a20f4183708a9aa7518cb3a5b766c08f6ae2bc2878a02a', 'typeString': 'literal_string \"Invalid trusted node\"'}], 'id': 81, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [4294967278, 4294967278], 'referencedDeclaration': 4294967278, 'src': '2672:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 93, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2672:114:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 94, 'nodeType': 'ExpressionStatement', 'src': '2672:114:0'}, {'id': 95, 'nodeType': 'PlaceholderStatement', 'src': '2796:1:0'}]}",
                        "documentation": "{'id': 77, 'nodeType': 'StructuredDocumentation', 'src': '2521:89:0', 'text': \" @dev Throws if called by any sender that isn't a trusted node DAO member\"}",
                        "id": 97,
                        "name": "onlyTrustedNode",
                        "parameters": "{'id': 80, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 79, 'mutability': 'mutable', 'name': '_nodeAddress', 'nodeType': 'VariableDeclaration', 'scope': 97, 'src': '2640:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 78, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '2640:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '2639:22:0'}",
                        "src": "2615:189:0",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "ModifierDefinition",
                    "attributes": {
                        "body": "{'id': 116, 'nodeType': 'Block', 'src': '2958:130:0', 'statements': [{'expression': {'arguments': [{'arguments': [{'arguments': [{'arguments': [{'hexValue': '6d696e69706f6f6c2e657869737473', 'id': 107, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3011:17:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_dfe6ae843ff25814f7bf5c7bfa924973e01df505cfc7d50128d20d2d0ce2419c', 'typeString': 'literal_string \"minipool.exists\"'}, 'value': 'minipool.exists'}, {'id': 108, 'name': '_minipoolAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 100, 'src': '3030:16:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_dfe6ae843ff25814f7bf5c7bfa924973e01df505cfc7d50128d20d2d0ce2419c', 'typeString': 'literal_string \"minipool.exists\"'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'id': 105, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967295, 'src': '2994:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 106, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'src': '2994:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 109, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2994:53:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 104, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967288, 'src': '2984:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 110, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2984:64:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 103, 'name': 'getBool', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 326, 'src': '2976:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$returns$_t_bool_$', 'typeString': 'function (bytes32) view returns (bool)'}}, 'id': 111, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2976:73:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '496e76616c6964206d696e69706f6f6c', 'id': 112, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3051:18:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_9a573f419a246c095b2e2a7428ab80f81d3c776e802546f997f84acfb1e44afb', 'typeString': 'literal_string \"Invalid minipool\"'}, 'value': 'Invalid minipool'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_9a573f419a246c095b2e2a7428ab80f81d3c776e802546f997f84acfb1e44afb', 'typeString': 'literal_string \"Invalid minipool\"'}], 'id': 102, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [4294967278, 4294967278], 'referencedDeclaration': 4294967278, 'src': '2968:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 113, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2968:102:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 114, 'nodeType': 'ExpressionStatement', 'src': '2968:102:0'}, {'id': 115, 'nodeType': 'PlaceholderStatement', 'src': '3080:1:0'}]}",
                        "documentation": "{'id': 98, 'nodeType': 'StructuredDocumentation', 'src': '2810:85:0', 'text': \" @dev Throws if called by any sender that isn't a registered minipool\"}",
                        "id": 117,
                        "name": "onlyRegisteredMinipool",
                        "parameters": "{'id': 101, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 100, 'mutability': 'mutable', 'name': '_minipoolAddress', 'nodeType': 'VariableDeclaration', 'scope': 117, 'src': '2932:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 99, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '2932:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '2931:26:0'}",
                        "src": "2900:188:0",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "ModifierDefinition",
                    "attributes": {
                        "body": "{'id': 131, 'nodeType': 'Block', 'src': '3286:117:0', 'statements': [{'expression': {'arguments': [{'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 126, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'expression': {'id': 121, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967281, 'src': '3304:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 122, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'sender', 'nodeType': 'MemberAccess', 'src': '3304:10:0', 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'nodeType': 'BinaryOperation', 'operator': '==', 'rightExpression': {'arguments': [], 'expression': {'argumentTypes': [], 'expression': {'id': 123, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '3318:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 124, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'getGuardian', 'nodeType': 'MemberAccess', 'referencedDeclaration': 587, 'src': '3318:25:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$__$returns$_t_address_$', 'typeString': 'function () view external returns (address)'}}, 'id': 125, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3318:27:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '3304:41:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '4163636f756e74206973206e6f7420612074656d706f7261727920677561726469616e', 'id': 127, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3347:37:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_bce8991bd724df673e3a1973b99bbee3a00d2cfad965242581773ba92c55ee90', 'typeString': 'literal_string \"Account is not a temporary guardian\"'}, 'value': 'Account is not a temporary guardian'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_bce8991bd724df673e3a1973b99bbee3a00d2cfad965242581773ba92c55ee90', 'typeString': 'literal_string \"Account is not a temporary guardian\"'}], 'id': 120, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [4294967278, 4294967278], 'referencedDeclaration': 4294967278, 'src': '3296:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 128, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3296:89:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 129, 'nodeType': 'ExpressionStatement', 'src': '3296:89:0'}, {'id': 130, 'nodeType': 'PlaceholderStatement', 'src': '3395:1:0'}]}",
                        "documentation": "{'id': 118, 'nodeType': 'StructuredDocumentation', 'src': '3099:158:0', 'text': ' @dev Throws if called by any account other than a guardian account (temporary account allowed access to settings before DAO is fully enabled)'}",
                        "id": 132,
                        "name": "onlyGuardian",
                        "parameters": "{'id': 119, 'nodeType': 'ParameterList', 'parameters': [], 'src': '3283:2:0'}",
                        "src": "3262:141:0",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 144, 'nodeType': 'Block', 'src': '3597:117:0', 'statements': [{'expression': {'id': 142, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'id': 138, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '3646:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'arguments': [{'id': 140, 'name': '_rocketStorageAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 135, 'src': '3685:21:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}], 'id': 139, 'name': 'RocketStorageInterface', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 771, 'src': '3662:22:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_contract$_RocketStorageInterface_$771_$', 'typeString': 'type(contract RocketStorageInterface)'}}, 'id': 141, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3662:45:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'src': '3646:61:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 143, 'nodeType': 'ExpressionStatement', 'src': '3646:61:0'}]}",
                        "documentation": "{'id': 133, 'nodeType': 'StructuredDocumentation', 'src': '3490:44:0', 'text': '@dev Set the main Rocket Storage address'}",
                        "id": 145,
                        "implemented": true,
                        "kind": "constructor",
                        "modifiers": [],
                        "name": "",
                        "parameters": "{'id': 136, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 135, 'mutability': 'mutable', 'name': '_rocketStorageAddress', 'nodeType': 'VariableDeclaration', 'scope': 145, 'src': '3551:44:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}, 'typeName': {'id': 134, 'name': 'RocketStorageInterface', 'nodeType': 'UserDefinedTypeName', 'referencedDeclaration': 771, 'src': '3551:22:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'visibility': 'internal'}], 'src': '3550:46:0'}",
                        "returnParameters": "{'id': 137, 'nodeType': 'ParameterList', 'parameters': [], 'src': '3597:0:0'}",
                        "scope": 575,
                        "src": "3539:175:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 177, 'nodeType': 'Block', 'src': '3869:303:0', 'statements': [{'assignments': [154], 'declarations': [{'constant': False, 'id': 154, 'mutability': 'mutable', 'name': 'contractAddress', 'nodeType': 'VariableDeclaration', 'scope': 177, 'src': '3923:23:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 153, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '3923:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'id': 164, 'initialValue': {'arguments': [{'arguments': [{'arguments': [{'hexValue': '636f6e74726163742e61646472657373', 'id': 159, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '3987:18:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_b86ec11852586a041fafc4775b679e5f136167d6f6d0dec7dace53c72fdac064', 'typeString': 'literal_string \"contract.address\"'}, 'value': 'contract.address'}, {'id': 160, 'name': '_contractName', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 148, 'src': '4007:13:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_b86ec11852586a041fafc4775b679e5f136167d6f6d0dec7dace53c72fdac064', 'typeString': 'literal_string \"contract.address\"'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'expression': {'id': 157, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967295, 'src': '3970:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 158, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'src': '3970:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 161, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3970:51:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 156, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967288, 'src': '3960:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 162, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3960:62:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 155, 'name': 'getAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 274, 'src': '3949:10:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$returns$_t_address_$', 'typeString': 'function (bytes32) view returns (address)'}}, 'id': 163, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '3949:74:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '3923:100:0'}, {'expression': {'arguments': [{'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 171, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'id': 166, 'name': 'contractAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 154, 'src': '4061:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'arguments': [{'hexValue': '307830', 'id': 169, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '4088:3:0', 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0x0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 168, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '4080:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 167, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '4080:7:0', 'typeDescriptions': {}}}, 'id': 170, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4080:12:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '4061:31:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '436f6e7472616374206e6f7420666f756e64', 'id': 172, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '4094:20:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_83e6f26acfe0377abfebb115f6a1acd27e86bbef8936cd1c936528d59dff758d', 'typeString': 'literal_string \"Contract not found\"'}, 'value': 'Contract not found'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_83e6f26acfe0377abfebb115f6a1acd27e86bbef8936cd1c936528d59dff758d', 'typeString': 'literal_string \"Contract not found\"'}], 'id': 165, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [4294967278, 4294967278], 'referencedDeclaration': 4294967278, 'src': '4053:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 173, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4053:62:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 174, 'nodeType': 'ExpressionStatement', 'src': '4053:62:0'}, {'expression': {'id': 175, 'name': 'contractAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 154, 'src': '4150:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'functionReturnParameters': 152, 'id': 176, 'nodeType': 'Return', 'src': '4143:22:0'}]}",
                        "documentation": "{'id': 146, 'nodeType': 'StructuredDocumentation', 'src': '3721:54:0', 'text': '@dev Get the address of a network contract by name'}",
                        "id": 178,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getContractAddress",
                        "parameters": "{'id': 149, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 148, 'mutability': 'mutable', 'name': '_contractName', 'nodeType': 'VariableDeclaration', 'scope': 178, 'src': '3808:27:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 147, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '3808:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'visibility': 'internal'}], 'src': '3807:29:0'}",
                        "returnParameters": "{'id': 152, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 151, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 178, 'src': '3860:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 150, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '3860:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '3859:9:0'}",
                        "scope": 575,
                        "src": "3780:392:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 200, 'nodeType': 'Block', 'src': '4404:211:0', 'statements': [{'assignments': [187], 'declarations': [{'constant': False, 'id': 187, 'mutability': 'mutable', 'name': 'contractAddress', 'nodeType': 'VariableDeclaration', 'scope': 200, 'src': '4458:23:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 186, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '4458:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'id': 197, 'initialValue': {'arguments': [{'arguments': [{'arguments': [{'hexValue': '636f6e74726163742e61646472657373', 'id': 192, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '4522:18:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_b86ec11852586a041fafc4775b679e5f136167d6f6d0dec7dace53c72fdac064', 'typeString': 'literal_string \"contract.address\"'}, 'value': 'contract.address'}, {'id': 193, 'name': '_contractName', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 181, 'src': '4542:13:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_b86ec11852586a041fafc4775b679e5f136167d6f6d0dec7dace53c72fdac064', 'typeString': 'literal_string \"contract.address\"'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'expression': {'id': 190, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967295, 'src': '4505:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 191, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'src': '4505:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 194, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4505:51:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 189, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967288, 'src': '4495:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 195, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4495:62:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 188, 'name': 'getAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 274, 'src': '4484:10:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$returns$_t_address_$', 'typeString': 'function (bytes32) view returns (address)'}}, 'id': 196, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4484:74:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '4458:100:0'}, {'expression': {'id': 198, 'name': 'contractAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 187, 'src': '4593:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'functionReturnParameters': 185, 'id': 199, 'nodeType': 'Return', 'src': '4586:22:0'}]}",
                        "documentation": "{'id': 179, 'nodeType': 'StructuredDocumentation', 'src': '4179:125:0', 'text': '@dev Get the address of a network contract by name (returns address(0x0) instead of reverting if contract does not exist)'}",
                        "id": 201,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getContractAddressUnsafe",
                        "parameters": "{'id': 182, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 181, 'mutability': 'mutable', 'name': '_contractName', 'nodeType': 'VariableDeclaration', 'scope': 201, 'src': '4343:27:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 180, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '4343:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'visibility': 'internal'}], 'src': '4342:29:0'}",
                        "returnParameters": "{'id': 185, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 184, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 201, 'src': '4395:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 183, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '4395:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '4394:9:0'}",
                        "scope": 575,
                        "src": "4309:306:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 234, 'nodeType': 'Block', 'src': '4770:290:0', 'statements': [{'assignments': [210], 'declarations': [{'constant': False, 'id': 210, 'mutability': 'mutable', 'name': 'contractName', 'nodeType': 'VariableDeclaration', 'scope': 234, 'src': '4813:26:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 209, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '4813:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'visibility': 'internal'}], 'id': 220, 'initialValue': {'arguments': [{'arguments': [{'arguments': [{'hexValue': '636f6e74726163742e6e616d65', 'id': 215, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '4879:15:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_be9a064ea0c2cac70a17a5c0ef39014ceeee5353d6b89cbfd983559201340d4a', 'typeString': 'literal_string \"contract.name\"'}, 'value': 'contract.name'}, {'id': 216, 'name': '_contractAddress', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 204, 'src': '4896:16:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_be9a064ea0c2cac70a17a5c0ef39014ceeee5353d6b89cbfd983559201340d4a', 'typeString': 'literal_string \"contract.name\"'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'id': 213, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967295, 'src': '4862:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 214, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodePacked', 'nodeType': 'MemberAccess', 'src': '4862:16:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodepacked_pure$__$returns$_t_bytes_memory_ptr_$', 'typeString': 'function () pure returns (bytes memory)'}}, 'id': 217, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4862:51:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 212, 'name': 'keccak256', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967288, 'src': '4852:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_keccak256_pure$_t_bytes_memory_ptr_$returns$_t_bytes32_$', 'typeString': 'function (bytes memory) pure returns (bytes32)'}}, 'id': 218, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4852:62:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'id': 211, 'name': 'getString', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 300, 'src': '4842:9:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_view$_t_bytes32_$returns$_t_string_memory_ptr_$', 'typeString': 'function (bytes32) view returns (string memory)'}}, 'id': 219, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4842:73:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '4813:102:0'}, {'expression': {'arguments': [{'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 228, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'expression': {'arguments': [{'id': 224, 'name': 'contractName', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 210, 'src': '4959:12:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'id': 223, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '4953:5:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_bytes_storage_ptr_$', 'typeString': 'type(bytes storage pointer)'}, 'typeName': {'id': 222, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '4953:5:0', 'typeDescriptions': {}}}, 'id': 225, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4953:19:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, 'id': 226, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'length', 'nodeType': 'MemberAccess', 'src': '4953:26:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '>', 'rightExpression': {'hexValue': '30', 'id': 227, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '4982:1:0', 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}, 'src': '4953:30:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '436f6e7472616374206e6f7420666f756e64', 'id': 229, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '4985:20:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_83e6f26acfe0377abfebb115f6a1acd27e86bbef8936cd1c936528d59dff758d', 'typeString': 'literal_string \"Contract not found\"'}, 'value': 'Contract not found'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_83e6f26acfe0377abfebb115f6a1acd27e86bbef8936cd1c936528d59dff758d', 'typeString': 'literal_string \"Contract not found\"'}], 'id': 221, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [4294967278, 4294967278], 'referencedDeclaration': 4294967278, 'src': '4945:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 230, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '4945:61:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 231, 'nodeType': 'ExpressionStatement', 'src': '4945:61:0'}, {'expression': {'id': 232, 'name': 'contractName', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 210, 'src': '5041:12:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'functionReturnParameters': 208, 'id': 233, 'nodeType': 'Return', 'src': '5034:19:0'}]}",
                        "documentation": "{'id': 202, 'nodeType': 'StructuredDocumentation', 'src': '4622:54:0', 'text': '@dev Get the name of a network contract by address'}",
                        "id": 235,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getContractName",
                        "parameters": "{'id': 205, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 204, 'mutability': 'mutable', 'name': '_contractAddress', 'nodeType': 'VariableDeclaration', 'scope': 235, 'src': '4706:24:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 203, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '4706:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '4705:26:0'}",
                        "returnParameters": "{'id': 208, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 207, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 235, 'src': '4755:13:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 206, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '4755:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'visibility': 'internal'}], 'src': '4754:15:0'}",
                        "scope": 575,
                        "src": "4681:379:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 259, 'nodeType': 'Block', 'src': '5210:399:0', 'statements': [{'condition': {'commonType': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'id': 246, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'expression': {'id': 243, 'name': '_returnData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 238, 'src': '5335:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, 'id': 244, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'length', 'nodeType': 'MemberAccess', 'src': '5335:18:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'nodeType': 'BinaryOperation', 'operator': '<', 'rightExpression': {'hexValue': '3638', 'id': 245, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '5356:2:0', 'typeDescriptions': {'typeIdentifier': 't_rational_68_by_1', 'typeString': 'int_const 68'}, 'value': '68'}, 'src': '5335:23:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'id': 249, 'nodeType': 'IfStatement', 'src': '5331:67:0', 'trueBody': {'expression': {'hexValue': '5472616e73616374696f6e2072657665727465642073696c656e746c79', 'id': 247, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '5367:31:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_d0b1e7612ebe87924453e5d4581b9067879655587bae8a2dfee438433699b890', 'typeString': 'literal_string \"Transaction reverted silently\"'}, 'value': 'Transaction reverted silently'}, 'functionReturnParameters': 242, 'id': 248, 'nodeType': 'Return', 'src': '5360:38:0'}}, {'AST': {'nodeType': 'YulBlock', 'src': '5417:95:0', 'statements': [{'nodeType': 'YulAssignment', 'src': '5465:37:0', 'value': {'arguments': [{'name': '_returnData', 'nodeType': 'YulIdentifier', 'src': '5484:11:0'}, {'kind': 'number', 'nodeType': 'YulLiteral', 'src': '5497:4:0', 'type': '', 'value': '0x04'}], 'functionName': {'name': 'add', 'nodeType': 'YulIdentifier', 'src': '5480:3:0'}, 'nodeType': 'YulFunctionCall', 'src': '5480:22:0'}, 'variableNames': [{'name': '_returnData', 'nodeType': 'YulIdentifier', 'src': '5465:11:0'}]}]}, 'evmVersion': 'istanbul', 'externalReferences': [{'declaration': 238, 'isOffset': False, 'isSlot': False, 'src': '5465:11:0', 'valueSize': 1}, {'declaration': 238, 'isOffset': False, 'isSlot': False, 'src': '5484:11:0', 'valueSize': 1}], 'id': 250, 'nodeType': 'InlineAssembly', 'src': '5408:104:0'}, {'expression': {'arguments': [{'id': 253, 'name': '_returnData', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 238, 'src': '5539:11:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, {'components': [{'id': 255, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '5553:6:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_string_storage_ptr_$', 'typeString': 'type(string storage pointer)'}, 'typeName': {'id': 254, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '5553:6:0', 'typeDescriptions': {}}}], 'id': 256, 'isConstant': False, 'isInlineArray': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'TupleExpression', 'src': '5552:8:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_string_storage_ptr_$', 'typeString': 'type(string storage pointer)'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}, {'typeIdentifier': 't_type$_t_string_storage_ptr_$', 'typeString': 'type(string storage pointer)'}], 'expression': {'id': 251, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 4294967295, 'src': '5528:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 252, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'decode', 'nodeType': 'MemberAccess', 'src': '5528:10:0', 'typeDescriptions': {'typeIdentifier': 't_function_abidecode_pure$__$returns$__$', 'typeString': 'function () pure'}}, 'id': 257, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '5528:33:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'functionReturnParameters': 242, 'id': 258, 'nodeType': 'Return', 'src': '5521:40:0'}]}",
                        "documentation": "{'id': 236, 'nodeType': 'StructuredDocumentation', 'src': '5066:53:0', 'text': '@dev Get revert error message from a .call method'}",
                        "id": 260,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getRevertMsg",
                        "parameters": "{'id': 239, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 238, 'mutability': 'mutable', 'name': '_returnData', 'nodeType': 'VariableDeclaration', 'scope': 260, 'src': '5146:24:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 237, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '5146:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'visibility': 'internal'}], 'src': '5145:26:0'}",
                        "returnParameters": "{'id': 242, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 241, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 260, 'src': '5195:13:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 240, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '5195:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'visibility': 'internal'}], 'src': '5194:15:0'}",
                        "scope": 575,
                        "src": "5124:485:0",
                        "stateMutability": "pure",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 273, 'nodeType': 'Block', 'src': '5866:42:0', 'statements': [{'expression': {'arguments': [{'id': 270, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 263, 'src': '5900:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 268, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '5875:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 269, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'getAddress', 'nodeType': 'MemberAccess', 'referencedDeclaration': 602, 'src': '5875:24:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_bytes32_$returns$_t_address_$', 'typeString': 'function (bytes32) view external returns (address)'}}, 'id': 271, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '5875:30:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'functionReturnParameters': 267, 'id': 272, 'nodeType': 'Return', 'src': '5868:37:0'}]}",
                        "documentation": "{'id': 261, 'nodeType': 'StructuredDocumentation', 'src': '5767:28:0', 'text': '@dev Storage get methods'}",
                        "id": 274,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getAddress",
                        "parameters": "{'id': 264, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 263, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 274, 'src': '5820:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 262, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '5820:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '5819:14:0'}",
                        "returnParameters": "{'id': 267, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 266, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 274, 'src': '5857:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 265, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '5857:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '5856:9:0'}",
                        "scope": 575,
                        "src": "5800:108:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 286, 'nodeType': 'Block', 'src': '5973:39:0', 'statements': [{'expression': {'arguments': [{'id': 283, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 276, 'src': '6004:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 281, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '5982:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 282, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'getUint', 'nodeType': 'MemberAccess', 'referencedDeclaration': 609, 'src': '5982:21:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_bytes32_$returns$_t_uint256_$', 'typeString': 'function (bytes32) view external returns (uint256)'}}, 'id': 284, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '5982:27:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'functionReturnParameters': 280, 'id': 285, 'nodeType': 'Return', 'src': '5975:34:0'}]}",
                        "id": 287,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getUint",
                        "parameters": "{'id': 277, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 276, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 287, 'src': '5930:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 275, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '5930:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '5929:14:0'}",
                        "returnParameters": "{'id': 280, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 279, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 287, 'src': '5967:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 278, 'name': 'uint', 'nodeType': 'ElementaryTypeName', 'src': '5967:4:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'visibility': 'internal'}], 'src': '5966:6:0'}",
                        "scope": 575,
                        "src": "5913:99:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 299, 'nodeType': 'Block', 'src': '6088:41:0', 'statements': [{'expression': {'arguments': [{'id': 296, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 289, 'src': '6121:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 294, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '6097:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 295, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'getString', 'nodeType': 'MemberAccess', 'referencedDeclaration': 616, 'src': '6097:23:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_bytes32_$returns$_t_string_memory_ptr_$', 'typeString': 'function (bytes32) view external returns (string memory)'}}, 'id': 297, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6097:29:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}, 'functionReturnParameters': 293, 'id': 298, 'nodeType': 'Return', 'src': '6090:36:0'}]}",
                        "id": 300,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getString",
                        "parameters": "{'id': 290, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 289, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 300, 'src': '6036:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 288, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6036:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '6035:14:0'}",
                        "returnParameters": "{'id': 293, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 292, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 300, 'src': '6073:13:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 291, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '6073:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'visibility': 'internal'}], 'src': '6072:15:0'}",
                        "scope": 575,
                        "src": "6017:112:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 312, 'nodeType': 'Block', 'src': '6203:40:0', 'statements': [{'expression': {'arguments': [{'id': 309, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 302, 'src': '6235:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 307, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '6212:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 308, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'getBytes', 'nodeType': 'MemberAccess', 'referencedDeclaration': 623, 'src': '6212:22:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_bytes32_$returns$_t_bytes_memory_ptr_$', 'typeString': 'function (bytes32) view external returns (bytes memory)'}}, 'id': 310, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6212:28:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}, 'functionReturnParameters': 306, 'id': 311, 'nodeType': 'Return', 'src': '6205:35:0'}]}",
                        "id": 313,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getBytes",
                        "parameters": "{'id': 303, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 302, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 313, 'src': '6152:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 301, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6152:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '6151:14:0'}",
                        "returnParameters": "{'id': 306, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 305, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 313, 'src': '6189:12:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 304, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '6189:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'visibility': 'internal'}], 'src': '6188:14:0'}",
                        "scope": 575,
                        "src": "6134:109:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 325, 'nodeType': 'Block', 'src': '6308:39:0', 'statements': [{'expression': {'arguments': [{'id': 322, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 315, 'src': '6339:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 320, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '6317:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 321, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'getBool', 'nodeType': 'MemberAccess', 'referencedDeclaration': 630, 'src': '6317:21:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_bytes32_$returns$_t_bool_$', 'typeString': 'function (bytes32) view external returns (bool)'}}, 'id': 323, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6317:27:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'functionReturnParameters': 319, 'id': 324, 'nodeType': 'Return', 'src': '6310:34:0'}]}",
                        "id": 326,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getBool",
                        "parameters": "{'id': 316, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 315, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 326, 'src': '6265:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 314, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6265:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '6264:14:0'}",
                        "returnParameters": "{'id': 319, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 318, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 326, 'src': '6302:4:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 317, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '6302:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'visibility': 'internal'}], 'src': '6301:6:0'}",
                        "scope": 575,
                        "src": "6248:99:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 338, 'nodeType': 'Block', 'src': '6410:38:0', 'statements': [{'expression': {'arguments': [{'id': 335, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 328, 'src': '6440:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 333, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '6419:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 334, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'getInt', 'nodeType': 'MemberAccess', 'referencedDeclaration': 637, 'src': '6419:20:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_bytes32_$returns$_t_int256_$', 'typeString': 'function (bytes32) view external returns (int256)'}}, 'id': 336, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6419:26:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_int256', 'typeString': 'int256'}}, 'functionReturnParameters': 332, 'id': 337, 'nodeType': 'Return', 'src': '6412:33:0'}]}",
                        "id": 339,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getInt",
                        "parameters": "{'id': 329, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 328, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 339, 'src': '6368:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 327, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6368:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '6367:14:0'}",
                        "returnParameters": "{'id': 332, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 331, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 339, 'src': '6405:3:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_int256', 'typeString': 'int256'}, 'typeName': {'id': 330, 'name': 'int', 'nodeType': 'ElementaryTypeName', 'src': '6405:3:0', 'typeDescriptions': {'typeIdentifier': 't_int256', 'typeString': 'int256'}}, 'visibility': 'internal'}], 'src': '6404:5:0'}",
                        "scope": 575,
                        "src": "6352:96:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 351, 'nodeType': 'Block', 'src': '6519:42:0', 'statements': [{'expression': {'arguments': [{'id': 348, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 341, 'src': '6553:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 346, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '6528:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 347, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'getBytes32', 'nodeType': 'MemberAccess', 'referencedDeclaration': 644, 'src': '6528:24:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_view$_t_bytes32_$returns$_t_bytes32_$', 'typeString': 'function (bytes32) view external returns (bytes32)'}}, 'id': 349, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6528:30:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'functionReturnParameters': 345, 'id': 350, 'nodeType': 'Return', 'src': '6521:37:0'}]}",
                        "id": 352,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "getBytes32",
                        "parameters": "{'id': 342, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 341, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 352, 'src': '6473:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 340, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6473:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '6472:14:0'}",
                        "returnParameters": "{'id': 345, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 344, 'mutability': 'mutable', 'name': '', 'nodeType': 'VariableDeclaration', 'scope': 352, 'src': '6510:7:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 343, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6510:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '6509:9:0'}",
                        "scope": 575,
                        "src": "6453:108:0",
                        "stateMutability": "view",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 367, 'nodeType': 'Block', 'src': '6659:43:0', 'statements': [{'expression': {'arguments': [{'id': 363, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 355, 'src': '6686:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'id': 364, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 357, 'src': '6692:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'expression': {'id': 360, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '6661:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 362, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setAddress', 'nodeType': 'MemberAccess', 'referencedDeclaration': 651, 'src': '6661:24:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$_t_address_$returns$__$', 'typeString': 'function (bytes32,address) external'}}, 'id': 365, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6661:38:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 366, 'nodeType': 'ExpressionStatement', 'src': '6661:38:0'}]}",
                        "documentation": "{'id': 353, 'nodeType': 'StructuredDocumentation', 'src': '6567:28:0', 'text': '@dev Storage set methods'}",
                        "id": 368,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setAddress",
                        "parameters": "{'id': 358, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 355, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 368, 'src': '6620:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 354, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6620:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}, {'constant': False, 'id': 357, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'scope': 368, 'src': '6634:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 356, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '6634:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '6619:30:0'}",
                        "returnParameters": "{'id': 359, 'nodeType': 'ParameterList', 'parameters': [], 'src': '6659:0:0'}",
                        "scope": 575,
                        "src": "6600:102:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 382, 'nodeType': 'Block', 'src': '6760:40:0', 'statements': [{'expression': {'arguments': [{'id': 378, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 370, 'src': '6784:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'id': 379, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 372, 'src': '6790:6:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'id': 375, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '6762:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 377, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setUint', 'nodeType': 'MemberAccess', 'referencedDeclaration': 658, 'src': '6762:21:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,uint256) external'}}, 'id': 380, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6762:35:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 381, 'nodeType': 'ExpressionStatement', 'src': '6762:35:0'}]}",
                        "id": 383,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setUint",
                        "parameters": "{'id': 373, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 370, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 383, 'src': '6724:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 369, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6724:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}, {'constant': False, 'id': 372, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'scope': 383, 'src': '6738:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 371, 'name': 'uint', 'nodeType': 'ElementaryTypeName', 'src': '6738:4:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'visibility': 'internal'}], 'src': '6723:27:0'}",
                        "returnParameters": "{'id': 374, 'nodeType': 'ParameterList', 'parameters': [], 'src': '6760:0:0'}",
                        "scope": 575,
                        "src": "6707:93:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 397, 'nodeType': 'Block', 'src': '6869:42:0', 'statements': [{'expression': {'arguments': [{'id': 393, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 385, 'src': '6895:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'id': 394, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 387, 'src': '6901:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string memory'}], 'expression': {'id': 390, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '6871:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 392, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setString', 'nodeType': 'MemberAccess', 'referencedDeclaration': 665, 'src': '6871:23:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bytes32,string memory) external'}}, 'id': 395, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6871:37:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 396, 'nodeType': 'ExpressionStatement', 'src': '6871:37:0'}]}",
                        "id": 398,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setString",
                        "parameters": "{'id': 388, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 385, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 398, 'src': '6824:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 384, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6824:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}, {'constant': False, 'id': 387, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'scope': 398, 'src': '6838:20:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_string_memory_ptr', 'typeString': 'string'}, 'typeName': {'id': 386, 'name': 'string', 'nodeType': 'ElementaryTypeName', 'src': '6838:6:0', 'typeDescriptions': {'typeIdentifier': 't_string_storage_ptr', 'typeString': 'string'}}, 'visibility': 'internal'}], 'src': '6823:36:0'}",
                        "returnParameters": "{'id': 389, 'nodeType': 'ParameterList', 'parameters': [], 'src': '6869:0:0'}",
                        "scope": 575,
                        "src": "6805:106:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 412, 'nodeType': 'Block', 'src': '6978:41:0', 'statements': [{'expression': {'arguments': [{'id': 408, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 400, 'src': '7003:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'id': 409, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 402, 'src': '7009:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'expression': {'id': 405, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '6980:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 407, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setBytes', 'nodeType': 'MemberAccess', 'referencedDeclaration': 672, 'src': '6980:22:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (bytes32,bytes memory) external'}}, 'id': 410, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '6980:36:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 411, 'nodeType': 'ExpressionStatement', 'src': '6980:36:0'}]}",
                        "id": 413,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setBytes",
                        "parameters": "{'id': 403, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 400, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 413, 'src': '6934:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 399, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '6934:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}, {'constant': False, 'id': 402, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'scope': 413, 'src': '6948:19:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 401, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '6948:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'visibility': 'internal'}], 'src': '6933:35:0'}",
                        "returnParameters": "{'id': 404, 'nodeType': 'ParameterList', 'parameters': [], 'src': '6978:0:0'}",
                        "scope": 575,
                        "src": "6916:103:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 427, 'nodeType': 'Block', 'src': '7077:40:0', 'statements': [{'expression': {'arguments': [{'id': 423, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 415, 'src': '7101:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'id': 424, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 417, 'src': '7107:6:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_bool', 'typeString': 'bool'}], 'expression': {'id': 420, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7079:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 422, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setBool', 'nodeType': 'MemberAccess', 'referencedDeclaration': 679, 'src': '7079:21:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$_t_bool_$returns$__$', 'typeString': 'function (bytes32,bool) external'}}, 'id': 425, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7079:35:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 426, 'nodeType': 'ExpressionStatement', 'src': '7079:35:0'}]}",
                        "id": 428,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setBool",
                        "parameters": "{'id': 418, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 415, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 428, 'src': '7041:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 414, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7041:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}, {'constant': False, 'id': 417, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'scope': 428, 'src': '7055:11:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 416, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '7055:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'visibility': 'internal'}], 'src': '7040:27:0'}",
                        "returnParameters": "{'id': 419, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7077:0:0'}",
                        "scope": 575,
                        "src": "7024:93:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 442, 'nodeType': 'Block', 'src': '7173:39:0', 'statements': [{'expression': {'arguments': [{'id': 438, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 430, 'src': '7196:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'id': 439, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 432, 'src': '7202:6:0', 'typeDescriptions': {'typeIdentifier': 't_int256', 'typeString': 'int256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_int256', 'typeString': 'int256'}], 'expression': {'id': 435, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7175:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 437, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setInt', 'nodeType': 'MemberAccess', 'referencedDeclaration': 686, 'src': '7175:20:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$_t_int256_$returns$__$', 'typeString': 'function (bytes32,int256) external'}}, 'id': 440, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7175:34:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 441, 'nodeType': 'ExpressionStatement', 'src': '7175:34:0'}]}",
                        "id": 443,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setInt",
                        "parameters": "{'id': 433, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 430, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 443, 'src': '7138:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 429, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7138:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}, {'constant': False, 'id': 432, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'scope': 443, 'src': '7152:10:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_int256', 'typeString': 'int256'}, 'typeName': {'id': 431, 'name': 'int', 'nodeType': 'ElementaryTypeName', 'src': '7152:3:0', 'typeDescriptions': {'typeIdentifier': 't_int256', 'typeString': 'int256'}}, 'visibility': 'internal'}], 'src': '7137:26:0'}",
                        "returnParameters": "{'id': 434, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7173:0:0'}",
                        "scope": 575,
                        "src": "7122:90:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 457, 'nodeType': 'Block', 'src': '7276:43:0', 'statements': [{'expression': {'arguments': [{'id': 453, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 445, 'src': '7303:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'id': 454, 'name': '_value', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 447, 'src': '7309:6:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 450, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7278:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 452, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'setBytes32', 'nodeType': 'MemberAccess', 'referencedDeclaration': 693, 'src': '7278:24:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32,bytes32) external'}}, 'id': 455, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7278:38:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 456, 'nodeType': 'ExpressionStatement', 'src': '7278:38:0'}]}",
                        "id": 458,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "setBytes32",
                        "parameters": "{'id': 448, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 445, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 458, 'src': '7237:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 444, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7237:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}, {'constant': False, 'id': 447, 'mutability': 'mutable', 'name': '_value', 'nodeType': 'VariableDeclaration', 'scope': 458, 'src': '7251:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 446, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7251:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '7236:30:0'}",
                        "returnParameters": "{'id': 449, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7276:0:0'}",
                        "scope": 575,
                        "src": "7217:102:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 470, 'nodeType': 'Block', 'src': '7407:38:0', 'statements': [{'expression': {'arguments': [{'id': 467, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 461, 'src': '7437:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 464, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7409:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 466, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'deleteAddress', 'nodeType': 'MemberAccess', 'referencedDeclaration': 698, 'src': '7409:27:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32) external'}}, 'id': 468, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7409:33:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 469, 'nodeType': 'ExpressionStatement', 'src': '7409:33:0'}]}",
                        "documentation": "{'id': 459, 'nodeType': 'StructuredDocumentation', 'src': '7325:31:0', 'text': '@dev Storage delete methods'}",
                        "id": 471,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "deleteAddress",
                        "parameters": "{'id': 462, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 461, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 471, 'src': '7384:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 460, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7384:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '7383:14:0'}",
                        "returnParameters": "{'id': 463, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7407:0:0'}",
                        "scope": 575,
                        "src": "7361:84:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 482, 'nodeType': 'Block', 'src': '7493:35:0', 'statements': [{'expression': {'arguments': [{'id': 479, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 473, 'src': '7520:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 476, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7495:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 478, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'deleteUint', 'nodeType': 'MemberAccess', 'referencedDeclaration': 703, 'src': '7495:24:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32) external'}}, 'id': 480, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7495:30:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 481, 'nodeType': 'ExpressionStatement', 'src': '7495:30:0'}]}",
                        "id": 483,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "deleteUint",
                        "parameters": "{'id': 474, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 473, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 483, 'src': '7470:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 472, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7470:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '7469:14:0'}",
                        "returnParameters": "{'id': 475, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7493:0:0'}",
                        "scope": 575,
                        "src": "7450:78:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 494, 'nodeType': 'Block', 'src': '7578:37:0', 'statements': [{'expression': {'arguments': [{'id': 491, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 485, 'src': '7607:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 488, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7580:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 490, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'deleteString', 'nodeType': 'MemberAccess', 'referencedDeclaration': 708, 'src': '7580:26:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32) external'}}, 'id': 492, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7580:32:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 493, 'nodeType': 'ExpressionStatement', 'src': '7580:32:0'}]}",
                        "id": 495,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "deleteString",
                        "parameters": "{'id': 486, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 485, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 495, 'src': '7555:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 484, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7555:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '7554:14:0'}",
                        "returnParameters": "{'id': 487, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7578:0:0'}",
                        "scope": 575,
                        "src": "7533:82:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 506, 'nodeType': 'Block', 'src': '7664:36:0', 'statements': [{'expression': {'arguments': [{'id': 503, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 497, 'src': '7692:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 500, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7666:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 502, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'deleteBytes', 'nodeType': 'MemberAccess', 'referencedDeclaration': 713, 'src': '7666:25:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32) external'}}, 'id': 504, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7666:31:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 505, 'nodeType': 'ExpressionStatement', 'src': '7666:31:0'}]}",
                        "id": 507,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "deleteBytes",
                        "parameters": "{'id': 498, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 497, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 507, 'src': '7641:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 496, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7641:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '7640:14:0'}",
                        "returnParameters": "{'id': 499, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7664:0:0'}",
                        "scope": 575,
                        "src": "7620:80:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 518, 'nodeType': 'Block', 'src': '7748:35:0', 'statements': [{'expression': {'arguments': [{'id': 515, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 509, 'src': '7775:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 512, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7750:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 514, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'deleteBool', 'nodeType': 'MemberAccess', 'referencedDeclaration': 718, 'src': '7750:24:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32) external'}}, 'id': 516, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7750:30:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 517, 'nodeType': 'ExpressionStatement', 'src': '7750:30:0'}]}",
                        "id": 519,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "deleteBool",
                        "parameters": "{'id': 510, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 509, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 519, 'src': '7725:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 508, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7725:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '7724:14:0'}",
                        "returnParameters": "{'id': 511, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7748:0:0'}",
                        "scope": 575,
                        "src": "7705:78:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 530, 'nodeType': 'Block', 'src': '7830:34:0', 'statements': [{'expression': {'arguments': [{'id': 527, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 521, 'src': '7856:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 524, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7832:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 526, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'deleteInt', 'nodeType': 'MemberAccess', 'referencedDeclaration': 723, 'src': '7832:23:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32) external'}}, 'id': 528, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7832:29:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 529, 'nodeType': 'ExpressionStatement', 'src': '7832:29:0'}]}",
                        "id": 531,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "deleteInt",
                        "parameters": "{'id': 522, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 521, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 531, 'src': '7807:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 520, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7807:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '7806:14:0'}",
                        "returnParameters": "{'id': 523, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7830:0:0'}",
                        "scope": 575,
                        "src": "7788:76:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 542, 'nodeType': 'Block', 'src': '7915:38:0', 'statements': [{'expression': {'arguments': [{'id': 539, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 533, 'src': '7945:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}], 'expression': {'id': 536, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '7917:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 538, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'deleteBytes32', 'nodeType': 'MemberAccess', 'referencedDeclaration': 728, 'src': '7917:27:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$returns$__$', 'typeString': 'function (bytes32) external'}}, 'id': 540, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '7917:33:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 541, 'nodeType': 'ExpressionStatement', 'src': '7917:33:0'}]}",
                        "id": 543,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "deleteBytes32",
                        "parameters": "{'id': 534, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 533, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 543, 'src': '7892:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 532, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '7892:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}], 'src': '7891:14:0'}",
                        "returnParameters": "{'id': 535, 'nodeType': 'ParameterList', 'parameters': [], 'src': '7915:0:0'}",
                        "scope": 575,
                        "src": "7869:84:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 558, 'nodeType': 'Block', 'src': '8056:41:0', 'statements': [{'expression': {'arguments': [{'id': 554, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 546, 'src': '8080:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'id': 555, 'name': '_amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 548, 'src': '8086:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'id': 551, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '8058:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 553, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'addUint', 'nodeType': 'MemberAccess', 'referencedDeclaration': 735, 'src': '8058:21:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,uint256) external'}}, 'id': 556, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '8058:36:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 557, 'nodeType': 'ExpressionStatement', 'src': '8058:36:0'}]}",
                        "documentation": "{'id': 544, 'nodeType': 'StructuredDocumentation', 'src': '7959:35:0', 'text': '@dev Storage arithmetic methods'}",
                        "id": 559,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "addUint",
                        "parameters": "{'id': 549, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 546, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 559, 'src': '8016:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 545, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '8016:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}, {'constant': False, 'id': 548, 'mutability': 'mutable', 'name': '_amount', 'nodeType': 'VariableDeclaration', 'scope': 559, 'src': '8030:15:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 547, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '8030:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'visibility': 'internal'}], 'src': '8015:31:0'}",
                        "returnParameters": "{'id': 550, 'nodeType': 'ParameterList', 'parameters': [], 'src': '8056:0:0'}",
                        "scope": 575,
                        "src": "7999:98:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 573, 'nodeType': 'Block', 'src': '8159:41:0', 'statements': [{'expression': {'arguments': [{'id': 569, 'name': '_key', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 561, 'src': '8183:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, {'id': 570, 'name': '_amount', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 563, 'src': '8189:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}], 'expression': {'id': 566, 'name': 'rocketStorage', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '8161:13:0', 'typeDescriptions': {'typeIdentifier': 't_contract$_RocketStorageInterface_$771', 'typeString': 'contract RocketStorageInterface'}}, 'id': 568, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'subUint', 'nodeType': 'MemberAccess', 'referencedDeclaration': 742, 'src': '8161:21:0', 'typeDescriptions': {'typeIdentifier': 't_function_external_nonpayable$_t_bytes32_$_t_uint256_$returns$__$', 'typeString': 'function (bytes32,uint256) external'}}, 'id': 571, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '8161:36:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 572, 'nodeType': 'ExpressionStatement', 'src': '8161:36:0'}]}",
                        "id": 574,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "subUint",
                        "parameters": "{'id': 564, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 561, 'mutability': 'mutable', 'name': '_key', 'nodeType': 'VariableDeclaration', 'scope': 574, 'src': '8119:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}, 'typeName': {'id': 560, 'name': 'bytes32', 'nodeType': 'ElementaryTypeName', 'src': '8119:7:0', 'typeDescriptions': {'typeIdentifier': 't_bytes32', 'typeString': 'bytes32'}}, 'visibility': 'internal'}, {'constant': False, 'id': 563, 'mutability': 'mutable', 'name': '_amount', 'nodeType': 'VariableDeclaration', 'scope': 574, 'src': '8133:15:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 562, 'name': 'uint256', 'nodeType': 'ElementaryTypeName', 'src': '8133:7:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'visibility': 'internal'}], 'src': '8118:31:0'}",
                        "returnParameters": "{'id': 565, 'nodeType': 'ParameterList', 'parameters': [], 'src': '8159:0:0'}",
                        "scope": 575,
                        "src": "8102:98:0",
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