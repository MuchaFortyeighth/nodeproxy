INSERT INTO defi_contracts
(contract_name, contract_address, primary_category, secondary_category,
	source_code,
	source_code_tree,
	source_code_scan_result)
VALUES('Maker', '0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2', '资产管理类', '合成资产',
$$
/**
 *Submitted for verification at Etherscan.io on 2017-11-25
*/

// MKR Token

// hevm: flattened sources of src/mkr-499.sol
pragma solidity ^0.4.15;

////// lib/ds-roles/lib/ds-auth/src/auth.sol
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.4.13; */

contract DSAuthority {
    function canCall(
        address src, address dst, bytes4 sig
    ) public view returns (bool);
}

contract DSAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority  public  authority;
    address      public  owner;

    function DSAuth() public {
        owner = msg.sender;
        LogSetOwner(msg.sender);
    }

    function setOwner(address owner_)
        public
        auth
    {
        owner = owner_;
        LogSetOwner(owner);
    }

    function setAuthority(DSAuthority authority_)
        public
        auth
    {
        authority = authority_;
        LogSetAuthority(authority);
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig));
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, this, sig);
        }
    }
}

////// lib/ds-thing/lib/ds-math/src/math.sol
/// math.sol -- mixin for inline numerical wizardry

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.4.13; */

contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function max(uint x, uint y) internal pure returns (uint z) {
        return x >= y ? x : y;
    }
    function imin(int x, int y) internal pure returns (int z) {
        return x <= y ? x : y;
    }
    function imax(int x, int y) internal pure returns (int z) {
        return x >= y ? x : y;
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    // This famous algorithm is called "exponentiation by squaring"
    // and calculates x^n with x as fixed-point and n as regular unsigned.
    //
    // It's O(log n), instead of O(n) for naive repeated multiplication.
    //
    // These facts are why it works:
    //
    //  If n is even, then x^n = (x^2)^(n/2).
    //  If n is odd,  then x^n = x * x^(n-1),
    //   and applying the equation for even x gives
    //    x^n = x * (x^2)^((n-1) / 2).
    //
    //  Also, EVM division is flooring and
    //    floor[(n-1) / 2] = floor[n / 2].
    //
    function rpow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

////// lib/ds-thing/lib/ds-note/src/note.sol
/// note.sol -- the `note' modifier, for logging calls as events

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.4.13; */

contract DSNote {
    event LogNote(
        bytes4   indexed  sig,
        address  indexed  guy,
        bytes32  indexed  foo,
        bytes32  indexed  bar,
        uint              wad,
        bytes             fax
    ) anonymous;

    modifier note {
        bytes32 foo;
        bytes32 bar;

        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
        }

        LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);

        _;
    }
}

////// lib/ds-thing/src/thing.sol
// thing.sol - `auth` with handy mixins. your things should be DSThings

// Copyright (C) 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.4.13; */

/* import 'ds-auth/auth.sol'; */
/* import 'ds-note/note.sol'; */
/* import 'ds-math/math.sol'; */

contract DSThing is DSAuth, DSNote, DSMath {
}

////// lib/ds-token/lib/ds-stop/src/stop.sol
/// stop.sol -- mixin for enable/disable functionality

// Copyright (C) 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.4.13; */

/* import "ds-auth/auth.sol"; */
/* import "ds-note/note.sol"; */

contract DSStop is DSNote, DSAuth {

    bool public stopped;

    modifier stoppable {
        require(!stopped);
        _;
    }
    function stop() public auth note {
        stopped = true;
    }
    function start() public auth note {
        stopped = false;
    }

}

////// lib/ds-token/lib/erc20/src/erc20.sol
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.4.8; */

// Token standard API
// https://github.com/ethereum/EIPs/issues/20

contract ERC20 {
    function totalSupply() public view returns (uint supply);
    function balanceOf( address who ) public view returns (uint value);
    function allowance( address owner, address spender ) public view returns (uint _allowance);

    function transfer( address to, uint value) public returns (bool ok);
    function transferFrom( address from, address to, uint value) public returns (bool ok);
    function approve( address spender, uint value ) public returns (bool ok);

    event Transfer( address indexed from, address indexed to, uint value);
    event Approval( address indexed owner, address indexed spender, uint value);
}

////// lib/ds-token/src/base.sol
/// base.sol -- basic ERC20 implementation

// Copyright (C) 2015, 2016, 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.4.13; */

/* import "erc20/erc20.sol"; */
/* import "ds-math/math.sol"; */

contract DSTokenBase is ERC20, DSMath {
    uint256                                            _supply;
    mapping (address => uint256)                       _balances;
    mapping (address => mapping (address => uint256))  _approvals;

    function DSTokenBase(uint supply) public {
        _balances[msg.sender] = supply;
        _supply = supply;
    }

    function totalSupply() public view returns (uint) {
        return _supply;
    }
    function balanceOf(address src) public view returns (uint) {
        return _balances[src];
    }
    function allowance(address src, address guy) public view returns (uint) {
        return _approvals[src][guy];
    }

    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        if (src != msg.sender) {
            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
        }

        _balances[src] = sub(_balances[src], wad);
        _balances[dst] = add(_balances[dst], wad);

        Transfer(src, dst, wad);

        return true;
    }

    function approve(address guy, uint wad) public returns (bool) {
        _approvals[msg.sender][guy] = wad;

        Approval(msg.sender, guy, wad);

        return true;
    }
}

////// lib/ds-token/src/token.sol
/// token.sol -- ERC20 implementation with minting and burning

// Copyright (C) 2015, 2016, 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity ^0.4.13; */

/* import "ds-stop/stop.sol"; */

/* import "./base.sol"; */

