INSERT INTO defi_contracts
(contract_name, contract_address, primary_category, secondary_category,
	source_code,
	source_code_tree,
	source_code_scan_result)
VALUES('Yield Protocol', '0xa8b61cff52564758a204f841e636265bebc8db9b', '衍生品', '利率衍生品',
$$
// SPDX-License-Identifier: MIT
pragma solidity =0.7.4;

import "./erc20permit/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";

contract YIELDToken is ERC20Permit, ERC20Burnable {
    //total fixed supply of 140,736,000 tokens.

    constructor () ERC20Permit("Yield Protocol") ERC20("Yield Protocol", "YIELD") {
        super._mint(msg.sender, 140736000 ether);
    }
}
$$,
$$

$$,
''
);