INSERT INTO defi_contracts
(contract_name, contract_address, primary_category, secondary_category,
	source_code,
	source_code_tree,
	source_code_scan_result)
VALUES('Fluid', '0x6f40d4A6237C257fff2dB00FA0510DeEECd303eb', '金融功能类', '借贷',
$$
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import { TokenDelegatorStorage, TokenEvents } from "./TokenInterfaces.sol";

contract InstaToken is TokenDelegatorStorage, TokenEvents {
    constructor(
        address account,
        address implementation_,
        uint initialSupply_,
        uint mintingAllowedAfter_,
        bool transferPaused_
    ) {
        require(implementation_ != address(0), "TokenDelegator::constructor invalid address");
        delegateTo(
            implementation_,
            abi.encodeWithSignature(
                "initialize(address,uint256,uint256,bool)",
                account,
                initialSupply_,
                mintingAllowedAfter_,
                transferPaused_
            )
        );

        implementation = implementation_;

        emit NewImplementation(address(0), implementation);
    }

    /**
     * @notice Called by the admin to update the implementation of the delegator
     * @param implementation_ The address of the new implementation for delegation
     */
    function _setImplementation(address implementation_) external isMaster {
        require(implementation_ != address(0), "TokenDelegator::_setImplementation: invalid implementation address");

        address oldImplementation = implementation;
        implementation = implementation_;

        emit NewImplementation(oldImplementation, implementation);
    }

    /**
     * @notice Internal method to delegate execution to another contract
     * @dev It returns to the external caller whatever the implementation returns or forwards reverts
     * @param callee The contract to delegatecall
     * @param data The raw data to delegatecall
     */
    function delegateTo(address callee, bytes memory data) internal {
        (bool success, bytes memory returnData) = callee.delegatecall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize())
            }
        }
    }

    /**
     * @dev Delegates execution to an implementation contract.
     * It returns to the external caller whatever the implementation returns
     * or forwards reverts.
     */
    fallback () external payable {
        // delegate all other functions to current implementation
        (bool success, ) = implementation.delegatecall(msg.data);

        assembly {
            let free_mem_ptr := mload(0x40)
            returndatacopy(free_mem_ptr, 0, returndatasize())

            switch success
            case 0 { revert(free_mem_ptr, returndatasize()) }
            default { return(free_mem_ptr, returndatasize()) }
        }
    }
}
$$,
$$
{
    "name": "SourceUnit",
    "attributes": {
        "absolutePath": "mainnet/0x6f40d4A6237C257fff2dB00FA0510DeEECd303eb/contracts/TokenDelegator.sol",
        "exportedSymbols": "{'InstaToken': [123], 'TokenDelegatorStorage': [246], 'TokenEvents': [207]}",
        "id": 124,
        "src": "0:2651:0"
    },
    "children": [
        {
            "name": "PragmaDirective",
            "attributes": {
                "id": 1,
                "literals": [
                    "solidity",
                    "^",
                    "0.7",
                    ".0"
                ],
                "src": "0:23:0"
            },
            "children": []
        },
        {
            "name": "PragmaDirective",
            "attributes": {
                "id": 2,
                "literals": [
                    "experimental",
                    "ABIEncoderV2"
                ],
                "src": "24:33:0"
            },
            "children": []
        },
        {
            "name": "ImportDirective",
            "attributes": {
                "absolutePath": "mainnet/0x6f40d4A6237C257fff2dB00FA0510DeEECd303eb/contracts/TokenInterfaces.sol",
                "file": "./TokenInterfaces.sol",
                "id": 5,
                "scope": 124,
                "sourceUnit": 294,
                "src": "59:75:0",
                "symbolAliases": [
                    {
                        "foreign": {
                            "id": 3,
                            "name": "TokenDelegatorStorage",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "src": "68:21:0",
                            "typeDescriptions": {}
                        }
                    },
                    {
                        "foreign": {
                            "id": 4,
                            "name": "TokenEvents",
                            "nodeType": "Identifier",
                            "overloadedDeclarations": [],
                            "src": "91:11:0",
                            "typeDescriptions": {}
                        }
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
                        "baseName": {
                            "id": 6,
                            "name": "TokenDelegatorStorage",
                            "nodeType": "UserDefinedTypeName",
                            "referencedDeclaration": 246,
                            "src": "159:21:0",
                            "typeDescriptions": {
                                "typeIdentifier": "t_contract$_TokenDelegatorStorage_$246",
                                "typeString": "contract TokenDelegatorStorage"
                            }
                        },
                        "id": 7,
                        "nodeType": "InheritanceSpecifier",
                        "src": "159:21:0"
                    },
                    {
                        "baseName": {
                            "id": 8,
                            "name": "TokenEvents",
                            "nodeType": "UserDefinedTypeName",
                            "referencedDeclaration": 207,
                            "src": "182:11:0",
                            "typeDescriptions": {
                                "typeIdentifier": "t_contract$_TokenEvents_$207",
                                "typeString": "contract TokenEvents"
                            }
                        },
                        "id": 9,
                        "nodeType": "InheritanceSpecifier",
                        "src": "182:11:0"
                    }
                ],
                "contractDependencies": [
                    207,
                    246
                ],
                "contractKind": "contract",
                "fullyImplemented": true,
                "id": 123,
                "linearizedBaseContracts": [
                    123,
                    207,
                    246
                ],
                "name": "InstaToken",
                "scope": 124,
                "src": "136:2514:0"
            },
            "children": [
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 56, 'nodeType': 'Block', 'src': '370:504:0', 'statements': [{'expression': {'arguments': [{'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 28, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'id': 23, 'name': 'implementation_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '388:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'arguments': [{'hexValue': '30', 'id': 26, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '415:1:0', 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 25, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '407:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 24, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '407:7:0', 'typeDescriptions': {}}}, 'id': 27, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '407:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '388:29:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '546f6b656e44656c656761746f723a3a636f6e7374727563746f7220696e76616c69642061646472657373', 'id': 29, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '419:45:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_03297b91b7539f33796c233e277871fd8ee07cb587b66a191781b176c0c1d550', 'typeString': 'literal_string \"TokenDelegator::constructor invalid address\"'}, 'value': 'TokenDelegator::constructor invalid address'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_03297b91b7539f33796c233e277871fd8ee07cb587b66a191781b176c0c1d550', 'typeString': 'literal_string \"TokenDelegator::constructor invalid address\"'}], 'id': 22, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '380:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 30, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '380:85:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 31, 'nodeType': 'ExpressionStatement', 'src': '380:85:0'}, {'expression': {'arguments': [{'id': 33, 'name': 'implementation_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '499:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'arguments': [{'hexValue': '696e697469616c697a6528616464726573732c75696e743235362c75696e743235362c626f6f6c29', 'id': 36, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '569:42:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_34aef837ebffa41744839677cff7eb547d13f5ccb93d40577f946998b9d45239', 'typeString': 'literal_string \"initialize(address,uint256,uint256,bool)\"'}, 'value': 'initialize(address,uint256,uint256,bool)'}, {'id': 37, 'name': 'account', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 11, 'src': '629:7:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'id': 38, 'name': 'initialSupply_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 15, 'src': '654:14:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'id': 39, 'name': 'mintingAllowedAfter_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 17, 'src': '686:20:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, {'id': 40, 'name': 'transferPaused_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 19, 'src': '724:15:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_stringliteral_34aef837ebffa41744839677cff7eb547d13f5ccb93d40577f946998b9d45239', 'typeString': 'literal_string \"initialize(address,uint256,uint256,bool)\"'}, {'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, {'typeIdentifier': 't_bool', 'typeString': 'bool'}], 'expression': {'id': 34, 'name': 'abi', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -1, 'src': '528:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_abi', 'typeString': 'abi'}}, 'id': 35, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'memberName': 'encodeWithSignature', 'nodeType': 'MemberAccess', 'src': '528:23:0', 'typeDescriptions': {'typeIdentifier': 't_function_abiencodewithsignature_pure$_t_string_memory_ptr_$returns$_t_bytes_memory_ptr_$', 'typeString': 'function (string memory) pure returns (bytes memory)'}}, 'id': 41, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '528:225:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'id': 32, 'name': 'delegateTo', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 108, 'src': '475:10:0', 'typeDescriptions': {'typeIdentifier': 't_function_internal_nonpayable$_t_address_$_t_bytes_memory_ptr_$returns$__$', 'typeString': 'function (address,bytes memory)'}}, 'id': 42, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '475:288:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 43, 'nodeType': 'ExpressionStatement', 'src': '475:288:0'}, {'expression': {'id': 46, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'id': 44, 'name': 'implementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 216, 'src': '774:14:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'id': 45, 'name': 'implementation_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 13, 'src': '791:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '774:32:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 47, 'nodeType': 'ExpressionStatement', 'src': '774:32:0'}, {'eventCall': {'arguments': [{'arguments': [{'hexValue': '30', 'id': 51, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '848:1:0', 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 50, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '840:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 49, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '840:7:0', 'typeDescriptions': {}}}, 'id': 52, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '840:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, {'id': 53, 'name': 'implementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 216, 'src': '852:14:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 48, 'name': 'NewImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 182, 'src': '822:17:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$returns$__$', 'typeString': 'function (address,address)'}}, 'id': 54, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '822:45:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 55, 'nodeType': 'EmitStatement', 'src': '817:50:0'}]}",
                        "id": 57,
                        "implemented": true,
                        "kind": "constructor",
                        "modifiers": [],
                        "name": "",
                        "parameters": "{'id': 20, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 11, 'mutability': 'mutable', 'name': 'account', 'nodeType': 'VariableDeclaration', 'scope': 57, 'src': '221:15:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 10, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '221:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}, {'constant': False, 'id': 13, 'mutability': 'mutable', 'name': 'implementation_', 'nodeType': 'VariableDeclaration', 'scope': 57, 'src': '246:23:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 12, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '246:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}, {'constant': False, 'id': 15, 'mutability': 'mutable', 'name': 'initialSupply_', 'nodeType': 'VariableDeclaration', 'scope': 57, 'src': '279:19:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 14, 'name': 'uint', 'nodeType': 'ElementaryTypeName', 'src': '279:4:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'visibility': 'internal'}, {'constant': False, 'id': 17, 'mutability': 'mutable', 'name': 'mintingAllowedAfter_', 'nodeType': 'VariableDeclaration', 'scope': 57, 'src': '308:25:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}, 'typeName': {'id': 16, 'name': 'uint', 'nodeType': 'ElementaryTypeName', 'src': '308:4:0', 'typeDescriptions': {'typeIdentifier': 't_uint256', 'typeString': 'uint256'}}, 'visibility': 'internal'}, {'constant': False, 'id': 19, 'mutability': 'mutable', 'name': 'transferPaused_', 'nodeType': 'VariableDeclaration', 'scope': 57, 'src': '343:20:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 18, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '343:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'visibility': 'internal'}], 'src': '211:158:0'}",
                        "returnParameters": "{'id': 21, 'nodeType': 'ParameterList', 'parameters': [], 'src': '370:0:0'}",
                        "scope": 123,
                        "src": "200:674:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "public"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 88, 'nodeType': 'Block', 'src': '1131:288:0', 'statements': [{'expression': {'arguments': [{'commonType': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'id': 71, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftExpression': {'id': 66, 'name': 'implementation_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 60, 'src': '1149:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'BinaryOperation', 'operator': '!=', 'rightExpression': {'arguments': [{'hexValue': '30', 'id': 69, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'number', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1176:1:0', 'typeDescriptions': {'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}, 'value': '0'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_rational_0_by_1', 'typeString': 'int_const 0'}], 'id': 68, 'isConstant': False, 'isLValue': False, 'isPure': True, 'lValueRequested': False, 'nodeType': 'ElementaryTypeNameExpression', 'src': '1168:7:0', 'typeDescriptions': {'typeIdentifier': 't_type$_t_address_$', 'typeString': 'type(address)'}, 'typeName': {'id': 67, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '1168:7:0', 'typeDescriptions': {}}}, 'id': 70, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'typeConversion', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1168:10:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_address_payable', 'typeString': 'address payable'}}, 'src': '1149:29:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, {'hexValue': '546f6b656e44656c656761746f723a3a5f736574496d706c656d656e746174696f6e3a20696e76616c696420696d706c656d656e746174696f6e2061646472657373', 'id': 72, 'isConstant': False, 'isLValue': False, 'isPure': True, 'kind': 'string', 'lValueRequested': False, 'nodeType': 'Literal', 'src': '1180:68:0', 'typeDescriptions': {'typeIdentifier': 't_stringliteral_5571c1c0c0b69139a1c28f162e49038f73f8fd9aedead0d969768afe76d8a988', 'typeString': 'literal_string \"TokenDelegator::_setImplementation: invalid implementation address\"'}, 'value': 'TokenDelegator::_setImplementation: invalid implementation address'}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bool', 'typeString': 'bool'}, {'typeIdentifier': 't_stringliteral_5571c1c0c0b69139a1c28f162e49038f73f8fd9aedead0d969768afe76d8a988', 'typeString': 'literal_string \"TokenDelegator::_setImplementation: invalid implementation address\"'}], 'id': 65, 'name': 'require', 'nodeType': 'Identifier', 'overloadedDeclarations': [-18, -18], 'referencedDeclaration': -18, 'src': '1141:7:0', 'typeDescriptions': {'typeIdentifier': 't_function_require_pure$_t_bool_$_t_string_memory_ptr_$returns$__$', 'typeString': 'function (bool,string memory) pure'}}, 'id': 73, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1141:108:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 74, 'nodeType': 'ExpressionStatement', 'src': '1141:108:0'}, {'assignments': [76], 'declarations': [{'constant': False, 'id': 76, 'mutability': 'mutable', 'name': 'oldImplementation', 'nodeType': 'VariableDeclaration', 'scope': 88, 'src': '1260:25:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 75, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '1260:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'id': 78, 'initialValue': {'id': 77, 'name': 'implementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 216, 'src': '1288:14:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '1260:42:0'}, {'expression': {'id': 81, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'leftHandSide': {'id': 79, 'name': 'implementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 216, 'src': '1312:14:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'nodeType': 'Assignment', 'operator': '=', 'rightHandSide': {'id': 80, 'name': 'implementation_', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 60, 'src': '1329:15:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'src': '1312:32:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 82, 'nodeType': 'ExpressionStatement', 'src': '1312:32:0'}, {'eventCall': {'arguments': [{'id': 84, 'name': 'oldImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 76, 'src': '1378:17:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, {'id': 85, 'name': 'implementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 216, 'src': '1397:14:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_address', 'typeString': 'address'}, {'typeIdentifier': 't_address', 'typeString': 'address'}], 'id': 83, 'name': 'NewImplementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 182, 'src': '1360:17:0', 'typeDescriptions': {'typeIdentifier': 't_function_event_nonpayable$_t_address_$_t_address_$returns$__$', 'typeString': 'function (address,address)'}}, 'id': 86, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1360:52:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$__$', 'typeString': 'tuple()'}}, 'id': 87, 'nodeType': 'EmitStatement', 'src': '1355:57:0'}]}",
                        "documentation": "{'id': 58, 'nodeType': 'StructuredDocumentation', 'src': '880:175:0', 'text': ' @notice Called by the admin to update the implementation of the delegator\\n @param implementation_ The address of the new implementation for delegation'}",
                        "functionSelector": "bb913f41",
                        "id": 89,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [
                            {
                                "id": 63,
                                "modifierName": {
                                    "id": 62,
                                    "name": "isMaster",
                                    "nodeType": "Identifier",
                                    "overloadedDeclarations": [],
                                    "referencedDeclaration": 245,
                                    "src": "1122:8:0",
                                    "typeDescriptions": {
                                        "typeIdentifier": "t_modifier$__$",
                                        "typeString": "modifier ()"
                                    }
                                },
                                "nodeType": "ModifierInvocation",
                                "src": "1122:8:0"
                            }
                        ],
                        "name": "_setImplementation",
                        "parameters": "{'id': 61, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 60, 'mutability': 'mutable', 'name': 'implementation_', 'nodeType': 'VariableDeclaration', 'scope': 89, 'src': '1088:23:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 59, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '1088:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}], 'src': '1087:25:0'}",
                        "returnParameters": "{'id': 64, 'nodeType': 'ParameterList', 'parameters': [], 'src': '1131:0:0'}",
                        "scope": 123,
                        "src": "1060:359:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "external"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 107, 'nodeType': 'Block', 'src': '1778:223:0', 'statements': [{'assignments': [98, 100], 'declarations': [{'constant': False, 'id': 98, 'mutability': 'mutable', 'name': 'success', 'nodeType': 'VariableDeclaration', 'scope': 107, 'src': '1789:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 97, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '1789:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'visibility': 'internal'}, {'constant': False, 'id': 100, 'mutability': 'mutable', 'name': 'returnData', 'nodeType': 'VariableDeclaration', 'scope': 107, 'src': '1803:23:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 99, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '1803:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'visibility': 'internal'}], 'id': 105, 'initialValue': {'arguments': [{'id': 103, 'name': 'data', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 94, 'src': '1850:4:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes memory'}], 'expression': {'id': 101, 'name': 'callee', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 92, 'src': '1830:6:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 102, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'delegatecall', 'nodeType': 'MemberAccess', 'src': '1830:19:0', 'typeDescriptions': {'typeIdentifier': 't_function_baredelegatecall_nonpayable$_t_bytes_memory_ptr_$returns$_t_bool_$_t_bytes_memory_ptr_$', 'typeString': 'function (bytes memory) returns (bool,bytes memory)'}}, 'id': 104, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '1830:25:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$_t_bool_$_t_bytes_memory_ptr_$', 'typeString': 'tuple(bool,bytes memory)'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '1788:67:0'}, {'AST': {'nodeType': 'YulBlock', 'src': '1874:121:0', 'statements': [{'body': {'nodeType': 'YulBlock', 'src': '1906:79:0', 'statements': [{'expression': {'arguments': [{'arguments': [{'name': 'returnData', 'nodeType': 'YulIdentifier', 'src': '1935:10:0'}, {'kind': 'number', 'nodeType': 'YulLiteral', 'src': '1947:4:0', 'type': '', 'value': '0x20'}], 'functionName': {'name': 'add', 'nodeType': 'YulIdentifier', 'src': '1931:3:0'}, 'nodeType': 'YulFunctionCall', 'src': '1931:21:0'}, {'arguments': [], 'functionName': {'name': 'returndatasize', 'nodeType': 'YulIdentifier', 'src': '1954:14:0'}, 'nodeType': 'YulFunctionCall', 'src': '1954:16:0'}], 'functionName': {'name': 'revert', 'nodeType': 'YulIdentifier', 'src': '1924:6:0'}, 'nodeType': 'YulFunctionCall', 'src': '1924:47:0'}, 'nodeType': 'YulExpressionStatement', 'src': '1924:47:0'}]}, 'condition': {'arguments': [{'name': 'success', 'nodeType': 'YulIdentifier', 'src': '1894:7:0'}, {'kind': 'number', 'nodeType': 'YulLiteral', 'src': '1903:1:0', 'type': '', 'value': '0'}], 'functionName': {'name': 'eq', 'nodeType': 'YulIdentifier', 'src': '1891:2:0'}, 'nodeType': 'YulFunctionCall', 'src': '1891:14:0'}, 'nodeType': 'YulIf', 'src': '1888:2:0'}]}, 'evmVersion': 'istanbul', 'externalReferences': [{'declaration': 100, 'isOffset': False, 'isSlot': False, 'src': '1935:10:0', 'valueSize': 1}, {'declaration': 98, 'isOffset': False, 'isSlot': False, 'src': '1894:7:0', 'valueSize': 1}], 'id': 106, 'nodeType': 'InlineAssembly', 'src': '1865:130:0'}]}",
                        "documentation": "{'id': 90, 'nodeType': 'StructuredDocumentation', 'src': '1425:284:0', 'text': ' @notice Internal method to delegate execution to another contract\\n @dev It returns to the external caller whatever the implementation returns or forwards reverts\\n @param callee The contract to delegatecall\\n @param data The raw data to delegatecall'}",
                        "id": 108,
                        "implemented": true,
                        "kind": "function",
                        "modifiers": [],
                        "name": "delegateTo",
                        "parameters": "{'id': 95, 'nodeType': 'ParameterList', 'parameters': [{'constant': False, 'id': 92, 'mutability': 'mutable', 'name': 'callee', 'nodeType': 'VariableDeclaration', 'scope': 108, 'src': '1734:14:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}, 'typeName': {'id': 91, 'name': 'address', 'nodeType': 'ElementaryTypeName', 'src': '1734:7:0', 'stateMutability': 'nonpayable', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'visibility': 'internal'}, {'constant': False, 'id': 94, 'mutability': 'mutable', 'name': 'data', 'nodeType': 'VariableDeclaration', 'scope': 108, 'src': '1750:17:0', 'stateVariable': False, 'storageLocation': 'memory', 'typeDescriptions': {'typeIdentifier': 't_bytes_memory_ptr', 'typeString': 'bytes'}, 'typeName': {'id': 93, 'name': 'bytes', 'nodeType': 'ElementaryTypeName', 'src': '1750:5:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_storage_ptr', 'typeString': 'bytes'}}, 'visibility': 'internal'}], 'src': '1733:35:0'}",
                        "returnParameters": "{'id': 96, 'nodeType': 'ParameterList', 'parameters': [], 'src': '1778:0:0'}",
                        "scope": 123,
                        "src": "1714:287:0",
                        "stateMutability": "nonpayable",
                        "virtual": false,
                        "visibility": "internal"
                    },
                    "children": []
                },
                {
                    "name": "FunctionDefinition",
                    "attributes": {
                        "body": "{'id': 121, 'nodeType': 'Block', 'src': '2220:428:0', 'statements': [{'assignments': [113, None], 'declarations': [{'constant': False, 'id': 113, 'mutability': 'mutable', 'name': 'success', 'nodeType': 'VariableDeclaration', 'scope': 121, 'src': '2297:12:0', 'stateVariable': False, 'storageLocation': 'default', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}, 'typeName': {'id': 112, 'name': 'bool', 'nodeType': 'ElementaryTypeName', 'src': '2297:4:0', 'typeDescriptions': {'typeIdentifier': 't_bool', 'typeString': 'bool'}}, 'visibility': 'internal'}, None], 'id': 119, 'initialValue': {'arguments': [{'expression': {'id': 116, 'name': 'msg', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': -15, 'src': '2343:3:0', 'typeDescriptions': {'typeIdentifier': 't_magic_message', 'typeString': 'msg'}}, 'id': 117, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'data', 'nodeType': 'MemberAccess', 'src': '2343:8:0', 'typeDescriptions': {'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes calldata'}}], 'expression': {'argumentTypes': [{'typeIdentifier': 't_bytes_calldata_ptr', 'typeString': 'bytes calldata'}], 'expression': {'id': 114, 'name': 'implementation', 'nodeType': 'Identifier', 'overloadedDeclarations': [], 'referencedDeclaration': 216, 'src': '2315:14:0', 'typeDescriptions': {'typeIdentifier': 't_address', 'typeString': 'address'}}, 'id': 115, 'isConstant': False, 'isLValue': False, 'isPure': False, 'lValueRequested': False, 'memberName': 'delegatecall', 'nodeType': 'MemberAccess', 'src': '2315:27:0', 'typeDescriptions': {'typeIdentifier': 't_function_baredelegatecall_nonpayable$_t_bytes_memory_ptr_$returns$_t_bool_$_t_bytes_memory_ptr_$', 'typeString': 'function (bytes memory) returns (bool,bytes memory)'}}, 'id': 118, 'isConstant': False, 'isLValue': False, 'isPure': False, 'kind': 'functionCall', 'lValueRequested': False, 'names': [], 'nodeType': 'FunctionCall', 'src': '2315:37:0', 'tryCall': False, 'typeDescriptions': {'typeIdentifier': 't_tuple$_t_bool_$_t_bytes_memory_ptr_$', 'typeString': 'tuple(bool,bytes memory)'}}, 'nodeType': 'VariableDeclarationStatement', 'src': '2296:56:0'}, {'AST': {'nodeType': 'YulBlock', 'src': '2372:270:0', 'statements': [{'nodeType': 'YulVariableDeclaration', 'src': '2386:31:0', 'value': {'arguments': [{'kind': 'number', 'nodeType': 'YulLiteral', 'src': '2412:4:0', 'type': '', 'value': '0x40'}], 'functionName': {'name': 'mload', 'nodeType': 'YulIdentifier', 'src': '2406:5:0'}, 'nodeType': 'YulFunctionCall', 'src': '2406:11:0'}, 'variables': [{'name': 'free_mem_ptr', 'nodeType': 'YulTypedName', 'src': '2390:12:0', 'type': ''}]}, {'expression': {'arguments': [{'name': 'free_mem_ptr', 'nodeType': 'YulIdentifier', 'src': '2445:12:0'}, {'kind': 'number', 'nodeType': 'YulLiteral', 'src': '2459:1:0', 'type': '', 'value': '0'}, {'arguments': [], 'functionName': {'name': 'returndatasize', 'nodeType': 'YulIdentifier', 'src': '2462:14:0'}, 'nodeType': 'YulFunctionCall', 'src': '2462:16:0'}], 'functionName': {'name': 'returndatacopy', 'nodeType': 'YulIdentifier', 'src': '2430:14:0'}, 'nodeType': 'YulFunctionCall', 'src': '2430:49:0'}, 'nodeType': 'YulExpressionStatement', 'src': '2430:49:0'}, {'cases': [{'body': {'nodeType': 'YulBlock', 'src': '2527:42:0', 'statements': [{'expression': {'arguments': [{'name': 'free_mem_ptr', 'nodeType': 'YulIdentifier', 'src': '2536:12:0'}, {'arguments': [], 'functionName': {'name': 'returndatasize', 'nodeType': 'YulIdentifier', 'src': '2550:14:0'}, 'nodeType': 'YulFunctionCall', 'src': '2550:16:0'}], 'functionName': {'name': 'revert', 'nodeType': 'YulIdentifier', 'src': '2529:6:0'}, 'nodeType': 'YulFunctionCall', 'src': '2529:38:0'}, 'nodeType': 'YulExpressionStatement', 'src': '2529:38:0'}]}, 'nodeType': 'YulCase', 'src': '2520:49:0', 'value': {'kind': 'number', 'nodeType': 'YulLiteral', 'src': '2525:1:0', 'type': '', 'value': '0'}}, {'body': {'nodeType': 'YulBlock', 'src': '2590:42:0', 'statements': [{'expression': {'arguments': [{'name': 'free_mem_ptr', 'nodeType': 'YulIdentifier', 'src': '2599:12:0'}, {'arguments': [], 'functionName': {'name': 'returndatasize', 'nodeType': 'YulIdentifier', 'src': '2613:14:0'}, 'nodeType': 'YulFunctionCall', 'src': '2613:16:0'}], 'functionName': {'name': 'return', 'nodeType': 'YulIdentifier', 'src': '2592:6:0'}, 'nodeType': 'YulFunctionCall', 'src': '2592:38:0'}, 'nodeType': 'YulExpressionStatement', 'src': '2592:38:0'}]}, 'nodeType': 'YulCase', 'src': '2582:50:0', 'value': 'default'}], 'expression': {'name': 'success', 'nodeType': 'YulIdentifier', 'src': '2500:7:0'}, 'nodeType': 'YulSwitch', 'src': '2493:139:0'}]}, 'evmVersion': 'istanbul', 'externalReferences': [{'declaration': 113, 'isOffset': False, 'isSlot': False, 'src': '2500:7:0', 'valueSize': 1}], 'id': 120, 'nodeType': 'InlineAssembly', 'src': '2363:279:0'}]}",
                        "documentation": "{'id': 109, 'nodeType': 'StructuredDocumentation', 'src': '2007:179:0', 'text': ' @dev Delegates execution to an implementation contract.\\n It returns to the external caller whatever the implementation returns\\n or forwards reverts.'}",
                        "id": 122,
                        "implemented": true,
                        "kind": "fallback",
                        "modifiers": [],
                        "name": "",
                        "parameters": "{'id': 110, 'nodeType': 'ParameterList', 'parameters': [], 'src': '2200:2:0'}",
                        "returnParameters": "{'id': 111, 'nodeType': 'ParameterList', 'parameters': [], 'src': '2220:0:0'}",
                        "scope": 123,
                        "src": "2191:457:0",
                        "stateMutability": "payable",
                        "virtual": false,
                        "visibility": "external"
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