contract DSToken is DSTokenBase(0), DSStop {

    bytes32  public  symbol;
    uint256  public  decimals = 18; // standard token precision. override to customize

    function DSToken(bytes32 symbol_) public {
        symbol = symbol_;
    }

    event Mint(address indexed guy, uint wad);
    event Burn(address indexed guy, uint wad);

    function approve(address guy) public stoppable returns (bool) {
        return super.approve(guy, uint(-1));
    }

    function approve(address guy, uint wad) public stoppable returns (bool) {
        return super.approve(guy, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        stoppable
        returns (bool)
    {
        if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
        }

        _balances[src] = sub(_balances[src], wad);
        _balances[dst] = add(_balances[dst], wad);

        Transfer(src, dst, wad);

        return true;
    }

    function push(address dst, uint wad) public {
        transferFrom(msg.sender, dst, wad);
    }
    function pull(address src, uint wad) public {
        transferFrom(src, msg.sender, wad);
    }
    function move(address src, address dst, uint wad) public {
        transferFrom(src, dst, wad);
    }

    function mint(uint wad) public {
        mint(msg.sender, wad);
    }
    function burn(uint wad) public {
        burn(msg.sender, wad);
    }
    function mint(address guy, uint wad) public auth stoppable {
        _balances[guy] = add(_balances[guy], wad);
        _supply = add(_supply, wad);
        Mint(guy, wad);
    }
    function burn(address guy, uint wad) public auth stoppable {
        if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
            _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
        }

        _balances[guy] = sub(_balances[guy], wad);
        _supply = sub(_supply, wad);
        Burn(guy, wad);
    }

    // Optional token name
    bytes32   public  name = "";

    function setName(bytes32 name_) public auth {
        name = name_;
    }
}
$$,
$$
{
    "attributes": {
        "absolutePath": "mainnet/0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2/DSToken.sol",
        "exportedSymbols": {
            "DSAuth": [
                131
            ],
            "DSAuthEvents": [
                22
            ],
            "DSAuthority": [
                13
            ],
            "DSMath": [
                430
            ],
            "DSNote": [
                469
            ],
            "DSStop": [
                516
            ],
            "DSThing": [
                476
            ],
            "DSToken": [
                1102
            ],
            "DSTokenBase": [
                763
            ],
            "ERC20": [
                583
            ]
        }
    },
    "children": [
        {
            "attributes": {
                "literals": [
                    "solidity",
                    "^",
                    "0.4",
                    ".15"
                ]
            },
            "id": 1,
            "name": "PragmaDirective",
            "src": "63:24:0"
        },
        {
            "attributes": {
                "baseContracts": [
                    null
                ],
                "contractDependencies": [
                    null
                ],
                "contractKind": "contract",
                "documentation": "/// lib/ds-roles/lib/ds-auth/src/auth.sol\r",
                "fullyImplemented": false,
                "linearizedBaseContracts": [
                    13
                ],
                "name": "DSAuthority",
                "scope": 1103
            },
            "children": [
                {
                    "attributes": {
                        "body": null,
                        "constant": true,
                        "implemented": false,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "canCall",
                        "payable": false,
                        "scope": 13,
                        "stateMutability": "view",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "src",
                                        "scope": 12,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 2,
                                            "name": "ElementaryTypeName",
                                            "src": "882:7:0"
                                        }
                                    ],
                                    "id": 3,
                                    "name": "VariableDeclaration",
                                    "src": "882:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "dst",
                                        "scope": 12,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 4,
                                            "name": "ElementaryTypeName",
                                            "src": "895:7:0"
                                        }
                                    ],
                                    "id": 5,
                                    "name": "VariableDeclaration",
                                    "src": "895:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "sig",
                                        "scope": 12,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bytes4",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bytes4",
                                                "type": "bytes4"
                                            },
                                            "id": 6,
                                            "name": "ElementaryTypeName",
                                            "src": "908:6:0"
                                        }
                                    ],
                                    "id": 7,
                                    "name": "VariableDeclaration",
                                    "src": "908:10:0"
                                }
                            ],
                            "id": 8,
                            "name": "ParameterList",
                            "src": "871:54:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 12,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 9,
                                            "name": "ElementaryTypeName",
                                            "src": "947:4:0"
                                        }
                                    ],
                                    "id": 10,
                                    "name": "VariableDeclaration",
                                    "src": "947:4:0"
                                }
                            ],
                            "id": 11,
                            "name": "ParameterList",
                            "src": "946:6:0"
                        }
                    ],
                    "id": 12,
                    "name": "FunctionDefinition",
                    "src": "855:98:0"
                }
            ],
            "id": 13,
            "name": "ContractDefinition",
            "src": "827:129:0"
        },
        {
            "attributes": {
                "baseContracts": [
                    null
                ],
                "contractDependencies": [
                    null
                ],
                "contractKind": "contract",
                "documentation": null,
                "fullyImplemented": true,
                "linearizedBaseContracts": [
                    22
                ],
                "name": "DSAuthEvents",
                "scope": 1103
            },
            "children": [
                {
                    "attributes": {
                        "anonymous": false,
                        "name": "LogSetAuthority"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "authority",
                                        "scope": 17,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 14,
                                            "name": "ElementaryTypeName",
                                            "src": "1012:7:0"
                                        }
                                    ],
                                    "id": 15,
                                    "name": "VariableDeclaration",
                                    "src": "1012:25:0"
                                }
                            ],
                            "id": 16,
                            "name": "ParameterList",
                            "src": "1011:27:0"
                        }
                    ],
                    "id": 17,
                    "name": "EventDefinition",
                    "src": "989:50:0"
                },
                {
                    "attributes": {
                        "anonymous": false,
                        "name": "LogSetOwner"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "owner",
                                        "scope": 21,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 18,
                                            "name": "ElementaryTypeName",
                                            "src": "1068:7:0"
                                        }
                                    ],
                                    "id": 19,
                                    "name": "VariableDeclaration",
                                    "src": "1068:21:0"
                                }
                            ],
                            "id": 20,
                            "name": "ParameterList",
                            "src": "1067:23:0"
                        }
                    ],
                    "id": 21,
                    "name": "EventDefinition",
                    "src": "1045:46:0"
                }
            ],
            "id": 22,
            "name": "ContractDefinition",
            "src": "960:134:0"
        },
        {
            "attributes": {
                "contractDependencies": [
                    22
                ],
                "contractKind": "contract",
                "documentation": null,
                "fullyImplemented": true,
                "linearizedBaseContracts": [
                    131,
                    22
                ],
                "name": "DSAuth",
                "scope": 1103
            },
            "children": [
                {
                    "attributes": {
                        "arguments": [
                            null
                        ]
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSAuthEvents",
                                "referencedDeclaration": 22,
                                "type": "contract DSAuthEvents"
                            },
                            "id": 23,
                            "name": "UserDefinedTypeName",
                            "src": "1117:12:0"
                        }
                    ],
                    "id": 24,
                    "name": "InheritanceSpecifier",
                    "src": "1117:12:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "name": "authority",
                        "scope": 131,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "contract DSAuthority",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSAuthority",
                                "referencedDeclaration": 13,
                                "type": "contract DSAuthority"
                            },
                            "id": 25,
                            "name": "UserDefinedTypeName",
                            "src": "1137:11:0"
                        }
                    ],
                    "id": 26,
                    "name": "VariableDeclaration",
                    "src": "1137:30:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "name": "owner",
                        "scope": 131,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "address",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "name": "address",
                                "type": "address"
                            },
                            "id": 27,
                            "name": "ElementaryTypeName",
                            "src": "1174:7:0"
                        }
                    ],
                    "id": 28,
                    "name": "VariableDeclaration",
                    "src": "1174:26:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": true,
                        "modifiers": [
                            null
                        ],
                        "name": "DSAuth",
                        "payable": false,
                        "scope": 131,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 29,
                            "name": "ParameterList",
                            "src": "1224:2:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 30,
                            "name": "ParameterList",
                            "src": "1234:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "address"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 28,
                                                        "type": "address",
                                                        "value": "owner"
                                                    },
                                                    "id": 31,
                                                    "name": "Identifier",
                                                    "src": "1245:5:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 32,
                                                            "name": "Identifier",
                                                            "src": "1253:3:0"
                                                        }
                                                    ],
                                                    "id": 33,
                                                    "name": "MemberAccess",
                                                    "src": "1253:10:0"
                                                }
                                            ],
                                            "id": 34,
                                            "name": "Assignment",
                                            "src": "1245:18:0"
                                        }
                                    ],
                                    "id": 35,
                                    "name": "ExpressionStatement",
                                    "src": "1245:18:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 21,
                                                        "type": "function (address)",
                                                        "value": "LogSetOwner"
                                                    },
                                                    "id": 36,
                                                    "name": "Identifier",
                                                    "src": "1274:11:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 37,
                                                            "name": "Identifier",
                                                            "src": "1286:3:0"
                                                        }
                                                    ],
                                                    "id": 38,
                                                    "name": "MemberAccess",
                                                    "src": "1286:10:0"
                                                }
                                            ],
                                            "id": 39,
                                            "name": "FunctionCall",
                                            "src": "1274:23:0"
                                        }
                                    ],
                                    "id": 40,
                                    "name": "ExpressionStatement",
                                    "src": "1274:23:0"
                                }
                            ],
                            "id": 41,
                            "name": "Block",
                            "src": "1234:71:0"
                        }
                    ],
                    "id": 42,
                    "name": "FunctionDefinition",
                    "src": "1209:96:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "setOwner",
                        "payable": false,
                        "scope": 131,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "owner_",
                                        "scope": 58,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 43,
                                            "name": "ElementaryTypeName",
                                            "src": "1331:7:0"
                                        }
                                    ],
                                    "id": 44,
                                    "name": "VariableDeclaration",
                                    "src": "1331:14:0"
                                }
                            ],
                            "id": 45,
                            "name": "ParameterList",
                            "src": "1330:16:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 48,
                            "name": "ParameterList",
                            "src": "1382:0:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 87,
                                        "type": "modifier ()",
                                        "value": "auth"
                                    },
                                    "id": 46,
                                    "name": "Identifier",
                                    "src": "1372:4:0"
                                }
                            ],
                            "id": 47,
                            "name": "ModifierInvocation",
                            "src": "1372:4:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "address"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 28,
                                                        "type": "address",
                                                        "value": "owner"
                                                    },
                                                    "id": 49,
                                                    "name": "Identifier",
                                                    "src": "1393:5:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 44,
                                                        "type": "address",
                                                        "value": "owner_"
                                                    },
                                                    "id": 50,
                                                    "name": "Identifier",
                                                    "src": "1401:6:0"
                                                }
                                            ],
                                            "id": 51,
                                            "name": "Assignment",
                                            "src": "1393:14:0"
                                        }
                                    ],
                                    "id": 52,
                                    "name": "ExpressionStatement",
                                    "src": "1393:14:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 21,
                                                        "type": "function (address)",
                                                        "value": "LogSetOwner"
                                                    },
                                                    "id": 53,
                                                    "name": "Identifier",
                                                    "src": "1418:11:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 28,
                                                        "type": "address",
                                                        "value": "owner"
                                                    },
                                                    "id": 54,
                                                    "name": "Identifier",
                                                    "src": "1430:5:0"
                                                }
                                            ],
                                            "id": 55,
                                            "name": "FunctionCall",
                                            "src": "1418:18:0"
                                        }
                                    ],
                                    "id": 56,
                                    "name": "ExpressionStatement",
                                    "src": "1418:18:0"
                                }
                            ],
                            "id": 57,
                            "name": "Block",
                            "src": "1382:62:0"
                        }
                    ],
                    "id": 58,
                    "name": "FunctionDefinition",
                    "src": "1313:131:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "setAuthority",
                        "payable": false,
                        "scope": 131,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "authority_",
                                        "scope": 74,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "contract DSAuthority",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "contractScope": null,
                                                "name": "DSAuthority",
                                                "referencedDeclaration": 13,
                                                "type": "contract DSAuthority"
                                            },
                                            "id": 59,
                                            "name": "UserDefinedTypeName",
                                            "src": "1474:11:0"
                                        }
                                    ],
                                    "id": 60,
                                    "name": "VariableDeclaration",
                                    "src": "1474:22:0"
                                }
                            ],
                            "id": 61,
                            "name": "ParameterList",
                            "src": "1473:24:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 64,
                            "name": "ParameterList",
                            "src": "1533:0:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 87,
                                        "type": "modifier ()",
                                        "value": "auth"
                                    },
                                    "id": 62,
                                    "name": "Identifier",
                                    "src": "1523:4:0"
                                }
                            ],
                            "id": 63,
                            "name": "ModifierInvocation",
                            "src": "1523:4:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "contract DSAuthority"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 26,
                                                        "type": "contract DSAuthority",
                                                        "value": "authority"
                                                    },
                                                    "id": 65,
                                                    "name": "Identifier",
                                                    "src": "1544:9:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 60,
                                                        "type": "contract DSAuthority",
                                                        "value": "authority_"
                                                    },
                                                    "id": 66,
                                                    "name": "Identifier",
                                                    "src": "1556:10:0"
                                                }
                                            ],
                                            "id": 67,
                                            "name": "Assignment",
                                            "src": "1544:22:0"
                                        }
                                    ],
                                    "id": 68,
                                    "name": "ExpressionStatement",
                                    "src": "1544:22:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_contract$_DSAuthority_$13",
                                                                "typeString": "contract DSAuthority"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 17,
                                                        "type": "function (address)",
                                                        "value": "LogSetAuthority"
                                                    },
                                                    "id": 69,
                                                    "name": "Identifier",
                                                    "src": "1577:15:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 26,
                                                        "type": "contract DSAuthority",
                                                        "value": "authority"
                                                    },
                                                    "id": 70,
                                                    "name": "Identifier",
                                                    "src": "1593:9:0"
                                                }
                                            ],
                                            "id": 71,
                                            "name": "FunctionCall",
                                            "src": "1577:26:0"
                                        }
                                    ],
                                    "id": 72,
                                    "name": "ExpressionStatement",
                                    "src": "1577:26:0"
                                }
                            ],
                            "id": 73,
                            "name": "Block",
                            "src": "1533:78:0"
                        }
                    ],
                    "id": 74,
                    "name": "FunctionDefinition",
                    "src": "1452:159:0"
                },
                {
                    "attributes": {
                        "name": "auth",
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 75,
                            "name": "ParameterList",
                            "src": "1633:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_bool",
                                                                "typeString": "bool"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 1117,
                                                        "type": "function (bool) pure",
                                                        "value": "require"
                                                    },
                                                    "id": 76,
                                                    "name": "Identifier",
                                                    "src": "1644:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "bool",
                                                        "type_conversion": false
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_address",
                                                                        "typeString": "address"
                                                                    },
                                                                    {
                                                                        "typeIdentifier": "t_bytes4",
                                                                        "typeString": "bytes4"
                                                                    }
                                                                ],
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 130,
                                                                "type": "function (address,bytes4) view returns (bool)",
                                                                "value": "isAuthorized"
                                                            },
                                                            "id": 77,
                                                            "name": "Identifier",
                                                            "src": "1652:12:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "member_name": "sender",
                                                                "referencedDeclaration": null,
                                                                "type": "address"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 1114,
                                                                        "type": "msg",
                                                                        "value": "msg"
                                                                    },
                                                                    "id": 78,
                                                                    "name": "Identifier",
                                                                    "src": "1665:3:0"
                                                                }
                                                            ],
                                                            "id": 79,
                                                            "name": "MemberAccess",
                                                            "src": "1665:10:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "member_name": "sig",
                                                                "referencedDeclaration": null,
                                                                "type": "bytes4"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 1114,
                                                                        "type": "msg",
                                                                        "value": "msg"
                                                                    },
                                                                    "id": 80,
                                                                    "name": "Identifier",
                                                                    "src": "1677:3:0"
                                                                }
                                                            ],
                                                            "id": 81,
                                                            "name": "MemberAccess",
                                                            "src": "1677:7:0"
                                                        }
                                                    ],
                                                    "id": 82,
                                                    "name": "FunctionCall",
                                                    "src": "1652:33:0"
                                                }
                                            ],
                                            "id": 83,
                                            "name": "FunctionCall",
                                            "src": "1644:42:0"
                                        }
                                    ],
                                    "id": 84,
                                    "name": "ExpressionStatement",
                                    "src": "1644:42:0"
                                },
                                {
                                    "id": 85,
                                    "name": "PlaceholderStatement",
                                    "src": "1697:1:0"
                                }
                            ],
                            "id": 86,
                            "name": "Block",
                            "src": "1633:73:0"
                        }
                    ],
                    "id": 87,
                    "name": "ModifierDefinition",
                    "src": "1619:87:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "isAuthorized",
                        "payable": false,
                        "scope": 131,
                        "stateMutability": "view",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "src",
                                        "scope": 130,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 88,
                                            "name": "ElementaryTypeName",
                                            "src": "1736:7:0"
                                        }
                                    ],
                                    "id": 89,
                                    "name": "VariableDeclaration",
                                    "src": "1736:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "sig",
                                        "scope": 130,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bytes4",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bytes4",
                                                "type": "bytes4"
                                            },
                                            "id": 90,
                                            "name": "ElementaryTypeName",
                                            "src": "1749:6:0"
                                        }
                                    ],
                                    "id": 91,
                                    "name": "VariableDeclaration",
                                    "src": "1749:10:0"
                                }
                            ],
                            "id": 92,
                            "name": "ParameterList",
                            "src": "1735:25:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 130,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 93,
                                            "name": "ElementaryTypeName",
                                            "src": "1784:4:0"
                                        }
                                    ],
                                    "id": 94,
                                    "name": "VariableDeclaration",
                                    "src": "1784:4:0"
                                }
                            ],
                            "id": 95,
                            "name": "ParameterList",
                            "src": "1783:6:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "commonType": {
                                                    "typeIdentifier": "t_address",
                                                    "typeString": "address"
                                                },
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "==",
                                                "type": "bool"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 89,
                                                        "type": "address",
                                                        "value": "src"
                                                    },
                                                    "id": 96,
                                                    "name": "Identifier",
                                                    "src": "1805:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "address",
                                                        "type_conversion": true
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_contract$_DSAuth_$131",
                                                                        "typeString": "contract DSAuth"
                                                                    }
                                                                ],
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": true,
                                                                "lValueRequested": false,
                                                                "type": "type(address)",
                                                                "value": "address"
                                                            },
                                                            "id": 97,
                                                            "name": "ElementaryTypeNameExpression",
                                                            "src": "1812:7:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1129,
                                                                "type": "contract DSAuth",
                                                                "value": "this"
                                                            },
                                                            "id": 98,
                                                            "name": "Identifier",
                                                            "src": "1820:4:0"
                                                        }
                                                    ],
                                                    "id": 99,
                                                    "name": "FunctionCall",
                                                    "src": "1812:13:0"
                                                }
                                            ],
                                            "id": 100,
                                            "name": "BinaryOperation",
                                            "src": "1805:20:0"
                                        },
                                        {
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "functionReturnParameters": 95
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "hexvalue": "74727565",
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": true,
                                                                "lValueRequested": false,
                                                                "subdenomination": null,
                                                                "token": "bool",
                                                                "type": "bool",
                                                                "value": "true"
                                                            },
                                                            "id": 101,
                                                            "name": "Literal",
                                                            "src": "1849:4:0"
                                                        }
                                                    ],
                                                    "id": 102,
                                                    "name": "Return",
                                                    "src": "1842:11:0"
                                                }
                                            ],
                                            "id": 103,
                                            "name": "Block",
                                            "src": "1827:38:0"
                                        },
                                        {
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_address",
                                                            "typeString": "address"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "==",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 89,
                                                                "type": "address",
                                                                "value": "src"
                                                            },
                                                            "id": 104,
                                                            "name": "Identifier",
                                                            "src": "1875:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 28,
                                                                "type": "address",
                                                                "value": "owner"
                                                            },
                                                            "id": 105,
                                                            "name": "Identifier",
                                                            "src": "1882:5:0"
                                                        }
                                                    ],
                                                    "id": 106,
                                                    "name": "BinaryOperation",
                                                    "src": "1875:12:0"
                                                },
                                                {
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "functionReturnParameters": 95
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "hexvalue": "74727565",
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "subdenomination": null,
                                                                        "token": "bool",
                                                                        "type": "bool",
                                                                        "value": "true"
                                                                    },
                                                                    "id": 107,
                                                                    "name": "Literal",
                                                                    "src": "1911:4:0"
                                                                }
                                                            ],
                                                            "id": 108,
                                                            "name": "Return",
                                                            "src": "1904:11:0"
                                                        }
                                                    ],
                                                    "id": 109,
                                                    "name": "Block",
                                                    "src": "1889:38:0"
                                                },
                                                {
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "commonType": {
                                                                    "typeIdentifier": "t_contract$_DSAuthority_$13",
                                                                    "typeString": "contract DSAuthority"
                                                                },
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "operator": "==",
                                                                "type": "bool"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 26,
                                                                        "type": "contract DSAuthority",
                                                                        "value": "authority"
                                                                    },
                                                                    "id": 110,
                                                                    "name": "Identifier",
                                                                    "src": "1937:9:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "isStructConstructorCall": false,
                                                                        "lValueRequested": false,
                                                                        "names": [
                                                                            null
                                                                        ],
                                                                        "type": "contract DSAuthority",
                                                                        "type_conversion": true
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": [
                                                                                    {
                                                                                        "typeIdentifier": "t_rational_0_by_1",
                                                                                        "typeString": "int_const 0"
                                                                                    }
                                                                                ],
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 13,
                                                                                "type": "type(contract DSAuthority)",
                                                                                "value": "DSAuthority"
                                                                            },
                                                                            "id": 111,
                                                                            "name": "Identifier",
                                                                            "src": "1950:11:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "30",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "number",
                                                                                "type": "int_const 0",
                                                                                "value": "0"
                                                                            },
                                                                            "id": 112,
                                                                            "name": "Literal",
                                                                            "src": "1962:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 113,
                                                                    "name": "FunctionCall",
                                                                    "src": "1950:14:0"
                                                                }
                                                            ],
                                                            "id": 114,
                                                            "name": "BinaryOperation",
                                                            "src": "1937:27:0"
                                                        },
                                                        {
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "functionReturnParameters": 95
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "66616c7365",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "bool",
                                                                                "type": "bool",
                                                                                "value": "false"
                                                                            },
                                                                            "id": 115,
                                                                            "name": "Literal",
                                                                            "src": "1988:5:0"
                                                                        }
                                                                    ],
                                                                    "id": 116,
                                                                    "name": "Return",
                                                                    "src": "1981:12:0"
                                                                }
                                                            ],
                                                            "id": 117,
                                                            "name": "Block",
                                                            "src": "1966:39:0"
                                                        },
                                                        {
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "functionReturnParameters": 95
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": false,
                                                                                "isStructConstructorCall": false,
                                                                                "lValueRequested": false,
                                                                                "names": [
                                                                                    null
                                                                                ],
                                                                                "type": "bool",
                                                                                "type_conversion": false
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": [
                                                                                            {
                                                                                                "typeIdentifier": "t_address",
                                                                                                "typeString": "address"
                                                                                            },
                                                                                            {
                                                                                                "typeIdentifier": "t_contract$_DSAuth_$131",
                                                                                                "typeString": "contract DSAuth"
                                                                                            },
                                                                                            {
                                                                                                "typeIdentifier": "t_bytes4",
                                                                                                "typeString": "bytes4"
                                                                                            }
                                                                                        ],
                                                                                        "isConstant": false,
                                                                                        "isLValue": false,
                                                                                        "isPure": false,
                                                                                        "lValueRequested": false,
                                                                                        "member_name": "canCall",
                                                                                        "referencedDeclaration": 12,
                                                                                        "type": "function (address,address,bytes4) view external returns (bool)"
                                                                                    },
                                                                                    "children": [
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 26,
                                                                                                "type": "contract DSAuthority",
                                                                                                "value": "authority"
                                                                                            },
                                                                                            "id": 118,
                                                                                            "name": "Identifier",
                                                                                            "src": "2033:9:0"
                                                                                        }
                                                                                    ],
                                                                                    "id": 119,
                                                                                    "name": "MemberAccess",
                                                                                    "src": "2033:17:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 89,
                                                                                        "type": "address",
                                                                                        "value": "src"
                                                                                    },
                                                                                    "id": 120,
                                                                                    "name": "Identifier",
                                                                                    "src": "2051:3:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 1129,
                                                                                        "type": "contract DSAuth",
                                                                                        "value": "this"
                                                                                    },
                                                                                    "id": 121,
                                                                                    "name": "Identifier",
                                                                                    "src": "2056:4:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 91,
                                                                                        "type": "bytes4",
                                                                                        "value": "sig"
                                                                                    },
                                                                                    "id": 122,
                                                                                    "name": "Identifier",
                                                                                    "src": "2062:3:0"
                                                                                }
                                                                            ],
                                                                            "id": 123,
                                                                            "name": "FunctionCall",
                                                                            "src": "2033:33:0"
                                                                        }
                                                                    ],
                                                                    "id": 124,
                                                                    "name": "Return",
                                                                    "src": "2026:40:0"
                                                                }
                                                            ],
                                                            "id": 125,
                                                            "name": "Block",
                                                            "src": "2011:67:0"
                                                        }
                                                    ],
                                                    "id": 126,
                                                    "name": "IfStatement",
                                                    "src": "1933:145:0"
                                                }
                                            ],
                                            "id": 127,
                                            "name": "IfStatement",
                                            "src": "1871:207:0"
                                        }
                                    ],
                                    "id": 128,
                                    "name": "IfStatement",
                                    "src": "1801:277:0"
                                }
                            ],
                            "id": 129,
                            "name": "Block",
                            "src": "1790:295:0"
                        }
                    ],
                    "id": 130,
                    "name": "FunctionDefinition",
                    "src": "1714:371:0"
                }
            ],
            "id": 131,
            "name": "ContractDefinition",
            "src": "1098:990:0"
        },
        {
            "attributes": {
                "baseContracts": [
                    null
                ],
                "contractDependencies": [
                    null
                ],
                "contractKind": "contract",
                "documentation": "/// lib/ds-thing/lib/ds-math/src/math.sol\r\n math.sol -- mixin for inline numerical wizardry\r",
                "fullyImplemented": true,
                "linearizedBaseContracts": [
                    430
                ],
                "name": "DSMath",
                "scope": 1103
            },
            "children": [
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "add",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 152,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 132,
                                            "name": "ElementaryTypeName",
                                            "src": "2919:4:0"
                                        }
                                    ],
                                    "id": 133,
                                    "name": "VariableDeclaration",
                                    "src": "2919:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 152,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 134,
                                            "name": "ElementaryTypeName",
                                            "src": "2927:4:0"
                                        }
                                    ],
                                    "id": 135,
                                    "name": "VariableDeclaration",
                                    "src": "2927:6:0"
                                }
                            ],
                            "id": 136,
                            "name": "ParameterList",
                            "src": "2918:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 152,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 137,
                                            "name": "ElementaryTypeName",
                                            "src": "2958:4:0"
                                        }
                                    ],
                                    "id": 138,
                                    "name": "VariableDeclaration",
                                    "src": "2958:6:0"
                                }
                            ],
                            "id": 139,
                            "name": "ParameterList",
                            "src": "2957:8:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_bool",
                                                                "typeString": "bool"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 1117,
                                                        "type": "function (bool) pure",
                                                        "value": "require"
                                                    },
                                                    "id": 140,
                                                    "name": "Identifier",
                                                    "src": "2977:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": ">=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isInlineArray": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "operator": "=",
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 138,
                                                                                "type": "uint256",
                                                                                "value": "z"
                                                                            },
                                                                            "id": 141,
                                                                            "name": "Identifier",
                                                                            "src": "2986:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "commonType": {
                                                                                    "typeIdentifier": "t_uint256",
                                                                                    "typeString": "uint256"
                                                                                },
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "operator": "+",
                                                                                "type": "uint256"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 133,
                                                                                        "type": "uint256",
                                                                                        "value": "x"
                                                                                    },
                                                                                    "id": 142,
                                                                                    "name": "Identifier",
                                                                                    "src": "2990:1:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 135,
                                                                                        "type": "uint256",
                                                                                        "value": "y"
                                                                                    },
                                                                                    "id": 143,
                                                                                    "name": "Identifier",
                                                                                    "src": "2994:1:0"
                                                                                }
                                                                            ],
                                                                            "id": 144,
                                                                            "name": "BinaryOperation",
                                                                            "src": "2990:5:0"
                                                                        }
                                                                    ],
                                                                    "id": 145,
                                                                    "name": "Assignment",
                                                                    "src": "2986:9:0"
                                                                }
                                                            ],
                                                            "id": 146,
                                                            "name": "TupleExpression",
                                                            "src": "2985:11:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 133,
                                                                "type": "uint256",
                                                                "value": "x"
                                                            },
                                                            "id": 147,
                                                            "name": "Identifier",
                                                            "src": "3000:1:0"
                                                        }
                                                    ],
                                                    "id": 148,
                                                    "name": "BinaryOperation",
                                                    "src": "2985:16:0"
                                                }
                                            ],
                                            "id": 149,
                                            "name": "FunctionCall",
                                            "src": "2977:25:0"
                                        }
                                    ],
                                    "id": 150,
                                    "name": "ExpressionStatement",
                                    "src": "2977:25:0"
                                }
                            ],
                            "id": 151,
                            "name": "Block",
                            "src": "2966:44:0"
                        }
                    ],
                    "id": 152,
                    "name": "FunctionDefinition",
                    "src": "2906:104:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "sub",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 173,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 153,
                                            "name": "ElementaryTypeName",
                                            "src": "3029:4:0"
                                        }
                                    ],
                                    "id": 154,
                                    "name": "VariableDeclaration",
                                    "src": "3029:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 173,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 155,
                                            "name": "ElementaryTypeName",
                                            "src": "3037:4:0"
                                        }
                                    ],
                                    "id": 156,
                                    "name": "VariableDeclaration",
                                    "src": "3037:6:0"
                                }
                            ],
                            "id": 157,
                            "name": "ParameterList",
                            "src": "3028:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 173,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 158,
                                            "name": "ElementaryTypeName",
                                            "src": "3068:4:0"
                                        }
                                    ],
                                    "id": 159,
                                    "name": "VariableDeclaration",
                                    "src": "3068:6:0"
                                }
                            ],
                            "id": 160,
                            "name": "ParameterList",
                            "src": "3067:8:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_bool",
                                                                "typeString": "bool"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 1117,
                                                        "type": "function (bool) pure",
                                                        "value": "require"
                                                    },
                                                    "id": 161,
                                                    "name": "Identifier",
                                                    "src": "3087:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "<=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isInlineArray": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "operator": "=",
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 159,
                                                                                "type": "uint256",
                                                                                "value": "z"
                                                                            },
                                                                            "id": 162,
                                                                            "name": "Identifier",
                                                                            "src": "3096:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "commonType": {
                                                                                    "typeIdentifier": "t_uint256",
                                                                                    "typeString": "uint256"
                                                                                },
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "operator": "-",
                                                                                "type": "uint256"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 154,
                                                                                        "type": "uint256",
                                                                                        "value": "x"
                                                                                    },
                                                                                    "id": 163,
                                                                                    "name": "Identifier",
                                                                                    "src": "3100:1:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 156,
                                                                                        "type": "uint256",
                                                                                        "value": "y"
                                                                                    },
                                                                                    "id": 164,
                                                                                    "name": "Identifier",
                                                                                    "src": "3104:1:0"
                                                                                }
                                                                            ],
                                                                            "id": 165,
                                                                            "name": "BinaryOperation",
                                                                            "src": "3100:5:0"
                                                                        }
                                                                    ],
                                                                    "id": 166,
                                                                    "name": "Assignment",
                                                                    "src": "3096:9:0"
                                                                }
                                                            ],
                                                            "id": 167,
                                                            "name": "TupleExpression",
                                                            "src": "3095:11:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 154,
                                                                "type": "uint256",
                                                                "value": "x"
                                                            },
                                                            "id": 168,
                                                            "name": "Identifier",
                                                            "src": "3110:1:0"
                                                        }
                                                    ],
                                                    "id": 169,
                                                    "name": "BinaryOperation",
                                                    "src": "3095:16:0"
                                                }
                                            ],
                                            "id": 170,
                                            "name": "FunctionCall",
                                            "src": "3087:25:0"
                                        }
                                    ],
                                    "id": 171,
                                    "name": "ExpressionStatement",
                                    "src": "3087:25:0"
                                }
                            ],
                            "id": 172,
                            "name": "Block",
                            "src": "3076:44:0"
                        }
                    ],
                    "id": 173,
                    "name": "FunctionDefinition",
                    "src": "3016:104:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "mul",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 200,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 174,
                                            "name": "ElementaryTypeName",
                                            "src": "3139:4:0"
                                        }
                                    ],
                                    "id": 175,
                                    "name": "VariableDeclaration",
                                    "src": "3139:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 200,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 176,
                                            "name": "ElementaryTypeName",
                                            "src": "3147:4:0"
                                        }
                                    ],
                                    "id": 177,
                                    "name": "VariableDeclaration",
                                    "src": "3147:6:0"
                                }
                            ],
                            "id": 178,
                            "name": "ParameterList",
                            "src": "3138:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 200,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 179,
                                            "name": "ElementaryTypeName",
                                            "src": "3178:4:0"
                                        }
                                    ],
                                    "id": 180,
                                    "name": "VariableDeclaration",
                                    "src": "3178:6:0"
                                }
                            ],
                            "id": 181,
                            "name": "ParameterList",
                            "src": "3177:8:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_bool",
                                                                "typeString": "bool"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 1117,
                                                        "type": "function (bool) pure",
                                                        "value": "require"
                                                    },
                                                    "id": 182,
                                                    "name": "Identifier",
                                                    "src": "3197:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_bool",
                                                            "typeString": "bool"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "||",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "commonType": {
                                                                    "typeIdentifier": "t_uint256",
                                                                    "typeString": "uint256"
                                                                },
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "operator": "==",
                                                                "type": "bool"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 177,
                                                                        "type": "uint256",
                                                                        "value": "y"
                                                                    },
                                                                    "id": 183,
                                                                    "name": "Identifier",
                                                                    "src": "3205:1:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "hexvalue": "30",
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "subdenomination": null,
                                                                        "token": "number",
                                                                        "type": "int_const 0",
                                                                        "value": "0"
                                                                    },
                                                                    "id": 184,
                                                                    "name": "Literal",
                                                                    "src": "3210:1:0"
                                                                }
                                                            ],
                                                            "id": 185,
                                                            "name": "BinaryOperation",
                                                            "src": "3205:6:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "commonType": {
                                                                    "typeIdentifier": "t_uint256",
                                                                    "typeString": "uint256"
                                                                },
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "operator": "==",
                                                                "type": "bool"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "commonType": {
                                                                            "typeIdentifier": "t_uint256",
                                                                            "typeString": "uint256"
                                                                        },
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "operator": "/",
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isInlineArray": false,
                                                                                "isLValue": false,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "type": "uint256"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "isConstant": false,
                                                                                        "isLValue": false,
                                                                                        "isPure": false,
                                                                                        "lValueRequested": false,
                                                                                        "operator": "=",
                                                                                        "type": "uint256"
                                                                                    },
                                                                                    "children": [
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 180,
                                                                                                "type": "uint256",
                                                                                                "value": "z"
                                                                                            },
                                                                                            "id": 186,
                                                                                            "name": "Identifier",
                                                                                            "src": "3216:1:0"
                                                                                        },
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "commonType": {
                                                                                                    "typeIdentifier": "t_uint256",
                                                                                                    "typeString": "uint256"
                                                                                                },
                                                                                                "isConstant": false,
                                                                                                "isLValue": false,
                                                                                                "isPure": false,
                                                                                                "lValueRequested": false,
                                                                                                "operator": "*",
                                                                                                "type": "uint256"
                                                                                            },
                                                                                            "children": [
                                                                                                {
                                                                                                    "attributes": {
                                                                                                        "argumentTypes": null,
                                                                                                        "overloadedDeclarations": [
                                                                                                            null
                                                                                                        ],
                                                                                                        "referencedDeclaration": 175,
                                                                                                        "type": "uint256",
                                                                                                        "value": "x"
                                                                                                    },
                                                                                                    "id": 187,
                                                                                                    "name": "Identifier",
                                                                                                    "src": "3220:1:0"
                                                                                                },
                                                                                                {
                                                                                                    "attributes": {
                                                                                                        "argumentTypes": null,
                                                                                                        "overloadedDeclarations": [
                                                                                                            null
                                                                                                        ],
                                                                                                        "referencedDeclaration": 177,
                                                                                                        "type": "uint256",
                                                                                                        "value": "y"
                                                                                                    },
                                                                                                    "id": 188,
                                                                                                    "name": "Identifier",
                                                                                                    "src": "3224:1:0"
                                                                                                }
                                                                                            ],
                                                                                            "id": 189,
                                                                                            "name": "BinaryOperation",
                                                                                            "src": "3220:5:0"
                                                                                        }
                                                                                    ],
                                                                                    "id": 190,
                                                                                    "name": "Assignment",
                                                                                    "src": "3216:9:0"
                                                                                }
                                                                            ],
                                                                            "id": 191,
                                                                            "name": "TupleExpression",
                                                                            "src": "3215:11:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 177,
                                                                                "type": "uint256",
                                                                                "value": "y"
                                                                            },
                                                                            "id": 192,
                                                                            "name": "Identifier",
                                                                            "src": "3229:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 193,
                                                                    "name": "BinaryOperation",
                                                                    "src": "3215:15:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 175,
                                                                        "type": "uint256",
                                                                        "value": "x"
                                                                    },
                                                                    "id": 194,
                                                                    "name": "Identifier",
                                                                    "src": "3234:1:0"
                                                                }
                                                            ],
                                                            "id": 195,
                                                            "name": "BinaryOperation",
                                                            "src": "3215:20:0"
                                                        }
                                                    ],
                                                    "id": 196,
                                                    "name": "BinaryOperation",
                                                    "src": "3205:30:0"
                                                }
                                            ],
                                            "id": 197,
                                            "name": "FunctionCall",
                                            "src": "3197:39:0"
                                        }
                                    ],
                                    "id": 198,
                                    "name": "ExpressionStatement",
                                    "src": "3197:39:0"
                                }
                            ],
                            "id": 199,
                            "name": "Block",
                            "src": "3186:58:0"
                        }
                    ],
                    "id": 200,
                    "name": "FunctionDefinition",
                    "src": "3126:118:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "min",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 217,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 201,
                                            "name": "ElementaryTypeName",
                                            "src": "3265:4:0"
                                        }
                                    ],
                                    "id": 202,
                                    "name": "VariableDeclaration",
                                    "src": "3265:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 217,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 203,
                                            "name": "ElementaryTypeName",
                                            "src": "3273:4:0"
                                        }
                                    ],
                                    "id": 204,
                                    "name": "VariableDeclaration",
                                    "src": "3273:6:0"
                                }
                            ],
                            "id": 205,
                            "name": "ParameterList",
                            "src": "3264:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 217,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 206,
                                            "name": "ElementaryTypeName",
                                            "src": "3304:4:0"
                                        }
                                    ],
                                    "id": 207,
                                    "name": "VariableDeclaration",
                                    "src": "3304:6:0"
                                }
                            ],
                            "id": 208,
                            "name": "ParameterList",
                            "src": "3303:8:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 208
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "<=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 202,
                                                                "type": "uint256",
                                                                "value": "x"
                                                            },
                                                            "id": 209,
                                                            "name": "Identifier",
                                                            "src": "3330:1:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 204,
                                                                "type": "uint256",
                                                                "value": "y"
                                                            },
                                                            "id": 210,
                                                            "name": "Identifier",
                                                            "src": "3335:1:0"
                                                        }
                                                    ],
                                                    "id": 211,
                                                    "name": "BinaryOperation",
                                                    "src": "3330:6:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 202,
                                                        "type": "uint256",
                                                        "value": "x"
                                                    },
                                                    "id": 212,
                                                    "name": "Identifier",
                                                    "src": "3339:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 204,
                                                        "type": "uint256",
                                                        "value": "y"
                                                    },
                                                    "id": 213,
                                                    "name": "Identifier",
                                                    "src": "3343:1:0"
                                                }
                                            ],
                                            "id": 214,
                                            "name": "Conditional",
                                            "src": "3330:14:0"
                                        }
                                    ],
                                    "id": 215,
                                    "name": "Return",
                                    "src": "3323:21:0"
                                }
                            ],
                            "id": 216,
                            "name": "Block",
                            "src": "3312:40:0"
                        }
                    ],
                    "id": 217,
                    "name": "FunctionDefinition",
                    "src": "3252:100:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "max",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 234,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 218,
                                            "name": "ElementaryTypeName",
                                            "src": "3371:4:0"
                                        }
                                    ],
                                    "id": 219,
                                    "name": "VariableDeclaration",
                                    "src": "3371:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 234,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 220,
                                            "name": "ElementaryTypeName",
                                            "src": "3379:4:0"
                                        }
                                    ],
                                    "id": 221,
                                    "name": "VariableDeclaration",
                                    "src": "3379:6:0"
                                }
                            ],
                            "id": 222,
                            "name": "ParameterList",
                            "src": "3370:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 234,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 223,
                                            "name": "ElementaryTypeName",
                                            "src": "3410:4:0"
                                        }
                                    ],
                                    "id": 224,
                                    "name": "VariableDeclaration",
                                    "src": "3410:6:0"
                                }
                            ],
                            "id": 225,
                            "name": "ParameterList",
                            "src": "3409:8:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 225
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": ">=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 219,
                                                                "type": "uint256",
                                                                "value": "x"
                                                            },
                                                            "id": 226,
                                                            "name": "Identifier",
                                                            "src": "3436:1:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 221,
                                                                "type": "uint256",
                                                                "value": "y"
                                                            },
                                                            "id": 227,
                                                            "name": "Identifier",
                                                            "src": "3441:1:0"
                                                        }
                                                    ],
                                                    "id": 228,
                                                    "name": "BinaryOperation",
                                                    "src": "3436:6:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 219,
                                                        "type": "uint256",
                                                        "value": "x"
                                                    },
                                                    "id": 229,
                                                    "name": "Identifier",
                                                    "src": "3445:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 221,
                                                        "type": "uint256",
                                                        "value": "y"
                                                    },
                                                    "id": 230,
                                                    "name": "Identifier",
                                                    "src": "3449:1:0"
                                                }
                                            ],
                                            "id": 231,
                                            "name": "Conditional",
                                            "src": "3436:14:0"
                                        }
                                    ],
                                    "id": 232,
                                    "name": "Return",
                                    "src": "3429:21:0"
                                }
                            ],
                            "id": 233,
                            "name": "Block",
                            "src": "3418:40:0"
                        }
                    ],
                    "id": 234,
                    "name": "FunctionDefinition",
                    "src": "3358:100:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "imin",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 251,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "int256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "int",
                                                "type": "int256"
                                            },
                                            "id": 235,
                                            "name": "ElementaryTypeName",
                                            "src": "3478:3:0"
                                        }
                                    ],
                                    "id": 236,
                                    "name": "VariableDeclaration",
                                    "src": "3478:5:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 251,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "int256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "int",
                                                "type": "int256"
                                            },
                                            "id": 237,
                                            "name": "ElementaryTypeName",
                                            "src": "3485:3:0"
                                        }
                                    ],
                                    "id": 238,
                                    "name": "VariableDeclaration",
                                    "src": "3485:5:0"
                                }
                            ],
                            "id": 239,
                            "name": "ParameterList",
                            "src": "3477:14:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 251,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "int256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "int",
                                                "type": "int256"
                                            },
                                            "id": 240,
                                            "name": "ElementaryTypeName",
                                            "src": "3515:3:0"
                                        }
                                    ],
                                    "id": 241,
                                    "name": "VariableDeclaration",
                                    "src": "3515:5:0"
                                }
                            ],
                            "id": 242,
                            "name": "ParameterList",
                            "src": "3514:7:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 242
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "type": "int256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_int256",
                                                            "typeString": "int256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "<=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 236,
                                                                "type": "int256",
                                                                "value": "x"
                                                            },
                                                            "id": 243,
                                                            "name": "Identifier",
                                                            "src": "3540:1:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 238,
                                                                "type": "int256",
                                                                "value": "y"
                                                            },
                                                            "id": 244,
                                                            "name": "Identifier",
                                                            "src": "3545:1:0"
                                                        }
                                                    ],
                                                    "id": 245,
                                                    "name": "BinaryOperation",
                                                    "src": "3540:6:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 236,
                                                        "type": "int256",
                                                        "value": "x"
                                                    },
                                                    "id": 246,
                                                    "name": "Identifier",
                                                    "src": "3549:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 238,
                                                        "type": "int256",
                                                        "value": "y"
                                                    },
                                                    "id": 247,
                                                    "name": "Identifier",
                                                    "src": "3553:1:0"
                                                }
                                            ],
                                            "id": 248,
                                            "name": "Conditional",
                                            "src": "3540:14:0"
                                        }
                                    ],
                                    "id": 249,
                                    "name": "Return",
                                    "src": "3533:21:0"
                                }
                            ],
                            "id": 250,
                            "name": "Block",
                            "src": "3522:40:0"
                        }
                    ],
                    "id": 251,
                    "name": "FunctionDefinition",
                    "src": "3464:98:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "imax",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 268,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "int256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "int",
                                                "type": "int256"
                                            },
                                            "id": 252,
                                            "name": "ElementaryTypeName",
                                            "src": "3582:3:0"
                                        }
                                    ],
                                    "id": 253,
                                    "name": "VariableDeclaration",
                                    "src": "3582:5:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 268,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "int256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "int",
                                                "type": "int256"
                                            },
                                            "id": 254,
                                            "name": "ElementaryTypeName",
                                            "src": "3589:3:0"
                                        }
                                    ],
                                    "id": 255,
                                    "name": "VariableDeclaration",
                                    "src": "3589:5:0"
                                }
                            ],
                            "id": 256,
                            "name": "ParameterList",
                            "src": "3581:14:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 268,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "int256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "int",
                                                "type": "int256"
                                            },
                                            "id": 257,
                                            "name": "ElementaryTypeName",
                                            "src": "3619:3:0"
                                        }
                                    ],
                                    "id": 258,
                                    "name": "VariableDeclaration",
                                    "src": "3619:5:0"
                                }
                            ],
                            "id": 259,
                            "name": "ParameterList",
                            "src": "3618:7:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 259
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "type": "int256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_int256",
                                                            "typeString": "int256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": ">=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 253,
                                                                "type": "int256",
                                                                "value": "x"
                                                            },
                                                            "id": 260,
                                                            "name": "Identifier",
                                                            "src": "3644:1:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 255,
                                                                "type": "int256",
                                                                "value": "y"
                                                            },
                                                            "id": 261,
                                                            "name": "Identifier",
                                                            "src": "3649:1:0"
                                                        }
                                                    ],
                                                    "id": 262,
                                                    "name": "BinaryOperation",
                                                    "src": "3644:6:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 253,
                                                        "type": "int256",
                                                        "value": "x"
                                                    },
                                                    "id": 263,
                                                    "name": "Identifier",
                                                    "src": "3653:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 255,
                                                        "type": "int256",
                                                        "value": "y"
                                                    },
                                                    "id": 264,
                                                    "name": "Identifier",
                                                    "src": "3657:1:0"
                                                }
                                            ],
                                            "id": 265,
                                            "name": "Conditional",
                                            "src": "3644:14:0"
                                        }
                                    ],
                                    "id": 266,
                                    "name": "Return",
                                    "src": "3637:21:0"
                                }
                            ],
                            "id": 267,
                            "name": "Block",
                            "src": "3626:40:0"
                        }
                    ],
                    "id": 268,
                    "name": "FunctionDefinition",
                    "src": "3568:98:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "name": "WAD",
                        "scope": 430,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "uint256",
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "attributes": {
                                "name": "uint",
                                "type": "uint256"
                            },
                            "id": 269,
                            "name": "ElementaryTypeName",
                            "src": "3674:4:0"
                        },
                        {
                            "attributes": {
                                "argumentTypes": null,
                                "commonType": {
                                    "typeIdentifier": "t_rational_1000000000000000000_by_1",
                                    "typeString": "int_const 1000000000000000000"
                                },
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": true,
                                "lValueRequested": false,
                                "operator": "**",
                                "type": "int_const 1000000000000000000"
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "hexvalue": "3130",
                                        "isConstant": false,
                                        "isLValue": false,
                                        "isPure": true,
                                        "lValueRequested": false,
                                        "subdenomination": null,
                                        "token": "number",
                                        "type": "int_const 10",
                                        "value": "10"
                                    },
                                    "id": 270,
                                    "name": "Literal",
                                    "src": "3694:2:0"
                                },
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "hexvalue": "3138",
                                        "isConstant": false,
                                        "isLValue": false,
                                        "isPure": true,
                                        "lValueRequested": false,
                                        "subdenomination": null,
                                        "token": "number",
                                        "type": "int_const 18",
                                        "value": "18"
                                    },
                                    "id": 271,
                                    "name": "Literal",
                                    "src": "3700:2:0"
                                }
                            ],
                            "id": 272,
                            "name": "BinaryOperation",
                            "src": "3694:8:0"
                        }
                    ],
                    "id": 273,
                    "name": "VariableDeclaration",
                    "src": "3674:28:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "name": "RAY",
                        "scope": 430,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "uint256",
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "attributes": {
                                "name": "uint",
                                "type": "uint256"
                            },
                            "id": 274,
                            "name": "ElementaryTypeName",
                            "src": "3709:4:0"
                        },
                        {
                            "attributes": {
                                "argumentTypes": null,
                                "commonType": {
                                    "typeIdentifier": "t_rational_1000000000000000000000000000_by_1",
                                    "typeString": "int_const 1000000000000000000000000000"
                                },
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": true,
                                "lValueRequested": false,
                                "operator": "**",
                                "type": "int_const 1000000000000000000000000000"
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "hexvalue": "3130",
                                        "isConstant": false,
                                        "isLValue": false,
                                        "isPure": true,
                                        "lValueRequested": false,
                                        "subdenomination": null,
                                        "token": "number",
                                        "type": "int_const 10",
                                        "value": "10"
                                    },
                                    "id": 275,
                                    "name": "Literal",
                                    "src": "3729:2:0"
                                },
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "hexvalue": "3237",
                                        "isConstant": false,
                                        "isLValue": false,
                                        "isPure": true,
                                        "lValueRequested": false,
                                        "subdenomination": null,
                                        "token": "number",
                                        "type": "int_const 27",
                                        "value": "27"
                                    },
                                    "id": 276,
                                    "name": "Literal",
                                    "src": "3735:2:0"
                                }
                            ],
                            "id": 277,
                            "name": "BinaryOperation",
                            "src": "3729:8:0"
                        }
                    ],
                    "id": 278,
                    "name": "VariableDeclaration",
                    "src": "3709:28:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "wmul",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 302,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 279,
                                            "name": "ElementaryTypeName",
                                            "src": "3760:4:0"
                                        }
                                    ],
                                    "id": 280,
                                    "name": "VariableDeclaration",
                                    "src": "3760:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 302,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 281,
                                            "name": "ElementaryTypeName",
                                            "src": "3768:4:0"
                                        }
                                    ],
                                    "id": 282,
                                    "name": "VariableDeclaration",
                                    "src": "3768:6:0"
                                }
                            ],
                            "id": 283,
                            "name": "ParameterList",
                            "src": "3759:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 302,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 284,
                                            "name": "ElementaryTypeName",
                                            "src": "3799:4:0"
                                        }
                                    ],
                                    "id": 285,
                                    "name": "VariableDeclaration",
                                    "src": "3799:6:0"
                                }
                            ],
                            "id": 286,
                            "name": "ParameterList",
                            "src": "3798:8:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 285,
                                                        "type": "uint256",
                                                        "value": "z"
                                                    },
                                                    "id": 287,
                                                    "name": "Identifier",
                                                    "src": "3818:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "/",
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "isStructConstructorCall": false,
                                                                "lValueRequested": false,
                                                                "names": [
                                                                    null
                                                                ],
                                                                "type": "uint256",
                                                                "type_conversion": false
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": [
                                                                            {
                                                                                "typeIdentifier": "t_uint256",
                                                                                "typeString": "uint256"
                                                                            },
                                                                            {
                                                                                "typeIdentifier": "t_uint256",
                                                                                "typeString": "uint256"
                                                                            }
                                                                        ],
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 152,
                                                                        "type": "function (uint256,uint256) pure returns (uint256)",
                                                                        "value": "add"
                                                                    },
                                                                    "id": 288,
                                                                    "name": "Identifier",
                                                                    "src": "3822:3:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "isStructConstructorCall": false,
                                                                        "lValueRequested": false,
                                                                        "names": [
                                                                            null
                                                                        ],
                                                                        "type": "uint256",
                                                                        "type_conversion": false
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": [
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    },
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    }
                                                                                ],
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 200,
                                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                                "value": "mul"
                                                                            },
                                                                            "id": 289,
                                                                            "name": "Identifier",
                                                                            "src": "3826:3:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 280,
                                                                                "type": "uint256",
                                                                                "value": "x"
                                                                            },
                                                                            "id": 290,
                                                                            "name": "Identifier",
                                                                            "src": "3830:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 282,
                                                                                "type": "uint256",
                                                                                "value": "y"
                                                                            },
                                                                            "id": 291,
                                                                            "name": "Identifier",
                                                                            "src": "3833:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 292,
                                                                    "name": "FunctionCall",
                                                                    "src": "3826:9:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "commonType": {
                                                                            "typeIdentifier": "t_uint256",
                                                                            "typeString": "uint256"
                                                                        },
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "operator": "/",
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 273,
                                                                                "type": "uint256",
                                                                                "value": "WAD"
                                                                            },
                                                                            "id": 293,
                                                                            "name": "Identifier",
                                                                            "src": "3837:3:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "32",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "number",
                                                                                "type": "int_const 2",
                                                                                "value": "2"
                                                                            },
                                                                            "id": 294,
                                                                            "name": "Literal",
                                                                            "src": "3843:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 295,
                                                                    "name": "BinaryOperation",
                                                                    "src": "3837:7:0"
                                                                }
                                                            ],
                                                            "id": 296,
                                                            "name": "FunctionCall",
                                                            "src": "3822:23:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 273,
                                                                "type": "uint256",
                                                                "value": "WAD"
                                                            },
                                                            "id": 297,
                                                            "name": "Identifier",
                                                            "src": "3848:3:0"
                                                        }
                                                    ],
                                                    "id": 298,
                                                    "name": "BinaryOperation",
                                                    "src": "3822:29:0"
                                                }
                                            ],
                                            "id": 299,
                                            "name": "Assignment",
                                            "src": "3818:33:0"
                                        }
                                    ],
                                    "id": 300,
                                    "name": "ExpressionStatement",
                                    "src": "3818:33:0"
                                }
                            ],
                            "id": 301,
                            "name": "Block",
                            "src": "3807:52:0"
                        }
                    ],
                    "id": 302,
                    "name": "FunctionDefinition",
                    "src": "3746:113:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "rmul",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 326,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 303,
                                            "name": "ElementaryTypeName",
                                            "src": "3879:4:0"
                                        }
                                    ],
                                    "id": 304,
                                    "name": "VariableDeclaration",
                                    "src": "3879:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 326,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 305,
                                            "name": "ElementaryTypeName",
                                            "src": "3887:4:0"
                                        }
                                    ],
                                    "id": 306,
                                    "name": "VariableDeclaration",
                                    "src": "3887:6:0"
                                }
                            ],
                            "id": 307,
                            "name": "ParameterList",
                            "src": "3878:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 326,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 308,
                                            "name": "ElementaryTypeName",
                                            "src": "3918:4:0"
                                        }
                                    ],
                                    "id": 309,
                                    "name": "VariableDeclaration",
                                    "src": "3918:6:0"
                                }
                            ],
                            "id": 310,
                            "name": "ParameterList",
                            "src": "3917:8:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 309,
                                                        "type": "uint256",
                                                        "value": "z"
                                                    },
                                                    "id": 311,
                                                    "name": "Identifier",
                                                    "src": "3937:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "/",
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "isStructConstructorCall": false,
                                                                "lValueRequested": false,
                                                                "names": [
                                                                    null
                                                                ],
                                                                "type": "uint256",
                                                                "type_conversion": false
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": [
                                                                            {
                                                                                "typeIdentifier": "t_uint256",
                                                                                "typeString": "uint256"
                                                                            },
                                                                            {
                                                                                "typeIdentifier": "t_uint256",
                                                                                "typeString": "uint256"
                                                                            }
                                                                        ],
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 152,
                                                                        "type": "function (uint256,uint256) pure returns (uint256)",
                                                                        "value": "add"
                                                                    },
                                                                    "id": 312,
                                                                    "name": "Identifier",
                                                                    "src": "3941:3:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "isStructConstructorCall": false,
                                                                        "lValueRequested": false,
                                                                        "names": [
                                                                            null
                                                                        ],
                                                                        "type": "uint256",
                                                                        "type_conversion": false
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": [
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    },
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    }
                                                                                ],
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 200,
                                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                                "value": "mul"
                                                                            },
                                                                            "id": 313,
                                                                            "name": "Identifier",
                                                                            "src": "3945:3:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 304,
                                                                                "type": "uint256",
                                                                                "value": "x"
                                                                            },
                                                                            "id": 314,
                                                                            "name": "Identifier",
                                                                            "src": "3949:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 306,
                                                                                "type": "uint256",
                                                                                "value": "y"
                                                                            },
                                                                            "id": 315,
                                                                            "name": "Identifier",
                                                                            "src": "3952:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 316,
                                                                    "name": "FunctionCall",
                                                                    "src": "3945:9:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "commonType": {
                                                                            "typeIdentifier": "t_uint256",
                                                                            "typeString": "uint256"
                                                                        },
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "operator": "/",
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 278,
                                                                                "type": "uint256",
                                                                                "value": "RAY"
                                                                            },
                                                                            "id": 317,
                                                                            "name": "Identifier",
                                                                            "src": "3956:3:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "32",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "number",
                                                                                "type": "int_const 2",
                                                                                "value": "2"
                                                                            },
                                                                            "id": 318,
                                                                            "name": "Literal",
                                                                            "src": "3962:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 319,
                                                                    "name": "BinaryOperation",
                                                                    "src": "3956:7:0"
                                                                }
                                                            ],
                                                            "id": 320,
                                                            "name": "FunctionCall",
                                                            "src": "3941:23:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 278,
                                                                "type": "uint256",
                                                                "value": "RAY"
                                                            },
                                                            "id": 321,
                                                            "name": "Identifier",
                                                            "src": "3967:3:0"
                                                        }
                                                    ],
                                                    "id": 322,
                                                    "name": "BinaryOperation",
                                                    "src": "3941:29:0"
                                                }
                                            ],
                                            "id": 323,
                                            "name": "Assignment",
                                            "src": "3937:33:0"
                                        }
                                    ],
                                    "id": 324,
                                    "name": "ExpressionStatement",
                                    "src": "3937:33:0"
                                }
                            ],
                            "id": 325,
                            "name": "Block",
                            "src": "3926:52:0"
                        }
                    ],
                    "id": 326,
                    "name": "FunctionDefinition",
                    "src": "3865:113:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "wdiv",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 350,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 327,
                                            "name": "ElementaryTypeName",
                                            "src": "3998:4:0"
                                        }
                                    ],
                                    "id": 328,
                                    "name": "VariableDeclaration",
                                    "src": "3998:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 350,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 329,
                                            "name": "ElementaryTypeName",
                                            "src": "4006:4:0"
                                        }
                                    ],
                                    "id": 330,
                                    "name": "VariableDeclaration",
                                    "src": "4006:6:0"
                                }
                            ],
                            "id": 331,
                            "name": "ParameterList",
                            "src": "3997:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 350,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 332,
                                            "name": "ElementaryTypeName",
                                            "src": "4037:4:0"
                                        }
                                    ],
                                    "id": 333,
                                    "name": "VariableDeclaration",
                                    "src": "4037:6:0"
                                }
                            ],
                            "id": 334,
                            "name": "ParameterList",
                            "src": "4036:8:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 333,
                                                        "type": "uint256",
                                                        "value": "z"
                                                    },
                                                    "id": 335,
                                                    "name": "Identifier",
                                                    "src": "4056:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "/",
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "isStructConstructorCall": false,
                                                                "lValueRequested": false,
                                                                "names": [
                                                                    null
                                                                ],
                                                                "type": "uint256",
                                                                "type_conversion": false
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": [
                                                                            {
                                                                                "typeIdentifier": "t_uint256",
                                                                                "typeString": "uint256"
                                                                            },
                                                                            {
                                                                                "typeIdentifier": "t_uint256",
                                                                                "typeString": "uint256"
                                                                            }
                                                                        ],
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 152,
                                                                        "type": "function (uint256,uint256) pure returns (uint256)",
                                                                        "value": "add"
                                                                    },
                                                                    "id": 336,
                                                                    "name": "Identifier",
                                                                    "src": "4060:3:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "isStructConstructorCall": false,
                                                                        "lValueRequested": false,
                                                                        "names": [
                                                                            null
                                                                        ],
                                                                        "type": "uint256",
                                                                        "type_conversion": false
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": [
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    },
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    }
                                                                                ],
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 200,
                                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                                "value": "mul"
                                                                            },
                                                                            "id": 337,
                                                                            "name": "Identifier",
                                                                            "src": "4064:3:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 328,
                                                                                "type": "uint256",
                                                                                "value": "x"
                                                                            },
                                                                            "id": 338,
                                                                            "name": "Identifier",
                                                                            "src": "4068:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 273,
                                                                                "type": "uint256",
                                                                                "value": "WAD"
                                                                            },
                                                                            "id": 339,
                                                                            "name": "Identifier",
                                                                            "src": "4071:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 340,
                                                                    "name": "FunctionCall",
                                                                    "src": "4064:11:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "commonType": {
                                                                            "typeIdentifier": "t_uint256",
                                                                            "typeString": "uint256"
                                                                        },
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "operator": "/",
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 330,
                                                                                "type": "uint256",
                                                                                "value": "y"
                                                                            },
                                                                            "id": 341,
                                                                            "name": "Identifier",
                                                                            "src": "4077:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "32",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "number",
                                                                                "type": "int_const 2",
                                                                                "value": "2"
                                                                            },
                                                                            "id": 342,
                                                                            "name": "Literal",
                                                                            "src": "4081:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 343,
                                                                    "name": "BinaryOperation",
                                                                    "src": "4077:5:0"
                                                                }
                                                            ],
                                                            "id": 344,
                                                            "name": "FunctionCall",
                                                            "src": "4060:23:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 330,
                                                                "type": "uint256",
                                                                "value": "y"
                                                            },
                                                            "id": 345,
                                                            "name": "Identifier",
                                                            "src": "4086:1:0"
                                                        }
                                                    ],
                                                    "id": 346,
                                                    "name": "BinaryOperation",
                                                    "src": "4060:27:0"
                                                }
                                            ],
                                            "id": 347,
                                            "name": "Assignment",
                                            "src": "4056:31:0"
                                        }
                                    ],
                                    "id": 348,
                                    "name": "ExpressionStatement",
                                    "src": "4056:31:0"
                                }
                            ],
                            "id": 349,
                            "name": "Block",
                            "src": "4045:50:0"
                        }
                    ],
                    "id": 350,
                    "name": "FunctionDefinition",
                    "src": "3984:111:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "rdiv",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 374,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 351,
                                            "name": "ElementaryTypeName",
                                            "src": "4115:4:0"
                                        }
                                    ],
                                    "id": 352,
                                    "name": "VariableDeclaration",
                                    "src": "4115:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "y",
                                        "scope": 374,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 353,
                                            "name": "ElementaryTypeName",
                                            "src": "4123:4:0"
                                        }
                                    ],
                                    "id": 354,
                                    "name": "VariableDeclaration",
                                    "src": "4123:6:0"
                                }
                            ],
                            "id": 355,
                            "name": "ParameterList",
                            "src": "4114:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 374,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 356,
                                            "name": "ElementaryTypeName",
                                            "src": "4154:4:0"
                                        }
                                    ],
                                    "id": 357,
                                    "name": "VariableDeclaration",
                                    "src": "4154:6:0"
                                }
                            ],
                            "id": 358,
                            "name": "ParameterList",
                            "src": "4153:8:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 357,
                                                        "type": "uint256",
                                                        "value": "z"
                                                    },
                                                    "id": 359,
                                                    "name": "Identifier",
                                                    "src": "4173:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "/",
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "isStructConstructorCall": false,
                                                                "lValueRequested": false,
                                                                "names": [
                                                                    null
                                                                ],
                                                                "type": "uint256",
                                                                "type_conversion": false
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": [
                                                                            {
                                                                                "typeIdentifier": "t_uint256",
                                                                                "typeString": "uint256"
                                                                            },
                                                                            {
                                                                                "typeIdentifier": "t_uint256",
                                                                                "typeString": "uint256"
                                                                            }
                                                                        ],
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 152,
                                                                        "type": "function (uint256,uint256) pure returns (uint256)",
                                                                        "value": "add"
                                                                    },
                                                                    "id": 360,
                                                                    "name": "Identifier",
                                                                    "src": "4177:3:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "isStructConstructorCall": false,
                                                                        "lValueRequested": false,
                                                                        "names": [
                                                                            null
                                                                        ],
                                                                        "type": "uint256",
                                                                        "type_conversion": false
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": [
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    },
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    }
                                                                                ],
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 200,
                                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                                "value": "mul"
                                                                            },
                                                                            "id": 361,
                                                                            "name": "Identifier",
                                                                            "src": "4181:3:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 352,
                                                                                "type": "uint256",
                                                                                "value": "x"
                                                                            },
                                                                            "id": 362,
                                                                            "name": "Identifier",
                                                                            "src": "4185:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 278,
                                                                                "type": "uint256",
                                                                                "value": "RAY"
                                                                            },
                                                                            "id": 363,
                                                                            "name": "Identifier",
                                                                            "src": "4188:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 364,
                                                                    "name": "FunctionCall",
                                                                    "src": "4181:11:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "commonType": {
                                                                            "typeIdentifier": "t_uint256",
                                                                            "typeString": "uint256"
                                                                        },
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "operator": "/",
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 354,
                                                                                "type": "uint256",
                                                                                "value": "y"
                                                                            },
                                                                            "id": 365,
                                                                            "name": "Identifier",
                                                                            "src": "4194:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "32",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "number",
                                                                                "type": "int_const 2",
                                                                                "value": "2"
                                                                            },
                                                                            "id": 366,
                                                                            "name": "Literal",
                                                                            "src": "4198:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 367,
                                                                    "name": "BinaryOperation",
                                                                    "src": "4194:5:0"
                                                                }
                                                            ],
                                                            "id": 368,
                                                            "name": "FunctionCall",
                                                            "src": "4177:23:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 354,
                                                                "type": "uint256",
                                                                "value": "y"
                                                            },
                                                            "id": 369,
                                                            "name": "Identifier",
                                                            "src": "4203:1:0"
                                                        }
                                                    ],
                                                    "id": 370,
                                                    "name": "BinaryOperation",
                                                    "src": "4177:27:0"
                                                }
                                            ],
                                            "id": 371,
                                            "name": "Assignment",
                                            "src": "4173:31:0"
                                        }
                                    ],
                                    "id": 372,
                                    "name": "ExpressionStatement",
                                    "src": "4173:31:0"
                                }
                            ],
                            "id": 373,
                            "name": "Block",
                            "src": "4162:50:0"
                        }
                    ],
                    "id": 374,
                    "name": "FunctionDefinition",
                    "src": "4101:111:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "rpow",
                        "payable": false,
                        "scope": 430,
                        "stateMutability": "pure",
                        "superFunction": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "x",
                                        "scope": 429,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 375,
                                            "name": "ElementaryTypeName",
                                            "src": "4806:4:0"
                                        }
                                    ],
                                    "id": 376,
                                    "name": "VariableDeclaration",
                                    "src": "4806:6:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "n",
                                        "scope": 429,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 377,
                                            "name": "ElementaryTypeName",
                                            "src": "4814:4:0"
                                        }
                                    ],
                                    "id": 378,
                                    "name": "VariableDeclaration",
                                    "src": "4814:6:0"
                                }
                            ],
                            "id": 379,
                            "name": "ParameterList",
                            "src": "4805:16:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "z",
                                        "scope": 429,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 380,
                                            "name": "ElementaryTypeName",
                                            "src": "4845:4:0"
                                        }
                                    ],
                                    "id": 381,
                                    "name": "VariableDeclaration",
                                    "src": "4845:6:0"
                                }
                            ],
                            "id": 382,
                            "name": "ParameterList",
                            "src": "4844:8:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 381,
                                                        "type": "uint256",
                                                        "value": "z"
                                                    },
                                                    "id": 383,
                                                    "name": "Identifier",
                                                    "src": "4864:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "commonType": {
                                                                    "typeIdentifier": "t_uint256",
                                                                    "typeString": "uint256"
                                                                },
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "operator": "!=",
                                                                "type": "bool"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "commonType": {
                                                                            "typeIdentifier": "t_uint256",
                                                                            "typeString": "uint256"
                                                                        },
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "operator": "%",
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 378,
                                                                                "type": "uint256",
                                                                                "value": "n"
                                                                            },
                                                                            "id": 384,
                                                                            "name": "Identifier",
                                                                            "src": "4868:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "32",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "number",
                                                                                "type": "int_const 2",
                                                                                "value": "2"
                                                                            },
                                                                            "id": 385,
                                                                            "name": "Literal",
                                                                            "src": "4872:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 386,
                                                                    "name": "BinaryOperation",
                                                                    "src": "4868:5:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "hexvalue": "30",
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "subdenomination": null,
                                                                        "token": "number",
                                                                        "type": "int_const 0",
                                                                        "value": "0"
                                                                    },
                                                                    "id": 387,
                                                                    "name": "Literal",
                                                                    "src": "4877:1:0"
                                                                }
                                                            ],
                                                            "id": 388,
                                                            "name": "BinaryOperation",
                                                            "src": "4868:10:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 376,
                                                                "type": "uint256",
                                                                "value": "x"
                                                            },
                                                            "id": 389,
                                                            "name": "Identifier",
                                                            "src": "4881:1:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 278,
                                                                "type": "uint256",
                                                                "value": "RAY"
                                                            },
                                                            "id": 390,
                                                            "name": "Identifier",
                                                            "src": "4885:3:0"
                                                        }
                                                    ],
                                                    "id": 391,
                                                    "name": "Conditional",
                                                    "src": "4868:20:0"
                                                }
                                            ],
                                            "id": 392,
                                            "name": "Assignment",
                                            "src": "4864:24:0"
                                        }
                                    ],
                                    "id": 393,
                                    "name": "ExpressionStatement",
                                    "src": "4864:24:0"
                                },
                                {
                                    "children": [
                                        {
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "/=",
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 378,
                                                                "type": "uint256",
                                                                "value": "n"
                                                            },
                                                            "id": 394,
                                                            "name": "Identifier",
                                                            "src": "4906:1:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "hexvalue": "32",
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": true,
                                                                "lValueRequested": false,
                                                                "subdenomination": null,
                                                                "token": "number",
                                                                "type": "int_const 2",
                                                                "value": "2"
                                                            },
                                                            "id": 395,
                                                            "name": "Literal",
                                                            "src": "4911:1:0"
                                                        }
                                                    ],
                                                    "id": 396,
                                                    "name": "Assignment",
                                                    "src": "4906:6:0"
                                                }
                                            ],
                                            "id": 397,
                                            "name": "ExpressionStatement",
                                            "src": "4906:6:0"
                                        },
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "commonType": {
                                                    "typeIdentifier": "t_uint256",
                                                    "typeString": "uint256"
                                                },
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "!=",
                                                "type": "bool"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 378,
                                                        "type": "uint256",
                                                        "value": "n"
                                                    },
                                                    "id": 398,
                                                    "name": "Identifier",
                                                    "src": "4914:1:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "hexvalue": "30",
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": true,
                                                        "lValueRequested": false,
                                                        "subdenomination": null,
                                                        "token": "number",
                                                        "type": "int_const 0",
                                                        "value": "0"
                                                    },
                                                    "id": 399,
                                                    "name": "Literal",
                                                    "src": "4919:1:0"
                                                }
                                            ],
                                            "id": 400,
                                            "name": "BinaryOperation",
                                            "src": "4914:6:0"
                                        },
                                        {
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "/=",
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 378,
                                                                "type": "uint256",
                                                                "value": "n"
                                                            },
                                                            "id": 401,
                                                            "name": "Identifier",
                                                            "src": "4922:1:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "hexvalue": "32",
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": true,
                                                                "lValueRequested": false,
                                                                "subdenomination": null,
                                                                "token": "number",
                                                                "type": "int_const 2",
                                                                "value": "2"
                                                            },
                                                            "id": 402,
                                                            "name": "Literal",
                                                            "src": "4927:1:0"
                                                        }
                                                    ],
                                                    "id": 403,
                                                    "name": "Assignment",
                                                    "src": "4922:6:0"
                                                }
                                            ],
                                            "id": 404,
                                            "name": "ExpressionStatement",
                                            "src": "4922:6:0"
                                        },
                                        {
                                            "children": [
                                                {
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "operator": "=",
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 376,
                                                                        "type": "uint256",
                                                                        "value": "x"
                                                                    },
                                                                    "id": 405,
                                                                    "name": "Identifier",
                                                                    "src": "4945:1:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "isStructConstructorCall": false,
                                                                        "lValueRequested": false,
                                                                        "names": [
                                                                            null
                                                                        ],
                                                                        "type": "uint256",
                                                                        "type_conversion": false
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": [
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    },
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    }
                                                                                ],
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 326,
                                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                                "value": "rmul"
                                                                            },
                                                                            "id": 406,
                                                                            "name": "Identifier",
                                                                            "src": "4949:4:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 376,
                                                                                "type": "uint256",
                                                                                "value": "x"
                                                                            },
                                                                            "id": 407,
                                                                            "name": "Identifier",
                                                                            "src": "4954:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 376,
                                                                                "type": "uint256",
                                                                                "value": "x"
                                                                            },
                                                                            "id": 408,
                                                                            "name": "Identifier",
                                                                            "src": "4957:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 409,
                                                                    "name": "FunctionCall",
                                                                    "src": "4949:10:0"
                                                                }
                                                            ],
                                                            "id": 410,
                                                            "name": "Assignment",
                                                            "src": "4945:14:0"
                                                        }
                                                    ],
                                                    "id": 411,
                                                    "name": "ExpressionStatement",
                                                    "src": "4945:14:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "falseBody": null
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "commonType": {
                                                                    "typeIdentifier": "t_uint256",
                                                                    "typeString": "uint256"
                                                                },
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "operator": "!=",
                                                                "type": "bool"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "commonType": {
                                                                            "typeIdentifier": "t_uint256",
                                                                            "typeString": "uint256"
                                                                        },
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "operator": "%",
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 378,
                                                                                "type": "uint256",
                                                                                "value": "n"
                                                                            },
                                                                            "id": 412,
                                                                            "name": "Identifier",
                                                                            "src": "4980:1:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "32",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "number",
                                                                                "type": "int_const 2",
                                                                                "value": "2"
                                                                            },
                                                                            "id": 413,
                                                                            "name": "Literal",
                                                                            "src": "4984:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 414,
                                                                    "name": "BinaryOperation",
                                                                    "src": "4980:5:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "hexvalue": "30",
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "subdenomination": null,
                                                                        "token": "number",
                                                                        "type": "int_const 0",
                                                                        "value": "0"
                                                                    },
                                                                    "id": 415,
                                                                    "name": "Literal",
                                                                    "src": "4989:1:0"
                                                                }
                                                            ],
                                                            "id": 416,
                                                            "name": "BinaryOperation",
                                                            "src": "4980:10:0"
                                                        },
                                                        {
                                                            "children": [
                                                                {
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "operator": "=",
                                                                                "type": "uint256"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 381,
                                                                                        "type": "uint256",
                                                                                        "value": "z"
                                                                                    },
                                                                                    "id": 417,
                                                                                    "name": "Identifier",
                                                                                    "src": "5011:1:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "isConstant": false,
                                                                                        "isLValue": false,
                                                                                        "isPure": false,
                                                                                        "isStructConstructorCall": false,
                                                                                        "lValueRequested": false,
                                                                                        "names": [
                                                                                            null
                                                                                        ],
                                                                                        "type": "uint256",
                                                                                        "type_conversion": false
                                                                                    },
                                                                                    "children": [
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": [
                                                                                                    {
                                                                                                        "typeIdentifier": "t_uint256",
                                                                                                        "typeString": "uint256"
                                                                                                    },
                                                                                                    {
                                                                                                        "typeIdentifier": "t_uint256",
                                                                                                        "typeString": "uint256"
                                                                                                    }
                                                                                                ],
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 326,
                                                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                                                "value": "rmul"
                                                                                            },
                                                                                            "id": 418,
                                                                                            "name": "Identifier",
                                                                                            "src": "5015:4:0"
                                                                                        },
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 381,
                                                                                                "type": "uint256",
                                                                                                "value": "z"
                                                                                            },
                                                                                            "id": 419,
                                                                                            "name": "Identifier",
                                                                                            "src": "5020:1:0"
                                                                                        },
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 376,
                                                                                                "type": "uint256",
                                                                                                "value": "x"
                                                                                            },
                                                                                            "id": 420,
                                                                                            "name": "Identifier",
                                                                                            "src": "5023:1:0"
                                                                                        }
                                                                                    ],
                                                                                    "id": 421,
                                                                                    "name": "FunctionCall",
                                                                                    "src": "5015:10:0"
                                                                                }
                                                                            ],
                                                                            "id": 422,
                                                                            "name": "Assignment",
                                                                            "src": "5011:14:0"
                                                                        }
                                                                    ],
                                                                    "id": 423,
                                                                    "name": "ExpressionStatement",
                                                                    "src": "5011:14:0"
                                                                }
                                                            ],
                                                            "id": 424,
                                                            "name": "Block",
                                                            "src": "4992:49:0"
                                                        }
                                                    ],
                                                    "id": 425,
                                                    "name": "IfStatement",
                                                    "src": "4976:65:0"
                                                }
                                            ],
                                            "id": 426,
                                            "name": "Block",
                                            "src": "4930:122:0"
                                        }
                                    ],
                                    "id": 427,
                                    "name": "ForStatement",
                                    "src": "4901:151:0"
                                }
                            ],
                            "id": 428,
                            "name": "Block",
                            "src": "4853:206:0"
                        }
                    ],
                    "id": 429,
                    "name": "FunctionDefinition",
                    "src": "4792:267:0"
                }
            ],
            "id": 430,
            "name": "ContractDefinition",
            "src": "2883:2179:0"
        },
        {
            "attributes": {
                "baseContracts": [
                    null
                ],
                "contractDependencies": [
                    null
                ],
                "contractKind": "contract",
                "documentation": "/// lib/ds-thing/lib/ds-note/src/note.sol\r\n note.sol -- the `note' modifier, for logging calls as events\r",
                "fullyImplemented": true,
                "linearizedBaseContracts": [
                    469
                ],
                "name": "DSNote",
                "scope": 1103
            },
            "children": [
                {
                    "attributes": {
                        "anonymous": true,
                        "name": "LogNote"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "sig",
                                        "scope": 444,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bytes4",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bytes4",
                                                "type": "bytes4"
                                            },
                                            "id": 431,
                                            "name": "ElementaryTypeName",
                                            "src": "5917:6:0"
                                        }
                                    ],
                                    "id": 432,
                                    "name": "VariableDeclaration",
                                    "src": "5917:21:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "guy",
                                        "scope": 444,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 433,
                                            "name": "ElementaryTypeName",
                                            "src": "5949:7:0"
                                        }
                                    ],
                                    "id": 434,
                                    "name": "VariableDeclaration",
                                    "src": "5949:21:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "foo",
                                        "scope": 444,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bytes32",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bytes32",
                                                "type": "bytes32"
                                            },
                                            "id": 435,
                                            "name": "ElementaryTypeName",
                                            "src": "5981:7:0"
                                        }
                                    ],
                                    "id": 436,
                                    "name": "VariableDeclaration",
                                    "src": "5981:21:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "bar",
                                        "scope": 444,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bytes32",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bytes32",
                                                "type": "bytes32"
                                            },
                                            "id": 437,
                                            "name": "ElementaryTypeName",
                                            "src": "6013:7:0"
                                        }
                                    ],
                                    "id": 438,
                                    "name": "VariableDeclaration",
                                    "src": "6013:21:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": false,
                                        "name": "wad",
                                        "scope": 444,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 439,
                                            "name": "ElementaryTypeName",
                                            "src": "6045:4:0"
                                        }
                                    ],
                                    "id": 440,
                                    "name": "VariableDeclaration",
                                    "src": "6045:21:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": false,
                                        "name": "fax",
                                        "scope": 444,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bytes memory",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bytes",
                                                "type": "bytes storage pointer"
                                            },
                                            "id": 441,
                                            "name": "ElementaryTypeName",
                                            "src": "6077:5:0"
                                        }
                                    ],
                                    "id": 442,
                                    "name": "VariableDeclaration",
                                    "src": "6077:21:0"
                                }
                            ],
                            "id": 443,
                            "name": "ParameterList",
                            "src": "5906:199:0"
                        }
                    ],
                    "id": 444,
                    "name": "EventDefinition",
                    "src": "5893:223:0"
                },
                {
                    "attributes": {
                        "name": "note",
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 445,
                            "name": "ParameterList",
                            "src": "6138:0:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "assignments": [
                                            null
                                        ],
                                        "initialValue": null
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "constant": false,
                                                "name": "foo",
                                                "scope": 468,
                                                "stateVariable": false,
                                                "storageLocation": "default",
                                                "type": "bytes32",
                                                "value": null,
                                                "visibility": "internal"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "name": "bytes32",
                                                        "type": "bytes32"
                                                    },
                                                    "id": 446,
                                                    "name": "ElementaryTypeName",
                                                    "src": "6149:7:0"
                                                }
                                            ],
                                            "id": 447,
                                            "name": "VariableDeclaration",
                                            "src": "6149:11:0"
                                        }
                                    ],
                                    "id": 448,
                                    "name": "VariableDeclarationStatement",
                                    "src": "6149:11:0"
                                },
                                {
                                    "attributes": {
                                        "assignments": [
                                            null
                                        ],
                                        "initialValue": null
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "constant": false,
                                                "name": "bar",
                                                "scope": 468,
                                                "stateVariable": false,
                                                "storageLocation": "default",
                                                "type": "bytes32",
                                                "value": null,
                                                "visibility": "internal"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "name": "bytes32",
                                                        "type": "bytes32"
                                                    },
                                                    "id": 449,
                                                    "name": "ElementaryTypeName",
                                                    "src": "6171:7:0"
                                                }
                                            ],
                                            "id": 450,
                                            "name": "VariableDeclaration",
                                            "src": "6171:11:0"
                                        }
                                    ],
                                    "id": 451,
                                    "name": "VariableDeclarationStatement",
                                    "src": "6171:11:0"
                                },
                                {
                                    "attributes": {
                                        "externalReferences": [
                                            {
                                                "foo": {
                                                    "declaration": 447,
                                                    "isOffset": false,
                                                    "isSlot": false,
                                                    "src": "6219:3:0",
                                                    "valueSize": 1
                                                }
                                            },
                                            {
                                                "bar": {
                                                    "declaration": 450,
                                                    "isOffset": false,
                                                    "isSlot": false,
                                                    "src": "6255:3:0",
                                                    "valueSize": 1
                                                }
                                            }
                                        ],
                                        "operations": "{\n    foo := calldataload(4)\n    bar := calldataload(36)\n}"
                                    },
                                    "children": [],
                                    "id": 452,
                                    "name": "InlineAssembly",
                                    "src": "6195:113:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_bytes4",
                                                                "typeString": "bytes4"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_bytes32",
                                                                "typeString": "bytes32"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_bytes32",
                                                                "typeString": "bytes32"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_bytes_calldata_ptr",
                                                                "typeString": "bytes calldata"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 444,
                                                        "type": "function (bytes4,address,bytes32,bytes32,uint256,bytes memory)",
                                                        "value": "LogNote"
                                                    },
                                                    "id": 453,
                                                    "name": "Identifier",
                                                    "src": "6301:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sig",
                                                        "referencedDeclaration": null,
                                                        "type": "bytes4"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 454,
                                                            "name": "Identifier",
                                                            "src": "6309:3:0"
                                                        }
                                                    ],
                                                    "id": 455,
                                                    "name": "MemberAccess",
                                                    "src": "6309:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 456,
                                                            "name": "Identifier",
                                                            "src": "6318:3:0"
                                                        }
                                                    ],
                                                    "id": 457,
                                                    "name": "MemberAccess",
                                                    "src": "6318:10:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 447,
                                                        "type": "bytes32",
                                                        "value": "foo"
                                                    },
                                                    "id": 458,
                                                    "name": "Identifier",
                                                    "src": "6330:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 450,
                                                        "type": "bytes32",
                                                        "value": "bar"
                                                    },
                                                    "id": 459,
                                                    "name": "Identifier",
                                                    "src": "6335:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "value",
                                                        "referencedDeclaration": null,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 460,
                                                            "name": "Identifier",
                                                            "src": "6340:3:0"
                                                        }
                                                    ],
                                                    "id": 461,
                                                    "name": "MemberAccess",
                                                    "src": "6340:9:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "data",
                                                        "referencedDeclaration": null,
                                                        "type": "bytes calldata"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 462,
                                                            "name": "Identifier",
                                                            "src": "6351:3:0"
                                                        }
                                                    ],
                                                    "id": 463,
                                                    "name": "MemberAccess",
                                                    "src": "6351:8:0"
                                                }
                                            ],
                                            "id": 464,
                                            "name": "FunctionCall",
                                            "src": "6301:59:0"
                                        }
                                    ],
                                    "id": 465,
                                    "name": "ExpressionStatement",
                                    "src": "6301:59:0"
                                },
                                {
                                    "id": 466,
                                    "name": "PlaceholderStatement",
                                    "src": "6373:1:0"
                                }
                            ],
                            "id": 467,
                            "name": "Block",
                            "src": "6138:244:0"
                        }
                    ],
                    "id": 468,
                    "name": "ModifierDefinition",
                    "src": "6124:258:0"
                }
            ],
            "id": 469,
            "name": "ContractDefinition",
            "src": "5870:515:0"
        },
        {
            "attributes": {
                "contractDependencies": [
                    22,
                    131,
                    430,
                    469
                ],
                "contractKind": "contract",
                "documentation": "/// lib/ds-thing/src/thing.sol\r",
                "fullyImplemented": true,
                "linearizedBaseContracts": [
                    476,
                    430,
                    469,
                    131,
                    22
                ],
                "name": "DSThing",
                "nodes": [
                    null
                ],
                "scope": 1103
            },
            "children": [
                {
                    "attributes": {
                        "arguments": [
                            null
                        ]
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSAuth",
                                "referencedDeclaration": 131,
                                "type": "contract DSAuth"
                            },
                            "id": 470,
                            "name": "UserDefinedTypeName",
                            "src": "7352:6:0"
                        }
                    ],
                    "id": 471,
                    "name": "InheritanceSpecifier",
                    "src": "7352:6:0"
                },
                {
                    "attributes": {
                        "arguments": [
                            null
                        ]
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSNote",
                                "referencedDeclaration": 469,
                                "type": "contract DSNote"
                            },
                            "id": 472,
                            "name": "UserDefinedTypeName",
                            "src": "7360:6:0"
                        }
                    ],
                    "id": 473,
                    "name": "InheritanceSpecifier",
                    "src": "7360:6:0"
                },
                {
                    "attributes": {
                        "arguments": [
                            null
                        ]
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSMath",
                                "referencedDeclaration": 430,
                                "type": "contract DSMath"
                            },
                            "id": 474,
                            "name": "UserDefinedTypeName",
                            "src": "7368:6:0"
                        }
                    ],
                    "id": 475,
                    "name": "InheritanceSpecifier",
                    "src": "7368:6:0"
                }
            ],
            "id": 476,
            "name": "ContractDefinition",
            "src": "7332:47:0"
        },
        {
            "attributes": {
                "contractDependencies": [
                    22,
                    131,
                    469
                ],
                "contractKind": "contract",
                "documentation": "/// lib/ds-token/lib/ds-stop/src/stop.sol\r\n stop.sol -- mixin for enable/disable functionality\r",
                "fullyImplemented": true,
                "linearizedBaseContracts": [
                    516,
                    131,
                    22,
                    469
                ],
                "name": "DSStop",
                "scope": 1103
            },
            "children": [
                {
                    "attributes": {
                        "arguments": [
                            null
                        ]
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSNote",
                                "referencedDeclaration": 469,
                                "type": "contract DSNote"
                            },
                            "id": 477,
                            "name": "UserDefinedTypeName",
                            "src": "8305:6:0"
                        }
                    ],
                    "id": 478,
                    "name": "InheritanceSpecifier",
                    "src": "8305:6:0"
                },
                {
                    "attributes": {
                        "arguments": [
                            null
                        ]
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSAuth",
                                "referencedDeclaration": 131,
                                "type": "contract DSAuth"
                            },
                            "id": 479,
                            "name": "UserDefinedTypeName",
                            "src": "8313:6:0"
                        }
                    ],
                    "id": 480,
                    "name": "InheritanceSpecifier",
                    "src": "8313:6:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "name": "stopped",
                        "scope": 516,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "bool",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "name": "bool",
                                "type": "bool"
                            },
                            "id": 481,
                            "name": "ElementaryTypeName",
                            "src": "8329:4:0"
                        }
                    ],
                    "id": 482,
                    "name": "VariableDeclaration",
                    "src": "8329:19:0"
                },
                {
                    "attributes": {
                        "name": "stoppable",
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 483,
                            "name": "ParameterList",
                            "src": "8376:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_bool",
                                                                "typeString": "bool"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 1117,
                                                        "type": "function (bool) pure",
                                                        "value": "require"
                                                    },
                                                    "id": 484,
                                                    "name": "Identifier",
                                                    "src": "8387:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "!",
                                                        "prefix": true,
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 482,
                                                                "type": "bool",
                                                                "value": "stopped"
                                                            },
                                                            "id": 485,
                                                            "name": "Identifier",
                                                            "src": "8396:7:0"
                                                        }
                                                    ],
                                                    "id": 486,
                                                    "name": "UnaryOperation",
                                                    "src": "8395:8:0"
                                                }
                                            ],
                                            "id": 487,
                                            "name": "FunctionCall",
                                            "src": "8387:17:0"
                                        }
                                    ],
                                    "id": 488,
                                    "name": "ExpressionStatement",
                                    "src": "8387:17:0"
                                },
                                {
                                    "id": 489,
                                    "name": "PlaceholderStatement",
                                    "src": "8415:1:0"
                                }
                            ],
                            "id": 490,
                            "name": "Block",
                            "src": "8376:48:0"
                        }
                    ],
                    "id": 491,
                    "name": "ModifierDefinition",
                    "src": "8357:67:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "stop",
                        "payable": false,
                        "scope": 516,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 492,
                            "name": "ParameterList",
                            "src": "8443:2:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 497,
                            "name": "ParameterList",
                            "src": "8463:0:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 87,
                                        "type": "modifier ()",
                                        "value": "auth"
                                    },
                                    "id": 493,
                                    "name": "Identifier",
                                    "src": "8453:4:0"
                                }
                            ],
                            "id": 494,
                            "name": "ModifierInvocation",
                            "src": "8453:4:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 468,
                                        "type": "modifier ()",
                                        "value": "note"
                                    },
                                    "id": 495,
                                    "name": "Identifier",
                                    "src": "8458:4:0"
                                }
                            ],
                            "id": 496,
                            "name": "ModifierInvocation",
                            "src": "8458:4:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "bool"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 482,
                                                        "type": "bool",
                                                        "value": "stopped"
                                                    },
                                                    "id": 498,
                                                    "name": "Identifier",
                                                    "src": "8474:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "hexvalue": "74727565",
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": true,
                                                        "lValueRequested": false,
                                                        "subdenomination": null,
                                                        "token": "bool",
                                                        "type": "bool",
                                                        "value": "true"
                                                    },
                                                    "id": 499,
                                                    "name": "Literal",
                                                    "src": "8484:4:0"
                                                }
                                            ],
                                            "id": 500,
                                            "name": "Assignment",
                                            "src": "8474:14:0"
                                        }
                                    ],
                                    "id": 501,
                                    "name": "ExpressionStatement",
                                    "src": "8474:14:0"
                                }
                            ],
                            "id": 502,
                            "name": "Block",
                            "src": "8463:33:0"
                        }
                    ],
                    "id": 503,
                    "name": "FunctionDefinition",
                    "src": "8430:66:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "start",
                        "payable": false,
                        "scope": 516,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 504,
                            "name": "ParameterList",
                            "src": "8516:2:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 509,
                            "name": "ParameterList",
                            "src": "8536:0:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 87,
                                        "type": "modifier ()",
                                        "value": "auth"
                                    },
                                    "id": 505,
                                    "name": "Identifier",
                                    "src": "8526:4:0"
                                }
                            ],
                            "id": 506,
                            "name": "ModifierInvocation",
                            "src": "8526:4:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 468,
                                        "type": "modifier ()",
                                        "value": "note"
                                    },
                                    "id": 507,
                                    "name": "Identifier",
                                    "src": "8531:4:0"
                                }
                            ],
                            "id": 508,
                            "name": "ModifierInvocation",
                            "src": "8531:4:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "bool"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 482,
                                                        "type": "bool",
                                                        "value": "stopped"
                                                    },
                                                    "id": 510,
                                                    "name": "Identifier",
                                                    "src": "8547:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "hexvalue": "66616c7365",
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": true,
                                                        "lValueRequested": false,
                                                        "subdenomination": null,
                                                        "token": "bool",
                                                        "type": "bool",
                                                        "value": "false"
                                                    },
                                                    "id": 511,
                                                    "name": "Literal",
                                                    "src": "8557:5:0"
                                                }
                                            ],
                                            "id": 512,
                                            "name": "Assignment",
                                            "src": "8547:15:0"
                                        }
                                    ],
                                    "id": 513,
                                    "name": "ExpressionStatement",
                                    "src": "8547:15:0"
                                }
                            ],
                            "id": 514,
                            "name": "Block",
                            "src": "8536:34:0"
                        }
                    ],
                    "id": 515,
                    "name": "FunctionDefinition",
                    "src": "8502:68:0"
                }
            ],
            "id": 516,
            "name": "ContractDefinition",
            "src": "8286:289:0"
        },
        {
            "attributes": {
                "baseContracts": [
                    null
                ],
                "contractDependencies": [
                    null
                ],
                "contractKind": "contract",
                "documentation": "/// lib/ds-token/lib/erc20/src/erc20.sol\r",
                "fullyImplemented": false,
                "linearizedBaseContracts": [
                    583
                ],
                "name": "ERC20",
                "scope": 1103
            },
            "children": [
                {
                    "attributes": {
                        "body": null,
                        "constant": true,
                        "implemented": false,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "totalSupply",
                        "payable": false,
                        "scope": 583,
                        "stateMutability": "view",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 517,
                            "name": "ParameterList",
                            "src": "9427:2:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "supply",
                                        "scope": 521,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 518,
                                            "name": "ElementaryTypeName",
                                            "src": "9451:4:0"
                                        }
                                    ],
                                    "id": 519,
                                    "name": "VariableDeclaration",
                                    "src": "9451:11:0"
                                }
                            ],
                            "id": 520,
                            "name": "ParameterList",
                            "src": "9450:13:0"
                        }
                    ],
                    "id": 521,
                    "name": "FunctionDefinition",
                    "src": "9407:57:0"
                },
                {
                    "attributes": {
                        "body": null,
                        "constant": true,
                        "implemented": false,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "balanceOf",
                        "payable": false,
                        "scope": 583,
                        "stateMutability": "view",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "who",
                                        "scope": 528,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 522,
                                            "name": "ElementaryTypeName",
                                            "src": "9490:7:0"
                                        }
                                    ],
                                    "id": 523,
                                    "name": "VariableDeclaration",
                                    "src": "9490:11:0"
                                }
                            ],
                            "id": 524,
                            "name": "ParameterList",
                            "src": "9488:15:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "value",
                                        "scope": 528,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 525,
                                            "name": "ElementaryTypeName",
                                            "src": "9525:4:0"
                                        }
                                    ],
                                    "id": 526,
                                    "name": "VariableDeclaration",
                                    "src": "9525:10:0"
                                }
                            ],
                            "id": 527,
                            "name": "ParameterList",
                            "src": "9524:12:0"
                        }
                    ],
                    "id": 528,
                    "name": "FunctionDefinition",
                    "src": "9470:67:0"
                },
                {
                    "attributes": {
                        "body": null,
                        "constant": true,
                        "implemented": false,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "allowance",
                        "payable": false,
                        "scope": 583,
                        "stateMutability": "view",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "owner",
                                        "scope": 537,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 529,
                                            "name": "ElementaryTypeName",
                                            "src": "9563:7:0"
                                        }
                                    ],
                                    "id": 530,
                                    "name": "VariableDeclaration",
                                    "src": "9563:13:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "spender",
                                        "scope": 537,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 531,
                                            "name": "ElementaryTypeName",
                                            "src": "9578:7:0"
                                        }
                                    ],
                                    "id": 532,
                                    "name": "VariableDeclaration",
                                    "src": "9578:15:0"
                                }
                            ],
                            "id": 533,
                            "name": "ParameterList",
                            "src": "9561:34:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "_allowance",
                                        "scope": 537,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 534,
                                            "name": "ElementaryTypeName",
                                            "src": "9617:4:0"
                                        }
                                    ],
                                    "id": 535,
                                    "name": "VariableDeclaration",
                                    "src": "9617:15:0"
                                }
                            ],
                            "id": 536,
                            "name": "ParameterList",
                            "src": "9616:17:0"
                        }
                    ],
                    "id": 537,
                    "name": "FunctionDefinition",
                    "src": "9543:91:0"
                },
                {
                    "attributes": {
                        "body": null,
                        "constant": false,
                        "implemented": false,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "transfer",
                        "payable": false,
                        "scope": 583,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "to",
                                        "scope": 546,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 538,
                                            "name": "ElementaryTypeName",
                                            "src": "9661:7:0"
                                        }
                                    ],
                                    "id": 539,
                                    "name": "VariableDeclaration",
                                    "src": "9661:10:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "value",
                                        "scope": 546,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 540,
                                            "name": "ElementaryTypeName",
                                            "src": "9673:4:0"
                                        }
                                    ],
                                    "id": 541,
                                    "name": "VariableDeclaration",
                                    "src": "9673:10:0"
                                }
                            ],
                            "id": 542,
                            "name": "ParameterList",
                            "src": "9659:25:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "ok",
                                        "scope": 546,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 543,
                                            "name": "ElementaryTypeName",
                                            "src": "9701:4:0"
                                        }
                                    ],
                                    "id": 544,
                                    "name": "VariableDeclaration",
                                    "src": "9701:7:0"
                                }
                            ],
                            "id": 545,
                            "name": "ParameterList",
                            "src": "9700:9:0"
                        }
                    ],
                    "id": 546,
                    "name": "FunctionDefinition",
                    "src": "9642:68:0"
                },
                {
                    "attributes": {
                        "body": null,
                        "constant": false,
                        "implemented": false,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "transferFrom",
                        "payable": false,
                        "scope": 583,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "from",
                                        "scope": 557,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 547,
                                            "name": "ElementaryTypeName",
                                            "src": "9739:7:0"
                                        }
                                    ],
                                    "id": 548,
                                    "name": "VariableDeclaration",
                                    "src": "9739:12:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "to",
                                        "scope": 557,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 549,
                                            "name": "ElementaryTypeName",
                                            "src": "9753:7:0"
                                        }
                                    ],
                                    "id": 550,
                                    "name": "VariableDeclaration",
                                    "src": "9753:10:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "value",
                                        "scope": 557,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 551,
                                            "name": "ElementaryTypeName",
                                            "src": "9765:4:0"
                                        }
                                    ],
                                    "id": 552,
                                    "name": "VariableDeclaration",
                                    "src": "9765:10:0"
                                }
                            ],
                            "id": 553,
                            "name": "ParameterList",
                            "src": "9737:39:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "ok",
                                        "scope": 557,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 554,
                                            "name": "ElementaryTypeName",
                                            "src": "9793:4:0"
                                        }
                                    ],
                                    "id": 555,
                                    "name": "VariableDeclaration",
                                    "src": "9793:7:0"
                                }
                            ],
                            "id": 556,
                            "name": "ParameterList",
                            "src": "9792:9:0"
                        }
                    ],
                    "id": 557,
                    "name": "FunctionDefinition",
                    "src": "9716:86:0"
                },
                {
                    "attributes": {
                        "body": null,
                        "constant": false,
                        "implemented": false,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "approve",
                        "payable": false,
                        "scope": 583,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "spender",
                                        "scope": 566,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 558,
                                            "name": "ElementaryTypeName",
                                            "src": "9826:7:0"
                                        }
                                    ],
                                    "id": 559,
                                    "name": "VariableDeclaration",
                                    "src": "9826:15:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "value",
                                        "scope": 566,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 560,
                                            "name": "ElementaryTypeName",
                                            "src": "9843:4:0"
                                        }
                                    ],
                                    "id": 561,
                                    "name": "VariableDeclaration",
                                    "src": "9843:10:0"
                                }
                            ],
                            "id": 562,
                            "name": "ParameterList",
                            "src": "9824:31:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "ok",
                                        "scope": 566,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 563,
                                            "name": "ElementaryTypeName",
                                            "src": "9872:4:0"
                                        }
                                    ],
                                    "id": 564,
                                    "name": "VariableDeclaration",
                                    "src": "9872:7:0"
                                }
                            ],
                            "id": 565,
                            "name": "ParameterList",
                            "src": "9871:9:0"
                        }
                    ],
                    "id": 566,
                    "name": "FunctionDefinition",
                    "src": "9808:73:0"
                },
                {
                    "attributes": {
                        "anonymous": false,
                        "name": "Transfer"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "from",
                                        "scope": 574,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 567,
                                            "name": "ElementaryTypeName",
                                            "src": "9905:7:0"
                                        }
                                    ],
                                    "id": 568,
                                    "name": "VariableDeclaration",
                                    "src": "9905:20:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "to",
                                        "scope": 574,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 569,
                                            "name": "ElementaryTypeName",
                                            "src": "9927:7:0"
                                        }
                                    ],
                                    "id": 570,
                                    "name": "VariableDeclaration",
                                    "src": "9927:18:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": false,
                                        "name": "value",
                                        "scope": 574,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 571,
                                            "name": "ElementaryTypeName",
                                            "src": "9947:4:0"
                                        }
                                    ],
                                    "id": 572,
                                    "name": "VariableDeclaration",
                                    "src": "9947:10:0"
                                }
                            ],
                            "id": 573,
                            "name": "ParameterList",
                            "src": "9903:55:0"
                        }
                    ],
                    "id": 574,
                    "name": "EventDefinition",
                    "src": "9889:70:0"
                },
                {
                    "attributes": {
                        "anonymous": false,
                        "name": "Approval"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "owner",
                                        "scope": 582,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 575,
                                            "name": "ElementaryTypeName",
                                            "src": "9981:7:0"
                                        }
                                    ],
                                    "id": 576,
                                    "name": "VariableDeclaration",
                                    "src": "9981:21:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "spender",
                                        "scope": 582,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 577,
                                            "name": "ElementaryTypeName",
                                            "src": "10004:7:0"
                                        }
                                    ],
                                    "id": 578,
                                    "name": "VariableDeclaration",
                                    "src": "10004:23:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": false,
                                        "name": "value",
                                        "scope": 582,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 579,
                                            "name": "ElementaryTypeName",
                                            "src": "10029:4:0"
                                        }
                                    ],
                                    "id": 580,
                                    "name": "VariableDeclaration",
                                    "src": "10029:10:0"
                                }
                            ],
                            "id": 581,
                            "name": "ParameterList",
                            "src": "9979:61:0"
                        }
                    ],
                    "id": 582,
                    "name": "EventDefinition",
                    "src": "9965:76:0"
                }
            ],
            "id": 583,
            "name": "ContractDefinition",
            "src": "9385:659:0"
        },
        {
            "attributes": {
                "contractDependencies": [
                    430,
                    583
                ],
                "contractKind": "contract",
                "documentation": "/// lib/ds-token/src/base.sol\r\n base.sol -- basic ERC20 implementation\r",
                "fullyImplemented": true,
                "linearizedBaseContracts": [
                    763,
                    430,
                    583
                ],
                "name": "DSTokenBase",
                "scope": 1103
            },
            "children": [
                {
                    "attributes": {
                        "arguments": [
                            null
                        ]
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "ERC20",
                                "referencedDeclaration": 583,
                                "type": "contract ERC20"
                            },
                            "id": 584,
                            "name": "UserDefinedTypeName",
                            "src": "10962:5:0"
                        }
                    ],
                    "id": 585,
                    "name": "InheritanceSpecifier",
                    "src": "10962:5:0"
                },
                {
                    "attributes": {
                        "arguments": [
                            null
                        ]
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSMath",
                                "referencedDeclaration": 430,
                                "type": "contract DSMath"
                            },
                            "id": 586,
                            "name": "UserDefinedTypeName",
                            "src": "10969:6:0"
                        }
                    ],
                    "id": 587,
                    "name": "InheritanceSpecifier",
                    "src": "10969:6:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "name": "_supply",
                        "scope": 763,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "uint256",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "attributes": {
                                "name": "uint256",
                                "type": "uint256"
                            },
                            "id": 588,
                            "name": "ElementaryTypeName",
                            "src": "10983:7:0"
                        }
                    ],
                    "id": 589,
                    "name": "VariableDeclaration",
                    "src": "10983:58:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "name": "_balances",
                        "scope": 763,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "mapping(address => uint256)",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "attributes": {
                                "type": "mapping(address => uint256)"
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "name": "address",
                                        "type": "address"
                                    },
                                    "id": 590,
                                    "name": "ElementaryTypeName",
                                    "src": "11057:7:0"
                                },
                                {
                                    "attributes": {
                                        "name": "uint256",
                                        "type": "uint256"
                                    },
                                    "id": 591,
                                    "name": "ElementaryTypeName",
                                    "src": "11068:7:0"
                                }
                            ],
                            "id": 592,
                            "name": "Mapping",
                            "src": "11048:28:0"
                        }
                    ],
                    "id": 593,
                    "name": "VariableDeclaration",
                    "src": "11048:60:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "name": "_approvals",
                        "scope": 763,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "mapping(address => mapping(address => uint256))",
                        "value": null,
                        "visibility": "internal"
                    },
                    "children": [
                        {
                            "attributes": {
                                "type": "mapping(address => mapping(address => uint256))"
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "name": "address",
                                        "type": "address"
                                    },
                                    "id": 594,
                                    "name": "ElementaryTypeName",
                                    "src": "11124:7:0"
                                },
                                {
                                    "attributes": {
                                        "type": "mapping(address => uint256)"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 595,
                                            "name": "ElementaryTypeName",
                                            "src": "11144:7:0"
                                        },
                                        {
                                            "attributes": {
                                                "name": "uint256",
                                                "type": "uint256"
                                            },
                                            "id": 596,
                                            "name": "ElementaryTypeName",
                                            "src": "11155:7:0"
                                        }
                                    ],
                                    "id": 597,
                                    "name": "Mapping",
                                    "src": "11135:28:0"
                                }
                            ],
                            "id": 598,
                            "name": "Mapping",
                            "src": "11115:49:0"
                        }
                    ],
                    "id": 599,
                    "name": "VariableDeclaration",
                    "src": "11115:61:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": true,
                        "modifiers": [
                            null
                        ],
                        "name": "DSTokenBase",
                        "payable": false,
                        "scope": 763,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "supply",
                                        "scope": 616,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 600,
                                            "name": "ElementaryTypeName",
                                            "src": "11206:4:0"
                                        }
                                    ],
                                    "id": 601,
                                    "name": "VariableDeclaration",
                                    "src": "11206:11:0"
                                }
                            ],
                            "id": 602,
                            "name": "ParameterList",
                            "src": "11205:13:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 603,
                            "name": "ParameterList",
                            "src": "11226:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": true,
                                                        "isPure": false,
                                                        "lValueRequested": true,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 593,
                                                                "type": "mapping(address => uint256)",
                                                                "value": "_balances"
                                                            },
                                                            "id": 604,
                                                            "name": "Identifier",
                                                            "src": "11237:9:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "member_name": "sender",
                                                                "referencedDeclaration": null,
                                                                "type": "address"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 1114,
                                                                        "type": "msg",
                                                                        "value": "msg"
                                                                    },
                                                                    "id": 605,
                                                                    "name": "Identifier",
                                                                    "src": "11247:3:0"
                                                                }
                                                            ],
                                                            "id": 606,
                                                            "name": "MemberAccess",
                                                            "src": "11247:10:0"
                                                        }
                                                    ],
                                                    "id": 607,
                                                    "name": "IndexAccess",
                                                    "src": "11237:21:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 601,
                                                        "type": "uint256",
                                                        "value": "supply"
                                                    },
                                                    "id": 608,
                                                    "name": "Identifier",
                                                    "src": "11261:6:0"
                                                }
                                            ],
                                            "id": 609,
                                            "name": "Assignment",
                                            "src": "11237:30:0"
                                        }
                                    ],
                                    "id": 610,
                                    "name": "ExpressionStatement",
                                    "src": "11237:30:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 589,
                                                        "type": "uint256",
                                                        "value": "_supply"
                                                    },
                                                    "id": 611,
                                                    "name": "Identifier",
                                                    "src": "11278:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 601,
                                                        "type": "uint256",
                                                        "value": "supply"
                                                    },
                                                    "id": 612,
                                                    "name": "Identifier",
                                                    "src": "11288:6:0"
                                                }
                                            ],
                                            "id": 613,
                                            "name": "Assignment",
                                            "src": "11278:16:0"
                                        }
                                    ],
                                    "id": 614,
                                    "name": "ExpressionStatement",
                                    "src": "11278:16:0"
                                }
                            ],
                            "id": 615,
                            "name": "Block",
                            "src": "11226:76:0"
                        }
                    ],
                    "id": 616,
                    "name": "FunctionDefinition",
                    "src": "11185:117:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "totalSupply",
                        "payable": false,
                        "scope": 763,
                        "stateMutability": "view",
                        "superFunction": 521,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 617,
                            "name": "ParameterList",
                            "src": "11330:2:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 624,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 618,
                                            "name": "ElementaryTypeName",
                                            "src": "11354:4:0"
                                        }
                                    ],
                                    "id": 619,
                                    "name": "VariableDeclaration",
                                    "src": "11354:4:0"
                                }
                            ],
                            "id": 620,
                            "name": "ParameterList",
                            "src": "11353:6:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 620
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "overloadedDeclarations": [
                                                    null
                                                ],
                                                "referencedDeclaration": 589,
                                                "type": "uint256",
                                                "value": "_supply"
                                            },
                                            "id": 621,
                                            "name": "Identifier",
                                            "src": "11378:7:0"
                                        }
                                    ],
                                    "id": 622,
                                    "name": "Return",
                                    "src": "11371:14:0"
                                }
                            ],
                            "id": 623,
                            "name": "Block",
                            "src": "11360:33:0"
                        }
                    ],
                    "id": 624,
                    "name": "FunctionDefinition",
                    "src": "11310:83:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "balanceOf",
                        "payable": false,
                        "scope": 763,
                        "stateMutability": "view",
                        "superFunction": 528,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "src",
                                        "scope": 636,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 625,
                                            "name": "ElementaryTypeName",
                                            "src": "11418:7:0"
                                        }
                                    ],
                                    "id": 626,
                                    "name": "VariableDeclaration",
                                    "src": "11418:11:0"
                                }
                            ],
                            "id": 627,
                            "name": "ParameterList",
                            "src": "11417:13:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 636,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 628,
                                            "name": "ElementaryTypeName",
                                            "src": "11452:4:0"
                                        }
                                    ],
                                    "id": 629,
                                    "name": "VariableDeclaration",
                                    "src": "11452:4:0"
                                }
                            ],
                            "id": 630,
                            "name": "ParameterList",
                            "src": "11451:6:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 630
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": true,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 593,
                                                        "type": "mapping(address => uint256)",
                                                        "value": "_balances"
                                                    },
                                                    "id": 631,
                                                    "name": "Identifier",
                                                    "src": "11476:9:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 626,
                                                        "type": "address",
                                                        "value": "src"
                                                    },
                                                    "id": 632,
                                                    "name": "Identifier",
                                                    "src": "11486:3:0"
                                                }
                                            ],
                                            "id": 633,
                                            "name": "IndexAccess",
                                            "src": "11476:14:0"
                                        }
                                    ],
                                    "id": 634,
                                    "name": "Return",
                                    "src": "11469:21:0"
                                }
                            ],
                            "id": 635,
                            "name": "Block",
                            "src": "11458:40:0"
                        }
                    ],
                    "id": 636,
                    "name": "FunctionDefinition",
                    "src": "11399:99:0"
                },
                {
                    "attributes": {
                        "constant": true,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "allowance",
                        "payable": false,
                        "scope": 763,
                        "stateMutability": "view",
                        "superFunction": 537,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "src",
                                        "scope": 652,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 637,
                                            "name": "ElementaryTypeName",
                                            "src": "11523:7:0"
                                        }
                                    ],
                                    "id": 638,
                                    "name": "VariableDeclaration",
                                    "src": "11523:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "guy",
                                        "scope": 652,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 639,
                                            "name": "ElementaryTypeName",
                                            "src": "11536:7:0"
                                        }
                                    ],
                                    "id": 640,
                                    "name": "VariableDeclaration",
                                    "src": "11536:11:0"
                                }
                            ],
                            "id": 641,
                            "name": "ParameterList",
                            "src": "11522:26:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 652,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 642,
                                            "name": "ElementaryTypeName",
                                            "src": "11570:4:0"
                                        }
                                    ],
                                    "id": 643,
                                    "name": "VariableDeclaration",
                                    "src": "11570:4:0"
                                }
                            ],
                            "id": 644,
                            "name": "ParameterList",
                            "src": "11569:6:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 644
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": true,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": true,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "type": "mapping(address => uint256)"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 599,
                                                                "type": "mapping(address => mapping(address => uint256))",
                                                                "value": "_approvals"
                                                            },
                                                            "id": 645,
                                                            "name": "Identifier",
                                                            "src": "11594:10:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 638,
                                                                "type": "address",
                                                                "value": "src"
                                                            },
                                                            "id": 646,
                                                            "name": "Identifier",
                                                            "src": "11605:3:0"
                                                        }
                                                    ],
                                                    "id": 647,
                                                    "name": "IndexAccess",
                                                    "src": "11594:15:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 640,
                                                        "type": "address",
                                                        "value": "guy"
                                                    },
                                                    "id": 648,
                                                    "name": "Identifier",
                                                    "src": "11610:3:0"
                                                }
                                            ],
                                            "id": 649,
                                            "name": "IndexAccess",
                                            "src": "11594:20:0"
                                        }
                                    ],
                                    "id": 650,
                                    "name": "Return",
                                    "src": "11587:27:0"
                                }
                            ],
                            "id": 651,
                            "name": "Block",
                            "src": "11576:46:0"
                        }
                    ],
                    "id": 652,
                    "name": "FunctionDefinition",
                    "src": "11504:118:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "transfer",
                        "payable": false,
                        "scope": 763,
                        "stateMutability": "nonpayable",
                        "superFunction": 546,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "dst",
                                        "scope": 669,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 653,
                                            "name": "ElementaryTypeName",
                                            "src": "11648:7:0"
                                        }
                                    ],
                                    "id": 654,
                                    "name": "VariableDeclaration",
                                    "src": "11648:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 669,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 655,
                                            "name": "ElementaryTypeName",
                                            "src": "11661:4:0"
                                        }
                                    ],
                                    "id": 656,
                                    "name": "VariableDeclaration",
                                    "src": "11661:8:0"
                                }
                            ],
                            "id": 657,
                            "name": "ParameterList",
                            "src": "11647:23:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 669,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 658,
                                            "name": "ElementaryTypeName",
                                            "src": "11687:4:0"
                                        }
                                    ],
                                    "id": 659,
                                    "name": "VariableDeclaration",
                                    "src": "11687:4:0"
                                }
                            ],
                            "id": 660,
                            "name": "ParameterList",
                            "src": "11686:6:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 660
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "bool",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            734
                                                        ],
                                                        "referencedDeclaration": 734,
                                                        "type": "function (address,address,uint256) returns (bool)",
                                                        "value": "transferFrom"
                                                    },
                                                    "id": 661,
                                                    "name": "Identifier",
                                                    "src": "11711:12:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 662,
                                                            "name": "Identifier",
                                                            "src": "11724:3:0"
                                                        }
                                                    ],
                                                    "id": 663,
                                                    "name": "MemberAccess",
                                                    "src": "11724:10:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 654,
                                                        "type": "address",
                                                        "value": "dst"
                                                    },
                                                    "id": 664,
                                                    "name": "Identifier",
                                                    "src": "11736:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 656,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 665,
                                                    "name": "Identifier",
                                                    "src": "11741:3:0"
                                                }
                                            ],
                                            "id": 666,
                                            "name": "FunctionCall",
                                            "src": "11711:34:0"
                                        }
                                    ],
                                    "id": 667,
                                    "name": "Return",
                                    "src": "11704:41:0"
                                }
                            ],
                            "id": 668,
                            "name": "Block",
                            "src": "11693:60:0"
                        }
                    ],
                    "id": 669,
                    "name": "FunctionDefinition",
                    "src": "11630:123:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "transferFrom",
                        "payable": false,
                        "scope": 763,
                        "stateMutability": "nonpayable",
                        "superFunction": 557,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "src",
                                        "scope": 734,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 670,
                                            "name": "ElementaryTypeName",
                                            "src": "11783:7:0"
                                        }
                                    ],
                                    "id": 671,
                                    "name": "VariableDeclaration",
                                    "src": "11783:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "dst",
                                        "scope": 734,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 672,
                                            "name": "ElementaryTypeName",
                                            "src": "11796:7:0"
                                        }
                                    ],
                                    "id": 673,
                                    "name": "VariableDeclaration",
                                    "src": "11796:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 734,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 674,
                                            "name": "ElementaryTypeName",
                                            "src": "11809:4:0"
                                        }
                                    ],
                                    "id": 675,
                                    "name": "VariableDeclaration",
                                    "src": "11809:8:0"
                                }
                            ],
                            "id": 676,
                            "name": "ParameterList",
                            "src": "11782:36:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 734,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 677,
                                            "name": "ElementaryTypeName",
                                            "src": "11853:4:0"
                                        }
                                    ],
                                    "id": 678,
                                    "name": "VariableDeclaration",
                                    "src": "11853:4:0"
                                }
                            ],
                            "id": 679,
                            "name": "ParameterList",
                            "src": "11852:6:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "falseBody": null
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "commonType": {
                                                    "typeIdentifier": "t_address",
                                                    "typeString": "address"
                                                },
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "!=",
                                                "type": "bool"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 671,
                                                        "type": "address",
                                                        "value": "src"
                                                    },
                                                    "id": 680,
                                                    "name": "Identifier",
                                                    "src": "11879:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 681,
                                                            "name": "Identifier",
                                                            "src": "11886:3:0"
                                                        }
                                                    ],
                                                    "id": 682,
                                                    "name": "MemberAccess",
                                                    "src": "11886:10:0"
                                                }
                                            ],
                                            "id": 683,
                                            "name": "BinaryOperation",
                                            "src": "11879:17:0"
                                        },
                                        {
                                            "children": [
                                                {
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "operator": "=",
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": true,
                                                                        "isPure": false,
                                                                        "lValueRequested": true,
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": true,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "type": "mapping(address => uint256)"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 599,
                                                                                        "type": "mapping(address => mapping(address => uint256))",
                                                                                        "value": "_approvals"
                                                                                    },
                                                                                    "id": 684,
                                                                                    "name": "Identifier",
                                                                                    "src": "11913:10:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 671,
                                                                                        "type": "address",
                                                                                        "value": "src"
                                                                                    },
                                                                                    "id": 685,
                                                                                    "name": "Identifier",
                                                                                    "src": "11924:3:0"
                                                                                }
                                                                            ],
                                                                            "id": 688,
                                                                            "name": "IndexAccess",
                                                                            "src": "11913:15:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "member_name": "sender",
                                                                                "referencedDeclaration": null,
                                                                                "type": "address"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 1114,
                                                                                        "type": "msg",
                                                                                        "value": "msg"
                                                                                    },
                                                                                    "id": 686,
                                                                                    "name": "Identifier",
                                                                                    "src": "11929:3:0"
                                                                                }
                                                                            ],
                                                                            "id": 687,
                                                                            "name": "MemberAccess",
                                                                            "src": "11929:10:0"
                                                                        }
                                                                    ],
                                                                    "id": 689,
                                                                    "name": "IndexAccess",
                                                                    "src": "11913:27:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "isStructConstructorCall": false,
                                                                        "lValueRequested": false,
                                                                        "names": [
                                                                            null
                                                                        ],
                                                                        "type": "uint256",
                                                                        "type_conversion": false
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": [
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    },
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    }
                                                                                ],
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 173,
                                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                                "value": "sub"
                                                                            },
                                                                            "id": 690,
                                                                            "name": "Identifier",
                                                                            "src": "11943:3:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": true,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "type": "uint256"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "isConstant": false,
                                                                                        "isLValue": true,
                                                                                        "isPure": false,
                                                                                        "lValueRequested": false,
                                                                                        "type": "mapping(address => uint256)"
                                                                                    },
                                                                                    "children": [
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 599,
                                                                                                "type": "mapping(address => mapping(address => uint256))",
                                                                                                "value": "_approvals"
                                                                                            },
                                                                                            "id": 691,
                                                                                            "name": "Identifier",
                                                                                            "src": "11947:10:0"
                                                                                        },
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 671,
                                                                                                "type": "address",
                                                                                                "value": "src"
                                                                                            },
                                                                                            "id": 692,
                                                                                            "name": "Identifier",
                                                                                            "src": "11958:3:0"
                                                                                        }
                                                                                    ],
                                                                                    "id": 693,
                                                                                    "name": "IndexAccess",
                                                                                    "src": "11947:15:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "isConstant": false,
                                                                                        "isLValue": false,
                                                                                        "isPure": false,
                                                                                        "lValueRequested": false,
                                                                                        "member_name": "sender",
                                                                                        "referencedDeclaration": null,
                                                                                        "type": "address"
                                                                                    },
                                                                                    "children": [
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 1114,
                                                                                                "type": "msg",
                                                                                                "value": "msg"
                                                                                            },
                                                                                            "id": 694,
                                                                                            "name": "Identifier",
                                                                                            "src": "11963:3:0"
                                                                                        }
                                                                                    ],
                                                                                    "id": 695,
                                                                                    "name": "MemberAccess",
                                                                                    "src": "11963:10:0"
                                                                                }
                                                                            ],
                                                                            "id": 696,
                                                                            "name": "IndexAccess",
                                                                            "src": "11947:27:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 675,
                                                                                "type": "uint256",
                                                                                "value": "wad"
                                                                            },
                                                                            "id": 697,
                                                                            "name": "Identifier",
                                                                            "src": "11976:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 698,
                                                                    "name": "FunctionCall",
                                                                    "src": "11943:37:0"
                                                                }
                                                            ],
                                                            "id": 699,
                                                            "name": "Assignment",
                                                            "src": "11913:67:0"
                                                        }
                                                    ],
                                                    "id": 700,
                                                    "name": "ExpressionStatement",
                                                    "src": "11913:67:0"
                                                }
                                            ],
                                            "id": 701,
                                            "name": "Block",
                                            "src": "11898:94:0"
                                        }
                                    ],
                                    "id": 702,
                                    "name": "IfStatement",
                                    "src": "11875:117:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": true,
                                                        "isPure": false,
                                                        "lValueRequested": true,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 593,
                                                                "type": "mapping(address => uint256)",
                                                                "value": "_balances"
                                                            },
                                                            "id": 703,
                                                            "name": "Identifier",
                                                            "src": "12004:9:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 671,
                                                                "type": "address",
                                                                "value": "src"
                                                            },
                                                            "id": 704,
                                                            "name": "Identifier",
                                                            "src": "12014:3:0"
                                                        }
                                                    ],
                                                    "id": 705,
                                                    "name": "IndexAccess",
                                                    "src": "12004:14:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "uint256",
                                                        "type_conversion": false
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    },
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    }
                                                                ],
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 173,
                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                "value": "sub"
                                                            },
                                                            "id": 706,
                                                            "name": "Identifier",
                                                            "src": "12021:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": true,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 593,
                                                                        "type": "mapping(address => uint256)",
                                                                        "value": "_balances"
                                                                    },
                                                                    "id": 707,
                                                                    "name": "Identifier",
                                                                    "src": "12025:9:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 671,
                                                                        "type": "address",
                                                                        "value": "src"
                                                                    },
                                                                    "id": 708,
                                                                    "name": "Identifier",
                                                                    "src": "12035:3:0"
                                                                }
                                                            ],
                                                            "id": 709,
                                                            "name": "IndexAccess",
                                                            "src": "12025:14:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 675,
                                                                "type": "uint256",
                                                                "value": "wad"
                                                            },
                                                            "id": 710,
                                                            "name": "Identifier",
                                                            "src": "12041:3:0"
                                                        }
                                                    ],
                                                    "id": 711,
                                                    "name": "FunctionCall",
                                                    "src": "12021:24:0"
                                                }
                                            ],
                                            "id": 712,
                                            "name": "Assignment",
                                            "src": "12004:41:0"
                                        }
                                    ],
                                    "id": 713,
                                    "name": "ExpressionStatement",
                                    "src": "12004:41:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": true,
                                                        "isPure": false,
                                                        "lValueRequested": true,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 593,
                                                                "type": "mapping(address => uint256)",
                                                                "value": "_balances"
                                                            },
                                                            "id": 714,
                                                            "name": "Identifier",
                                                            "src": "12056:9:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 673,
                                                                "type": "address",
                                                                "value": "dst"
                                                            },
                                                            "id": 715,
                                                            "name": "Identifier",
                                                            "src": "12066:3:0"
                                                        }
                                                    ],
                                                    "id": 716,
                                                    "name": "IndexAccess",
                                                    "src": "12056:14:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "uint256",
                                                        "type_conversion": false
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    },
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    }
                                                                ],
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 152,
                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                "value": "add"
                                                            },
                                                            "id": 717,
                                                            "name": "Identifier",
                                                            "src": "12073:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": true,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 593,
                                                                        "type": "mapping(address => uint256)",
                                                                        "value": "_balances"
                                                                    },
                                                                    "id": 718,
                                                                    "name": "Identifier",
                                                                    "src": "12077:9:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 673,
                                                                        "type": "address",
                                                                        "value": "dst"
                                                                    },
                                                                    "id": 719,
                                                                    "name": "Identifier",
                                                                    "src": "12087:3:0"
                                                                }
                                                            ],
                                                            "id": 720,
                                                            "name": "IndexAccess",
                                                            "src": "12077:14:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 675,
                                                                "type": "uint256",
                                                                "value": "wad"
                                                            },
                                                            "id": 721,
                                                            "name": "Identifier",
                                                            "src": "12093:3:0"
                                                        }
                                                    ],
                                                    "id": 722,
                                                    "name": "FunctionCall",
                                                    "src": "12073:24:0"
                                                }
                                            ],
                                            "id": 723,
                                            "name": "Assignment",
                                            "src": "12056:41:0"
                                        }
                                    ],
                                    "id": 724,
                                    "name": "ExpressionStatement",
                                    "src": "12056:41:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 574,
                                                        "type": "function (address,address,uint256)",
                                                        "value": "Transfer"
                                                    },
                                                    "id": 725,
                                                    "name": "Identifier",
                                                    "src": "12110:8:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 671,
                                                        "type": "address",
                                                        "value": "src"
                                                    },
                                                    "id": 726,
                                                    "name": "Identifier",
                                                    "src": "12119:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 673,
                                                        "type": "address",
                                                        "value": "dst"
                                                    },
                                                    "id": 727,
                                                    "name": "Identifier",
                                                    "src": "12124:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 675,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 728,
                                                    "name": "Identifier",
                                                    "src": "12129:3:0"
                                                }
                                            ],
                                            "id": 729,
                                            "name": "FunctionCall",
                                            "src": "12110:23:0"
                                        }
                                    ],
                                    "id": 730,
                                    "name": "ExpressionStatement",
                                    "src": "12110:23:0"
                                },
                                {
                                    "attributes": {
                                        "functionReturnParameters": 679
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "hexvalue": "74727565",
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": true,
                                                "lValueRequested": false,
                                                "subdenomination": null,
                                                "token": "bool",
                                                "type": "bool",
                                                "value": "true"
                                            },
                                            "id": 731,
                                            "name": "Literal",
                                            "src": "12153:4:0"
                                        }
                                    ],
                                    "id": 732,
                                    "name": "Return",
                                    "src": "12146:11:0"
                                }
                            ],
                            "id": 733,
                            "name": "Block",
                            "src": "11864:301:0"
                        }
                    ],
                    "id": 734,
                    "name": "FunctionDefinition",
                    "src": "11761:404:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "approve",
                        "payable": false,
                        "scope": 763,
                        "stateMutability": "nonpayable",
                        "superFunction": 566,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "guy",
                                        "scope": 762,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 735,
                                            "name": "ElementaryTypeName",
                                            "src": "12190:7:0"
                                        }
                                    ],
                                    "id": 736,
                                    "name": "VariableDeclaration",
                                    "src": "12190:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 762,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 737,
                                            "name": "ElementaryTypeName",
                                            "src": "12203:4:0"
                                        }
                                    ],
                                    "id": 738,
                                    "name": "VariableDeclaration",
                                    "src": "12203:8:0"
                                }
                            ],
                            "id": 739,
                            "name": "ParameterList",
                            "src": "12189:23:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 762,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 740,
                                            "name": "ElementaryTypeName",
                                            "src": "12229:4:0"
                                        }
                                    ],
                                    "id": 741,
                                    "name": "VariableDeclaration",
                                    "src": "12229:4:0"
                                }
                            ],
                            "id": 742,
                            "name": "ParameterList",
                            "src": "12228:6:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": true,
                                                        "isPure": false,
                                                        "lValueRequested": true,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": true,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "mapping(address => uint256)"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 599,
                                                                        "type": "mapping(address => mapping(address => uint256))",
                                                                        "value": "_approvals"
                                                                    },
                                                                    "id": 743,
                                                                    "name": "Identifier",
                                                                    "src": "12246:10:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "member_name": "sender",
                                                                        "referencedDeclaration": null,
                                                                        "type": "address"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 1114,
                                                                                "type": "msg",
                                                                                "value": "msg"
                                                                            },
                                                                            "id": 744,
                                                                            "name": "Identifier",
                                                                            "src": "12257:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 745,
                                                                    "name": "MemberAccess",
                                                                    "src": "12257:10:0"
                                                                }
                                                            ],
                                                            "id": 747,
                                                            "name": "IndexAccess",
                                                            "src": "12246:22:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 736,
                                                                "type": "address",
                                                                "value": "guy"
                                                            },
                                                            "id": 746,
                                                            "name": "Identifier",
                                                            "src": "12269:3:0"
                                                        }
                                                    ],
                                                    "id": 748,
                                                    "name": "IndexAccess",
                                                    "src": "12246:27:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 738,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 749,
                                                    "name": "Identifier",
                                                    "src": "12276:3:0"
                                                }
                                            ],
                                            "id": 750,
                                            "name": "Assignment",
                                            "src": "12246:33:0"
                                        }
                                    ],
                                    "id": 751,
                                    "name": "ExpressionStatement",
                                    "src": "12246:33:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 582,
                                                        "type": "function (address,address,uint256)",
                                                        "value": "Approval"
                                                    },
                                                    "id": 752,
                                                    "name": "Identifier",
                                                    "src": "12292:8:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 753,
                                                            "name": "Identifier",
                                                            "src": "12301:3:0"
                                                        }
                                                    ],
                                                    "id": 754,
                                                    "name": "MemberAccess",
                                                    "src": "12301:10:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 736,
                                                        "type": "address",
                                                        "value": "guy"
                                                    },
                                                    "id": 755,
                                                    "name": "Identifier",
                                                    "src": "12313:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 738,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 756,
                                                    "name": "Identifier",
                                                    "src": "12318:3:0"
                                                }
                                            ],
                                            "id": 757,
                                            "name": "FunctionCall",
                                            "src": "12292:30:0"
                                        }
                                    ],
                                    "id": 758,
                                    "name": "ExpressionStatement",
                                    "src": "12292:30:0"
                                },
                                {
                                    "attributes": {
                                        "functionReturnParameters": 742
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "hexvalue": "74727565",
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": true,
                                                "lValueRequested": false,
                                                "subdenomination": null,
                                                "token": "bool",
                                                "type": "bool",
                                                "value": "true"
                                            },
                                            "id": 759,
                                            "name": "Literal",
                                            "src": "12342:4:0"
                                        }
                                    ],
                                    "id": 760,
                                    "name": "Return",
                                    "src": "12335:11:0"
                                }
                            ],
                            "id": 761,
                            "name": "Block",
                            "src": "12235:119:0"
                        }
                    ],
                    "id": 762,
                    "name": "FunctionDefinition",
                    "src": "12173:181:0"
                }
            ],
            "id": 763,
            "name": "ContractDefinition",
            "src": "10938:1419:0"
        },
        {
            "attributes": {
                "contractDependencies": [
                    22,
                    131,
                    430,
                    469,
                    516,
                    583,
                    763
                ],
                "contractKind": "contract",
                "documentation": "/// lib/ds-token/src/token.sol\r\n token.sol -- ERC20 implementation with minting and burning\r",
                "fullyImplemented": true,
                "linearizedBaseContracts": [
                    1102,
                    516,
                    131,
                    22,
                    469,
                    763,
                    430,
                    583
                ],
                "name": "DSToken",
                "scope": 1103
            },
            "children": [
                {
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSTokenBase",
                                "referencedDeclaration": 763,
                                "type": "contract DSTokenBase"
                            },
                            "id": 764,
                            "name": "UserDefinedTypeName",
                            "src": "13289:11:0"
                        },
                        {
                            "attributes": {
                                "argumentTypes": null,
                                "hexvalue": "30",
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": true,
                                "lValueRequested": false,
                                "subdenomination": null,
                                "token": "number",
                                "type": "int_const 0",
                                "value": "0"
                            },
                            "id": 765,
                            "name": "Literal",
                            "src": "13301:1:0"
                        }
                    ],
                    "id": 766,
                    "name": "InheritanceSpecifier",
                    "src": "13289:14:0"
                },
                {
                    "attributes": {
                        "arguments": [
                            null
                        ]
                    },
                    "children": [
                        {
                            "attributes": {
                                "contractScope": null,
                                "name": "DSStop",
                                "referencedDeclaration": 516,
                                "type": "contract DSStop"
                            },
                            "id": 767,
                            "name": "UserDefinedTypeName",
                            "src": "13305:6:0"
                        }
                    ],
                    "id": 768,
                    "name": "InheritanceSpecifier",
                    "src": "13305:6:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "name": "symbol",
                        "scope": 1102,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "bytes32",
                        "value": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "name": "bytes32",
                                "type": "bytes32"
                            },
                            "id": 769,
                            "name": "ElementaryTypeName",
                            "src": "13321:7:0"
                        }
                    ],
                    "id": 770,
                    "name": "VariableDeclaration",
                    "src": "13321:23:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "name": "decimals",
                        "scope": 1102,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "uint256",
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "name": "uint256",
                                "type": "uint256"
                            },
                            "id": 771,
                            "name": "ElementaryTypeName",
                            "src": "13351:7:0"
                        },
                        {
                            "attributes": {
                                "argumentTypes": null,
                                "hexvalue": "3138",
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": true,
                                "lValueRequested": false,
                                "subdenomination": null,
                                "token": "number",
                                "type": "int_const 18",
                                "value": "18"
                            },
                            "id": 772,
                            "name": "Literal",
                            "src": "13379:2:0"
                        }
                    ],
                    "id": 773,
                    "name": "VariableDeclaration",
                    "src": "13351:30:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": true,
                        "modifiers": [
                            null
                        ],
                        "name": "DSToken",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "symbol_",
                                        "scope": 783,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bytes32",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bytes32",
                                                "type": "bytes32"
                                            },
                                            "id": 774,
                                            "name": "ElementaryTypeName",
                                            "src": "13458:7:0"
                                        }
                                    ],
                                    "id": 775,
                                    "name": "VariableDeclaration",
                                    "src": "13458:15:0"
                                }
                            ],
                            "id": 776,
                            "name": "ParameterList",
                            "src": "13457:17:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 777,
                            "name": "ParameterList",
                            "src": "13482:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "bytes32"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 770,
                                                        "type": "bytes32",
                                                        "value": "symbol"
                                                    },
                                                    "id": 778,
                                                    "name": "Identifier",
                                                    "src": "13493:6:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 775,
                                                        "type": "bytes32",
                                                        "value": "symbol_"
                                                    },
                                                    "id": 779,
                                                    "name": "Identifier",
                                                    "src": "13502:7:0"
                                                }
                                            ],
                                            "id": 780,
                                            "name": "Assignment",
                                            "src": "13493:16:0"
                                        }
                                    ],
                                    "id": 781,
                                    "name": "ExpressionStatement",
                                    "src": "13493:16:0"
                                }
                            ],
                            "id": 782,
                            "name": "Block",
                            "src": "13482:35:0"
                        }
                    ],
                    "id": 783,
                    "name": "FunctionDefinition",
                    "src": "13441:76:0"
                },
                {
                    "attributes": {
                        "anonymous": false,
                        "name": "Mint"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "guy",
                                        "scope": 789,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 784,
                                            "name": "ElementaryTypeName",
                                            "src": "13536:7:0"
                                        }
                                    ],
                                    "id": 785,
                                    "name": "VariableDeclaration",
                                    "src": "13536:19:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": false,
                                        "name": "wad",
                                        "scope": 789,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 786,
                                            "name": "ElementaryTypeName",
                                            "src": "13557:4:0"
                                        }
                                    ],
                                    "id": 787,
                                    "name": "VariableDeclaration",
                                    "src": "13557:8:0"
                                }
                            ],
                            "id": 788,
                            "name": "ParameterList",
                            "src": "13535:31:0"
                        }
                    ],
                    "id": 789,
                    "name": "EventDefinition",
                    "src": "13525:42:0"
                },
                {
                    "attributes": {
                        "anonymous": false,
                        "name": "Burn"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": true,
                                        "name": "guy",
                                        "scope": 795,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 790,
                                            "name": "ElementaryTypeName",
                                            "src": "13584:7:0"
                                        }
                                    ],
                                    "id": 791,
                                    "name": "VariableDeclaration",
                                    "src": "13584:19:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "indexed": false,
                                        "name": "wad",
                                        "scope": 795,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 792,
                                            "name": "ElementaryTypeName",
                                            "src": "13605:4:0"
                                        }
                                    ],
                                    "id": 793,
                                    "name": "VariableDeclaration",
                                    "src": "13605:8:0"
                                }
                            ],
                            "id": 794,
                            "name": "ParameterList",
                            "src": "13583:31:0"
                        }
                    ],
                    "id": 795,
                    "name": "EventDefinition",
                    "src": "13573:42:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "approve",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "guy",
                                        "scope": 814,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 796,
                                            "name": "ElementaryTypeName",
                                            "src": "13640:7:0"
                                        }
                                    ],
                                    "id": 797,
                                    "name": "VariableDeclaration",
                                    "src": "13640:11:0"
                                }
                            ],
                            "id": 798,
                            "name": "ParameterList",
                            "src": "13639:13:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 814,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 801,
                                            "name": "ElementaryTypeName",
                                            "src": "13679:4:0"
                                        }
                                    ],
                                    "id": 802,
                                    "name": "VariableDeclaration",
                                    "src": "13679:4:0"
                                }
                            ],
                            "id": 803,
                            "name": "ParameterList",
                            "src": "13678:6:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 491,
                                        "type": "modifier ()",
                                        "value": "stoppable"
                                    },
                                    "id": 799,
                                    "name": "Identifier",
                                    "src": "13660:9:0"
                                }
                            ],
                            "id": 800,
                            "name": "ModifierInvocation",
                            "src": "13660:9:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 803
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "bool",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "approve",
                                                        "referencedDeclaration": 762,
                                                        "type": "function (address,uint256) returns (bool)"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1144,
                                                                "type": "contract super DSToken",
                                                                "value": "super"
                                                            },
                                                            "id": 804,
                                                            "name": "Identifier",
                                                            "src": "13703:5:0"
                                                        }
                                                    ],
                                                    "id": 805,
                                                    "name": "MemberAccess",
                                                    "src": "13703:13:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 797,
                                                        "type": "address",
                                                        "value": "guy"
                                                    },
                                                    "id": 806,
                                                    "name": "Identifier",
                                                    "src": "13717:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": true,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "uint256",
                                                        "type_conversion": true
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_rational_-1_by_1",
                                                                        "typeString": "int_const -1"
                                                                    }
                                                                ],
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": true,
                                                                "lValueRequested": false,
                                                                "type": "type(uint256)",
                                                                "value": "uint"
                                                            },
                                                            "id": 807,
                                                            "name": "ElementaryTypeNameExpression",
                                                            "src": "13722:4:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": true,
                                                                "lValueRequested": false,
                                                                "operator": "-",
                                                                "prefix": true,
                                                                "type": "int_const -1"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "hexvalue": "31",
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "subdenomination": null,
                                                                        "token": "number",
                                                                        "type": "int_const 1",
                                                                        "value": "1"
                                                                    },
                                                                    "id": 808,
                                                                    "name": "Literal",
                                                                    "src": "13728:1:0"
                                                                }
                                                            ],
                                                            "id": 809,
                                                            "name": "UnaryOperation",
                                                            "src": "13727:2:0"
                                                        }
                                                    ],
                                                    "id": 810,
                                                    "name": "FunctionCall",
                                                    "src": "13722:8:0"
                                                }
                                            ],
                                            "id": 811,
                                            "name": "FunctionCall",
                                            "src": "13703:28:0"
                                        }
                                    ],
                                    "id": 812,
                                    "name": "Return",
                                    "src": "13696:35:0"
                                }
                            ],
                            "id": 813,
                            "name": "Block",
                            "src": "13685:54:0"
                        }
                    ],
                    "id": 814,
                    "name": "FunctionDefinition",
                    "src": "13623:116:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "approve",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": 762,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "guy",
                                        "scope": 832,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 815,
                                            "name": "ElementaryTypeName",
                                            "src": "13764:7:0"
                                        }
                                    ],
                                    "id": 816,
                                    "name": "VariableDeclaration",
                                    "src": "13764:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 832,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 817,
                                            "name": "ElementaryTypeName",
                                            "src": "13777:4:0"
                                        }
                                    ],
                                    "id": 818,
                                    "name": "VariableDeclaration",
                                    "src": "13777:8:0"
                                }
                            ],
                            "id": 819,
                            "name": "ParameterList",
                            "src": "13763:23:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 832,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 822,
                                            "name": "ElementaryTypeName",
                                            "src": "13813:4:0"
                                        }
                                    ],
                                    "id": 823,
                                    "name": "VariableDeclaration",
                                    "src": "13813:4:0"
                                }
                            ],
                            "id": 824,
                            "name": "ParameterList",
                            "src": "13812:6:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 491,
                                        "type": "modifier ()",
                                        "value": "stoppable"
                                    },
                                    "id": 820,
                                    "name": "Identifier",
                                    "src": "13794:9:0"
                                }
                            ],
                            "id": 821,
                            "name": "ModifierInvocation",
                            "src": "13794:9:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "functionReturnParameters": 824
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "bool",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "approve",
                                                        "referencedDeclaration": 762,
                                                        "type": "function (address,uint256) returns (bool)"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1144,
                                                                "type": "contract super DSToken",
                                                                "value": "super"
                                                            },
                                                            "id": 825,
                                                            "name": "Identifier",
                                                            "src": "13837:5:0"
                                                        }
                                                    ],
                                                    "id": 826,
                                                    "name": "MemberAccess",
                                                    "src": "13837:13:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 816,
                                                        "type": "address",
                                                        "value": "guy"
                                                    },
                                                    "id": 827,
                                                    "name": "Identifier",
                                                    "src": "13851:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 818,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 828,
                                                    "name": "Identifier",
                                                    "src": "13856:3:0"
                                                }
                                            ],
                                            "id": 829,
                                            "name": "FunctionCall",
                                            "src": "13837:23:0"
                                        }
                                    ],
                                    "id": 830,
                                    "name": "Return",
                                    "src": "13830:30:0"
                                }
                            ],
                            "id": 831,
                            "name": "Block",
                            "src": "13819:49:0"
                        }
                    ],
                    "id": 832,
                    "name": "FunctionDefinition",
                    "src": "13747:121:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "transferFrom",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": 734,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "src",
                                        "scope": 911,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 833,
                                            "name": "ElementaryTypeName",
                                            "src": "13898:7:0"
                                        }
                                    ],
                                    "id": 834,
                                    "name": "VariableDeclaration",
                                    "src": "13898:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "dst",
                                        "scope": 911,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 835,
                                            "name": "ElementaryTypeName",
                                            "src": "13911:7:0"
                                        }
                                    ],
                                    "id": 836,
                                    "name": "VariableDeclaration",
                                    "src": "13911:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 911,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 837,
                                            "name": "ElementaryTypeName",
                                            "src": "13924:4:0"
                                        }
                                    ],
                                    "id": 838,
                                    "name": "VariableDeclaration",
                                    "src": "13924:8:0"
                                }
                            ],
                            "id": 839,
                            "name": "ParameterList",
                            "src": "13897:36:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "",
                                        "scope": 911,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bool",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bool",
                                                "type": "bool"
                                            },
                                            "id": 842,
                                            "name": "ElementaryTypeName",
                                            "src": "13987:4:0"
                                        }
                                    ],
                                    "id": 843,
                                    "name": "VariableDeclaration",
                                    "src": "13987:4:0"
                                }
                            ],
                            "id": 844,
                            "name": "ParameterList",
                            "src": "13986:6:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 491,
                                        "type": "modifier ()",
                                        "value": "stoppable"
                                    },
                                    "id": 840,
                                    "name": "Identifier",
                                    "src": "13959:9:0"
                                }
                            ],
                            "id": 841,
                            "name": "ModifierInvocation",
                            "src": "13959:9:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "falseBody": null
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "commonType": {
                                                    "typeIdentifier": "t_bool",
                                                    "typeString": "bool"
                                                },
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "&&",
                                                "type": "bool"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_address",
                                                            "typeString": "address"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "!=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 834,
                                                                "type": "address",
                                                                "value": "src"
                                                            },
                                                            "id": 845,
                                                            "name": "Identifier",
                                                            "src": "14013:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "member_name": "sender",
                                                                "referencedDeclaration": null,
                                                                "type": "address"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 1114,
                                                                        "type": "msg",
                                                                        "value": "msg"
                                                                    },
                                                                    "id": 846,
                                                                    "name": "Identifier",
                                                                    "src": "14020:3:0"
                                                                }
                                                            ],
                                                            "id": 847,
                                                            "name": "MemberAccess",
                                                            "src": "14020:10:0"
                                                        }
                                                    ],
                                                    "id": 848,
                                                    "name": "BinaryOperation",
                                                    "src": "14013:17:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "!=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": true,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": true,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "type": "mapping(address => uint256)"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 599,
                                                                                "type": "mapping(address => mapping(address => uint256))",
                                                                                "value": "_approvals"
                                                                            },
                                                                            "id": 849,
                                                                            "name": "Identifier",
                                                                            "src": "14034:10:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 834,
                                                                                "type": "address",
                                                                                "value": "src"
                                                                            },
                                                                            "id": 850,
                                                                            "name": "Identifier",
                                                                            "src": "14045:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 851,
                                                                    "name": "IndexAccess",
                                                                    "src": "14034:15:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "member_name": "sender",
                                                                        "referencedDeclaration": null,
                                                                        "type": "address"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 1114,
                                                                                "type": "msg",
                                                                                "value": "msg"
                                                                            },
                                                                            "id": 852,
                                                                            "name": "Identifier",
                                                                            "src": "14050:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 853,
                                                                    "name": "MemberAccess",
                                                                    "src": "14050:10:0"
                                                                }
                                                            ],
                                                            "id": 854,
                                                            "name": "IndexAccess",
                                                            "src": "14034:27:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": true,
                                                                "isStructConstructorCall": false,
                                                                "lValueRequested": false,
                                                                "names": [
                                                                    null
                                                                ],
                                                                "type": "uint256",
                                                                "type_conversion": true
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": [
                                                                            {
                                                                                "typeIdentifier": "t_rational_-1_by_1",
                                                                                "typeString": "int_const -1"
                                                                            }
                                                                        ],
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "type": "type(uint256)",
                                                                        "value": "uint"
                                                                    },
                                                                    "id": 855,
                                                                    "name": "ElementaryTypeNameExpression",
                                                                    "src": "14065:4:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "operator": "-",
                                                                        "prefix": true,
                                                                        "type": "int_const -1"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "31",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "number",
                                                                                "type": "int_const 1",
                                                                                "value": "1"
                                                                            },
                                                                            "id": 856,
                                                                            "name": "Literal",
                                                                            "src": "14071:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 857,
                                                                    "name": "UnaryOperation",
                                                                    "src": "14070:2:0"
                                                                }
                                                            ],
                                                            "id": 858,
                                                            "name": "FunctionCall",
                                                            "src": "14065:8:0"
                                                        }
                                                    ],
                                                    "id": 859,
                                                    "name": "BinaryOperation",
                                                    "src": "14034:39:0"
                                                }
                                            ],
                                            "id": 860,
                                            "name": "BinaryOperation",
                                            "src": "14013:60:0"
                                        },
                                        {
                                            "children": [
                                                {
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "operator": "=",
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": true,
                                                                        "isPure": false,
                                                                        "lValueRequested": true,
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": true,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "type": "mapping(address => uint256)"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 599,
                                                                                        "type": "mapping(address => mapping(address => uint256))",
                                                                                        "value": "_approvals"
                                                                                    },
                                                                                    "id": 861,
                                                                                    "name": "Identifier",
                                                                                    "src": "14090:10:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 834,
                                                                                        "type": "address",
                                                                                        "value": "src"
                                                                                    },
                                                                                    "id": 862,
                                                                                    "name": "Identifier",
                                                                                    "src": "14101:3:0"
                                                                                }
                                                                            ],
                                                                            "id": 865,
                                                                            "name": "IndexAccess",
                                                                            "src": "14090:15:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "member_name": "sender",
                                                                                "referencedDeclaration": null,
                                                                                "type": "address"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 1114,
                                                                                        "type": "msg",
                                                                                        "value": "msg"
                                                                                    },
                                                                                    "id": 863,
                                                                                    "name": "Identifier",
                                                                                    "src": "14106:3:0"
                                                                                }
                                                                            ],
                                                                            "id": 864,
                                                                            "name": "MemberAccess",
                                                                            "src": "14106:10:0"
                                                                        }
                                                                    ],
                                                                    "id": 866,
                                                                    "name": "IndexAccess",
                                                                    "src": "14090:27:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "isStructConstructorCall": false,
                                                                        "lValueRequested": false,
                                                                        "names": [
                                                                            null
                                                                        ],
                                                                        "type": "uint256",
                                                                        "type_conversion": false
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": [
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    },
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    }
                                                                                ],
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 173,
                                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                                "value": "sub"
                                                                            },
                                                                            "id": 867,
                                                                            "name": "Identifier",
                                                                            "src": "14120:3:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": true,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "type": "uint256"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "isConstant": false,
                                                                                        "isLValue": true,
                                                                                        "isPure": false,
                                                                                        "lValueRequested": false,
                                                                                        "type": "mapping(address => uint256)"
                                                                                    },
                                                                                    "children": [
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 599,
                                                                                                "type": "mapping(address => mapping(address => uint256))",
                                                                                                "value": "_approvals"
                                                                                            },
                                                                                            "id": 868,
                                                                                            "name": "Identifier",
                                                                                            "src": "14124:10:0"
                                                                                        },
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 834,
                                                                                                "type": "address",
                                                                                                "value": "src"
                                                                                            },
                                                                                            "id": 869,
                                                                                            "name": "Identifier",
                                                                                            "src": "14135:3:0"
                                                                                        }
                                                                                    ],
                                                                                    "id": 870,
                                                                                    "name": "IndexAccess",
                                                                                    "src": "14124:15:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "isConstant": false,
                                                                                        "isLValue": false,
                                                                                        "isPure": false,
                                                                                        "lValueRequested": false,
                                                                                        "member_name": "sender",
                                                                                        "referencedDeclaration": null,
                                                                                        "type": "address"
                                                                                    },
                                                                                    "children": [
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 1114,
                                                                                                "type": "msg",
                                                                                                "value": "msg"
                                                                                            },
                                                                                            "id": 871,
                                                                                            "name": "Identifier",
                                                                                            "src": "14140:3:0"
                                                                                        }
                                                                                    ],
                                                                                    "id": 872,
                                                                                    "name": "MemberAccess",
                                                                                    "src": "14140:10:0"
                                                                                }
                                                                            ],
                                                                            "id": 873,
                                                                            "name": "IndexAccess",
                                                                            "src": "14124:27:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 838,
                                                                                "type": "uint256",
                                                                                "value": "wad"
                                                                            },
                                                                            "id": 874,
                                                                            "name": "Identifier",
                                                                            "src": "14153:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 875,
                                                                    "name": "FunctionCall",
                                                                    "src": "14120:37:0"
                                                                }
                                                            ],
                                                            "id": 876,
                                                            "name": "Assignment",
                                                            "src": "14090:67:0"
                                                        }
                                                    ],
                                                    "id": 877,
                                                    "name": "ExpressionStatement",
                                                    "src": "14090:67:0"
                                                }
                                            ],
                                            "id": 878,
                                            "name": "Block",
                                            "src": "14075:94:0"
                                        }
                                    ],
                                    "id": 879,
                                    "name": "IfStatement",
                                    "src": "14009:160:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": true,
                                                        "isPure": false,
                                                        "lValueRequested": true,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 593,
                                                                "type": "mapping(address => uint256)",
                                                                "value": "_balances"
                                                            },
                                                            "id": 880,
                                                            "name": "Identifier",
                                                            "src": "14181:9:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 834,
                                                                "type": "address",
                                                                "value": "src"
                                                            },
                                                            "id": 881,
                                                            "name": "Identifier",
                                                            "src": "14191:3:0"
                                                        }
                                                    ],
                                                    "id": 882,
                                                    "name": "IndexAccess",
                                                    "src": "14181:14:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "uint256",
                                                        "type_conversion": false
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    },
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    }
                                                                ],
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 173,
                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                "value": "sub"
                                                            },
                                                            "id": 883,
                                                            "name": "Identifier",
                                                            "src": "14198:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": true,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 593,
                                                                        "type": "mapping(address => uint256)",
                                                                        "value": "_balances"
                                                                    },
                                                                    "id": 884,
                                                                    "name": "Identifier",
                                                                    "src": "14202:9:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 834,
                                                                        "type": "address",
                                                                        "value": "src"
                                                                    },
                                                                    "id": 885,
                                                                    "name": "Identifier",
                                                                    "src": "14212:3:0"
                                                                }
                                                            ],
                                                            "id": 886,
                                                            "name": "IndexAccess",
                                                            "src": "14202:14:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 838,
                                                                "type": "uint256",
                                                                "value": "wad"
                                                            },
                                                            "id": 887,
                                                            "name": "Identifier",
                                                            "src": "14218:3:0"
                                                        }
                                                    ],
                                                    "id": 888,
                                                    "name": "FunctionCall",
                                                    "src": "14198:24:0"
                                                }
                                            ],
                                            "id": 889,
                                            "name": "Assignment",
                                            "src": "14181:41:0"
                                        }
                                    ],
                                    "id": 890,
                                    "name": "ExpressionStatement",
                                    "src": "14181:41:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": true,
                                                        "isPure": false,
                                                        "lValueRequested": true,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 593,
                                                                "type": "mapping(address => uint256)",
                                                                "value": "_balances"
                                                            },
                                                            "id": 891,
                                                            "name": "Identifier",
                                                            "src": "14233:9:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 836,
                                                                "type": "address",
                                                                "value": "dst"
                                                            },
                                                            "id": 892,
                                                            "name": "Identifier",
                                                            "src": "14243:3:0"
                                                        }
                                                    ],
                                                    "id": 893,
                                                    "name": "IndexAccess",
                                                    "src": "14233:14:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "uint256",
                                                        "type_conversion": false
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    },
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    }
                                                                ],
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 152,
                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                "value": "add"
                                                            },
                                                            "id": 894,
                                                            "name": "Identifier",
                                                            "src": "14250:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": true,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 593,
                                                                        "type": "mapping(address => uint256)",
                                                                        "value": "_balances"
                                                                    },
                                                                    "id": 895,
                                                                    "name": "Identifier",
                                                                    "src": "14254:9:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 836,
                                                                        "type": "address",
                                                                        "value": "dst"
                                                                    },
                                                                    "id": 896,
                                                                    "name": "Identifier",
                                                                    "src": "14264:3:0"
                                                                }
                                                            ],
                                                            "id": 897,
                                                            "name": "IndexAccess",
                                                            "src": "14254:14:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 838,
                                                                "type": "uint256",
                                                                "value": "wad"
                                                            },
                                                            "id": 898,
                                                            "name": "Identifier",
                                                            "src": "14270:3:0"
                                                        }
                                                    ],
                                                    "id": 899,
                                                    "name": "FunctionCall",
                                                    "src": "14250:24:0"
                                                }
                                            ],
                                            "id": 900,
                                            "name": "Assignment",
                                            "src": "14233:41:0"
                                        }
                                    ],
                                    "id": 901,
                                    "name": "ExpressionStatement",
                                    "src": "14233:41:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 574,
                                                        "type": "function (address,address,uint256)",
                                                        "value": "Transfer"
                                                    },
                                                    "id": 902,
                                                    "name": "Identifier",
                                                    "src": "14287:8:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 834,
                                                        "type": "address",
                                                        "value": "src"
                                                    },
                                                    "id": 903,
                                                    "name": "Identifier",
                                                    "src": "14296:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 836,
                                                        "type": "address",
                                                        "value": "dst"
                                                    },
                                                    "id": 904,
                                                    "name": "Identifier",
                                                    "src": "14301:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 838,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 905,
                                                    "name": "Identifier",
                                                    "src": "14306:3:0"
                                                }
                                            ],
                                            "id": 906,
                                            "name": "FunctionCall",
                                            "src": "14287:23:0"
                                        }
                                    ],
                                    "id": 907,
                                    "name": "ExpressionStatement",
                                    "src": "14287:23:0"
                                },
                                {
                                    "attributes": {
                                        "functionReturnParameters": 844
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "hexvalue": "74727565",
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": true,
                                                "lValueRequested": false,
                                                "subdenomination": null,
                                                "token": "bool",
                                                "type": "bool",
                                                "value": "true"
                                            },
                                            "id": 908,
                                            "name": "Literal",
                                            "src": "14330:4:0"
                                        }
                                    ],
                                    "id": 909,
                                    "name": "Return",
                                    "src": "14323:11:0"
                                }
                            ],
                            "id": 910,
                            "name": "Block",
                            "src": "13998:344:0"
                        }
                    ],
                    "id": 911,
                    "name": "FunctionDefinition",
                    "src": "13876:466:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "push",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "dst",
                                        "scope": 926,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 912,
                                            "name": "ElementaryTypeName",
                                            "src": "14364:7:0"
                                        }
                                    ],
                                    "id": 913,
                                    "name": "VariableDeclaration",
                                    "src": "14364:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 926,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 914,
                                            "name": "ElementaryTypeName",
                                            "src": "14377:4:0"
                                        }
                                    ],
                                    "id": 915,
                                    "name": "VariableDeclaration",
                                    "src": "14377:8:0"
                                }
                            ],
                            "id": 916,
                            "name": "ParameterList",
                            "src": "14363:23:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 917,
                            "name": "ParameterList",
                            "src": "14394:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "bool",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            911
                                                        ],
                                                        "referencedDeclaration": 911,
                                                        "type": "function (address,address,uint256) returns (bool)",
                                                        "value": "transferFrom"
                                                    },
                                                    "id": 918,
                                                    "name": "Identifier",
                                                    "src": "14405:12:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 919,
                                                            "name": "Identifier",
                                                            "src": "14418:3:0"
                                                        }
                                                    ],
                                                    "id": 920,
                                                    "name": "MemberAccess",
                                                    "src": "14418:10:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 913,
                                                        "type": "address",
                                                        "value": "dst"
                                                    },
                                                    "id": 921,
                                                    "name": "Identifier",
                                                    "src": "14430:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 915,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 922,
                                                    "name": "Identifier",
                                                    "src": "14435:3:0"
                                                }
                                            ],
                                            "id": 923,
                                            "name": "FunctionCall",
                                            "src": "14405:34:0"
                                        }
                                    ],
                                    "id": 924,
                                    "name": "ExpressionStatement",
                                    "src": "14405:34:0"
                                }
                            ],
                            "id": 925,
                            "name": "Block",
                            "src": "14394:53:0"
                        }
                    ],
                    "id": 926,
                    "name": "FunctionDefinition",
                    "src": "14350:97:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "pull",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "src",
                                        "scope": 941,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 927,
                                            "name": "ElementaryTypeName",
                                            "src": "14467:7:0"
                                        }
                                    ],
                                    "id": 928,
                                    "name": "VariableDeclaration",
                                    "src": "14467:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 941,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 929,
                                            "name": "ElementaryTypeName",
                                            "src": "14480:4:0"
                                        }
                                    ],
                                    "id": 930,
                                    "name": "VariableDeclaration",
                                    "src": "14480:8:0"
                                }
                            ],
                            "id": 931,
                            "name": "ParameterList",
                            "src": "14466:23:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 932,
                            "name": "ParameterList",
                            "src": "14497:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "bool",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            911
                                                        ],
                                                        "referencedDeclaration": 911,
                                                        "type": "function (address,address,uint256) returns (bool)",
                                                        "value": "transferFrom"
                                                    },
                                                    "id": 933,
                                                    "name": "Identifier",
                                                    "src": "14508:12:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 928,
                                                        "type": "address",
                                                        "value": "src"
                                                    },
                                                    "id": 934,
                                                    "name": "Identifier",
                                                    "src": "14521:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 935,
                                                            "name": "Identifier",
                                                            "src": "14526:3:0"
                                                        }
                                                    ],
                                                    "id": 936,
                                                    "name": "MemberAccess",
                                                    "src": "14526:10:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 930,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 937,
                                                    "name": "Identifier",
                                                    "src": "14538:3:0"
                                                }
                                            ],
                                            "id": 938,
                                            "name": "FunctionCall",
                                            "src": "14508:34:0"
                                        }
                                    ],
                                    "id": 939,
                                    "name": "ExpressionStatement",
                                    "src": "14508:34:0"
                                }
                            ],
                            "id": 940,
                            "name": "Block",
                            "src": "14497:53:0"
                        }
                    ],
                    "id": 941,
                    "name": "FunctionDefinition",
                    "src": "14453:97:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "move",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "src",
                                        "scope": 957,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 942,
                                            "name": "ElementaryTypeName",
                                            "src": "14570:7:0"
                                        }
                                    ],
                                    "id": 943,
                                    "name": "VariableDeclaration",
                                    "src": "14570:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "dst",
                                        "scope": 957,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 944,
                                            "name": "ElementaryTypeName",
                                            "src": "14583:7:0"
                                        }
                                    ],
                                    "id": 945,
                                    "name": "VariableDeclaration",
                                    "src": "14583:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 957,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 946,
                                            "name": "ElementaryTypeName",
                                            "src": "14596:4:0"
                                        }
                                    ],
                                    "id": 947,
                                    "name": "VariableDeclaration",
                                    "src": "14596:8:0"
                                }
                            ],
                            "id": 948,
                            "name": "ParameterList",
                            "src": "14569:36:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 949,
                            "name": "ParameterList",
                            "src": "14613:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "bool",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            911
                                                        ],
                                                        "referencedDeclaration": 911,
                                                        "type": "function (address,address,uint256) returns (bool)",
                                                        "value": "transferFrom"
                                                    },
                                                    "id": 950,
                                                    "name": "Identifier",
                                                    "src": "14624:12:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 943,
                                                        "type": "address",
                                                        "value": "src"
                                                    },
                                                    "id": 951,
                                                    "name": "Identifier",
                                                    "src": "14637:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 945,
                                                        "type": "address",
                                                        "value": "dst"
                                                    },
                                                    "id": 952,
                                                    "name": "Identifier",
                                                    "src": "14642:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 947,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 953,
                                                    "name": "Identifier",
                                                    "src": "14647:3:0"
                                                }
                                            ],
                                            "id": 954,
                                            "name": "FunctionCall",
                                            "src": "14624:27:0"
                                        }
                                    ],
                                    "id": 955,
                                    "name": "ExpressionStatement",
                                    "src": "14624:27:0"
                                }
                            ],
                            "id": 956,
                            "name": "Block",
                            "src": "14613:46:0"
                        }
                    ],
                    "id": 957,
                    "name": "FunctionDefinition",
                    "src": "14556:103:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "mint",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 969,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 958,
                                            "name": "ElementaryTypeName",
                                            "src": "14681:4:0"
                                        }
                                    ],
                                    "id": 959,
                                    "name": "VariableDeclaration",
                                    "src": "14681:8:0"
                                }
                            ],
                            "id": 960,
                            "name": "ParameterList",
                            "src": "14680:10:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 961,
                            "name": "ParameterList",
                            "src": "14698:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            969,
                                                            1016
                                                        ],
                                                        "referencedDeclaration": 1016,
                                                        "type": "function (address,uint256)",
                                                        "value": "mint"
                                                    },
                                                    "id": 962,
                                                    "name": "Identifier",
                                                    "src": "14709:4:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 963,
                                                            "name": "Identifier",
                                                            "src": "14714:3:0"
                                                        }
                                                    ],
                                                    "id": 964,
                                                    "name": "MemberAccess",
                                                    "src": "14714:10:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 959,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 965,
                                                    "name": "Identifier",
                                                    "src": "14726:3:0"
                                                }
                                            ],
                                            "id": 966,
                                            "name": "FunctionCall",
                                            "src": "14709:21:0"
                                        }
                                    ],
                                    "id": 967,
                                    "name": "ExpressionStatement",
                                    "src": "14709:21:0"
                                }
                            ],
                            "id": 968,
                            "name": "Block",
                            "src": "14698:40:0"
                        }
                    ],
                    "id": 969,
                    "name": "FunctionDefinition",
                    "src": "14667:71:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "modifiers": [
                            null
                        ],
                        "name": "burn",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 981,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 970,
                                            "name": "ElementaryTypeName",
                                            "src": "14758:4:0"
                                        }
                                    ],
                                    "id": 971,
                                    "name": "VariableDeclaration",
                                    "src": "14758:8:0"
                                }
                            ],
                            "id": 972,
                            "name": "ParameterList",
                            "src": "14757:10:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 973,
                            "name": "ParameterList",
                            "src": "14775:0:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            981,
                                                            1086
                                                        ],
                                                        "referencedDeclaration": 1086,
                                                        "type": "function (address,uint256)",
                                                        "value": "burn"
                                                    },
                                                    "id": 974,
                                                    "name": "Identifier",
                                                    "src": "14786:4:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "member_name": "sender",
                                                        "referencedDeclaration": null,
                                                        "type": "address"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1114,
                                                                "type": "msg",
                                                                "value": "msg"
                                                            },
                                                            "id": 975,
                                                            "name": "Identifier",
                                                            "src": "14791:3:0"
                                                        }
                                                    ],
                                                    "id": 976,
                                                    "name": "MemberAccess",
                                                    "src": "14791:10:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 971,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 977,
                                                    "name": "Identifier",
                                                    "src": "14803:3:0"
                                                }
                                            ],
                                            "id": 978,
                                            "name": "FunctionCall",
                                            "src": "14786:21:0"
                                        }
                                    ],
                                    "id": 979,
                                    "name": "ExpressionStatement",
                                    "src": "14786:21:0"
                                }
                            ],
                            "id": 980,
                            "name": "Block",
                            "src": "14775:40:0"
                        }
                    ],
                    "id": 981,
                    "name": "FunctionDefinition",
                    "src": "14744:71:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "mint",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "guy",
                                        "scope": 1016,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 982,
                                            "name": "ElementaryTypeName",
                                            "src": "14835:7:0"
                                        }
                                    ],
                                    "id": 983,
                                    "name": "VariableDeclaration",
                                    "src": "14835:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 1016,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 984,
                                            "name": "ElementaryTypeName",
                                            "src": "14848:4:0"
                                        }
                                    ],
                                    "id": 985,
                                    "name": "VariableDeclaration",
                                    "src": "14848:8:0"
                                }
                            ],
                            "id": 986,
                            "name": "ParameterList",
                            "src": "14834:23:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 991,
                            "name": "ParameterList",
                            "src": "14880:0:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 87,
                                        "type": "modifier ()",
                                        "value": "auth"
                                    },
                                    "id": 987,
                                    "name": "Identifier",
                                    "src": "14865:4:0"
                                }
                            ],
                            "id": 988,
                            "name": "ModifierInvocation",
                            "src": "14865:4:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 491,
                                        "type": "modifier ()",
                                        "value": "stoppable"
                                    },
                                    "id": 989,
                                    "name": "Identifier",
                                    "src": "14870:9:0"
                                }
                            ],
                            "id": 990,
                            "name": "ModifierInvocation",
                            "src": "14870:9:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": true,
                                                        "isPure": false,
                                                        "lValueRequested": true,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 593,
                                                                "type": "mapping(address => uint256)",
                                                                "value": "_balances"
                                                            },
                                                            "id": 992,
                                                            "name": "Identifier",
                                                            "src": "14891:9:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 983,
                                                                "type": "address",
                                                                "value": "guy"
                                                            },
                                                            "id": 993,
                                                            "name": "Identifier",
                                                            "src": "14901:3:0"
                                                        }
                                                    ],
                                                    "id": 994,
                                                    "name": "IndexAccess",
                                                    "src": "14891:14:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "uint256",
                                                        "type_conversion": false
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    },
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    }
                                                                ],
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 152,
                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                "value": "add"
                                                            },
                                                            "id": 995,
                                                            "name": "Identifier",
                                                            "src": "14908:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": true,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 593,
                                                                        "type": "mapping(address => uint256)",
                                                                        "value": "_balances"
                                                                    },
                                                                    "id": 996,
                                                                    "name": "Identifier",
                                                                    "src": "14912:9:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 983,
                                                                        "type": "address",
                                                                        "value": "guy"
                                                                    },
                                                                    "id": 997,
                                                                    "name": "Identifier",
                                                                    "src": "14922:3:0"
                                                                }
                                                            ],
                                                            "id": 998,
                                                            "name": "IndexAccess",
                                                            "src": "14912:14:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 985,
                                                                "type": "uint256",
                                                                "value": "wad"
                                                            },
                                                            "id": 999,
                                                            "name": "Identifier",
                                                            "src": "14928:3:0"
                                                        }
                                                    ],
                                                    "id": 1000,
                                                    "name": "FunctionCall",
                                                    "src": "14908:24:0"
                                                }
                                            ],
                                            "id": 1001,
                                            "name": "Assignment",
                                            "src": "14891:41:0"
                                        }
                                    ],
                                    "id": 1002,
                                    "name": "ExpressionStatement",
                                    "src": "14891:41:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 589,
                                                        "type": "uint256",
                                                        "value": "_supply"
                                                    },
                                                    "id": 1003,
                                                    "name": "Identifier",
                                                    "src": "14943:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "uint256",
                                                        "type_conversion": false
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    },
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    }
                                                                ],
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 152,
                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                "value": "add"
                                                            },
                                                            "id": 1004,
                                                            "name": "Identifier",
                                                            "src": "14953:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 589,
                                                                "type": "uint256",
                                                                "value": "_supply"
                                                            },
                                                            "id": 1005,
                                                            "name": "Identifier",
                                                            "src": "14957:7:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 985,
                                                                "type": "uint256",
                                                                "value": "wad"
                                                            },
                                                            "id": 1006,
                                                            "name": "Identifier",
                                                            "src": "14966:3:0"
                                                        }
                                                    ],
                                                    "id": 1007,
                                                    "name": "FunctionCall",
                                                    "src": "14953:17:0"
                                                }
                                            ],
                                            "id": 1008,
                                            "name": "Assignment",
                                            "src": "14943:27:0"
                                        }
                                    ],
                                    "id": 1009,
                                    "name": "ExpressionStatement",
                                    "src": "14943:27:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 789,
                                                        "type": "function (address,uint256)",
                                                        "value": "Mint"
                                                    },
                                                    "id": 1010,
                                                    "name": "Identifier",
                                                    "src": "14981:4:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 983,
                                                        "type": "address",
                                                        "value": "guy"
                                                    },
                                                    "id": 1011,
                                                    "name": "Identifier",
                                                    "src": "14986:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 985,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 1012,
                                                    "name": "Identifier",
                                                    "src": "14991:3:0"
                                                }
                                            ],
                                            "id": 1013,
                                            "name": "FunctionCall",
                                            "src": "14981:14:0"
                                        }
                                    ],
                                    "id": 1014,
                                    "name": "ExpressionStatement",
                                    "src": "14981:14:0"
                                }
                            ],
                            "id": 1015,
                            "name": "Block",
                            "src": "14880:123:0"
                        }
                    ],
                    "id": 1016,
                    "name": "FunctionDefinition",
                    "src": "14821:182:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "burn",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "guy",
                                        "scope": 1086,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "address",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "address",
                                                "type": "address"
                                            },
                                            "id": 1017,
                                            "name": "ElementaryTypeName",
                                            "src": "15023:7:0"
                                        }
                                    ],
                                    "id": 1018,
                                    "name": "VariableDeclaration",
                                    "src": "15023:11:0"
                                },
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "wad",
                                        "scope": 1086,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "uint256",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "uint",
                                                "type": "uint256"
                                            },
                                            "id": 1019,
                                            "name": "ElementaryTypeName",
                                            "src": "15036:4:0"
                                        }
                                    ],
                                    "id": 1020,
                                    "name": "VariableDeclaration",
                                    "src": "15036:8:0"
                                }
                            ],
                            "id": 1021,
                            "name": "ParameterList",
                            "src": "15022:23:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 1026,
                            "name": "ParameterList",
                            "src": "15068:0:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 87,
                                        "type": "modifier ()",
                                        "value": "auth"
                                    },
                                    "id": 1022,
                                    "name": "Identifier",
                                    "src": "15053:4:0"
                                }
                            ],
                            "id": 1023,
                            "name": "ModifierInvocation",
                            "src": "15053:4:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 491,
                                        "type": "modifier ()",
                                        "value": "stoppable"
                                    },
                                    "id": 1024,
                                    "name": "Identifier",
                                    "src": "15058:9:0"
                                }
                            ],
                            "id": 1025,
                            "name": "ModifierInvocation",
                            "src": "15058:9:0"
                        },
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "falseBody": null
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "commonType": {
                                                    "typeIdentifier": "t_bool",
                                                    "typeString": "bool"
                                                },
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "&&",
                                                "type": "bool"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_address",
                                                            "typeString": "address"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "!=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1018,
                                                                "type": "address",
                                                                "value": "guy"
                                                            },
                                                            "id": 1027,
                                                            "name": "Identifier",
                                                            "src": "15083:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "member_name": "sender",
                                                                "referencedDeclaration": null,
                                                                "type": "address"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 1114,
                                                                        "type": "msg",
                                                                        "value": "msg"
                                                                    },
                                                                    "id": 1028,
                                                                    "name": "Identifier",
                                                                    "src": "15090:3:0"
                                                                }
                                                            ],
                                                            "id": 1029,
                                                            "name": "MemberAccess",
                                                            "src": "15090:10:0"
                                                        }
                                                    ],
                                                    "id": 1030,
                                                    "name": "BinaryOperation",
                                                    "src": "15083:17:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "commonType": {
                                                            "typeIdentifier": "t_uint256",
                                                            "typeString": "uint256"
                                                        },
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "lValueRequested": false,
                                                        "operator": "!=",
                                                        "type": "bool"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": true,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": true,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "type": "mapping(address => uint256)"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 599,
                                                                                "type": "mapping(address => mapping(address => uint256))",
                                                                                "value": "_approvals"
                                                                            },
                                                                            "id": 1031,
                                                                            "name": "Identifier",
                                                                            "src": "15104:10:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 1018,
                                                                                "type": "address",
                                                                                "value": "guy"
                                                                            },
                                                                            "id": 1032,
                                                                            "name": "Identifier",
                                                                            "src": "15115:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 1033,
                                                                    "name": "IndexAccess",
                                                                    "src": "15104:15:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "lValueRequested": false,
                                                                        "member_name": "sender",
                                                                        "referencedDeclaration": null,
                                                                        "type": "address"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 1114,
                                                                                "type": "msg",
                                                                                "value": "msg"
                                                                            },
                                                                            "id": 1034,
                                                                            "name": "Identifier",
                                                                            "src": "15120:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 1035,
                                                                    "name": "MemberAccess",
                                                                    "src": "15120:10:0"
                                                                }
                                                            ],
                                                            "id": 1036,
                                                            "name": "IndexAccess",
                                                            "src": "15104:27:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": true,
                                                                "isStructConstructorCall": false,
                                                                "lValueRequested": false,
                                                                "names": [
                                                                    null
                                                                ],
                                                                "type": "uint256",
                                                                "type_conversion": true
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": [
                                                                            {
                                                                                "typeIdentifier": "t_rational_-1_by_1",
                                                                                "typeString": "int_const -1"
                                                                            }
                                                                        ],
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "type": "type(uint256)",
                                                                        "value": "uint"
                                                                    },
                                                                    "id": 1037,
                                                                    "name": "ElementaryTypeNameExpression",
                                                                    "src": "15135:4:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": true,
                                                                        "lValueRequested": false,
                                                                        "operator": "-",
                                                                        "prefix": true,
                                                                        "type": "int_const -1"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "hexvalue": "31",
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": true,
                                                                                "lValueRequested": false,
                                                                                "subdenomination": null,
                                                                                "token": "number",
                                                                                "type": "int_const 1",
                                                                                "value": "1"
                                                                            },
                                                                            "id": 1038,
                                                                            "name": "Literal",
                                                                            "src": "15141:1:0"
                                                                        }
                                                                    ],
                                                                    "id": 1039,
                                                                    "name": "UnaryOperation",
                                                                    "src": "15140:2:0"
                                                                }
                                                            ],
                                                            "id": 1040,
                                                            "name": "FunctionCall",
                                                            "src": "15135:8:0"
                                                        }
                                                    ],
                                                    "id": 1041,
                                                    "name": "BinaryOperation",
                                                    "src": "15104:39:0"
                                                }
                                            ],
                                            "id": 1042,
                                            "name": "BinaryOperation",
                                            "src": "15083:60:0"
                                        },
                                        {
                                            "children": [
                                                {
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": false,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "operator": "=",
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": true,
                                                                        "isPure": false,
                                                                        "lValueRequested": true,
                                                                        "type": "uint256"
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": true,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "type": "mapping(address => uint256)"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 599,
                                                                                        "type": "mapping(address => mapping(address => uint256))",
                                                                                        "value": "_approvals"
                                                                                    },
                                                                                    "id": 1043,
                                                                                    "name": "Identifier",
                                                                                    "src": "15160:10:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 1018,
                                                                                        "type": "address",
                                                                                        "value": "guy"
                                                                                    },
                                                                                    "id": 1044,
                                                                                    "name": "Identifier",
                                                                                    "src": "15171:3:0"
                                                                                }
                                                                            ],
                                                                            "id": 1047,
                                                                            "name": "IndexAccess",
                                                                            "src": "15160:15:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": false,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "member_name": "sender",
                                                                                "referencedDeclaration": null,
                                                                                "type": "address"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "overloadedDeclarations": [
                                                                                            null
                                                                                        ],
                                                                                        "referencedDeclaration": 1114,
                                                                                        "type": "msg",
                                                                                        "value": "msg"
                                                                                    },
                                                                                    "id": 1045,
                                                                                    "name": "Identifier",
                                                                                    "src": "15176:3:0"
                                                                                }
                                                                            ],
                                                                            "id": 1046,
                                                                            "name": "MemberAccess",
                                                                            "src": "15176:10:0"
                                                                        }
                                                                    ],
                                                                    "id": 1048,
                                                                    "name": "IndexAccess",
                                                                    "src": "15160:27:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "isConstant": false,
                                                                        "isLValue": false,
                                                                        "isPure": false,
                                                                        "isStructConstructorCall": false,
                                                                        "lValueRequested": false,
                                                                        "names": [
                                                                            null
                                                                        ],
                                                                        "type": "uint256",
                                                                        "type_conversion": false
                                                                    },
                                                                    "children": [
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": [
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    },
                                                                                    {
                                                                                        "typeIdentifier": "t_uint256",
                                                                                        "typeString": "uint256"
                                                                                    }
                                                                                ],
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 173,
                                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                                "value": "sub"
                                                                            },
                                                                            "id": 1049,
                                                                            "name": "Identifier",
                                                                            "src": "15190:3:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "isConstant": false,
                                                                                "isLValue": true,
                                                                                "isPure": false,
                                                                                "lValueRequested": false,
                                                                                "type": "uint256"
                                                                            },
                                                                            "children": [
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "isConstant": false,
                                                                                        "isLValue": true,
                                                                                        "isPure": false,
                                                                                        "lValueRequested": false,
                                                                                        "type": "mapping(address => uint256)"
                                                                                    },
                                                                                    "children": [
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 599,
                                                                                                "type": "mapping(address => mapping(address => uint256))",
                                                                                                "value": "_approvals"
                                                                                            },
                                                                                            "id": 1050,
                                                                                            "name": "Identifier",
                                                                                            "src": "15194:10:0"
                                                                                        },
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 1018,
                                                                                                "type": "address",
                                                                                                "value": "guy"
                                                                                            },
                                                                                            "id": 1051,
                                                                                            "name": "Identifier",
                                                                                            "src": "15205:3:0"
                                                                                        }
                                                                                    ],
                                                                                    "id": 1052,
                                                                                    "name": "IndexAccess",
                                                                                    "src": "15194:15:0"
                                                                                },
                                                                                {
                                                                                    "attributes": {
                                                                                        "argumentTypes": null,
                                                                                        "isConstant": false,
                                                                                        "isLValue": false,
                                                                                        "isPure": false,
                                                                                        "lValueRequested": false,
                                                                                        "member_name": "sender",
                                                                                        "referencedDeclaration": null,
                                                                                        "type": "address"
                                                                                    },
                                                                                    "children": [
                                                                                        {
                                                                                            "attributes": {
                                                                                                "argumentTypes": null,
                                                                                                "overloadedDeclarations": [
                                                                                                    null
                                                                                                ],
                                                                                                "referencedDeclaration": 1114,
                                                                                                "type": "msg",
                                                                                                "value": "msg"
                                                                                            },
                                                                                            "id": 1053,
                                                                                            "name": "Identifier",
                                                                                            "src": "15210:3:0"
                                                                                        }
                                                                                    ],
                                                                                    "id": 1054,
                                                                                    "name": "MemberAccess",
                                                                                    "src": "15210:10:0"
                                                                                }
                                                                            ],
                                                                            "id": 1055,
                                                                            "name": "IndexAccess",
                                                                            "src": "15194:27:0"
                                                                        },
                                                                        {
                                                                            "attributes": {
                                                                                "argumentTypes": null,
                                                                                "overloadedDeclarations": [
                                                                                    null
                                                                                ],
                                                                                "referencedDeclaration": 1020,
                                                                                "type": "uint256",
                                                                                "value": "wad"
                                                                            },
                                                                            "id": 1056,
                                                                            "name": "Identifier",
                                                                            "src": "15223:3:0"
                                                                        }
                                                                    ],
                                                                    "id": 1057,
                                                                    "name": "FunctionCall",
                                                                    "src": "15190:37:0"
                                                                }
                                                            ],
                                                            "id": 1058,
                                                            "name": "Assignment",
                                                            "src": "15160:67:0"
                                                        }
                                                    ],
                                                    "id": 1059,
                                                    "name": "ExpressionStatement",
                                                    "src": "15160:67:0"
                                                }
                                            ],
                                            "id": 1060,
                                            "name": "Block",
                                            "src": "15145:94:0"
                                        }
                                    ],
                                    "id": 1061,
                                    "name": "IfStatement",
                                    "src": "15079:160:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": true,
                                                        "isPure": false,
                                                        "lValueRequested": true,
                                                        "type": "uint256"
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 593,
                                                                "type": "mapping(address => uint256)",
                                                                "value": "_balances"
                                                            },
                                                            "id": 1062,
                                                            "name": "Identifier",
                                                            "src": "15251:9:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1018,
                                                                "type": "address",
                                                                "value": "guy"
                                                            },
                                                            "id": 1063,
                                                            "name": "Identifier",
                                                            "src": "15261:3:0"
                                                        }
                                                    ],
                                                    "id": 1064,
                                                    "name": "IndexAccess",
                                                    "src": "15251:14:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "uint256",
                                                        "type_conversion": false
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    },
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    }
                                                                ],
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 173,
                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                "value": "sub"
                                                            },
                                                            "id": 1065,
                                                            "name": "Identifier",
                                                            "src": "15268:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "isConstant": false,
                                                                "isLValue": true,
                                                                "isPure": false,
                                                                "lValueRequested": false,
                                                                "type": "uint256"
                                                            },
                                                            "children": [
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 593,
                                                                        "type": "mapping(address => uint256)",
                                                                        "value": "_balances"
                                                                    },
                                                                    "id": 1066,
                                                                    "name": "Identifier",
                                                                    "src": "15272:9:0"
                                                                },
                                                                {
                                                                    "attributes": {
                                                                        "argumentTypes": null,
                                                                        "overloadedDeclarations": [
                                                                            null
                                                                        ],
                                                                        "referencedDeclaration": 1018,
                                                                        "type": "address",
                                                                        "value": "guy"
                                                                    },
                                                                    "id": 1067,
                                                                    "name": "Identifier",
                                                                    "src": "15282:3:0"
                                                                }
                                                            ],
                                                            "id": 1068,
                                                            "name": "IndexAccess",
                                                            "src": "15272:14:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1020,
                                                                "type": "uint256",
                                                                "value": "wad"
                                                            },
                                                            "id": 1069,
                                                            "name": "Identifier",
                                                            "src": "15288:3:0"
                                                        }
                                                    ],
                                                    "id": 1070,
                                                    "name": "FunctionCall",
                                                    "src": "15268:24:0"
                                                }
                                            ],
                                            "id": 1071,
                                            "name": "Assignment",
                                            "src": "15251:41:0"
                                        }
                                    ],
                                    "id": 1072,
                                    "name": "ExpressionStatement",
                                    "src": "15251:41:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "uint256"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 589,
                                                        "type": "uint256",
                                                        "value": "_supply"
                                                    },
                                                    "id": 1073,
                                                    "name": "Identifier",
                                                    "src": "15303:7:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "isConstant": false,
                                                        "isLValue": false,
                                                        "isPure": false,
                                                        "isStructConstructorCall": false,
                                                        "lValueRequested": false,
                                                        "names": [
                                                            null
                                                        ],
                                                        "type": "uint256",
                                                        "type_conversion": false
                                                    },
                                                    "children": [
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": [
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    },
                                                                    {
                                                                        "typeIdentifier": "t_uint256",
                                                                        "typeString": "uint256"
                                                                    }
                                                                ],
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 173,
                                                                "type": "function (uint256,uint256) pure returns (uint256)",
                                                                "value": "sub"
                                                            },
                                                            "id": 1074,
                                                            "name": "Identifier",
                                                            "src": "15313:3:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 589,
                                                                "type": "uint256",
                                                                "value": "_supply"
                                                            },
                                                            "id": 1075,
                                                            "name": "Identifier",
                                                            "src": "15317:7:0"
                                                        },
                                                        {
                                                            "attributes": {
                                                                "argumentTypes": null,
                                                                "overloadedDeclarations": [
                                                                    null
                                                                ],
                                                                "referencedDeclaration": 1020,
                                                                "type": "uint256",
                                                                "value": "wad"
                                                            },
                                                            "id": 1076,
                                                            "name": "Identifier",
                                                            "src": "15326:3:0"
                                                        }
                                                    ],
                                                    "id": 1077,
                                                    "name": "FunctionCall",
                                                    "src": "15313:17:0"
                                                }
                                            ],
                                            "id": 1078,
                                            "name": "Assignment",
                                            "src": "15303:27:0"
                                        }
                                    ],
                                    "id": 1079,
                                    "name": "ExpressionStatement",
                                    "src": "15303:27:0"
                                },
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "isStructConstructorCall": false,
                                                "lValueRequested": false,
                                                "names": [
                                                    null
                                                ],
                                                "type": "tuple()",
                                                "type_conversion": false
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": [
                                                            {
                                                                "typeIdentifier": "t_address",
                                                                "typeString": "address"
                                                            },
                                                            {
                                                                "typeIdentifier": "t_uint256",
                                                                "typeString": "uint256"
                                                            }
                                                        ],
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 795,
                                                        "type": "function (address,uint256)",
                                                        "value": "Burn"
                                                    },
                                                    "id": 1080,
                                                    "name": "Identifier",
                                                    "src": "15341:4:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 1018,
                                                        "type": "address",
                                                        "value": "guy"
                                                    },
                                                    "id": 1081,
                                                    "name": "Identifier",
                                                    "src": "15346:3:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 1020,
                                                        "type": "uint256",
                                                        "value": "wad"
                                                    },
                                                    "id": 1082,
                                                    "name": "Identifier",
                                                    "src": "15351:3:0"
                                                }
                                            ],
                                            "id": 1083,
                                            "name": "FunctionCall",
                                            "src": "15341:14:0"
                                        }
                                    ],
                                    "id": 1084,
                                    "name": "ExpressionStatement",
                                    "src": "15341:14:0"
                                }
                            ],
                            "id": 1085,
                            "name": "Block",
                            "src": "15068:295:0"
                        }
                    ],
                    "id": 1086,
                    "name": "FunctionDefinition",
                    "src": "15009:354:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "name": "name",
                        "scope": 1102,
                        "stateVariable": true,
                        "storageLocation": "default",
                        "type": "bytes32",
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "attributes": {
                                "name": "bytes32",
                                "type": "bytes32"
                            },
                            "id": 1087,
                            "name": "ElementaryTypeName",
                            "src": "15399:7:0"
                        },
                        {
                            "attributes": {
                                "argumentTypes": null,
                                "hexvalue": "",
                                "isConstant": false,
                                "isLValue": false,
                                "isPure": true,
                                "lValueRequested": false,
                                "subdenomination": null,
                                "token": "string",
                                "type": "literal_string \"\"",
                                "value": ""
                            },
                            "id": 1088,
                            "name": "Literal",
                            "src": "15424:2:0"
                        }
                    ],
                    "id": 1089,
                    "name": "VariableDeclaration",
                    "src": "15399:27:0"
                },
                {
                    "attributes": {
                        "constant": false,
                        "implemented": true,
                        "isConstructor": false,
                        "name": "setName",
                        "payable": false,
                        "scope": 1102,
                        "stateMutability": "nonpayable",
                        "superFunction": null,
                        "visibility": "public"
                    },
                    "children": [
                        {
                            "children": [
                                {
                                    "attributes": {
                                        "constant": false,
                                        "name": "name_",
                                        "scope": 1101,
                                        "stateVariable": false,
                                        "storageLocation": "default",
                                        "type": "bytes32",
                                        "value": null,
                                        "visibility": "internal"
                                    },
                                    "children": [
                                        {
                                            "attributes": {
                                                "name": "bytes32",
                                                "type": "bytes32"
                                            },
                                            "id": 1090,
                                            "name": "ElementaryTypeName",
                                            "src": "15452:7:0"
                                        }
                                    ],
                                    "id": 1091,
                                    "name": "VariableDeclaration",
                                    "src": "15452:13:0"
                                }
                            ],
                            "id": 1092,
                            "name": "ParameterList",
                            "src": "15451:15:0"
                        },
                        {
                            "attributes": {
                                "parameters": [
                                    null
                                ]
                            },
                            "children": [],
                            "id": 1095,
                            "name": "ParameterList",
                            "src": "15479:0:0"
                        },
                        {
                            "attributes": {
                                "arguments": [
                                    null
                                ]
                            },
                            "children": [
                                {
                                    "attributes": {
                                        "argumentTypes": null,
                                        "overloadedDeclarations": [
                                            null
                                        ],
                                        "referencedDeclaration": 87,
                                        "type": "modifier ()",
                                        "value": "auth"
                                    },
                                    "id": 1093,
                                    "name": "Identifier",
                                    "src": "15474:4:0"
                                }
                            ],
                            "id": 1094,
                            "name": "ModifierInvocation",
                            "src": "15474:4:0"
                        },
                        {
                            "children": [
                                {
                                    "children": [
                                        {
                                            "attributes": {
                                                "argumentTypes": null,
                                                "isConstant": false,
                                                "isLValue": false,
                                                "isPure": false,
                                                "lValueRequested": false,
                                                "operator": "=",
                                                "type": "bytes32"
                                            },
                                            "children": [
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 1089,
                                                        "type": "bytes32",
                                                        "value": "name"
                                                    },
                                                    "id": 1096,
                                                    "name": "Identifier",
                                                    "src": "15490:4:0"
                                                },
                                                {
                                                    "attributes": {
                                                        "argumentTypes": null,
                                                        "overloadedDeclarations": [
                                                            null
                                                        ],
                                                        "referencedDeclaration": 1091,
                                                        "type": "bytes32",
                                                        "value": "name_"
                                                    },
                                                    "id": 1097,
                                                    "name": "Identifier",
                                                    "src": "15497:5:0"
                                                }
                                            ],
                                            "id": 1098,
                                            "name": "Assignment",
                                            "src": "15490:12:0"
                                        }
                                    ],
                                    "id": 1099,
                                    "name": "ExpressionStatement",
                                    "src": "15490:12:0"
                                }
                            ],
                            "id": 1100,
                            "name": "Block",
                            "src": "15479:31:0"
                        }
                    ],
                    "id": 1101,
                    "name": "FunctionDefinition",
                    "src": "15435:75:0"
                }
            ],
            "id": 1102,
            "name": "ContractDefinition",
            "src": "13269:2244:0"
        }
    ],
    "id": 1103,
    "name": "SourceUnit",
    "src": "63:15450:0"
}
$$,
''
);